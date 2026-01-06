Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F4F3559C4;
	Tue,  6 Jan 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720541; cv=none; b=VgPOU8xHvgQQvlkfcL7iGjMPwtanuHhqI/7+gvzgUVt9hTslhIaQDOq+94+5A5QBp4761aMukqv4Swc5aNJHSvij01dDiQJtR6BbPUE69FfGvurnlUnWS7HQp9sDiTTGsFOeGgijtaP4d3TmHjhmG/JIfgR/HuJARz+d/CSjWcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720541; c=relaxed/simple;
	bh=nVFlFoWB3q0UvBe0P90YrnZWpKD6A6FmAocBzjmZr6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AASULiqHgkR4vVSPgwc5sTmVmAhxNs415yTfEIVwJbqzHvAJQv7tpGfkn+zfsstjBe1QIP1mUlUtEZ6SwY5njjG+MnylHQ0V3bz6d4EDgBCzh8U4wJlnlIufHS0KJxiUEmReaQTrOCWfXV5zqL5lhiQJKlXvLejPU3kf30+akvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1ljI4dI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1ljI4dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF161C116C6;
	Tue,  6 Jan 2026 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720541;
	bh=nVFlFoWB3q0UvBe0P90YrnZWpKD6A6FmAocBzjmZr6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1ljI4dImssQZVE066WcGhX0cFGCXU9Y8is9JQeOGXYjYVEX2cv+JWPEPGhFjRXLC
	 jV8dMOWskNUco8SKHPRJhOqFpJ47MNhZuz8ZMqcIzio3xTO+gXeOVGzTeHhb/6ROcf
	 bRktTCs65Qecl1D0FObgLXJ9BwGoqKZKXL8su4N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 268/567] dt-bindings: PCI: qcom,pcie-sm8250: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:50 +0100
Message-ID: <20260106170501.239087537@linuxfoundation.org>
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
 


