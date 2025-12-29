Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1B53346A5;
	Mon, 29 Dec 2025 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025942; cv=none; b=kDKFOc7OUg749vJHzAi2Nr8yfLyLj9W7cYXs5RiZGWDXR8zx4v2A0W2WSGhA85/6Y2H6QqpToG8jFaU6t6Yc3dJaU4B2iWWxkG9Pyx2yxKff136B38ZmLVPvRKHNlqPnSImNvlhfdImAziAbaZ+9pcCplxO2ZMZ0FV3TPw6e53c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025942; c=relaxed/simple;
	bh=77eBEOhl59h68SrcKeQc9SXTi8VSi+QV0blf8a5EYMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTnyuDZdwrIuVz7SjxCsVIkRjboa57WEKH33NZZq2vuynKi3hiviikx+7p6aR/HmEAmHPjRacI/9IP2CZWiCqbb6FCoqq9ty3bMsyqrum6KGa7lL0E+pe42CCU62Ihv5At/8qg8cZiCJHcuhGKIhm19XD4rtTcTcApW1PsHXCBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9WJcov2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9WJcov2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C61C4CEF7;
	Mon, 29 Dec 2025 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025941;
	bh=77eBEOhl59h68SrcKeQc9SXTi8VSi+QV0blf8a5EYMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9WJcov2zR6BjzSj35NWkCvoxpxHQchcSRXCIPjMhzCpB0AolhvBmyTIQnNkQYDgO
	 MSEuDZ7lLzUbVg9igCkQg7NoUcZ5pZwSfmhFr1QvQZpayGtTw848AZ79aJ8hzJrgwA
	 c2dglk9nDpoa4U18obk5YDlQgs6PuMpCoF7te/xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 392/430] dt-bindings: PCI: qcom,pcie-sm8150: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:14 +0100
Message-ID: <20251229160738.743468228@linuxfoundation.org>
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

commit 31cb432b62fb796e0c1084542ba39311d2f716d5 upstream.

Commit 51bc04d5b49d ("dt-bindings: PCI: qcom,pcie-sm8150: Move SM8150 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 51bc04d5b49d ("dt-bindings: PCI: qcom,pcie-sm8150: Move SM8150 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-4-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sm8150.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sm8150.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sm8150.yaml
@@ -74,6 +74,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


