Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040764;
	b=yv3VWsB8EOAmOVAWw87LtuPK1me8XF4xgpDwnJ7U85TLZm1SVpO+i+26l2FPiellfZg/
	 3/uF15rPTMpt/oX24aQS+il8FO5l/NVEqSXXjeR2bloqyMjw5BUXWGHJEpxBzyBL6BfKf
	 Y7CKIsh78cIKDl9fxt3jGE9XavRRU+jvTJa5U7R5YECLCx5JXncF3FvCwwYX0r+M4qxeA
	 GEBNku0cqA31WrSm28HOZ3oAgsBH5X4WYKnV/+wkET4GwkfO9OGhJ6QeoVr7QqI3VeTGM
	 WxHaZSy+zDGa0fpn8yCXPNLXovTogyULu6G4FjqRoLm//Dk11jQ21v3/BkPKk01DvPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ce67ZPgpDJehJgE85kE3Nx7d/kmoAVk0MRQfMYR0K2E=;
	b=R1/3oa0+lb1TgqU9HfD1JerPxCcEvawAai9yDwf4syg/Y9flqIFLvLl6AalHl+5KX5QH
	 ZDZaTJQRtQiyR1vpJqmssKDp6wlug878vp4YHzB+vndBfkOd8P/lvdKLII3fIyScwUI9P
	 MCnB7rbfv9zxTtIIlGqT7NkaB7wX+B9FdLWfdWuUScNVg/mrSm/PxBYCLJJk0rx//xbKv
	 3DoW+63frU8SCkTGapwMRZEHhxWKDiNqvGmW4uF72PFcAgg4ort2c7qfEY8u4ucKOgLNM
	 hZczfGV2oYFaX+1U6SJHLb6k63XSRz+5YM0hW8q1j/F3e88tiFLHyBNBKU6EDANbTUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqfswndZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2553B606A31C;
	Wed, 18 Nov 2026 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqfswndZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488101F000C4;
	Wed, 18 Nov 2026 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040763;
	bh=ce67ZPgpDJehJgE85kE3Nx7d/kmoAVk0MRQfMYR0K2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqfswndZXbWakeUxY6KUXaD34+yMqw0HIbD9slSGsoXtWZDN9WDmzZB6tnGn2g6TI
	 lK6ldr1iE0QJLsxqGAnJtvSGxqpdcMNqHcaazavUHO7nbpZoLkXcoxUlk5yejBQpQd
	 C8y96E2TDcjqbqYHqGPJCGrmhVfD/dya3oWMU1TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2572/3318] ARM: dts: ux500: Use AB8505 charger compatible
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150438.385602156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit ff1501cbb825de117267124ecb8898112b4051c5 ]

Identify the AB8505 charger using its variant-specific compatible and
retain the AB8500 compatible as a fallback for the existing driver. This
selects the AB8505 interrupt constraints from the binding.

The AB8505 interrupt table explicitly omits the five interrupt sources
belonging to the AB8500 main charger. Remove these nonexistent interrupts
from the AB8505 charger node, leaving its nine USB charger interrupts.

Fixes: bc324d447fba ("ARM: dts: ux500: Add interrupts to charger")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/ste-ab8505.dtsi | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/st/ste-ab8505.dtsi b/arch/arm/boot/dts/st/ste-ab8505.dtsi
index 131c82508e820..4c9a8418f225a 100644
--- a/arch/arm/boot/dts/st/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/st/ste-ab8505.dtsi
@@ -137,13 +137,9 @@ ab8500_btemp {
 				};
 
 				ab8500_charger {
-					compatible = "stericsson,ab8500-charger";
-					interrupts = <10 IRQ_TYPE_LEVEL_HIGH>,
-						     <11 IRQ_TYPE_LEVEL_HIGH>,
-						     <0 IRQ_TYPE_LEVEL_HIGH>,
-						     <107 IRQ_TYPE_LEVEL_HIGH>,
-						     <106 IRQ_TYPE_LEVEL_HIGH>,
-						     <14 IRQ_TYPE_LEVEL_HIGH>,
+					compatible = "stericsson,ab8505-charger",
+						     "stericsson,ab8500-charger";
+					interrupts = <14 IRQ_TYPE_LEVEL_HIGH>,
 						     <15 IRQ_TYPE_LEVEL_HIGH>,
 						     <79 IRQ_TYPE_LEVEL_HIGH>,
 						     <105 IRQ_TYPE_LEVEL_HIGH>,
@@ -152,12 +148,7 @@ ab8500_charger {
 						     <22 IRQ_TYPE_LEVEL_HIGH>,
 						     <21 IRQ_TYPE_LEVEL_HIGH>,
 						     <16 IRQ_TYPE_LEVEL_HIGH>;
-					interrupt-names = "MAIN_CH_UNPLUG_DET",
-							  "MAIN_CHARGE_PLUG_DET",
-							  "MAIN_EXT_CH_NOT_OK",
-							  "MAIN_CH_TH_PROT_R",
-							  "MAIN_CH_TH_PROT_F",
-							  "VBUS_DET_F",
+					interrupt-names = "VBUS_DET_F",
 							  "VBUS_DET_R",
 							  "USB_LINK_STATUS",
 							  "USB_CH_TH_PROT_R",
-- 
2.53.0



