Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018564;
	b=0h2qws1HIC3TmRmy/qip+8ttrj7hEmxWzCNCUtL36rHEmXoQ0HUJtaHeWjN977r0FGls
	 KEjAw2+Z0SGxQb5L4FjLCGhfMysqexw1elq7Jd1qlsoTHmws8nARm9RwAIhKd2XXSsjAE
	 0Dk99rtSzNKSjO1EanSRzSBIbtZSCsmoMl949vseCDn4Hqu5wbPLBEoSJ7+cHugIqsfNI
	 JeeHRX6YPoAbfnp8rSZSDeBu0cgYDYagfVCoB1NPVW9qhwMmyDzxbPA4wVvRXoE/mYC8+
	 qLpp0SHKssDejnMWpatHA6wdvhothcyuvWVAuN63W8tnsXIviGnmpwiJ3LXeJpgzwFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZXIXgYmNAMnqjY4jbOgx9m2Ay6V7VYduE79dFiL/4sA=;
	b=GQFHsuubNeVi0fAiVAGDCk5yvJcf9zbjnm85RtBkFjwS+wYj7xFYZRHjxfnslp+YyJwe
	 7lknEnuH75TH2T3Ixk1w98IHQPXBrMa7J3a2kazEHN8eKPEn7s/p1qBv8ye8UdLQrviy2
	 3JefahSJmXsFaVKxOvz4IsyZi7e/rm76wXWs+KpYLYcabamG9w4om9CUdtwjD1RhWOOOQ
	 aLUaXqo1xCozT+NJ25f3lsAQ0HFk/VXSJ7U7aDIqqHRbz0Ly27yHB2yDpdod4wZveHFTH
	 O+24ooCd/39728+oh2kR+mvMfhPZlnbPvbCIcEnuQXFYmo6UEedUgYiI+hoUsVLVF7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bee0gs90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AE9606A31C;
	Wed, 18 Nov 2026 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bee0gs90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EECA1F000C5;
	Wed, 18 Nov 2026 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018563;
	bh=ZXIXgYmNAMnqjY4jbOgx9m2Ay6V7VYduE79dFiL/4sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bee0gs90TuR/dhyoCeCdplsPmdxBM8Ra0TWR7X1t0bliNvIMga8Oww4U/9E6qIOgM
	 IWPbo84cAYUvN8XrWEH0jVkhvizZpjrTQHbBZgDnXDdEBjaOB2o5gMTkPcYukUVHYv
	 Qa+tuefEFG0657DdfiOO1Mu+vzIm/AB/t7L/Hdi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1285/2651] ARM: dts: ux500: Use AB8505 charger compatible
Date: Wed, 18 Nov 2026 15:42:05 +0100
Message-ID: <20261118150334.199161519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



