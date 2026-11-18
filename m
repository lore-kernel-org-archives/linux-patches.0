Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051996;
	b=a2P4HAbPBRA+9+rr3sRyICXVDGb1ATV1Qs1CH2o5A0x48C4KSab8tIgP17CfabBvNdMn
	 tluxdNjvWtyPC7y5r+3qcvQv74u99ZARP2FOcznfffO+E599DzmnE9U/dZvWJ9Yh3zQJi
	 2vEKjxd69g/fknUS1ZtF9buMtbaPE/Bvu6vHukJfcTUlH0VjXr2MUGr4cB4yYtPE4IF3p
	 DvUyn9Kp4WU4hDrCpOwVpvgzV5fCbCxQNUQqnDN1SPh0ire1J9jyCI7lDKvaaa9qqoWq7
	 hkbQnqzXoF3HqlszGN6wpbTyP5cdkv8awk/+NZfbUDweeqKHeTL+NgrwG7umrFwmyiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kRkg5sXGMXj2ehtZDnId2sdXJlxbDuVlq55eYJNgjl4=;
	b=kGmW+bZWSdQS8HThiittfPMA4SIspQ4gbavmKDI8wSVEJa6ijvEWsf780R17n/XuRjid
	 IHHU9cXsPxedGWtD7zr6hW4Yt7yUQeYCbI25E69StKDkdqq/8wTTMcsA3Hxwbmq/3j+/T
	 OJuqM42zqF9Ck60vqenHH7iANP2KNrt5XcEOnd47/Tjb7jiDjzET5wTo7I9j29FkeApca
	 5ZV/9yEHsQe97wqNwudZkjDukJ3pvbqP9r4FBAVccgktJ7hCbt/OwPVl+Y7RZnZSY/8au
	 zoG2g1MEQi66K5+T7xHyruofreyuoiO5q/CLHnw+i1AMDt2yOYH5cOAN73zcNIGURQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6uD7IEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1779606A338;
	Thu, 19 Nov 2026 01:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6uD7IEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCE61F000C4;
	Thu, 19 Nov 2026 01:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051996;
	bh=kRkg5sXGMXj2ehtZDnId2sdXJlxbDuVlq55eYJNgjl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6uD7IEk10a6khHiuHDSxWfwg6jpoS7NO8O6tFmXUpYApzbnHp64W0QOKT8d3d2hY
	 YV3eARdkuxSgOcinqiUoH9XUb9Om+uOeQn+LzJzWqtFJaR1igE7z1WQia5yEJFzuuW
	 7dhqqGtUZos+gL9F4bYgbQU9WqH76Xl4RrcyzrbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Wang <vulab@iscas.ac.cn>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0405/2214] backlight: lm3630a_bl: Remove redundant flush_workqueue() calls
Date: Wed, 18 Nov 2026 15:34:41 +0100
Message-ID: <20261118150026.952038317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit adc122011125682932ef279d717153670feedde4 ]

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 2cf184caab8b ("backlight: lm3630a: Cancel delayed work before destroying workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index a15102bf21365..0886bbce25e54 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -589,7 +589,6 @@ static int lm3630a_remove(struct i2c_client *client)
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
-		flush_workqueue(pchip->irqthread);
 		destroy_workqueue(pchip->irqthread);
 	}
 	return 0;
-- 
2.53.0



