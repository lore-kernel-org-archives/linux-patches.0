Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511E1334682;
	Mon, 29 Dec 2025 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025945; cv=none; b=dmsqS7qICBThlrEjyHgHOa2JGXWatL+O8G+Iy9TUH5mgLD6JKtLft38L0lYLNYIvcQnxlypRVcaNhcCzcke8cWqpiVIYvsxjs/lUXXkZpnyNnWv0fmdg5qSRW6tyEuSyxG/9fcRRbt7gAWaRPiX+/U205QUHUwXCYx8aRtxqKuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025945; c=relaxed/simple;
	bh=+9DEaXJSGpyLamT3nvKokevZli+SOGS6l8oHWfc+iy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt8A82TrZto1eyAGG3EcCzs9ljEw94zEtGC2+w9DJUB6wXIqiOe1xV7PrNqLyH/VMIuQAlr7tYwNbsuXLwTchemHPsX27NISWNCXkDTfh0UtY64x2Qdq0eZCxvU41oTJhBT2BC2IyElT/GDr2pFkq3YhaZ4LtnHNm87VeifgQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEAS6K9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEAS6K9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5867AC116C6;
	Mon, 29 Dec 2025 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025944;
	bh=+9DEaXJSGpyLamT3nvKokevZli+SOGS6l8oHWfc+iy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEAS6K9N0Sbg532Cj1MCVGQlCjwmfuOZPF5+PjHfwGnx0quCQMasLMG5pMNJy9mOD
	 x75RhVUtnNBxTW92VysAqcpftPcduVW6qbyM3lLAIZXakY4FUujSEYOLtSq/Rq4fut
	 sGu/6sDs5KNn1zT7fLkyNSTD1u2ImwtFP97fXq9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 393/430] dt-bindings: PCI: qcom,pcie-sm8250: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:15 +0100
Message-ID: <20251229160738.779875893@linuxfoundation.org>
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

commit 2620c6bcd8c141b79ff2afe95dc814dfab644f63 upstream.

Commit 4891b66185c1 ("dt-bindings: PCI: qcom,pcie-sm8250: Move SM8250 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 4891b66185c1 ("dt-bindings: PCI: qcom,pcie-sm8250: Move SM8250 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-5-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sm8250.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sm8250.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sm8250.yaml
@@ -83,6 +83,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


