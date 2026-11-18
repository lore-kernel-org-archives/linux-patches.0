Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046780;
	b=ZBXcuPLfaDE/ILZSGf9ijQu+o9yiXi65KPDzc4Bg5uU94FmDUiaqGfh0oPF/gfnMS68W
	 GTcBN+1WqwCeAfqp1TcbvBOA3HdtAZ5qGbHrqq6au1Jk9rZTApJGbDD0aDz0WdU19Tw4Y
	 I/qefWpDYFEk71m8Hb+3ApSLkLqcGPx+yc2U1fK5wAW+kdxBnpHZbGCRMfVUKdJPiOoh1
	 qEppLC+5TeQLC3clpanph9of2h4Z48brb37tx7itteM5/J9Cj3GGTT6OIoNfgWbo36x+r
	 c+ppT8OQj/2ABtyQ082faEnOl1lA08vL19XtK+YnY/ukUd3AJ+hhfperhbMT3ekxyxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vvpvUYppmT62pUBE3aRfZTMdMSN+Q4kZSpf3Z2EzVTk=;
	b=uQd5lWRpCakBjmsGRzdClaR7M7IpcqzbR5c/rYVK72qcDlgqFqVG3FkilsDMBB+6MEwQ
	 OvCEQPHGB6wLZXk3GVrgQY2G6AJOHYUChHkd9YFRMEf1dv2nXFX8fPt4r4wpdXKD1EkvQ
	 JNLY5fMIFsnjgN+l8TZHqPfL3meOGKJ026abD0qrVMOQ5+focr1GoRqVMF/SwH/Ne62ed
	 cYMp7w9VOoWLXXoTycShZ1k4MtTrHt9zSI7PHxHDlo4hdxSVCcjHc4RELb05opLJNRPxz
	 SHSFIj7LXj0XVDhpEkcvRmYN5irfO6AKC4CrA9PhwOjSDaGrX0C89nqSk7W2mfAx8TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLtDWOXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBC3606A31C;
	Thu, 19 Nov 2026 00:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLtDWOXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A051F000C4;
	Thu, 19 Nov 2026 00:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046780;
	bh=vvpvUYppmT62pUBE3aRfZTMdMSN+Q4kZSpf3Z2EzVTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLtDWOXBMiGwmaopFmwSFm3nWBKTPgXf5jjuNaRma/bn5ArIQJ1UFl8ugDoWpI55B
	 GRwT2xDvYjorB16KCP/OePIwABA4UsosFf8ecrg/MlIkIvz/u7YD6M/v8DrB3tbDO3
	 bkEBnty75u6/ud4HBliiElhq7Q8QYISB9CaKTTH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1403/2857] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118150251.861399306@linuxfoundation.org>
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

From: Dominik Maier <dmnk@google.com>

[ Upstream commit 87409eedc543d288cdd49c2174f7d61eca7b8db5 ]

lo_ioctl() checks for (mode & BLK_OPEN_WRITE) || capable(CAP_SYS_ADMIN)
before allowing LOOP_SET_STATUS or LOOP_SET_STATUS64, but not
lo_compat_ioctl(), the handler used by 32-bit user space on 64-bit
kernels.

As a result, on 64-bit kernels with CONFIG_COMPAT=y, a 32-bit
unprivileged user-space process holding a read-only (O_RDONLY) file
descriptor to an active /dev/loopN device can issue a compat
LOOP_SET_STATUS ioctl to modify lo_offset, clear lo_sizelimit to 0
(exposing backing-file data past the configured limit), or alter
lo_flags.

Enforce the same (mode & BLK_OPEN_WRITE) || capable(CAP_SYS_ADMIN) check
on LOOP_SET_STATUS in lo_compat_ioctl().

Cc: stable@vger.kernel.org
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Reviewed-by: Bart Van Assche bvanassche@acm.org
Link: https://patch.msgid.link/20261025200740.2064379-1-dmnk@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Replaced BLK_OPEN_WRITE with FMODE_WRITE to match the existing fmode_t API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 20ecd689c2e63..8d3b016398a48 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1717,8 +1717,10 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch(cmd) {
 	case LOOP_SET_STATUS:
-		err = loop_set_status_compat(lo,
-			     (const struct compat_loop_info __user *)arg);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status_compat(lo,
+				(const struct compat_loop_info __user *)arg);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_compat(lo,
-- 
2.53.0



