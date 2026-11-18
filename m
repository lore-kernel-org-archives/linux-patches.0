Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025424;
	b=MTbbE/75O2269oHbFSlL5D+g50oTDsYwG9hWq7MarnvQLPnqWgZqwUlvo0j5RjUIZ0z+
	 YlIrHT0EmZpsJtBnYnG2O5zvWp/scfZnpscgJqLFuT0QJIMF4OISoRw7YYav0NvI34W4Y
	 iuqfUSpZIDkQix2ak4stOdMmEWFMnMvLok7n02ZEjmJTKlcjbCDZONxj/7m2Yy2Xa8Q63
	 L0r7gXO1OAKV5fawzyJOOTOfWXQxRR+wKfLrRsiRERz4qIJ6VH5/6lw+GiSxmDSQTWwHM
	 eUo19Eobcn6ltXb1Wz2awTgyfoGlwVmZbpafIhhuw4aaEyKQdPU61NzcTmldC4pw7Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vl9SjPSTdkrnwNZ7Csx401YzVhekRrpJjE/QpDvGMGY=;
	b=ZpBq5R/dtZDkXR9JYtwqMpODXi4SRhTM1nw9ZJpFQGViz5U7//VWv5864YnFgKU4Aoqi
	 PJed89lcddo4YgCdHjOkQKDnFrFAgobhX8Bb6dvfqPCPmsw5ZX7XxbL5j97YXmXBq1xeX
	 ho6sTOKEt9JwvhRFF1iHXw9mFBgIjEwKJlgYJ3OF/3Z7KDBWT/ypdiHU/LxGDbRlyajky
	 ecYmiLAo9L56BSuAINgIagl20gbyjLdr3YU3952ttJHvjGFMrzt6NBRdFVXF8+b+0twVL
	 fIFGi8oKGcitFV3SGBVCjcPRVzKlA0xymZcEa5+pbKC41BgaA3OXV8KX/vMm09eTXBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig5cxwmq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B3E606A31C;
	Wed, 18 Nov 2026 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig5cxwmq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FF81F000C4;
	Wed, 18 Nov 2026 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025423;
	bh=Vl9SjPSTdkrnwNZ7Csx401YzVhekRrpJjE/QpDvGMGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig5cxwmqfkXdSscK2w2TLy62mZ5N5Iy5WGAB2EfoPvf5e5XFGk3jmQWScE3f+Yp5z
	 ohhgOMXXh/D0MuDv/PpsJjTO3s84x5/0SKF2rr6T6EmR5kD8eCaxSQZruo8lFuJ1GR
	 EPVEQKp5OgMkEo9dNfiKjRvGoODKv4IncwH0/vE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1075/2151] ARM: dts: ux500: Use AB8505 charger compatible
Date: Wed, 18 Nov 2026 15:46:50 +0100
Message-ID: <20261118150201.439751968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



