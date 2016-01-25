Attribute VB_Name = "export_nodes"
Sub ExportNodes()

    Dim OrigSelection As ShapeRange
    'Dim Selection2 As ShapeRange
    'Dim TempSelection As New ShapeRange
    Dim s As Shape
    Dim s2 As Shape
    Dim grupo As Integer
    Dim nsr As New ShapeRange
    'Set OrigSelection = ActiveSelectionRange 'orderByZOrder(ActiveSelectionRange)
    Set OrigSelection = orderByZOrder2(ActiveSelectionRange)
    
    Dim text As String
    Dim counter As Integer
    

    text = "{"
    counter = 0
    grupo = 0
    For Each s In OrigSelection
        If s.Type = cdrGroupShape Then
            ' se é um grupo, processe cada elemento
            
            'create new shaperange in order to use sort
            For Each s2 In s.Shapes
                nsr.Add s2
            Next
            Set nsr = orderByZOrder2(nsr)
            For Each s2 In nsr
                text = processShape(s2, text, counter, grupo)
                counter = counter + 1
            Next
            nsr.RemoveAll
        Else
            text = processShape(s, text, counter, grupo)
            counter = counter + 1
        End If
        grupo = grupo + 1
    Next
    text = text + "  }," + vbNewLine
    
    
    text = Split(text + ";", "," + vbNewLine + ";")(0) + ";"
    
    'MsgBox (text)
    
    'settin the clipboard
    Dim DataObj As New MSForms.DataObject
    Dim str As String
    str = text
    DataObj.SetText str
    DataObj.PutInClipboard
    
    MsgBox (CStr(counter) + " items exported")
End Sub



Public Function processShape(s, text, counter, grupo) As String
    Dim k_lw    As Double
    Dim k_s As Double
    k_lw = 100
    k_s = 100
    Dim n As Node
    Dim n1 As Segment
    Dim posx, posy, posx2, posy2 As Double
    Dim ecpl, ecpa, scpl, scpa As Double

    text = text + "  " + CStr(counter) + ": {" + vbNewLine
    text = text + "      grupo: " + CStr(grupo) + "," + vbNewLine
    text = text + "      outline: " + formatNumber(s.Outline.Width, 100) + "," + vbNewLine
    text = text + "      ZOrder: " + CStr(s.ZOrder) + "," + vbNewLine
    
    'If s.Outline.Color.IsCMYK Then
    'Else
    '    text = text + "      strokeStyle: """ + CStr(s.Outline.Color.HexValue) + """," + vbNewLine
    'End If
    text = text + "      strokeStyle: """ + s.Outline.Color.HexValue + """," + vbNewLine

    If s.Type = cdrRectangleShape Then
        text = text + "      type: ""rectangle""," + vbNewLine
        If s.Fill.Type = cdrUniformFill Then
            text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        Else
            text = text + "      fillStyle: ""none""," + vbNewLine
        End If
        'If s.Outline.LineCaps = cdrOutlineButtLineCaps Then
        text = text + "      linecaps: " + CStr(2) + "," + vbNewLine
        'End If
        text = text + "      points: [" + formatNumber(s.LeftX, k_s) + "," + formatNumber(s.BottomY, k_s) + "]," + vbNewLine
        text = text + "      dims: [" + formatNumber(s.SizeWidth, k_s) + "," + formatNumber(s.SizeHeight, k_s) + "]" + vbNewLine
        text = text + "  }," + vbNewLine
        

    End If
    
    If s.Type = cdrEllipseShape Then
        text = text + "      type: ""ellipse""," + vbNewLine
        If s.Fill.Type = cdrUniformFill Then
            text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        Else
            text = text + "      fillStyle: ""none""," + vbNewLine
        End If
        text = text + "      center: " + "[" + formatNumber(s.Ellipse.CenterX, k_s) + "," + formatNumber(s.Ellipse.CenterY, k_s) + "]," + vbNewLine
        text = text + "      radius: " + "[" + formatNumber(s.SizeWidth / 2, k_s) + "," + formatNumber(s.SizeHeight / 2, k_s) + "]" + vbNewLine
        text = text + "  }," + vbNewLine
    End If
    
    If s.Type = cdrTextShape Then
    
    'Dim obj As New ObjectSnapPoint
    
    'Dim obj As New Object
'Dim lstProperties As New List(Of String)
'Dim pdc As System.ComponentModel.PropertyDescriptorCollection
'pdc = System.ComponentModel.TypeDescriptor.GetProperties(s.GetType)
'For Each pd As System.ComponentModel.PropertyDescriptor In pdc
'     lstProperties.Add (pd.Name)
'Next


    
    
    
    
    
   
    
    
    
    
    
    
        text = text + "      type: ""text""," + vbNewLine
        text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        text = text + "      text: """ 'inicio do texto
        For i = 1 To s.text.Frame.Range.Characters.Count
            If s.text.Frame.Range.Characters.Item(i).Position = cdrSubscriptFontPosition Then
                'text = text + "      text: """ + s.text.Frame.Range.Characters.All.text + """," + vbNewLine
                text = text + "_" + s.text.Frame.Range.Characters.Item(i).text
            Else
                If s.text.Frame.Range.Characters.Item(i).Position = cdrSuperscriptFontPosition Then
                    text = text + "^" + s.text.Frame.Range.Characters.Item(i).text
                Else
                    text = text + s.text.Frame.Range.Characters.Item(i).text
                End If
            End If
        Next i
        text = text + """," + vbNewLine
        text = text + "      size: """ + formatNumber(s.text.Frame.Range.Size, 1) + """," + vbNewLine
        text = text + "      font: """ + s.text.Frame.Range.Font + """," + vbNewLine
        text = text + "      posicao: [" + formatNumber(s.PositionX, k_s) + "," + formatNumber(s.BottomY, k_s) + "]," + vbNewLine
        text = text + "  }," + vbNewLine
    End If
                
    If s.Type = cdrPolygonShape Then
        text = text + "      type: ""curveLine""," + vbNewLine
        If s.Fill.Type = cdrUniformFill Then
            text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        Else
            text = text + "      fillStyle: ""none""," + vbNewLine
        End If
        'If s.Curve.Closed Then
            text = text + "      closed: true," + vbNewLine
        'End If
        text = text + "      points: [" + vbNewLine
        For i = 1 To s.DisplayCurve.nodes.Count
            posx = s.DisplayCurve.nodes(i).PositionX
            posy = s.DisplayCurve.nodes(i).PositionY
  
            text = text + "          [" + formatNumber(posx, k_s) + "," + formatNumber(posy, k_s) + "]," + vbNewLine
        Next i
        text = text + "      ]," + vbNewLine
        text = text + "      linecaps: " + CStr(2) + "," + vbNewLine
        text = text + "  }," + vbNewLine
    End If
                
                
    If s.Type = cdrCurveShape Then
        If s.Fill.Type <> cdrNoFill Then
            text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        Else
            text = text + "      fillStyle: ""none""," + vbNewLine
        End If
        If s.Curve.Closed Then
            text = text + "      closed: true," + vbNewLine
        End If
        text = text + "      linecaps: " + CStr(s.Outline.LineCaps) + "," + vbNewLine
        If s.Outline.EndArrow.index > 0 Then
            text = text + "      endArrow: true," + vbNewLine
        Else
            text = text + "      endArrow: false," + vbNewLine
        End If
        If s.Outline.StartArrow.index > 0 Then
            text = text + "      startArrow: true," + vbNewLine
        Else
            text = text + "      startArrow: false," + vbNewLine
        End If
        If s.Curve.Segments.First.Type = cdrLineSegment Then
            text = text + "      type: ""curveLine""," + vbNewLine
            text = text + "      points: [" + vbNewLine
            For i = 1 To s.Curve.nodes.Count
                posx = s.Curve.nodes(i).PositionX
                posy = s.Curve.nodes(i).PositionY
  
                text = text + "          [" + formatNumber(posx, k_s) + "," + formatNumber(posy, k_s) + "]," + vbNewLine
            Next i
            text = text + "      ]," + vbNewLine
            text = text + "  }," + vbNewLine
        Else
            text = text + "      type: ""curveCurve""," + vbNewLine
            text = text + "      points: {" + vbNewLine
            For i = 1 To s.Curve.Segments.Count
                Set n1 = s.Curve.Segments.Item(i)
        
                posx = n1.StartNode.PositionX
                posy = n1.StartNode.PositionY
                posx2 = n1.EndNode.PositionX
                posy2 = n1.EndNode.PositionY
                ecpx = n1.EndingControlPointX
                ecpy = n1.EndingControlPointY
                scpx = n1.StartingControlPointX
                scpy = n1.StartingControlPointY
        
                text = text + "          " + CStr(i - 1) + ": { start: [" + formatNumber(posx, k_s) + "," + formatNumber(posy, k_s) + "]," + vbNewLine
                text = text + "              startC: [" + formatNumber(scpx, k_s) + "," + formatNumber(scpy, k_s) + "]," + vbNewLine
                text = text + "              endC: [" + formatNumber(ecpx, k_s) + "," + formatNumber(ecpy, k_s) + "]," + vbNewLine
                text = text + "              end: [" + formatNumber(posx2, k_s) + "," + formatNumber(posy2, k_s) + "]," + vbNewLine
                text = text + "          }," + vbNewLine
  
            Next i
        text = text + "      }," + vbNewLine
        text = text + "  }," + vbNewLine
        End If
    End If

    processShape = text
End Function


Public Function orderByZOrder2(sr) As ShapeRange
    Dim nsr As New ShapeRange
    
    Dim i As Integer
    i = 0
    Do Until nsr.Count = sr.Count
    
        For Each s In sr
            If s.ZOrder = i Then
                nsr.Add s
            End If
        Next
        i = i + 1
    Loop


Set orderByZOrder2 = nsr.ReverseRange
End Function


Public Function formatNumber(valor, escala) As String
    formatNumber = Replace(CStr(Format(valor * escala, "###0.00")), ",", ".")
End Function
