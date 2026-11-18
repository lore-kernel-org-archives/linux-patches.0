Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061684;
	b=edlDuYa9B/3ydvUi4tKH0T/fVCs4+kXyZ0hsEGAIH71pgoQxpc5ovYpdAUUFEaP4ABTx
	 yuS6Y7BvfmkUJ7lkuVsOahi/c400ySq2iFfli4lHUEIOMFougVIRZrrrDWkqSpjw1Azxs
	 LOa5fi8hu1QQOZPnn22AOQVIfofSUb/cSvUbiWG3eEzdTX7gZPSqNuLjhOJHEyJzZCjj4
	 oF82uIG5JgxbnHXJisbIxrjglcPD3QtomleNcWMFK/dEUGqr139OMOFVKv9/6/Hq/TtyY
	 zhajaldwGzfmJ4pn919CPmZU2dcYS66O0XhuKmF8U3yP+zFnCYjkKFr9/aILVOJToDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7MmHyYt6HeDywWqnaYvjtK62Y0NtsCynGj1X0F45Wj0=;
	b=MZsR0Af6+UHjZQgRDvo6QZk8jb1NVqeUYCa9Biq5yp7Ou6do9m6sx5To0tldMXbKhXw9
	 5gr/CT7qqi55mjytn6eky0HGNPIsr1Zzt8GWcmPk8CA/kiM+ExKUIQ6ICPZox7hNt9LjE
	 PhQibb79HKOu3ro+YDyj34PSg8vVtjEfew00iSitHaKZ7cF2Ow7ogWuWiiBDNoIR7HHWz
	 VqsXCR+1AFJfil2kUP/jAb3q2p+Q88/8PVZzaWSmRqI2/mz+/sLWW48Oy+RPSX35impSM
	 sWYFgzvf4XUCWD9QIZlXAWtKuVCF6ZvUY4kvCxUfiuCBrkzheUllYXAbzSQx550un5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xu9kA1bK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15DE606A326;
	Thu, 19 Nov 2026 04:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xu9kA1bK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E8D1F000C4;
	Thu, 19 Nov 2026 04:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061684;
	bh=7MmHyYt6HeDywWqnaYvjtK62Y0NtsCynGj1X0F45Wj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xu9kA1bKfCl+LPMIy6uU359Qfr0KuSZfev4T/lffn4/mWXrwQBIga3GkYfAVtUGKZ
	 vkpN7vzz/V85KEs3cRRUWBwYprmAYF+r+ojJiYO80A5tW/YMU/9WXUYqJO9NHDA7OD
	 PUk7RHA/rQuVeVMz70nEAxkvBmx5zbwnR0VKtVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1600/1848] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150026.448093365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



