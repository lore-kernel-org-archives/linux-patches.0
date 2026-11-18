Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062274;
	b=SYBd/SagqZtErvURHI2QTS/4hD5TaDDsGS7pWYwZadPF2no1CrMr9Pslxm9VcLubahWN
	 N/jwBb0YMbAKEqrph1b9UTBwcUllM/Te8EwdyzX4sLLYkO2rSgF19EJhcQfjMC9W1H+Yx
	 qIwylNgbJ/2wXhcSNOiDKuyvxsHxGz4Qg1bsuwR/mHBsBzg2I8NN8HuUDrC1YsRnsidF1
	 Nm8rfHwUn6ebP1KPGrZEbfoeXTVvAk7BAyfVSSeZnKL4W+hZS4q+AUcHmZgJ9xqFYDfZZ
	 nfyayrT4UdUinrGzN9Ffvj+Ahx9Jmyzt9AzMe4bgku9KuZ8GqnQyq3o1HIjz/gByjUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wJApbMZkaiO7UA5vjZXXa5ytTMwGslY0Wywv4WpNjpg=;
	b=ne6IFaKiMtHAnqlua7OPKngJ9G2ixIE7BDKkZI28m8PUSqGUGpLqzpAgCxdOGbddx976
	 Db0F/4qyjuE8Hk25fvChgjOSS+Ym2PaFyGosAd87Xjc+iqfM/uRewniEgcXdX+1xG/tia
	 fsCjwDWBLI3iD9FOL9/n0EiXd+bppojoX2vGEFgd5nPLgwV304lMXwX3VpXoAn3w93dKs
	 zmy4X/0lrLR6Thc+yldbbiYmDO2+v8ZeKYsKMUfgyqzr90NgMGAKaVmODOtuV/IlgT2OL
	 NxqibbtIWaKwYh4+cgWKKtJPMoWLADqdKgRNWXNfZ9Cfz509X37dN00ecnb5ld/reLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ld1p8Lnb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A1606A32C;
	Thu, 19 Nov 2026 04:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ld1p8Lnb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FD81F000C4;
	Thu, 19 Nov 2026 04:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062274;
	bh=wJApbMZkaiO7UA5vjZXXa5ytTMwGslY0Wywv4WpNjpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ld1p8Lnb5jFdAoUM/7eQBWpCtLC5y/7GMQUy1zAeMEyI3vhI1nl3i/wtu8RnNHqdr
	 fmlZM7qYPufWFMjyUU3uflR9uEFI5bMDNOTXCBFTZ+7lbi+RZ1S0kQ4ZM4akxz6NWx
	 HQOWH7QxAK0S2QFOn01Ni8uIyhF0YY7FBnYkkG+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1823/1848] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:04:21 +0100
Message-ID: <20261118150035.998472785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 21a829af60a7f5c7456f1f0ff9b6b0eff0ceb738 ]

Power-off handlers run from an atomic notifier chain and must not
sleep. Use mdelay() for the delay before setting PAB.

Fixes: aaaf5fbf56f1 ("rtc: add driver for DS1685 family of real time clocks")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-169477@kernel.org/
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Acked-by: Joshua Kinard <linux@kumba.dev>
Link: https://patch.msgid.link/20261013120208.11268-3-kaloz@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1685.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1685.c b/drivers/rtc/rtc-ds1685.c
index a2a8959f13b42..5cf1ac8323002 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1438,7 +1438,7 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 		/* Set PAB to 1 in Control 4A to power the system down. */
 		dev_warn(&pdev->dev, "Powerdown.\n");
-		msleep(20);
+		mdelay(20);
 		rtc->write(rtc, RTC_EXT_CTRL_4A,
 			   (ctrl4a | RTC_CTRL_4A_PAB));
 
-- 
2.53.0



