Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774718;
	b=jaK6FbY2NrWe44EJl/zklMn5X8QOiLGyh81pL3lgQZSTu152Mx6fmFYsOfpusPYc0LX+
	 yCZ35XuKsJMrBzOW4Vv2NMetT8I1YM2WIQGX+l/Chk6EMDONGXF8ZH+Y9LQbnYHxeKr2j
	 bM3/SB5YS+x/SQ42x5yCM0b2I+Pk5BjNka8iJQ1CNWrJ3DLQq9Kps2J9qjR54503qWXsI
	 quBfCY2/qlkrappX6kAdVtE5fs1OUEntzM69aDJSeUj06RqIrbwErrhWAjh2v6zKOmuha
	 yreM8j7npaMhHUPj+zKLp5aCa03G48K6XSwnk+PqW6LUAufu0iUASdrLwBeBaJCMFzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2K9BGukUVmb/jXAbsIVLyZgFuCwMKmOSyLrx56+fCI=;
	b=E3vbfoQA/4wim4pgj2uZRCw8MoASOwcu+brUk1r3WwiQerM41g8m/zF9tmM7dGXU7MRR
	 mTeCfs+SxJX+SQCFM5HbLluBzJ9xylPfgIo4s3SaoX/ANEsG+FvuHt2Lqnn9Dw0kvOjed
	 iT06Gr3iZPFeYBKQNcAa1bBT17aETOjDqzsVpzlpsxpI4UW5AwGH0vge2aItkgvHR2zNq
	 qQOKEemnPu5pi+AoiRT/YgLFUg4W7C7ZTnWOxMrK2EjmY61Fnk/XOG+mxAlj5JMbDN1Lr
	 H2MtTKX57mzMnRIRn0z91GPzeEvadHHzX9ev8u5NiAklopQ+n2FyehgCNOmRClg15fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yy+Echr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FEA606A31B;
	Fri, 23 Oct 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yy+Echr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85781F01825;
	Fri, 23 Oct 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774718;
	bh=Y2K9BGukUVmb/jXAbsIVLyZgFuCwMKmOSyLrx56+fCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yy+Echr83vIalGQCUBFf+htL3zlxYmXPwDtRwtkiB+jZsMswZ4Uxg+y/jzWonpFRn
	 Pq4EhdWgi05jajDPTV9ZAg23GQp2J3+LwIB4W6aVNB3ETJHt9XnUkcZDzwn/5ZCzY4
	 BtOROT0t5QJYbd59DwFeAK/qsU03S1T9ss5QNbEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 7.2 128/242] riscv: dts: microchip: beaglev-fire: remove double definition of gpio interrupts
Date: Fri, 23 Oct 2026 18:39:30 +0200
Message-ID: <20261023163716.810077832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 0f70fd6f4c1d6c1f2ea298d8dd07c4a4d5dff9af upstream.

When the irq-mux and its interrupt-map were added to the mpfs
devicetree, the gpio interrupts became fixed at the SoC level rather
than dependant on the design - the interrupt-map is now what varies.
The beaglev-fire should have had its dts copy of the interrupts removed
but did not. As a result, the mcp3564 driver does not probe, because
even though it doesn't use the interrupt at present, the SPI core still
looks it up. This lookup fails because the second copy of the interrupts
property doesn't resolve to something valid when passed via the
interrupt-map. Remove the second/incorrect set of interrupts properties.

Fixes: b0258f69f1e0 ("riscv: dts: microchip: update mpfs gpio interrupts to better match the SoC")
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../boot/dts/microchip/mpfs-beaglev-fire.dts   | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts b/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts
index 6d7037c9528d..a09371d9d064 100644
--- a/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts
+++ b/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts
@@ -90,10 +90,6 @@ regulator-1v8-syzygy {
 };
 
 &gpio0 {
-	interrupts = <13>, <14>, <15>, <16>,
-		     <17>, <18>, <19>, <20>,
-		     <21>, <22>, <23>, <24>,
-		     <25>, <26>;
 	ngpios = <14>;
 	gpio-line-names = "", "", "", "", "", "", "",
 			  "", "", "", "", "", "SD_CARD_CS", "USER_BUTTON";
@@ -101,12 +97,6 @@ &gpio0 {
 };
 
 &gpio1 {
-	interrupts = <27>, <28>, <29>, <30>,
-		     <31>, <32>, <33>, <34>,
-		     <35>, <36>, <37>, <38>,
-		     <39>, <40>, <41>, <42>,
-		     <43>, <44>, <45>, <46>,
-		     <47>, <48>, <49>, <50>;
 	ngpios = <24>;
 	gpio-line-names = "", "", "", "", "", "", "", "", "", "",
 			  "", "", "", "", "", "", "", "", "", "",
@@ -115,14 +105,6 @@ &gpio1 {
 };
 
 &gpio2 {
-	interrupts = <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>,
-		     <53>, <53>, <53>, <53>;
 	ngpios = <32>;
 	gpio-line-names = "P8_PIN3_USER_LED_0", "P8_PIN4_USER_LED_1", "P8_PIN5_USER_LED_2",
 			  "P8_PIN6_USER_LED_3", "P8_PIN7_USER_LED_4", "P8_PIN8_USER_LED_5",
-- 
2.56.0



