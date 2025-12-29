Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B1A331A45;
	Mon, 29 Dec 2025 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025936; cv=none; b=brfb2LDC+FtGmhvV2hCGCrzjEgJTcsnRJoQzF2WcvJ4adceIkmDK1ALclMPbPd3r2h4dambO8ps2ahQNjHm7RzKYe6uFC37ulI4Pq/MTd+attusxGSKu3DqLYlkyxlVK9VqUXMIHxK91U9Bl511ol03nb9wWNyvx9d3mrBpLWGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025936; c=relaxed/simple;
	bh=O3NcR/Ke8u8ELqu8zd9IKNhi9p2VfmgZgyLqqR5FV3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6R2aMa+kRmROFHpV1WGNYnU2R0m0XYoYeyG9zf7hUcp5LYFllbQSGLrsBSbc6kq33RP5hmdo0DsSavzwuGvk5hito+Z8R+7fjHYWqGtE4N1fqkX+V/cCza+dQaNMe9H/iiuVpfK13Rm0pTkPB/OIZt55M5T1jJn95V4nCni0wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzdB/0QU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzdB/0QU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E552CC19423;
	Mon, 29 Dec 2025 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025936;
	bh=O3NcR/Ke8u8ELqu8zd9IKNhi9p2VfmgZgyLqqR5FV3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzdB/0QU9wtZlF9U9OWxKVl8A1cDExX6x9pXPv3N2XribmOjnV9RtA5cf0+q+9DQG
	 iXA4OJQxhI4Zg4rjzWqH2ekghRTEFO7JxwBxARUTMx01+J09Z09mGykxx1mXHR9bNl
	 zWR0uUWd7SDClaoTQ6UJL+984bFp5IOwfXSi9EHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 390/430] dt-bindings: PCI: qcom,pcie-sc7280: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:12 +0100
Message-ID: <20251229160738.670792469@linuxfoundation.org>
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

commit ef99c2efeacac7758cc8c2d00e3200100a4da16c upstream.

Commit 756485bfbb85 ("dt-bindings: PCI: qcom,pcie-sc7280: Move SC7280 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 756485bfbb85 ("dt-bindings: PCI: qcom,pcie-sc7280: Move SC7280 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-2-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sc7280.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sc7280.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sc7280.yaml
@@ -76,6 +76,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


