Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033298;
	b=GwvOABD+mLJD5NzuL7uWKDxH52Ar7OcNZNNsQTVnNEq+JX9eOFXPTQK/iD4YQcdcgmc+
	 TC+ZOh+aiAd5vOZdNchIxf9opKjkhi2RM2LTYYm84x+VAIDj6bY57qGtcMtM4fAVM7vEF
	 XIQfwcmXvmgtGqdezMj/F4t4uSG2GJqOUphuHoQ2ofn+DDK8YcsUmd5b7WsR9sZxfXLJ1
	 UcTPBgQkIufrfDmRsfkbGWqlioBGTnxav4rJBBs5838Xjb4tsZVVshL3KhNvsrsL/NEpw
	 xn3tonvy6F3KlpoC8KPL2tHZUUhT9hvDKyiRebyGukRpztPGOMkgB8r82cAvdKV2DJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HhPVf4fFo7uTP84a5GpkLtHd5ZJ4Bue1GtGmA3vBtSk=;
	b=2v0qSCBEX3S2Cxt231he9yh52QNmOSzWKHfqemamZO4GnnYhRhkMk7ThPb4tJ1mbEOZ6
	 UnYpAZK5VQ4rYJrS/hkD87pTt+Ae84ypoGtC3cYlFD7r5w3x0yTKzUeqymjuTYNvAqs7S
	 /Bw77ooGdL3jUyS4rcy6++lHejiOrbM9CB4ANNiz3kfPYuJ97BIq54vWNiWmO/Uy8Jk6W
	 Fbn7uycYfDcCXh9OwN7HDMvL5bn5gTRYEG/K52YsadvxI7fRSRC0vqMnD5Jwsf+OhRXwV
	 CN0spsTGd55eiQOC2NhIz1VQZILobgQPCBBZYablBIUEj5W2Pk3ahdHLroYC3P4UbwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvru1lrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42122606A31C;
	Wed, 18 Nov 2026 20:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvru1lrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4CE1F000C4;
	Wed, 18 Nov 2026 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033298;
	bh=HhPVf4fFo7uTP84a5GpkLtHd5ZJ4Bue1GtGmA3vBtSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvru1lrBv24SzwDE5SCBcCoY3SU3OdqSqFNidXiKV5YW530mmIkmwgAvXx2NBPWRS
	 Scaui4QOjj/3NuBViq7bZVwpU7tPsJgTJktz6nO0Qtk28krsclNxOCU7hw+tnWOZUQ
	 bThDmVVnV1R1BTZFtIjhL5yvz048Ll8aErniUaYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1719/1756] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150118.026231998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 93f463a8251e9..621825d3f147f 100644
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



