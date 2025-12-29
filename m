Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269A93346A5;
	Mon, 29 Dec 2025 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025951; cv=none; b=RwRn9Xshqs+rlEKcid8xRtKREom/OJeOLuN08mFtRXTWo7pZrn43cnwu1Swok4h6JljBz1d0kRkq2aKmcmefY95yROirNmG2mcStYJCvi3pCcvDcX43iK0su+Igm5c6+tuqDSe1P1BacTIioD9L/mK83lOmREs5JtEe0ELNrsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025951; c=relaxed/simple;
	bh=PKrHVVfK/FIM2EvBoSWL+M16WQQrrTqYZE+GzU/MaCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXz/pe6YNNw7Kg44a5LkE5bHajvlTizl5GGRusqPeRg+oPx9TxAPAX7jKrdQ/rRWJNm7/CuyZL9d6j9U7pxGM9toZkLDcXhaK/j6KooLMH3dBh/HG/OyTjA4SK3rc/FgR0sCCRvW+qRStksU/gqpzaapqS2GeXkvaOoeX+t1WUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUQotzkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUQotzkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BC8C4CEF7;
	Mon, 29 Dec 2025 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025950;
	bh=PKrHVVfK/FIM2EvBoSWL+M16WQQrrTqYZE+GzU/MaCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUQotzkjvDXDklS2M1rOSZibIk6LS9NgUQYj810ymMErQFhiCODi3rCbnu/ZPq13u
	 1sISs/17NPloOgyjM5/zhyU+4CwFCqdZBk+57waCqLHKFPX+sNYoBe0cHU+zaCefXC
	 yZx271x3GM2q0vHiD1TT4W+Da5fM62hEe/a0hYLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 395/430] dt-bindings: PCI: qcom,pcie-sm8450: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:17 +0100
Message-ID: <20251229160738.852740770@linuxfoundation.org>
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
@@ -77,6 +77,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


