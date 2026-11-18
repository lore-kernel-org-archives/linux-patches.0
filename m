Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049627;
	b=14GULenBHzzkmE6Hl0IcPp9AEgRH9q7VXzni2e0oDdKi+yt8oEjGeVrIa03iIvnw/Sh8
	 2r5sau7nmu5w5FsuwaKDB+RteMikFsFkua2Wu+97wADSEn4UQAnFHDFCNLYi7LjUx853m
	 xCdG4ZviQqR7efxIrPwRlyUIjKb3z/4vdKaDEvcZ9XofC9DbuAqqpLd/vA5yinDAieURY
	 2pQ8TGnB1B7WzE6Oc+m+s9QGkMcKdsnNEoIDxuqiUJuaspQGKn5BPuXQHSBRq4PeY7JAb
	 ALTFqXd1lE1OQ0kloM4we93NoVEA/cOWklWQgGJ2sk29hSyrAziPFXLwnE4V6hICXVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQQ6qDi9jGow6eublhV0G4v0FA6dhVuPuGKpNA0WiDQ=;
	b=t2LEPpA4pTgTsJfRoXb7CKXXBQZYJ7i+eHhRpGYla5SccEmpe64+jqpmvdxMVLgIBDfu
	 L9MZdWlmXcCK1eHdsg7sASmVll2TcEwgqS/vfuYra2WMYGVG5Vw9ZsAs1K134VRPivgor
	 yjK7YWAKAInzNVj8wZnrd+2or6PeyizkzoVL7ESxmDeuIezMn+smgFP5AnJcErFsb8hJL
	 esQ9A/smDMRdvcMMqjs3w97kvwpF0btdr/L8/H7YmZcbIfvOYDoHeJkvGa3zg1cKWj1fu
	 P6GlWwDlj5i1WxywOoRmf4qRtbnWJRhjXM6i96afB7CW/RZvsxQs7/9EKXLhBtfhc9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HoVmslR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348FA606A325;
	Thu, 19 Nov 2026 00:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HoVmslR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAA91F000C4;
	Thu, 19 Nov 2026 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049627;
	bh=tQQ6qDi9jGow6eublhV0G4v0FA6dhVuPuGKpNA0WiDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HoVmslRT+P2km9iVkDr1U1h/17jxKj07upEx21Vm0ZQC/CSQ/5AF1j5t8YKBoq2K
	 rW5a3zbLocoldDr+q0ljeqyqHdSjSw1ol9eiyUtdtR3Df5fnmmeAV6+WklNCaIXGBk
	 hMpyWBHu8b66ARauBVJzgvRuKTEkzl6kzhNRlBkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2420/2857] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 15:57:34 +0100
Message-ID: <20261118150328.689139415@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit fe26c195c265c033e474d015061a0183c7a02193 ]

cdev_add() can fail. The driver currently ignores the return value and
reports probe success even when the cdev was not registered, leaving a
chrdev region allocated with no working file operations.

Check the return value, emit an error, and unwind the chrdev region and
platform device on failure.

Fixes: 635adb6cd25c ("[PATCH] scx200_gpio: use 1 cdev for N minors, not N for N")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260803015450.2050900-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/scx200_gpio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/scx200_gpio.c b/drivers/char/scx200_gpio.c
index 9f701dcba95c7..4f6b1039417d6 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -108,10 +108,16 @@ static int __init scx200_gpio_init(void)
 	}
 
 	cdev_init(&scx200_gpio_cdev, &scx200_gpio_fileops);
-	cdev_add(&scx200_gpio_cdev, devid, MAX_PINS);
+	rc = cdev_add(&scx200_gpio_cdev, devid, MAX_PINS);
+	if (rc) {
+		dev_err(&pdev->dev, "cdev_add err: %d\n", rc);
+		goto undo_chrdev_region;
+	}
 
 	return 0; /* succeed */
 
+undo_chrdev_region:
+	unregister_chrdev_region(devid, MAX_PINS);
 undo_platform_device_add:
 	platform_device_del(pdev);
 undo_malloc:
-- 
2.53.0



