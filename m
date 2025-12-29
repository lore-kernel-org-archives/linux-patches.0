Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCB3334C23;
	Mon, 29 Dec 2025 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025948; cv=none; b=GU8lqghr5m+xeqDsKjtw4z0g8ctO/n9TWXQo6EMaDrQYielPkFsMuApryvObPzfGwwMWQvbsZwN3VJ8OnjA5zroDMg3FDSo/g0gGbejUGjYvQiFKXH8/4EMDMTlCvmlfoh/1os0ikCtRzU/gf6FWuAx8MttEKhai0FCVBVLrZhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025948; c=relaxed/simple;
	bh=1cjfDlubJFNBxflPXj1Wz3+X19jZ69t2QPVi/WtzB9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFY3k7n8yki0xmPQhao0gnrrQSTGV8P9fX8NxW+BW+fHjP4C8ZBQT8ibU8W7hbeDkBRradpFrSRpdAPyNMDmZ2qAMZpuFrtFzELThJcEGilCbRzjDAQ1Wg5VeLjevnv5KgD7VSw5CgsCQH9lXVxjBB8H5sJ44bLdQfHE1FJohHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3Et/2Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3Et/2Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7762AC4CEF7;
	Mon, 29 Dec 2025 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025947;
	bh=1cjfDlubJFNBxflPXj1Wz3+X19jZ69t2QPVi/WtzB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3Et/2KwMjwipttdQxiAlEH3NKp0OfvQp1VtlL+rWyi3B6AQpBuoPwPPARIsoInzj
	 NbMDBPpxUcYBZsOIm3e/N2oGyCGdZ4BoQ7qK0IzxTp48yGXR+xGYVYxNwU6vecdtsy
	 JF4ZVPZCOsKP0MV854m88/vOcXN6eh/143XL/Yxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 394/430] dt-bindings: PCI: qcom,pcie-sm8350: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:16 +0100
Message-ID: <20251229160738.816034389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 012ba0d5f02e1f192eda263b5f9f826e47d607bb upstream.

Commit 2278b8b54773 ("dt-bindings: PCI: qcom,pcie-sm8350: Move SM8350 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 2278b8b54773 ("dt-bindings: PCI: qcom,pcie-sm8350: Move SM8350 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-6-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sm8350.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sm8350.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sm8350.yaml
@@ -73,6 +73,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


