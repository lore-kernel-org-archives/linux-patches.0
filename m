Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89FE2F619A;
	Tue,  6 Jan 2026 17:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720547; cv=none; b=VcodqEO7PkxJrDvA3Qb9CvyGLaOSu5Fjh/EcQ8RgbcwdkS7AYk0ny8Rd7UPEvZsBHp4gPBexnwtdcHeo403/w+YLicbphxWSugpEmlccfDYGYkN6BqXB66Qxaa3SjVGjrj0ThlWST8BNuWZAArvE5G3dHV0RRMfgpbNgZ5ml+io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720547; c=relaxed/simple;
	bh=E5XjxIEcVt41tVfT9uWVcfHo10DdLZSa4U1dcxN01Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMwoe9+lczqiae+ibQtVorvgsK6N3D0ruSZTwUe/s6WBfj1bhh59xXhKaHjj0fZXlpAFfWWYBwWk7lx43htXPL7Hutow4jPtLmc9I+sADFu2//QtLNBZXO3IS9v5M34B0hOs6GBr6owxeGY7QZEDBITsPfjcYxBZs1X6LM4lpJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqIYf0yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqIYf0yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A082C116C6;
	Tue,  6 Jan 2026 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720547;
	bh=E5XjxIEcVt41tVfT9uWVcfHo10DdLZSa4U1dcxN01Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqIYf0yLOK+sCXV/EOwN1Ra3h+WZVRXYXwjbrRw/je0HGhPB9MgpBU/XbORR+pT1e
	 vxBUmwFk4YZeSucLfNbUSRQ2gHLh94pROEmMPAo6/G5G60VuQymLf+LjZSxhba3PhU
	 jw2AABdSl9lI/5cZaGFawYc5t/JlVlTXG6Gu49XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 270/567] dt-bindings: PCI: qcom,pcie-sm8450: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:52 +0100
Message-ID: <20260106170501.312267042@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 667facc4000c49a7c280097ef6638f133bcb1e59 upstream.

Commit 88c9b3af4e31 ("dt-bindings: PCI: qcom,pcie-sm8450: Move SM8450 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 88c9b3af4e31 ("dt-bindings: PCI: qcom,pcie-sm8450: Move SM8450 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-7-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sm8450.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sm8450.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sm8450.yaml
@@ -81,6 +81,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


