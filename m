Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD1D6F2FE;
	Thu, 12 Dec 2024 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025363; cv=none; b=PWKMjwBb11J4MrNvQXMiIeBWExFEi7b6JOtTrswKzLFngfH8dqCbaLxK8n8lylv8+btmQZR6roP5q/LRzDLfQDwHSyAoaS1v61D6Q7Omz7VuRaM7dFX++r3uomHEQKVop3fvNBNCMDS1G+sICb9iI8592pDZiBrUZRm8kuwSOBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025363; c=relaxed/simple;
	bh=2yrqFAHmR5ADfFhpjc73IVMjazkT07/zF0cVb67vR1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ehh7ZeXdKogBvbDn9+0JsGRtS0RXpIoamk9Vn6CTugI22jkJUPDBDRX71ySRJBmxPtBR22HCfgTQmUwdyzDDfWcCNKtN3ynnJEH3dRr69UNuXswvs6k8yLQ8CHY6hKRnWamwIWN1yjUmg97x99RXS2jkzvw19qhNNUchTTrfq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9q5WaEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9q5WaEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54012C4CED3;
	Thu, 12 Dec 2024 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025363;
	bh=2yrqFAHmR5ADfFhpjc73IVMjazkT07/zF0cVb67vR1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9q5WaEG+ochLOt7FiHShHUjrBRVlJSNnOsje3ODHcMTQKvl5a1rbL0VatbJAnFAZ
	 oPEnGcxYgen6LVDoln5/GpVjvOpxHf/r1TKmmV6byW5KIqp7eIPucjOuAM/GfWv0+9
	 OeCQywokGgN7rza/bkUWLG4aDH/EJNsCdMu5ZkHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	Antonio Quartulli <antonio@mandelbit.com>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/321] m68k: coldfire/device.c: only build FEC when HW macros are defined
Date: Thu, 12 Dec 2024 16:00:33 +0100
Message-ID: <20241212144234.525717733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@mandelbit.com>

[ Upstream commit 63a24cf8cc330e5a68ebd2e20ae200096974c475 ]

When CONFIG_FEC is set (due to COMPILE_TEST) along with
CONFIG_M54xx, coldfire/device.c has compile errors due to
missing MCFEC_* and MCF_IRQ_FEC_* symbols.

Make the whole FEC blocks dependent on having the HW macros
defined, rather than on CONFIG_FEC itself.

This fix is very similar to commit e6e1e7b19fa1 ("m68k: coldfire/device.c: only build for MCF_EDMA when h/w macros are defined")

Fixes: b7ce7f0d0efc ("m68knommu: merge common ColdFire FEC platform setup code")
To: Greg Ungerer <gerg@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/coldfire/device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index b4103b6bfdeb6..6b676965495fa 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -92,7 +92,7 @@ static struct platform_device mcf_uart = {
 	.dev.platform_data	= mcf_uart_platform_data,
 };
 
-#if IS_ENABLED(CONFIG_FEC)
+#ifdef MCFFEC_BASE0
 
 #ifdef CONFIG_M5441x
 #define FEC_NAME	"enet-fec"
@@ -144,6 +144,7 @@ static struct platform_device mcf_fec0 = {
 		.platform_data		= FEC_PDATA,
 	}
 };
+#endif /* MCFFEC_BASE0 */
 
 #ifdef MCFFEC_BASE1
 static struct resource mcf_fec1_resources[] = {
@@ -181,7 +182,6 @@ static struct platform_device mcf_fec1 = {
 	}
 };
 #endif /* MCFFEC_BASE1 */
-#endif /* CONFIG_FEC */
 
 #if IS_ENABLED(CONFIG_SPI_COLDFIRE_QSPI)
 /*
@@ -556,12 +556,12 @@ static struct platform_device mcf_edma = {
 
 static struct platform_device *mcf_devices[] __initdata = {
 	&mcf_uart,
-#if IS_ENABLED(CONFIG_FEC)
+#ifdef MCFFEC_BASE0
 	&mcf_fec0,
+#endif
 #ifdef MCFFEC_BASE1
 	&mcf_fec1,
 #endif
-#endif
 #if IS_ENABLED(CONFIG_SPI_COLDFIRE_QSPI)
 	&mcf_qspi,
 #endif
-- 
2.43.0



