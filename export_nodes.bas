Attribute VB_Name = "export_nodes"
Sub ExportNodes()

    Dim OrigSelection As ShapeRange
    'Dim Selection2 As ShapeRange
    'Dim TempSelection As New ShapeRange
    Dim s As Shape
    Dim s2 As Shape
    Dim grupo As Integer
    Set OrigSelection = ActiveSelectionRange

    
    Dim text As String
    Dim counter As Integer

    text = "{"
    counter = 0
    grupo = 0
    For Each s In OrigSelection
        If s.Type = cdrGroupShape Then
            ' se é um grupo, processe cada elemento
            For Each s2 In s.Shapes
                text = processShape(s2, text, counter, grupo)
                counter = counter + 1
            Next
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
    text = text + "      linecaps: " + CStr(s.Outline.LineCaps) + "," + vbNewLine
    
    'If s.Outline.Color.IsCMYK Then
    'Else
    '    text = text + "      strokeStyle: """ + CStr(s.Outline.Color.HexValue) + """," + vbNewLine
    'End If
    text = text + "      strokeStyle: """ + s.Outline.Color.HexValue + """," + vbNewLine

    If s.Type = cdrRectangleShape Then
        text = text + "      type : ""rectangle""," + vbNewLine
        text = text + CStr(s.Rectangle.RadiusLowerLeft) + vbNewLine
        text = text + "  }," + vbNewLine
    End If
    
    If s.Type = cdrEllipseShape Then
        text = text + "      type: ""ellipse""," + vbNewLine
        text = text + "      center: " + "[" + formatNumber(s.Ellipse.CenterX, k_s) + "," + formatNumber(s.Ellipse.CenterX, k_s) + "]" + vbNewLine
        text = text + "  }," + vbNewLine
    End If
    
    If s.Type = cdrTextShape Then
        text = text + "      type: ""text""," + vbNewLine
        text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        text = text + "      text: """ + s.text.Frame.Range.Characters.All.text + """," + vbNewLine
        text = text + "      size: """ + formatNumber(s.text.Frame.Range.Size, 1) + """," + vbNewLine
        text = text + "      font: """ + s.text.Frame.Range.Font + """," + vbNewLine
        text = text + "      posicao: [" + formatNumber(s.PositionX, k_s) + "," + formatNumber(s.BottomY, k_s) + "]," + vbNewLine
        text = text + "  }," + vbNewLine
    End If
                
    If s.Type = cdrCurveShape Then
        If s.Fill.Type <> cdrNoFill Then
            text = text + "      fillStyle: """ + s.Fill.UniformColor.HexValue + """," + vbNewLine
        End If
        If s.Curve.Closed Then
            text = text + "      closed: true," + vbNewLine
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
