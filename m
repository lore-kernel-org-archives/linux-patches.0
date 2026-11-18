Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030834;
	b=mNZcXLJMNlZEza7sHyvYy633rhr5nEp5f3GwQALv7vaB/tjf7Ew5sKz4yd/duLo8zKbH
	 cPxSLXkELscyT03eT3Mj5xFf8pna+nJsnKRZyjL3wWZNcyQDKwR8Vk7SComLbwrbD3iaV
	 Kwca7P0S39hO61+fg9I0rN0pd8LYHOK9IV9npLzMJBKLNtxIIX8QJ9y/+xy/WClXnVp+I
	 B9Xy3opRbX14OyOXhX3P7PbA4qh57bVLiyOTS96T8EgNbvf1u8PZstwmJveXS2rdFAU3E
	 E9nUPT25n5q8L58O+zL9PUFEd+iDxlCTjjWsnU6CI1l5LChbHqe53f7Q+8K8plHKTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4dRZBNIkhg6663C44RjGrwy2M24T9A2nMFRbmDIb+Y=;
	b=FJKr3XtiZZLV6fMKFek02vSyBuoD1OUhC4cD+yDco+9lRAgBDL18lHgQuJfH0rCZjmOk
	 R76RzaKp/zL3aV7WjjjGwP9hqeviEkC6Zy6P2IEemCIplrsoPqcDc6eDJe7P+CskEivs8
	 XL2qS5QfFXjoLNEzeWOvI5kFesMqos7lUFFzHL4THp64jYIOTy4/xTeT96B8b/ZdNiCH9
	 5Jbd9nKgqdxgzQzA16U6sOiZnzBJbS6tP5N/0k3WmpHjLhKG4zLStoqe5E+2CVi1w/qur
	 HBajv3KXw6yPNIz6YSaWhA3Oyed7+k6lM0e6wa61xmCps1D6JxEiTLW15s8d010mWVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DchxTgE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C1606A92E;
	Wed, 18 Nov 2026 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DchxTgE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1621F000C5;
	Wed, 18 Nov 2026 19:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030834;
	bh=f4dRZBNIkhg6663C44RjGrwy2M24T9A2nMFRbmDIb+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DchxTgE0noR+LDh/BFUEwNAzxhxH3OgDXc3M5Mtp29uN1BwYzTF8+ZVvFuQtsE1v9
	 bxFckle/59X/dkGB3TrcPxFwQozaurvm3iCBWyvZtDbFtF26I8dltJC1HhFTHVwXGD
	 zx/m8CSg+DbQvH+wKnOjj0KaiOSkwd6n8Pe7AxJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0846/1756] ARM: dts: ux500: Use AB8505 charger compatible
Date: Wed, 18 Nov 2026 15:49:33 +0100
Message-ID: <20261118150043.094298196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 24b12f0cf322f..434251f36ff68 100644
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



