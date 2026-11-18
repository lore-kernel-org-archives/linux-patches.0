Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049075;
	b=BVFTXENmXN0VFlJMjsc9j5tKlWLndC1hu7r1Kz3cmHtn5NAx8hv9ivm+Vkk0dil1/zIu
	 HMiw1a1niOtjtwOMh3gvtC63avxLu2cEMsACHWEdI1y/qMKf/L7EK7m2mAQLu+K1UWHKK
	 Oi+oyKH5Eiwy5MJb72p6Ce7hNRNn55kw6yjYp7zv/upnJVaDRszvtDIAL83ZUYPus+kqy
	 EO+BPQdNt5VEx+YYJPYz8Hu4Bl7qUPVJfIXOHD+aeO+sVbN9ElW/C+gf8gFxxUK2gvV2L
	 2O8ppNbfoPezjRntxqqtI7km0GJ5Ks/imd4BtJJD9lapizysB+WW2uaYtU3yNP074BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tmX7Qojpyf+jL01EfYOq40C/xatJ86PSCP0Bv5cQWls=;
	b=x+f6cKEVBcPyLMZ31u1aI+4CXVMPe1ZEn0cqYaD77EUndkRE0lZCzbzvHzPI2TdkZXJ2
	 gQrgYmrCv03MPCuCC+p+sBf9Q0vPWDwQavTxJ/6toNEtaEYKAdOfNTiGvo2s7U+XT1XVT
	 ugvOueG+KjRFedko2hYx903/UcQ6x48TFtqfTzNntBUhY8hfN4UEm8P/I+aUwz622H7bm
	 NgYzBRyv5c60WSqoU/03ef+aVZLKdQhnfkk/7093Jq0DN554BDj80xEjzAmtEwWiMAh+L
	 06NMJo+wLejDKoPgjKq9TRpNUWdo469Q9UEd4wEdKw1c7C+dukR2982k150IWYx/oIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aB3yEm69;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A6C606A31C;
	Thu, 19 Nov 2026 00:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aB3yEm69
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B8B1F000C4;
	Thu, 19 Nov 2026 00:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049074;
	bh=tmX7Qojpyf+jL01EfYOq40C/xatJ86PSCP0Bv5cQWls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aB3yEm69iI2bLT6rnspng3kQBkxLZOF31n1y3yHy0kIhJ7XYEkxv4FxwUEEiu9afB
	 Rfoi+AR3r1+/YPL8FP+L7eKOu9QUkVkRa8d4HmD+IbDQnwiiyB3R85QLGMI5wBdzX+
	 gO/xrRwuL4+L+9F06OvsnNLrj0FgBKI9wH+jS+RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2221/2857] ARM: dts: ux500: Use AB8505 charger compatible
Date: Wed, 18 Nov 2026 15:54:15 +0100
Message-ID: <20261118150321.384726062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/ste-ab8505.dtsi | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ab8505.dtsi b/arch/arm/boot/dts/ste-ab8505.dtsi
index 131c82508e820..4c9a8418f225a 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
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



