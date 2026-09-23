Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600565304A0;
	Wed, 23 Sep 2026 14:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173382; cv=none; b=hrxYuBywcm7Pg8wGIaWdMtDAPPpsqrdQNIeiSAPd/hmuNoP7GKhaCJz9o1u6acC/ye1xK0COw69cvHh91bxFZ9HT/5RvsYH+/HcNc21tjcVeRAODaBaXcdyrosu6azyD2QvwhzDyeA304BewNKBeFeBsLKtm3Hn1fOxO13nHAHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173382; c=relaxed/simple;
	bh=EvUh2Z9Xxg0SE7jVz/ZIJRtAFHYTnR8BGfygUwDlp5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXR2yxS+OZdbp9wa15ooGgnF/i5BrJdiMeJRAcTgVOJ/CLzZrwFVocTcARxul0pXcdZ3tT3oPZZbGIlC9NreK29lGHxE+rTyHzd+cHGsiNqwALeqEf/6qsVedWqrvcUBc/TIP37CwmS1dkO8qa/+JjqPnJcClMB+Nj9X/GpTvs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqnvF9my; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqnvF9my"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65C11F000FF;
	Wed, 23 Sep 2026 14:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173381;
	bh=25r6OJ96utxYmGkFCT3v4bB+uQyQ6rPyec6wMHMy6fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqnvF9myFmwwv60YfBUX9jVjiZMuRRqMg+K8oZWpOCzhP18hvKawkZatpRZ45ik7A
	 mc/e7ey03Lz+YFEEevIge6PU80xIpRPVc3Ch7Bj03E4LPYrGPh/B4EejoQrw2j1as+
	 W3i5BlZ6fvCDHUca1kLHnqGbnPBfJNjYbGPKPW3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 229/438] Input: eeti_ts - publish the OF module alias
Date: Wed, 23 Sep 2026 16:04:10 +0200
Message-ID: <20260923140650.702415092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit a52ae68a937efc353251aec27fc995ff66cbe1ca ]

The EETI driver matches eeti,exc3000-i2c Device Tree clients, but only
publishes the legacy eeti_ts I2C ID. The I2C core emits an OF modalias
for a Device Tree client.

Publish the existing OF match table within its CONFIG_OF guard.

Fixes: e32d7f1b246c ("Input: eeti - add device tree matching table")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905134004.66336-1-hppiscas@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/eeti_ts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index b12602bc368ef..b870a939508bb 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -276,6 +276,7 @@ static const struct of_device_id of_eeti_ts_match[] = {
 	{ .compatible = "eeti,exc3000-i2c", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, of_eeti_ts_match);
 #endif
 
 static struct i2c_driver eeti_ts_driver = {
-- 
2.53.0



