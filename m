Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B232863C;
	Mon, 27 Oct 2025 19:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593548; cv=none; b=tLZ82QgErtMm5UJ0ZmZ7oAIn4i5cF9g9WQhT1VdATQ2J17+yPTmP/BUZI5JhnIaNXoEAVM2bupVELWhdZ5OLch4tSK5f4vG3cNQdaHWXvQIvYZToGDUy8Q1W5dL4XvsudMSHBoYqPTmrjbw8v0k1Y0Gs4Vr9QI3HlpMxPCyK4jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593548; c=relaxed/simple;
	bh=tObrKUTGOTfpq4MLZu5YcsMmbp8yFcoT/6CAywx2Ejg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVXWWTO8GkZy2I56/1rcoKlEcwFa3TM08H8pUA3aQQevsmNL66GnSsyS7zTdTkkuen9Qo20AMq7ekX/GalCJfWliYqL4/C1598LbIIX94eCiEZhhlpubcUi2uW/NhHVC5VdcqvdwUqr7wTmVbHVAHxj3LDRtOYW02IAntJShv5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCWbdUtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCWbdUtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6803CC19424;
	Mon, 27 Oct 2025 19:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593547;
	bh=tObrKUTGOTfpq4MLZu5YcsMmbp8yFcoT/6CAywx2Ejg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCWbdUtWR5RrpVJfpnBQlHF5IXl1wxQB5Pls+iLe+iwJtqqyaJem5VlLEdLPkOkR5
	 s3IJ06WgLbXK+KGZXafSX7/hfO02884tVwCnIiEpmUHqpV9eyN/m8/WVhHCgfwsi4+
	 tgb0+PaqeAww9ZLDOjR88O4oF6Yr4I1eFtB4m1pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.17 169/184] dt-bindings: usb: qcom,snps-dwc3: Fix bindings for X1E80100
Date: Mon, 27 Oct 2025 19:37:31 +0100
Message-ID: <20251027183519.475817206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

commit 51cb04abd39097209b871e95ffa7e8584ce7dcba upstream.

Add the missing multiport controller binding to target list.

Fix minItems for interrupt-names to avoid the following error on High
Speed controller:

usb@a200000: interrupt-names: ['dwc_usb3', 'pwr_event', 'dp_hs_phy_irq', 'dm_hs_phy_irq'] is too short

Fixes: 6e762f7b8edc ("dt-bindings: usb: Introduce qcom,snps-dwc3")
Cc: stable@vger.kernel.org
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml b/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
index dfd084ed9024..d49a58d5478f 100644
--- a/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
@@ -68,6 +68,7 @@ properties:
           - qcom,sm8550-dwc3
           - qcom,sm8650-dwc3
           - qcom,x1e80100-dwc3
+          - qcom,x1e80100-dwc3-mp
       - const: qcom,snps-dwc3
 
   reg:
@@ -460,8 +461,10 @@ allOf:
     then:
       properties:
         interrupts:
+          minItems: 4
           maxItems: 5
         interrupt-names:
+          minItems: 4
           items:
             - const: dwc_usb3
             - const: pwr_event
-- 
2.51.1



