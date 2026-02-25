Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E832D7D42;
	Wed, 25 Feb 2026 06:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002787; cv=none; b=KP7yM1IRJG+mCHxYM3BTthN8i4SZ2nk50bEYzQvITBVY70HRpreTOKlWHDtWwx8IJf+pjIewY8YX04UlI62x3qO+MtvrZJ/6kyhFBXQEE1mwUzZYB9A/DIqOrw1eZeFoie6cpvmPymFn2EbJxWRzNrJsCAvKqJM4TKRuuDCUXyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002787; c=relaxed/simple;
	bh=auSbsCI7scxOD5eXre+XqNLdcTHpSqNvVX2KMH8avF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBC6RTnoiXuVtBTDgK3LVs/Am07PYr5EvyaYA0yprrm0n+M2rnoZ/f9vgNIwQkSQ9Zs1CkeOmQf5Zqyz5oKqZTg68bYCHcefImZnQVe7gBSjpkfJlTMUscCBtPzuTi3iBHVMyGzdaHd+DotbcB2I3tuQWE6tCWlhMHTaxAN2twk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEuvZDuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEuvZDuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFE8C19422;
	Wed, 25 Feb 2026 06:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002786;
	bh=auSbsCI7scxOD5eXre+XqNLdcTHpSqNvVX2KMH8avF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEuvZDuCpLc2ZNdz0uj7/ugBPz08k9bcLBWLJBsatx7KTHndXcpHUIFEFa3B6xPkL
	 8RTRvNi+8vuiw+G7akCMU/UpmRMB3XpF7sESF5yydzPh6rUfIkbGP3ZFj5+bIhWF7P
	 0HFg3ukT/FHWlgsOguEXla+inJuMKuzeoBH2WxLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nihal Kumar Gupta <quic_nihalkum@quicinc.com>,
	Vikram Sharma <quic_vikramsa@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 628/641] dt-bindings: media: qcom,qcs8300-camss: Add missing power supplies
Date: Tue, 24 Feb 2026 17:25:54 -0800
Message-ID: <20260225012403.720919784@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


