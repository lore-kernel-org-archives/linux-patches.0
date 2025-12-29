Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A22334C39;
	Mon, 29 Dec 2025 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025939; cv=none; b=eB1WPhdpENpslXZqkRoBY9iKvavDKifcz+n7X450M1TCrYN54j9N/Ax0f2qAE3RKY3rM8CBHYNOmf8hft0GubaPuPOpbKUst3eQPMnMkAS/dWpcsVncMHwMWfSpXK4jGzFN23vJJbJWYrIy++n9nsKbSUTAZxwpHPagUhsgvN7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025939; c=relaxed/simple;
	bh=YdjtZVqElN1axQ/6uJOUNy1YuLlvne+ziuSDqJ/Ja90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taTJvLhjYfSTtaB7F4eG4aMD1XOElxPLtzgx3UhlAngTnzYYZ6MtoQ2GjBj16NImR5BL07uNJOuLT7oq0Vk5B1I0kwJ5UDCdyTnw0VIvAo9l/MmEyCR2pWffayL/PtRNxYuzb9bngB4+uRXdGfhst2brSkcckfA7Fi4kGpUzq+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVxmNb7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVxmNb7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA628C4CEF7;
	Mon, 29 Dec 2025 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025939;
	bh=YdjtZVqElN1axQ/6uJOUNy1YuLlvne+ziuSDqJ/Ja90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVxmNb7iKzGMcFRRoS8uRIwzH7viNyrOpQYrWbN97NJFJ6Etx4Zt+BgfhVngYvEpC
	 78j92OYDc7gOs70KS9nqX+D55riLqpUzGSm6Rt4Kw1l6dX1Kj9mx9t8Dkmsou/Bkk+
	 ZRlVERcxs+TEbS2h9mVG8SuHzLbX9t4AuOyLwoGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 391/430] dt-bindings: PCI: qcom,pcie-sc8280xp: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:13 +0100
Message-ID: <20251229160738.707391073@linuxfoundation.org>
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
 Documentation/devicetree/bindings/pci/qcom,pcie-sc8280xp.yaml |    3 +++
 1 file changed, 3 insertions(+)

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


