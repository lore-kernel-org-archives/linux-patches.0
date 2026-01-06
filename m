Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268A93559DA;
	Tue,  6 Jan 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720538; cv=none; b=atEVfKDnw443B5PVR38pGeQNOLx9+RUiecqz7KGYafhuLr3Hzm1k6AdVycHEshsceOf/HqJ7n1eT0Ujk3jbflUUmvQWXkUSCT+QDNaq+aTm5dQlByGQcRMj18msm02cQGJpDsroSjolF282biQArTNlFDinwgxiVEd3v3bfVJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720538; c=relaxed/simple;
	bh=/zTLd2zUbhN8RQJbsyRU5m+vSF5tsrm9uNESN7ItS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvHp2HOpv/x+5ZkJwJ+GEwYX9KiIywNFS0SqWY6p3N8tmLjWP6fGWOvUPMmQVORgb8Pr2+cV+Ir15NzKF6+CCPCxfxGlWmH9uFym+ZjgRgnWKQCBCFECiMTox/VaH4uu9kL/jreiOSixpqg9oSZt81FGbqKXHMzZ8jfZuRGJp60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cz/4EyHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cz/4EyHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C904C116C6;
	Tue,  6 Jan 2026 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720538;
	bh=/zTLd2zUbhN8RQJbsyRU5m+vSF5tsrm9uNESN7ItS1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cz/4EyHC/SHXKZwUyGxI9Lg5zAAWQ6vr5f/rS5Y1siVLwF7Hm7B4hQblUVL65Agz8
	 7detItKjm1iqEw1sWk/w5xuft9lrt0p+9xQunubrycLiC642yuRYlWpwxmIs8FCzlE
	 /LEX5msr0QmMZW4hEg2hLsxFNRgZ54QK3eqGgx24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 267/567] dt-bindings: PCI: qcom,pcie-sm8150: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:49 +0100
Message-ID: <20260106170501.200977995@linuxfoundation.org>
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
@@ -69,6 +69,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


