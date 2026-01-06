Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407323559DA;
	Tue,  6 Jan 2026 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720535; cv=none; b=W/VSfDRUoqgI5Bp4VrcCTRWgGndphsJuOFT7Y0KqL4AzPzTDCXMXvhNu4eF6Bd4g+YU25Upxka0C+KM1IlLHJG+i3WfyyaaPDn9J9mwKoZXDyCQFkfbU1N660vpX1wemNA5wqeYEotpttWNqWHynu1QFROWS6NLMkGDXF+rTAkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720535; c=relaxed/simple;
	bh=SpVzZ7va6emnhcHx3cw84H5YT4oYg+fQGolcdjnt+uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y55C8oNC/LYjOsZu0cbxui5C85CdS8NHjmAky0mghmcPP63d62+q0YWpQ1NArMZtLjM5VtWHqPIsdLUhcDfDq1bfLqcHEEJnJ9poxbZKbd8Tqyin5LugjihRwnLZ6Cb6npCZoPYJV8Mrh//ieb0OP22x6Rqp3wbBdRUxy6iCqWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfedYHgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfedYHgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60296C116C6;
	Tue,  6 Jan 2026 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720534;
	bh=SpVzZ7va6emnhcHx3cw84H5YT4oYg+fQGolcdjnt+uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfedYHgY9lmrkNqXqTl19VMh+9VnMebzaj6Cm5rZ4K4q4GdEvIQVq52mElqrjLfih
	 FTdzpNYHhgj1wWPhuZxiYX8w/7H78egaGUJNHkphj5Xnezf0Q/NVqWBkZ1Wx7IPZh9
	 Eu97+RQkS1+WcCGXEvC25uf0/JHGu42AlHXRfS1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 266/567] dt-bindings: PCI: qcom,pcie-sc8280xp: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:48 +0100
Message-ID: <20260106170501.164630283@linuxfoundation.org>
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

commit ea551601404d286813aef6819ddf0bf1d7d69a24 upstream.

Commit c007a5505504 ("dt-bindings: PCI: qcom,pcie-sc8280xp: Move
SC8280XP to dedicated schema") move the device schema to separate file,
but it missed a "if:not:...then:" clause in the original binding which
was requiring power-domains and resets for this particular chip.

Fixes: c007a5505504 ("dt-bindings: PCI: qcom,pcie-sc8280xp: Move SC8280XP to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-3-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sc8280xp.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/qcom,pcie-sc8280xp.yaml b/Documentation/devicetree/bindings/pci/qcom,pcie-sc8280xp.yaml
index a18cba10acea..bc0e71dc06a3 100644
--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sc8280xp.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sc8280xp.yaml
@@ -61,6 +61,9 @@ properties:
 required:
   - interconnects
   - interconnect-names
+  - power-domains
+  - resets
+  - reset-names
 
 allOf:
   - $ref: qcom,pcie-common.yaml#
-- 
2.52.0



