Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023515;
	b=Eq+c+kFXn5pxmGCtjBnf1Fe+UiIyk7vWfxJiCT7d+Pf0v0ocnfe4nAtOHNoNQ7DCM/nF
	 ROWV5X62fHGRwsxgphWzgverQisM7rJlJZrd874TnRTt9soMCNlc2lo11xwujp4kAMF8H
	 YH9ijN+gI9WKSSfXrQUSTkhvGOZ5bLXhPRUp8pBDc3WDvnl4BJd6CQ6KVLEZegBuSLFEd
	 dgVc6FGLapmGbPGcEq+SWM67WMcxfw1IGDJNJxP53nPeNv4KaLsBzYnIT9v4poDRKgawJ
	 HoVUwrnp2tE4G6PSZg2ATpgVj6DFmeOGUl6tPDZ5u+usrGo/F5Ga3fIRNhvVRUey7cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=peIhqgDEFNDqZsuUImm1/5CuHRhEVfl+SGkM2jk4js8=;
	b=YTKzow7TFLin4K/qKnQh5yaN5P+S+Y15tFxnCAdRNYoJzShicaMy5sgbHQ3qfWJyeSrc
	 LOXAAiPCqoo28tVEGfqlcj9yiwR1ejEB/SH1IX+TkftKujaJvKlJlGO0pLG4nmmOTLvEP
	 gENgONsb909B/pc9i5YgiN5bqwPVbzA4R5lF+KXujOfnISCj36YoyTaVqstOnMC+mfzUZ
	 z0BnN5SrEpu7iUpr/vE+ciezqeKESTHX5NQ5CpK2LmaX1qGXuK+gcgGW+BKEVjwHdp4+P
	 HxRR07NlPKdAK+7G8sapfcECha55PqU1CpWElloiIbXa+KeO0YWNtgzhQZ+eNI0AfwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnTebq9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791DC606A31C;
	Wed, 18 Nov 2026 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnTebq9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C813B1F000C4;
	Wed, 18 Nov 2026 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023515;
	bh=peIhqgDEFNDqZsuUImm1/5CuHRhEVfl+SGkM2jk4js8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnTebq9+dOivi7d/JFPLwh3Jc1vYB9dnqd4CYO8h2N1lc5EydRILEuBIqVvZoZPJE
	 maiMUfM0COaQrY6IfaQArcrEGgjUq6PqDjfCvWq2gDUTIcKJDpLL6PST/3EfoMsv7l
	 3XmxJcAPHIWTB+nS9nwG5uluH6jvuH/yGo1MLA2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0398/2151] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:35:33 +0100
Message-ID: <20261118150136.562471047@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit fc3c0ffefc169719316eddb8c36e2427e11ce713 ]

The default baud rate when none is specified is up to the DT consumer.

In the case of the Linux STM32 serial driver, it defaults to 9600 baud,
which differs from the 115200 baud that this board's barebox bootloader
configured.

This went unnoticed, because barebox automatically fixes up a console=
command-line option that looks like this on the LXA boards:

  console=ttySTM0,115200n8

This had precedence over the 9600 fallback baud rate.

But when EFI booting a kernel via GRUB, we run into this issue, because
the barebox-provided command-line is disregarded by GRUB.

Fix this by explicitly setting the baud rate to the correct 115200.

Fixes: 666b5ca85cd3 ("ARM: dts: stm32: add STM32MP1-based Linux Automation MC-1 board")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20260611-lxa-stdout-path-baudrate-v1-1-59b60a5069ff@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts b/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts
index eada9cf257be9..b3d8eb57aa24e 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts
@@ -33,7 +33,7 @@ backlight: backlight {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



