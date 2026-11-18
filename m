Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026524;
	b=ULi1UZ6Rx5pmj1Z0lWCU1vQvW4IP54t8j/TYt4UNoP7clhemW0yNKmfruDUG8m5ewfdp
	 hBkTlDVnoEOh3zkOrtdgR0imdjDS3v5NRVp16RY0F5U1hWdSaMKSYRe07aHnFZMIXCh9p
	 YkETmUBBAa2nCO2Pl9JDfYB8CsxPXW7/U7fRwlN1kas7mzMN41Plthiai0HUdJ8s1Sfv6
	 DnQnAQ8DUpSc4zEK67v2w+lmFLBFd1HvhwZj0DgoFsssFxwvo7UcM9jPFufZcqN31x+Yl
	 CgW9k2WrQTaiZzgLw58vm0okv7/P7tmBnf+uGlYz4nLEnh1jcURLGbXGT5SIPHJuYRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yAb2vZ6woyGSS8Yqq0CvViALA+Kv3hMcg0khBEPjEmY=;
	b=oHyNV2dFbNx04+7AWNSkDO5rh8WIOt+71L2OIenVhFAJXy9ZJy2ZouHctuoJ+cAstd//
	 f3qZQRoBHWnHCFQLUmbIVgTSoOTyMvygFYPqo2aCcuTMRf2KfO1XSC2lQA2JupBWvHQOy
	 jNMcy0CgTp/Iaxqi5TrAdmqQ/LAtpJdZtlw/7DoW3EHEtNbeAmUZqu1wqxojMjBLxopp+
	 33GxUGAg7VYsQH1PbcrsbS9ozb5NI0z6Dpv8WhG5S0pr6HOXtfjdXVIZjRvK8rwQqMglh
	 CQeBi1+07h4Xcf0LJnnBuoTGJX9P4FdEfk9x7E95p2v7YXrzrSDCEEDfY2y9f/E2h/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtlxLrfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660E1606A31C;
	Wed, 18 Nov 2026 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtlxLrfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BE01F000C4;
	Wed, 18 Nov 2026 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026524;
	bh=yAb2vZ6woyGSS8Yqq0CvViALA+Kv3hMcg0khBEPjEmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtlxLrfwhysa7D+KN1AdT2yxJxCsiCp72G5JF/qnSfTd8pc5oeuuxY4z8mlspJqf2
	 JAEHfEJWqvhAV3tFHzbw2I5gt7W/clD3x7tWbYSXvaauREmLypplc36jCk8lE2WEPE
	 L3QvXZaSBBPYjSriBfhvtpN0t/xbP04LCZnMIbFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1424/2151] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 15:52:39 +0100
Message-ID: <20261118150213.827494242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 700e6affea6f7..3ec17832e9c9d 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -107,10 +107,16 @@ static int __init scx200_gpio_init(void)
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



