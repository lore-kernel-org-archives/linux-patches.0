Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059578;
	b=oQirnyQDITvKXWGEfVzwKsyaOXKeqMwxi06pBrZLek/TumC9C80XtV4sfVMNH03kKQuY
	 phZlffbXtQuWlYqZ9oM2bawDoUVo+tiZKkREJ5NECXRmTXOZx+od7BgDIiacFeioA82FO
	 soaexOhS08mZuhSiO06JqdnkGBlbp5QFwey4PjmWtzPVbs/RgBFC7xK8uqGJod0MsBHZO
	 PVJ7QG2H+6lhl0fZFLUieSXiDkm3dFBx1W9wNNLX3TCkklaN3wB9CISPGDjK3ygFPQogC
	 R2Za8b4VTvS+xcD2E9ELaLl2N5FIumeaobTciorNQA4TA4+KFoHXmpd2uRaj5zda+AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YR4rriffynI8pG6l4zK8WE+Og34ZgnF+cW9PbjfVCng=;
	b=LnD2AAbAdXDS1GzNGJ9mzlqDsh2UFwD6Gpbu4VU+3eTdKM0ib9L7X2++dqSz8+yRZhFW
	 bxAc2axyAW0R36r4usPeglnIL+AY4fUh54/rtWNJIx4gLBynQnutQBIE/DU4h2AzJTlca
	 hcxjHNaWH4Th7lO2JjvQMfrtKScxI0/AUjKv9jcq+EauJdYwXUjuS146bBSvGuP2ayLvU
	 /mw0GB97u1qQsR5WEs6W+K2huDG3HXcr5chP0QPAmQjRzoVe4psPUyrhzWJdKgN7ljldi
	 XOdj/wXeKueDasLCZnEPlwn+jCZ4mqaK0E5W78E7p9rpV7iI2gPPGHRjFosXJWVH0TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrOKCXLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23848606A333;
	Thu, 19 Nov 2026 03:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrOKCXLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D361F000C4;
	Thu, 19 Nov 2026 03:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059577;
	bh=YR4rriffynI8pG6l4zK8WE+Og34ZgnF+cW9PbjfVCng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrOKCXLvRb3V+Ipf6wK0RZPLmbgl+MNEW9z3pcDAq4n8lzvgFYIu0jCATcs6gXFVF
	 pSWUFoBXmP5O5368ZYWU7AomQNMMg15P8i8I/JjokZiLoOc8lMwjHUaP/swXgRaGUF
	 HgQ3RurQPKNb//UkY0H7I3dxslWP9V9yaH4Qtu0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0850/1848] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Wed, 18 Nov 2026 15:48:08 +0100
Message-ID: <20261118145952.161224295@linuxfoundation.org>
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
[ sashal: Replaced BLK_OPEN_WRITE with FMODE_WRITE to match the existing fmode_t interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index dab31049bd4fa..a25467bb1cc74 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1850,8 +1850,10 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 
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



