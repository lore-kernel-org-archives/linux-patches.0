Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043141;
	b=5cIYbQh+3mxj8fG3SDWEg17Ro7+Tzyf8ejedyDA3mEycFiAiERcEd2pyif1pDEktVUAO
	 5RHyr6RCRbQh7x7P0B7Gaxd0dtT8Z1C3NzlQRr0cwV+DEbuVv/DtFkJ4S86HmxQMdCSMA
	 L1AYhh1NyqRRER1H2SWjZk21r2siQvlVzaa1BNETrAeFPWj0FchkjpGH9Ux9JZOMq7w+K
	 onZxNhYb96oOROHitvexawswhwhPSjAtc0u7nAe+e66uCWWqF2MwRmnzcV0IecPTMKeYN
	 YyXBiE8ZHT5xogEz6T8W59CxdlbI2aAU0JvqD9JwgjZTIegXtflldWNLSZ0RLIJ0rLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mhn7c6nUSsRx4C2e3DCHuIqHN7w0FRUhw8L86mLRuEY=;
	b=Bk9SjYuTfSFJLGkW5sWbTa8EEU8nzjq268P/2AxNVNS+2Bnmvhlm1OLZ2MomkVNHpNge
	 nJWBVC2ZF+ebVvUHxi2jwc8wMjp929U7nUO6W1Rgx96SOpipJvT2OCIvAV8uRnSst9Yfx
	 wI9EmgEY4OthoTYrplefdKU0JYguUFzgLiJuecn8BgPAQhkAhD1RDFcPM8BTnT20UOZTg
	 FzfAVqb/fg9V4MLZJiFyw2l14b0BVio6AS9lujkknMRylhJNIuPLvbF4Cw8jVv1C5QXmW
	 C8zRdSHgGV5jJA9wcNzY36c0uIfLLxjf4iZrnlKaQFDNkO8KsMOLaskb7dR6o8soyCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5ffrOTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6F1606A330;
	Wed, 18 Nov 2026 23:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5ffrOTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3911F000C9;
	Wed, 18 Nov 2026 23:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043141;
	bh=mhn7c6nUSsRx4C2e3DCHuIqHN7w0FRUhw8L86mLRuEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5ffrOTP3GzA71hzmCV8g+HGOKSfsVkZhB8pAaSWqj35/8esGdvZMP4fyZBe/J3rY
	 krnwLa6vHHVMt6MM5kfaSYPM+ky8XFeyV5B9Hd3wiwYdB3nxhG+1lrTZKOiE7hegPR
	 V0AHgAFSLIazrib8Db8UEPJGEEG7tgGd5NatncbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devansh Soni <devanshsoni874@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0063/2857] staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure
Date: Wed, 18 Nov 2026 15:18:17 +0100
Message-ID: <20261118150203.603999844@linuxfoundation.org>
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

From: Devansh Soni <devanshsoni874@gmail.com>

[ Upstream commit 51b554f1a758570159a770983c7a0ccd7c761491 ]

In rtw_drv_init(), if rtw_drv_register_netdev() succeeds but
sdio_alloc_irq() fails, the error path jumps to free_if1 and calls
rtw_sdio_if1_deinit(). However, rtw_sdio_if1_deinit() calls
rtw_free_netdev() without a preceding unregister_netdev(), freeing a
still-registered netdev but leaving stale sysfs entries behind.

Signed-off-by: Devansh Soni <devanshsoni874@gmail.com>
Link: https://patch.msgid.link/20260619125724.12458-1-devanshsoni874@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 3b5a6f685bce5..258f68c35dc07 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -382,11 +382,14 @@ static int rtw_drv_init(
 
 	status = sdio_alloc_irq(dvobj);
 	if (status != _SUCCESS)
-		goto free_if1;
+		goto free_netdev;
 
 	rtw_ndev_notifier_register();
 	status = _SUCCESS;
 
+free_netdev:
+	if (status != _SUCCESS)
+		rtw_unregister_netdevs(dvobj);
 free_if1:
 	if (status != _SUCCESS && if1)
 		rtw_sdio_if1_deinit(if1);
-- 
2.53.0



