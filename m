Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033716;
	b=YjSI3hoFZmWgNZQcKgvpmkCHkGfTsyjm1ybcUdlCqVJs2bA1NHqxJSi/b73p/ptrlILy
	 p0ZFHnuvlNvP690K/1zu8xF+kXLg4Im7NrBUSrr4OLoGVSi8zjde1GGLx7NiMe17k4svH
	 xmqyQa37JJwSqUpTqlrlU90UzbO2kOPbiO2eiEW7pKCnFunLmmiJKK5hs/dRAI+mCppal
	 K95+anaD/tSRXYX3hWiAwcCe01xBfhRJgCMKJ3uG3vJVMY3cmnGgN1mjYTrA0u8igftoU
	 0+gULP2RTxQ53syXmBAN7M5npbKdusedAHf5V/DQ1QJTscWCHexqXH7BXTskT9MGU/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UyrsP6I1ATGkfDWGhclu+uz07VVKlSKEy6L7Vl9mpvg=;
	b=egyZW/SJEaAo+eCqgIut9CugwwF9vznw3s1qzVLTQtbC0RQmOZrjhQNZLTwea0d5z1IR
	 dN9Gs1olWTSfFR+Xa8t1m+ytHbKY2nMaO2Oaw4l0bWuapVGRSduiVjUsWGoe2SLfZxmmQ
	 B8NM0XGJ5+LAUlj0RJAIUXJjpSHiHDoOsCp/M8f9goHevBzN5N1Zg3ciViYuvUJGmiyzw
	 dluhb3FwsMpi/AiNOnuUe6ov4hR0reH03W5xbruTMWJvzaLu/VxwKHrhFb1hBtwx9FbSi
	 FrV80qUJhyB8u0mk1GTRGTTOVH9aJhH9N69SCxYztxAJALhveeeQLxw7qxpQEGQGjqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1AZnVJbg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A81E606A33F;
	Wed, 18 Nov 2026 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1AZnVJbg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582171F000C7;
	Wed, 18 Nov 2026 20:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033715;
	bh=UyrsP6I1ATGkfDWGhclu+uz07VVKlSKEy6L7Vl9mpvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AZnVJbgUm9wJQphf2BKZ+IdoL5fcaH7T9tFUArhsak1v5tKsM6pmGd5pWHgDRmO/
	 ZajR/so92qt9NofabvXlCcJPi+4Pzhz3hXaG+IRkPmwOxtbkR6LqPkSzGai3GeUQ7S
	 pGT3fC0I1A/Ak4mlVKHd9Ftmv5TYHst97W4lbvIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0111/3318] remoteproc: core: cancel crash_handler work in rproc_add() error path
Date: Wed, 18 Nov 2026 15:12:13 +0100
Message-ID: <20261118150317.611906494@linuxfoundation.org>
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

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 0ec167625b4fea30b26da33c188e853ff25d5583 ]

Ensure crash_handler work is cancelled before tearing down rproc resources
to avoid accessing freed memory.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-3-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index c90aa87a94030..cba79fcb87d59 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2338,6 +2338,7 @@ int rproc_add(struct rproc *rproc)
 	return 0;
 
 rproc_remove_dev:
+	cancel_work_sync(&rproc->crash_handler);
 	rproc_delete_debug_dir(rproc);
 	device_del(dev);
 rproc_remove_cdev:
-- 
2.53.0



