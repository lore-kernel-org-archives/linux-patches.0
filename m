Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B45F2690EC;
	Wed, 25 Feb 2026 01:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983688; cv=none; b=D+f8WgUkpTz/jptx8xHVeahYXRHFJDg4MpYDiUtiHioLI0ujq3qnzkvHewDxBvLYscoaLdZz0m/j8mCieidt+HScacMrv2YJKqyTuVqPLRAocuxWIsIBUOfnbtTZDLH6AeG6SfI/Zs0o9Ci4v/AfHYp0XcwenwwK3nER/Us97v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983688; c=relaxed/simple;
	bh=jz+UEefKkEvT/7EDvNUJ/xRzswZViTuq9fJD6O1DFPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYdnF4H1ukSYnzRQa99rE3d3Rke6WsApDpGU56WHNrDPpPDAtLFV3HdX65rXJhuI1ixlA7asBBtzkly/sACMXXkL1UxuJF2/UjRkzh2Q1Euu3ZtyiDYmRqwLXAJKkS2mSm5ckAFkQOjetFJ+3oqH6UJaXzpVm+fodxSjR7tQ1iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txf5oI5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txf5oI5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1FDC116D0;
	Wed, 25 Feb 2026 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983688;
	bh=jz+UEefKkEvT/7EDvNUJ/xRzswZViTuq9fJD6O1DFPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txf5oI5UWHVw6bzKhk1H6TRY7EpQ0s/LK1H8ii03nnXDL1e0cdJHrWyx0nz9Inflt
	 ji9lg5smpOccMPdUNhMRUSm2bP4+tsHhLcGP/412l0o9oCYejC16F2HIk5wDGo1oRi
	 o9p/lpDcRQIyheKrTeWf+SVSCOgFbYhcTQMK/WYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nihal Kumar Gupta <quic_nihalkum@quicinc.com>,
	Vikram Sharma <quic_vikramsa@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.19 771/781] dt-bindings: media: qcom,qcs8300-camss: Add missing power supplies
Date: Tue, 24 Feb 2026 17:24:40 -0800
Message-ID: <20260225012418.627910241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikram Sharma <quic_vikramsa@quicinc.com>

commit 555e882051a3a7ecc2bcee2b2047822249dcd074 upstream.

Add missing vdda-phy-supply and vdda-pll-supply in the (monaco)qcs8300
camss binding. While enabling imx412 sensor for qcs8300 we see a need
to add these supplies which were missing in initial submission.

Fixes: 634a2958fae30 ("media: dt-bindings: Add qcom,qcs8300-camss compatible")
Cc: stable@vger.kernel.org
Co-developed-by: Nihal Kumar Gupta <quic_nihalkum@quicinc.com>
Signed-off-by: Nihal Kumar Gupta <quic_nihalkum@quicinc.com>
Signed-off-by: Vikram Sharma <quic_vikramsa@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/qcom,qcs8300-camss.yaml |   13 ++++++++++
 1 file changed, 13 insertions(+)

--- a/Documentation/devicetree/bindings/media/qcom,qcs8300-camss.yaml
+++ b/Documentation/devicetree/bindings/media/qcom,qcs8300-camss.yaml
@@ -120,6 +120,14 @@ properties:
     items:
       - const: top
 
+  vdda-phy-supply:
+    description:
+      Phandle to a 0.88V regulator supply to CSI PHYs.
+
+  vdda-pll-supply:
+    description:
+      Phandle to 1.2V regulator supply to CSI PHYs pll block.
+
   ports:
     $ref: /schemas/graph.yaml#/properties/ports
 
@@ -160,6 +168,8 @@ required:
   - power-domains
   - power-domain-names
   - ports
+  - vdda-phy-supply
+  - vdda-pll-supply
 
 additionalProperties: false
 
@@ -328,6 +338,9 @@ examples:
             power-domains = <&camcc CAM_CC_TITAN_TOP_GDSC>;
             power-domain-names = "top";
 
+            vdda-phy-supply = <&vreg_l4a_0p88>;
+            vdda-pll-supply = <&vreg_l1c_1p2>;
+
             ports {
                 #address-cells = <1>;
                 #size-cells = <0>;


