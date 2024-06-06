Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5976D1C372B;
	Thu,  6 Jun 2024 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683661; cv=none; b=OwXvWKHoegDigwUqs+Guwi9sJt9byGH2CcFPlDbNq2uy8eecMJbmdmfL+C7ILGdE13W/FcAOzinzWwqthj8yHeLkGAffDzILw4tsfAiY9yzLJgLXQA2bo6gyN0DYUHwwrpX4Qfu1HXvss1uei6SA26C+iTeNxeiIKcse/HeLCaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683661; c=relaxed/simple;
	bh=Nd0DpqHggqYkSRhTH4waLDJchF0CMAmPNHdeWJaa0yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n7paCNQN0Ntuf3lURV8id2Gf9Fe+zkA0zMJPv0576iCuOGfc/Zl7RTgDG+XOLFPaOLNxSftu2nxwfK1FgmU0uor2+LtUNwDsZj1PB16oTgaZ/I9X5hOWvyA7pZ6OUYx/SmGwKWQjsU20E2r8qwndyv04KBpT/7nHHUr0Rnjgn2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB8SUlBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB8SUlBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BFFC32781;
	Thu,  6 Jun 2024 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683661;
	bh=Nd0DpqHggqYkSRhTH4waLDJchF0CMAmPNHdeWJaa0yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB8SUlBPNyA3h37TGo8IIpWRCSg7dFTbu4Vm7TVAEdJxhJpvwNwmHX+xc7ZX8a7EJ
	 LctDPWsp/IU2XbAyjjjEaJGOYN2u7IbXBPA4deSBJJoCdBWbfEf8JgOuqsZiG3VlMT
	 RjRvj5Sitb4sprO317c5s04NsU3DDoTy8QsFAI5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 542/744] dt-bindings: PCI: rockchip,rk3399-pcie: Add missing maxItems to ep-gpios
Date: Thu,  6 Jun 2024 16:03:34 +0200
Message-ID: <20240606131749.838620197@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 52d06636a4ae4db24ebfe23fae7a525f7e983604 ]

Properties with GPIOs should define number of actual GPIOs, so add
missing maxItems to ep-gpios.  Otherwise multiple GPIOs could be
provided which is not a true hardware description.

Fixes: aa222f9311e1 ("dt-bindings: PCI: Convert Rockchip RK3399 PCIe to DT schema")
Link: https://lore.kernel.org/linux-pci/20240401100058.15749-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml b/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml
index 531008f0b6ac3..002b728cbc718 100644
--- a/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/rockchip,rk3399-pcie.yaml
@@ -37,6 +37,7 @@ properties:
     description: This property is needed if using 24MHz OSC for RC's PHY.
 
   ep-gpios:
+    maxItems: 1
     description: pre-reset GPIO
 
   vpcie12v-supply:
-- 
2.43.0



