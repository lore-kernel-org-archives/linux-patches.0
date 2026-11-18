Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022372;
	b=iiTPLSBxnLYpoorVpGqiAZ5AoncA+vCrHk04jJXfaouZDjnMm6qyBZN0DtOvu7CY0CFu
	 q61eNbbwq3CHWr9LKmbDT6IsavqJEWIju2/rL52s6NH0j8KR6NceeoVA84U8JrG0G5v8v
	 eHIGj0Y/H+NkamDxjWhfnsmCPZxErZ9ocRAkf2wZl+prPyT9+gnJafJldZ4Ee2WPDs84g
	 oZPcVrQtxxO1a/jWes3QIA5De8jOjRlDRmA9TowRXbGZr1vSKDeGbOzB0/7vCKolBm8AD
	 O2mz0GNPyV1GLbgQRCU6KltFu1cNT335m9WEXqwSLqsTqO6YZ+SxQ6HzQLHn0hVrNmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yb38wnorR5HbsaWFyS3pNm6TEkmvJPd4tss8CO9y9Q0=;
	b=d/p3Xz3LmO0JFLB8LiLQIG9PYHqfBn4W9OvrCyuNqQBbQNtcMr+S8gGSmotfDFtWKccc
	 WIQN+h04WDd1as3q1YW2VbsJzPjOFO5VhpbV0fmVCMO8ca53gj4iWoxp1zgWbdZ04Y2lj
	 /a9q1dwx9Nbd1tqOOBmiu9eRt9cHpxpdMsZ5Uq7+WBI4M5ttD13WXppuV3lRVtFGZ7gIe
	 QqQqy5Ya2RCulhfHTIrnnNbDOb4g4TobC9ZNFYNz3P4iffMnLT8h1n19nc90mHjflrmzt
	 iSIRvRJ3douM6Lukx6kqbboeUJyH9ihuQUpqrdRyKNnYUvb2kPlQ9hyWzSVWJA0MpdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PL81+Wu/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517A9606A31C;
	Wed, 18 Nov 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL81+Wu/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47B51F000C5;
	Wed, 18 Nov 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022372;
	bh=Yb38wnorR5HbsaWFyS3pNm6TEkmvJPd4tss8CO9y9Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PL81+Wu/aYysd1L1zhuO279+Sv4LZfhf8gn1wJRRkQZg6KjDtOl/GmUau4c9aBQ/8
	 b1UCAFhoMCBVopMACTZg3QwdDYnO10LPN09qGdifcOXCNMKE6zzUyRsY+K+y0GwzEh
	 Lg0yb/sXf7bS8rPBzxQhYiYzspj4YHZ8Rmgbi6ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2639/2651] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150419.127434224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 94c89333c5d5c..123ab9fc9c8d4 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1426,7 +1426,7 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 		/* Set PAB to 1 in Control 4A to power the system down. */
 		dev_warn(&pdev->dev, "Powerdown.\n");
-		msleep(20);
+		mdelay(20);
 		rtc->write(rtc, RTC_EXT_CTRL_4A,
 			   (ctrl4a | RTC_CTRL_4A_PAB));
 
-- 
2.53.0



