Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056183;
	b=EOX56i8yYnjIPP/kNZfQtY+cZkSSWXI+tc3yULDDbivgnKDQ2w3cLmpF9kUQyUkImron
	 kBh9VhxmlqOd5+DceFaU/vVOuWtcC4M7hC4HOzltiEYYsPAsrrxk7OrqfjmbHYb7+Luax
	 LXrQU1/wiaYxKWtcJHPeLZjHl1mVmGrqZf9RM1z/GL0WwEBtoDJ/FI8WAMN9JpRAvqOVw
	 b/wji45g3To0RhzySD26JGCMVhPVCzrJWWGvniy4LTWe327SLAimiUtJ86ijG3uISL9rS
	 iQwMjZn7RWJXyVpQWFZMKaaqu9mCVz3P8+xpBLXOnRRCJxsLpoLVhI7V+EW0fjPuSWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mV6/FpWhRE140qMOBghh3BclwtsImMQveydvaU1f/Xk=;
	b=DCmuxFEEHeHwogmT6MBapk2u4sLsi13c0gF9cCDNVbfGNN3p6FkCpwEKF8u6MuoYi4I5
	 9Kj4mwxcHcnQymFCqeL0rluPsFRY7NdKC86zQf7PnjTzQ91zNCd7zwr16qcvKakuMZoHZ
	 KdU1eoVnLd1uXdlyZXNX/rJdq5hMB++rxJSdGB0PNfmyxkdnlgOP2lHnvd0QY0BUBr0sa
	 sihK9+0AhPR4V1WIA+R4bBTczUMgR5/2gF0Ueu39/53M4dBlMGw+pGsvfhW65IuCvb7+J
	 7MiuZ3XWiyIQXikMmuyqFjgI2OdEfrBasPnAxTUbYb81ri7+UJh/J+5N7a0SxYFflAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hjnb8Wqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C5A606A320;
	Thu, 19 Nov 2026 02:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hjnb8Wqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBEB1F000C4;
	Thu, 19 Nov 2026 02:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056183;
	bh=mV6/FpWhRE140qMOBghh3BclwtsImMQveydvaU1f/Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hjnb8Wqs+RW7tczV0uDq65OCFTRTJpLg9Z0oFF/4yRb42FFLJ4x1+HI16xsgtjtLD
	 kB0X1NW9uJbMa23qEbADzLyKf3KxhOZg2m0SeVF3bXtnBT7ndYy8CcBcLFd5zZWPRV
	 6ke4jbvbLAJRqO28wXJ5eSXMambZmEbyR/HvyaA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1860/2214] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:58:56 +0100
Message-ID: <20261118150125.748306361@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1fe88b1741ff655bb59e4fd78178fe2c557b9185 ]

ec_dbgfs_cmd_write() copies user input into a zero-initialized stack
buffer and passes it to sscanf(). A write that overwrites the entire
buffer leaves no terminator, so the subsequent parsing can read beyond
the buffer.

Limit the copy to leave room for the trailing NUL.

Fixes: 6cca83d498bd ("Platform: OLPC: move debugfs support from x86 EC driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926121250.3258285-2-yaojiale02@163.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 921520475ff68..9e9d20343faab 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -269,7 +269,7 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&ec_dbgfs_lock);
 
-	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf) - 1, ppos, buf, size);
 
 	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
 			&ec_dbgfs_resp_bytes, &ec_cmd_int[1], &ec_cmd_int[2],
-- 
2.53.0



