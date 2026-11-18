Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042785;
	b=yp1llJrpgO+ZajF3MYnuIlhh1ZGfWqBuu4Ojs1pA4ZujBKJ0fWWYJLCR7bdfvV5Lvepz
	 odbyEh41WcJk6kQAhPCwEp/eysurTMZdA0nDAVsIWUxgSUp6DWjhY5RnuNPW3G/72Qb0b
	 WsXs1VpEb36radP5INGuoal3V/R65Dt3kit/oJXTc3QmiDjm8041xLZUMom51XFu6hTe8
	 6k4vlCltiRln25qUVNNjNLlnacjjH7hWqqBHfInGDbrraY4GI20D7mJb7Gz1ZY6qWpyu1
	 QTz1VtcToQj5ek+k0vNL0IOh2nOPyTA/uUpSJ9ndccnmZajbSmJKmz0xYrZFs05e6NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a8rpsze6KUyR5UYRxjEL9CnW7h8ZBi9APU6m8hxwcmo=;
	b=pbwwP5JxE6/4hBgA55InIHm9s+2iG2rVmPxvrBp9I0YGiE3FYi/0eGvB4pqJ+hUmoryW
	 ao4u1hJ2AyThSoXHaqYsdT5gFcXO7z7JXoDLtak0tCrE7QR7kNIJXITGqprCuu/JT5Lpa
	 JHg6M8xGcd9TdUAYlQ8kcDG8qdQcgteyHK01oxP2uKTkmkBI4uYzFpSqUI9sK8HkT6QOk
	 15D7iKlQ7o0AkfTmZ/AG5o+ucwZFZOEyt/cN6jxhVmC3H0Dqs2ONEdInAX9i19lZfWaVt
	 i2hl+3iYBnjAEY28Y9VA4yGm1lfZy/EGDC/StwzB3L/uomNmLtUUu/N4fojuc0gryPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xjxIUNTs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD3606A31C;
	Wed, 18 Nov 2026 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xjxIUNTs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67E61F000C4;
	Wed, 18 Nov 2026 22:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042785;
	bh=a8rpsze6KUyR5UYRxjEL9CnW7h8ZBi9APU6m8hxwcmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjxIUNTsWitn49TZemWXuMd6016sQ08UnC5yjPmGv3+SdMF+AEsj2ZcEoqx5cpufu
	 yTEBJukRFAEgE7Zmwn4z2i7dqeUj6u1ofNpmtsU9xsbUlVALvrKp/Db/FFusYswP79
	 VNbvakdGP4IvK9x4HYkH7Gvm2GfKjdrfjAqXYgWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3295/3318] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:05:17 +0100
Message-ID: <20261118150458.445241373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dd509b3de6abc..ddfbc89e2740f 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1429,7 +1429,7 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 		/* Set PAB to 1 in Control 4A to power the system down. */
 		dev_warn(&pdev->dev, "Powerdown.\n");
-		msleep(20);
+		mdelay(20);
 		rtc->write(rtc, RTC_EXT_CTRL_4A,
 			   (ctrl4a | RTC_CTRL_4A_PAB));
 
-- 
2.53.0



