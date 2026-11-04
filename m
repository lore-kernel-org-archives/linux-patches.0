Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829515;
	b=klVyT1BJ/YtvidGL9X+cShXEdOFvEUFUYzQE9Zcsxxe90vaK3YFH3m6zYV68xSBayJkd
	 J0lns+Dgf6NEyvZq5wsaeHCJzeOFQWB8ZSpAx4+Ef4GtrnZ48zTlHzR/Lr1ktEsftldxl
	 VWMJotwDfljK5yTrcJvaDnQUA3JgT5hM7rebyLE93i5mkOiDTpwvI0w4J3sQh+j0qaTSC
	 rBspX1GefaNqwhRXuJw5Fl4F73cB7gLo7+llwfxREbG8xSCSOKMegD/WFKjXmXNNsMjvy
	 su9n46X0/4gK8xiVlZwp3Jjie1Sr0BxD+gU+34DugFXbi9jbfhe8NFXv+8FGLZfzjJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S4k6UroUmpXl4D5ZQbqvLHt7qyAB0N8EgDJfpiPa/Vs=;
	b=V0CZNYYYy0GPcJrhuJIVjUWG+sk2zj4QEmc5fP6ahsyvAreKEtMe5q7Ktqh84qRLL4aS
	 hAYF0/QFa/jYr+/IJPywh5VfiVeNyMa8HeEC4R3jyoWxfHMNQChNVf8vkVYcPO8cSfbko
	 xFuoS78eT3nw2e/WmcoCtUYbxNrZe90TBwKEWpN3sKeD15kAAXUtjtfvz7DPOhxtwtD0l
	 iHMa22aTbK/MOhq6yKYEGmgXPYXQa6USLqoNbjUhou045Br1OroNP9MSswjxBpnP9fGlf
	 DbI6LGHEakJUd74srk3xjYoHDle25iX+2LCPY933RT67IDdF4LHd2ozZKRgh5hEWouQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzMAH76b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB5A606AB00;
	Wed,  4 Nov 2026 21:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzMAH76b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B261F000C1;
	Wed,  4 Nov 2026 21:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829515;
	bh=S4k6UroUmpXl4D5ZQbqvLHt7qyAB0N8EgDJfpiPa/Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzMAH76bCcVSvIdYW5ZfnAvveXYOGAT2PMXgpUUW7m/jM7/hIrw3QSmUPUABbAISE
	 0GwFBmhwsj/fKmh7Ut7v1sZasq/Dj719YTj8irk59HwEyaRbDVgN3h9oSU+PZr71QO
	 X/h3r/Mjuu2ZepuzZgeIe/TFzQJ0jAAUYuevRzzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0137/1005] mmc: rtsx_usb_sdmmc: suppress false CD after init timeout
Date: Wed,  4 Nov 2026 15:57:50 -0500
Message-ID: <20261104211047.535066452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit 7185b6d33b170cae54fb562ead44452810b6c231 ]

Some Realtek USB SD readers with a tray keep raw SD_CD asserted
when an empty tray is inserted. The MMC core then repeatedly tries to
initialize non-existent media, sees command timeouts, calls ->get_cd()
again, and starts the same detect cycle over.

Do not qualify media by open-coding MMC commands in ->get_cd().
Instead, let the normal MMC rescan path probe the card. If an
initialization command times out before a card has been attached,
suppress the raw SD_CD signal so the host can settle and the USB
parent can autosuspend.

Clear the suppression only when raw SD_CD drops. On the affected tray
reader, changing media requires removing and reinserting the tray, so
a low CD transition is the signal that a new insertion attempt can be
trusted again.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_usb_sdmmc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 84674659a84d4..bf37fab233cf0 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -44,6 +44,7 @@ struct rtsx_usb_sdmmc {
 	bool			double_clk;
 	bool			host_removal;
 	bool			card_exist;
+	bool			suppress_cd;
 	bool			initial_mode;
 	bool			ddr_mode;
 
@@ -774,6 +775,7 @@ static int sdmmc_get_cd(struct mmc_host *mmc)
 	struct rtsx_ucr *ucr = host->ucr;
 	int err;
 	u16 val;
+	bool cd;
 
 	if (host->host_removal)
 		return -ENOMEDIUM;
@@ -791,8 +793,14 @@ static int sdmmc_get_cd(struct mmc_host *mmc)
 
 	/* get OCP status */
 	host->ocp_stat = (val >> 4) & 0x03;
+	cd = val & SD_CD;
 
-	if (val & SD_CD) {
+	if (!cd) {
+		WRITE_ONCE(host->suppress_cd, false);
+		goto no_card;
+	}
+
+	if (!READ_ONCE(host->suppress_cd)) {
 		host->card_exist = true;
 		return 1;
 	}
@@ -874,6 +882,8 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		 * detect card when fail to update card existence state and
 		 * speed up card removal when retry
 		 */
+		if (!mmc->card && cmd->error == -ETIMEDOUT)
+			WRITE_ONCE(host->suppress_cd, true);
 		sdmmc_get_cd(mmc);
 		dev_dbg(sdmmc_dev(host), "cmd->error = %d\n", cmd->error);
 	}
@@ -1359,6 +1369,7 @@ static void rtsx_usb_init_host(struct rtsx_usb_sdmmc *host)
 
 	host->power_mode = MMC_POWER_OFF;
 	host->ocp_stat = 0;
+	host->suppress_cd = false;
 }
 
 static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
-- 
2.53.0



