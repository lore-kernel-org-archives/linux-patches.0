Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057022;
	b=AEe1l7zBcTHA8AIelDhKFjf/f36UZkeEAyM+mH0F2d4O7hZCipx47+2BZi9Pr9ER8iw/
	 Tv90JJkokSIAI7EBQZvJe58Q6wdfAMVGYHxATtexyk9LA20VyLXUZaeLI6QI49NKSEpvH
	 xIFoKK+D4xOMb7VFHbkr9AdSgt13BVrKqLgGO3SxjSHpZM9vt8hnzSnqoFPUfLc/Smylg
	 3MRM4mf0ZSAEjrzttE2dNF5jLmJB7Jx6knonaopI4/G6ibzj9wzuBSf36xCteX1FpUnn9
	 xLggk5sWPs8dhAi1SRdFvoociVQyS3je0WgYmlflN3yROk+H2p4Zqk3GwutSdpHmyzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y2DEWcwIRbrUA+hf9YF6qSH4xJVExw73CSZE50/ZzWw=;
	b=XsOY1DoDFJDvMZCSzD8qKBBgLB1kMG7g78KQ8xUnNsa/cS2CwoO+TESQS6uEH2pa+HV/
	 cKPihp4opknR3+IKea7LPO+G0+2yJNep3Ldpx6dqjy7SnHsF84P9vvco9yPppeMPfyGRK
	 FJvHmmUNtWQbQDU7h0DrFJP91+xonkPfLgfbu/ufe+faMITTRaIH6UJCpItplWDTuOssM
	 WBekTJc/PWLZX61orHQAQ5lF1zHyWzoBHTb/0ANCbnuhObLqxXddGHsIinVHh3kZU6ur3
	 uCiP94hpTj53g6qJrXdFwBnLrclFqDMlMaBUErqdHlLcOWnNLxY7B5JEooDxd6YWF5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrF3AOWl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6A7606A320;
	Thu, 19 Nov 2026 02:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrF3AOWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9109E1F000C4;
	Thu, 19 Nov 2026 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057022;
	bh=y2DEWcwIRbrUA+hf9YF6qSH4xJVExw73CSZE50/ZzWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrF3AOWl2qH8FREyRceV5QySz6sTgZw/UanlTqwBDK7ExWUUc3afirZqKCKHlXqmT
	 Pk7axUz1Y+jrOF06DAunuh4DWog0oI6f4WSpDYFXxEeiTMtgWp9EG/r7Pt1BL7fYid
	 csKlASDvd56ITEQhlGXN6bAm/75mR42w/S8WmMmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2195/2214] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:04:31 +0100
Message-ID: <20261118150138.120372860@linuxfoundation.org>
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
index a7e6839998958..7704259f4eaeb 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1435,7 +1435,7 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 		/* Set PAB to 1 in Control 4A to power the system down. */
 		dev_warn(&pdev->dev, "Powerdown.\n");
-		msleep(20);
+		mdelay(20);
 		rtc->write(rtc, RTC_EXT_CTRL_4A,
 			   (ctrl4a | RTC_CTRL_4A_PAB));
 
-- 
2.53.0



