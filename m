Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047873;
	b=edsP/k783d1QDRI3pQLxoQ5/hYBCC5F0kyfnIbaqOf3raRyDv3D+eC3QPud1hlQpsYy9
	 JyGykjGIQF+bkiJIrSsTUWRsuerYibulwQBT2iiYuTr9ptRV4DZ3JMIiK3g5lN6s6Luxn
	 u0+/M8Vuucqnb5F10uG5L5Soezm8VNodu/XqWgq3uwzU2SM1KQSVycx6M8Tio2iM0KqlF
	 iZoVpvI5VsVvK7eLo2QLzLzEHTnb7rL1lkDbEMaVFrXJ/iy2PMCxv09qxVCE1wV1cHMvr
	 b3mGdH0EEL5HoWHbRLyv2xz1LtdbAYK/jSN8IJ0pMiPXzGg99DJHzJH+3Ovtd0R/xmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IJodem+6XoOT5jWk7/0cmYa5anEhKPzRfDf6RiXbIAY=;
	b=0VcntjdXp4MxqBTo5h4jeZ/N5i76CtZWnldDnvoqM+69oN+QQxnpUezrZTFwKMLJkAXj
	 mdsGvUxfsDSh22eXZIV+81x2KuoT5RIrH9jDcxO82sOLt0uWHrhK8tTTeyy8x9pBBLp9s
	 0ivrGrpLpgwuouV8dpO6IiuclP+Ax8iDAfjDgEYnbeSQIQueJ4nbjbGZe1P/lhauT0+pf
	 5l09W8uDwHSOA73LPPHO2ZRZjLD0ABYUnN7PrAaPz3+tynead/JENZcHLDdnjrw0vNYcY
	 WLHwZ7EXKLu+ncIvnIYheRxDReHHkLONs1j0moot2tO8W5Vj+JSnwmfLjS3y2Sc3o8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPs8dVDr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626A606A320;
	Thu, 19 Nov 2026 00:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPs8dVDr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D422E1F000C4;
	Thu, 19 Nov 2026 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047873;
	bh=IJodem+6XoOT5jWk7/0cmYa5anEhKPzRfDf6RiXbIAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPs8dVDrJWFv3Y2Y/SNwZBjiiu4dEnFW/8AuhPlO2z0Pe/ZYmMBvlG7J752bhX8Xd
	 t6T6H8+eD3AcSnEMf7xnOcIlO6bEK+zVZYGOOEFjB2nDt+E8ugYkPLUAo5WJabT5FM
	 iZ8ucICyjktbAGfum5kAorA2SRtwPh8rtsNYjD0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1794/2857] wifi: wfx: Remove some dead code
Date: Wed, 18 Nov 2026 15:47:08 +0100
Message-ID: <20261118150305.858413677@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 015bf4df8ea67080668ac8314e692076dea1ce6d ]

wait_for_completion_timeout() can not return a <0 value.
So simplify the logic and remove dead code.

-ERESTARTSYS can not be returned by do_wait_for_common() for tasks with
TASK_UNINTERRUPTIBLE, which is the case for wait_for_completion_timeout()

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr
Stable-dep-of: 102f54dc47be ("wifi: wfx: fix possible device hang during init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/main.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index 2a3dc7d961edc..b5269fcba1a3f 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -357,13 +357,9 @@ int wfx_probe(struct wfx_dev *wdev)
 
 	wfx_bh_poll_irq(wdev);
 	err = wait_for_completion_timeout(&wdev->firmware_ready, 1 * HZ);
-	if (err <= 0) {
-		if (err == 0) {
-			dev_err(wdev->dev, "timeout while waiting for startup indication\n");
-			err = -ETIMEDOUT;
-		} else if (err == -ERESTARTSYS) {
-			dev_info(wdev->dev, "probe interrupted by user\n");
-		}
+	if (err == 0) {
+		dev_err(wdev->dev, "timeout while waiting for startup indication\n");
+		err = -ETIMEDOUT;
 		goto bh_unregister;
 	}
 
-- 
2.53.0



