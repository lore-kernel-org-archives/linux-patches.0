Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A823CBE69;
	Mon, 17 Aug 2026 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974706; cv=none; b=oGABwO2+aR2dwO8es7BxgN8v05h+ihNXQJfpS4mpN63+PBNkUyueQg0NxTATrZtmd8gD8eiYO134WjI08VVTh9oh0F4sw0bhSwIOKnrjc0AePbEw2rWQVehWGI2T/Ebyw9BalakyCSobqk5HhI04T1CEiCrvMJXwtMCXs3T1XZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974706; c=relaxed/simple;
	bh=oMYeVoSu+ItZTNSEklxP4zXIfKqzIgY7hG9oaei4W14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS0rCHALkDyQsd/m1moLGFHMrky1Ka8Ym/ciIfDesEFGU2oDXYuuwlbZieKRLk1wzLjqRwISo2bH7Ron0QZCdAlxumtFr4H2z0dKwaInYcrx7AYgsmAFDY89LVaUkJL1GB6gb/7ZafEpjyrZ5IN3S6pNbCQsX9flpFdd65s06sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPu+QPZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPu+QPZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E201F00A3A;
	Mon, 17 Aug 2026 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974692;
	bh=fPViEyPTNVjT8eYL9Tpz9QUW5CF5tztSX72OWBDWC3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPu+QPZhY8OKdrtt6/LHhg6VuvtV7pddORFZnIqR026uAVzRO1OAE5+81GDFT7IsK
	 qIKuOYSUpDx/bdNkI9G5S/SL9HxlglnBW8+o6pFfOO2LlJwx138PhVY+ltvKNsU+jS
	 7H8tA/cZubH857OwSoEGCr6sV3nL/QeWmiZXOuDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/250] ARM: dts: BCM5301X: fix PCIe controller 2 second interrupt
Date: Mon, 17 Aug 2026 15:29:42 +0200
Message-ID: <20260817132537.326888336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bab4d538f8485e0d48538fcb82b285df3779278e ]

PCIe controller 2 has interrupts 0-4 mapping to GIC SPI 138-142. The
mapping for interrupt 1 was incorrectly set to 138 due to a copy-paste
error. Fix it to 139.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20260725215722.9323-1-rosenp@gmail.com
Fixes: 3b3e35b279be ("ARM: dts: BCM5301X: Relicense AXI interrupts code to the GPL 2.0+ / MIT")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
index d0d5f7e52a917..f08d0a27de0b4 100644
--- a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
@@ -138,7 +138,7 @@ axi@18000000 {
 
 			/* PCIe Controller 2 */
 			<0x00014000 0 &gic GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
-			<0x00014000 1 &gic GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00014000 1 &gic GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 2 &gic GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 3 &gic GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 4 &gic GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



