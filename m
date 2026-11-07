Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060654;
	b=SRERgzuXN9Ub1elqAqh3lmWwnw19SyjyktbMY/pVqDSyqkLT0ackKfT7EILTW+zDcnVO
	 j1wOd1Ox7ExiJKtZoeIKo3fIFxqRwGH8zbOHPu3wGAN9wmib9HDCFHlmI2+KPHXekfz0Q
	 DHD2Luil7keAo5FlCIEfud20OPXvFaJwCYfbuGOh8TZKcG5HEl8aftfTCEtgmGxZ+l3ST
	 3N9U1zLzn8qJuMfjCCdWoE1LpvNhNaehizrrNQWp8AspJlltLcdoQt9zOzWVtfgR+tyiK
	 iJb23QjRZVjpeqqj45v42VFk14N/MvBpEgk9l8B6hpVVBoOsUIlRRWx776mzvBCJvwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I9xfptSxBgaCyF6eOo4XknwSYqcrTWmkF2y5i11I7es=;
	b=HopDJTwia7mTK1sCbcUbWbSda6lSCtJ9gEwe2izJdM20iR4GjN25p34EL7Zq7o3UQucG
	 we+QjczMMqHId4hUysEylh6UxJnHjrh9AXCyV+bDO+ntZU6V4QtQwKlokiLrdtJdVWjYL
	 4RlcCu4Jwd2sX99J302zDDJThTe5inVMGgaob58Zbgwnt6Gal31aQ8moFQsP04HNLovSF
	 xXBNB/+AA7ku9jBK9mYtCb7Au/kjaqXCrMtd8gAyN7hczPI+pGXHk2gY7hNdJH7j8OB9b
	 aEI86yrt6kZNZT+Eh4Ts4Ll2SrRBWY6zKZrqAOiMJk3Epg8Dp8rrRSbl4NpHoNd0gbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BeLGEY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A3D606A326;
	Sat,  7 Nov 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BeLGEY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF551F0089F;
	Sat,  7 Nov 2026 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060653;
	bh=I9xfptSxBgaCyF6eOo4XknwSYqcrTWmkF2y5i11I7es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BeLGEY42EuKcYoE4KRiOMs4iyXyI+iCUhxQ4NgRq71UkD/mMtiYjwkhdxIsbzl8O
	 6Cv82KHbDW6VtjUqdFAEvFU5s8JTLDI7myggk+huh/Vn83E/uEz5bwi5OUAnRtw+/z
	 RVMj4hoVn5RRS7jbnzsnX9AAj5uLWvTM7OFYMkJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devansh Soni <devanshsoni874@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0094/1536] staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure
Date: Sat,  7 Nov 2026 08:35:10 -0500
Message-ID: <20261107135000.305414455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index c9a90d5293b02..c1e02f2a84c3c 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -381,11 +381,14 @@ static int rtw_drv_init(
 
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



