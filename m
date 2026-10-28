Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212379;
	b=1izN21Iikpg0vwZHIn+94etIJKC8xYpd+hDtw35DoHIG9A3G0LogEt1QshpzTUU3lbru
	 7Bzkd8odjAcNeNOlG4GNOh5P1jAAiCup3GZvTlOm15EIjmvx/uZsYMVrgrTvu4IHdVgv7
	 OPnkslE+wOOTXkcpWXoWrKNNaaAxSAdW+jdLZQkZlG+S9zDcQR6yhAnH0E2xC+gOyjNn8
	 Zlp6j5Il5Oyqd9AbQIT3eSiSmEFQ0QsPA2cs0XvyFMKSr6AMjWlsavMCDWYCF3caccjkE
	 U01ilPY5+agZb5RgJ7VrQFzpdSRhfPDu30H5gecPTJXoXp+DNK8yBQvabW61PY/9j0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZImWKUSYVQe1zk+r/b9pczU+Q3OwfwPPcG+xjoCLBhs=;
	b=Mf1ZC6ClAlMc7KgrQq/tiioUgAM0r72Rej9nyFZbSVZsBmK7WhC/7BMBLMF0nNhtCnwa
	 VHHrGm3Fq5i8q029tMqy8MLVAwRvG+qDW1eJSFd9RjsFQ8Fu3+QHiJWpd01lhBRdY051Z
	 KL+ZIAfSdNpQzyesN/LZRWmXS4QH3/03/NxpLVsqDkJ/xr6LixpHgn0+68U3q7SZMdnew
	 o7elpY4jEtM7/cjTHGqkDla6Vl6NpvFJfbQitybaHpHTLxBTO+QopUxXDxh2TLo8NZfuf
	 ULRHGdW7Jr3FsnHgpsmdS8sJ18Oify/+cOmEqM7Q42rQ1roV5hXVJ34EXCwYaPIvIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SeqZbtN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCDD606A31A;
	Wed, 28 Oct 2026 18:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SeqZbtN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1021F01825;
	Wed, 28 Oct 2026 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212379;
	bh=ZImWKUSYVQe1zk+r/b9pczU+Q3OwfwPPcG+xjoCLBhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SeqZbtNW/A3nMlfHmwNZ4kbfHBEVkD9+LKf32T5xUA8dZnRluDkXgBukibKUtu4n
	 G+suoLzkHwP3kmJ8ym1Jdi/nLLSG1sInoShc3vaiXtMDjkNGbHAbZ//ItaTmfMNQ0o
	 dMYMvdVhJCzvAHdd1vhvT0wk1UPmYgKD/z/YkcWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0133/1887] watchdog: rtd119x: Avoid division by zero
Date: Wed, 28 Oct 2026 17:37:09 +0100
Message-ID: <20261028170502.263299604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 5af7d2cbd20f893def03c8310a460ade66a5d822 ]

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: 2bdf6acbfead ("watchdog: Add Realtek RTD1295")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-3-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rtd119x_wdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
index 95c8d7abce42e..e963be4df8c4e 100644
--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -98,6 +98,7 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rtd119x_watchdog_device *data;
+	unsigned long rate;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -111,10 +112,14 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(data->clk))
 		return PTR_ERR(data->clk);
 
+	rate = clk_get_rate(data->clk);
+	if (!rate)
+		return -EINVAL;
+
 	data->wdt_dev.info = &rtd119x_wdt_info;
 	data->wdt_dev.ops = &rtd119x_wdt_ops;
 	data->wdt_dev.timeout = 120;
-	data->wdt_dev.max_timeout = 0xffffffff / clk_get_rate(data->clk);
+	data->wdt_dev.max_timeout = 0xffffffff / rate;
 	data->wdt_dev.min_timeout = 1;
 	data->wdt_dev.parent = dev;
 
-- 
2.53.0



