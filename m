Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050794;
	b=B/CPPpsW/WH0OG05U5uIzsm67pVIQL4p7Cy+88fW32oaHDctXHgD3z3JWLcWvTmcmOEA
	 vZQgaJv/J95b+rvrFCWQZ6OB9S3op88j+ds4MHdrv5nqh+GLQfQ8rEJgrTfE+lRzoAKlm
	 PXXcSd/VXxArb4G5CZNRR1n1j6I5qHhuZ9THdwYtKhov92xoIAvgORY1oSWp7VRoy8DTg
	 N68F2/w+DuaaWQvrjPdcevkpUk3M2QF0vLuH9aF3pm0VkXarGjwC2Uu502wjmjPJf2qMs
	 8gP+R1z0dQ90j52r4VDCktOnU8tDUH0eVzx+j4B/bnyElm1V+3auTTdLBRLzI9Fe4yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j49d8EBjcr5tfUUOXYMiIMQ8fYupouyNvDslNotXPZY=;
	b=Zf273qNHIENpcB1s3wFlX0Ch91Sl4CGpSvoH3/rK1eiBH91R8kNSIGe2kF2UpQWC3vxd
	 NOTRcfHxCUlTULei4PcWfr/GJTozM3kBDDykCWFqYiYhSmA1Yxak3ITJ/1oj7fPtVbsf1
	 3MWJRXkOJwno5bwWn2ufDhxWnFjIuiQIgkWzBlyRsTAJPlZIZGmDt/qNbWdlBCwTx/I4O
	 3dzlZzFIr6KjsJWJTqRA4C394mrG29hYplAQYLWZfM49+Tm7AlGnHbv8gA7eNE+nROhmI
	 HZ3DctB1QCz9OcoR7FGiIda97i7yfmYx5uY5xi1mz8peYgCXlMsmurP0jbhk1Hkh8Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUvrJWo3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DC8606A31C;
	Thu, 19 Nov 2026 01:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUvrJWo3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279C41F000C4;
	Thu, 19 Nov 2026 01:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050794;
	bh=j49d8EBjcr5tfUUOXYMiIMQ8fYupouyNvDslNotXPZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUvrJWo35LfyPUfexbrohII3yzAF2ocYUjWX5AVRVNXcLRwGSXUE2O8MAsMlF0g5p
	 Ot0zwy4EwtH67ZAYoNIvlXvDz3DPknpkjPXNIaoHKGFSzRppXo6odnw8WHXUqncHli
	 US1XcWvzZgdGWNIEZyrWCQqjAGeHyfTLmEzeTqcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2834/2857] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:04:28 +0100
Message-ID: <20261118150343.620764328@linuxfoundation.org>
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
index e9607eeeb349d..3352faa710dac 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1431,7 +1431,7 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 		/* Set PAB to 1 in Control 4A to power the system down. */
 		dev_warn(&pdev->dev, "Powerdown.\n");
-		msleep(20);
+		mdelay(20);
 		rtc->write(rtc, RTC_EXT_CTRL_4A,
 			   (ctrl4a | RTC_CTRL_4A_PAB));
 
-- 
2.53.0



