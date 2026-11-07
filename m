Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065456;
	b=QMgLIvZnvn/3fB0nyGV7HtMOmM9Nfy+/ungJWlHi2Rc/frJfU1QETaom9EsWkrwRznmO
	 wjNV+JVMqGMDVU84hjcQPwGoMThX3l0yV2f87YnYSjjQ1aJaMx6aUkdQc9B3V64N/qcew
	 +OrOA7MFXFlcWp16uL3SMJtb3bZF8fWFIzfvRwMOAPgC0jeKoDGiPEo+UBwv/HF6O6fvq
	 5Xlmis+pT5+4WsdZ8N3bUMiF5iKE1tVKXBBeB+9/wHF0M2sQp31aWKGvXGZYe1g6/XplM
	 uuIoNYM5VB1PyksvTnQUQabORpKJGwiQJAlmD+3AANh6u7Pn+TRVu88S2d4r146odeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZkRirIZu+RaMj13DH4UybH+8jYENrv7xfvXO0wOL6SM=;
	b=Ye4dnHfuLLB/732WfRZf6Yjpc5irSP/GLMbkLU4VQ3PG1UTyea+MBwa2fDPWUKFh4cRO
	 QT1tFNGjo9P4jnI56WbKFLewS+oD9Zxovhq61SHhDst2WKyKvZEl98KvD+H/30aKZM/ME
	 DE5Mtd0fy7kSISD0hyPEG+G7DGKcEFRjNFrKHf2APZMLUOsvTQ6lCJvBPZK5Sb0wy8fb4
	 IVao1IjS+iQkDAEVzGdVEaHK7SOPR2kRBB3gciC+CbEoRV/ZG5T5ryog1SKXZmnBACqPK
	 2kOJSvodYZfYZpzId89fmZphh4+qepz+9+oKCRIqmwiFvcywdyqkjD5/htbm3FfRXgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUA6i95p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3F2606A335;
	Sat,  7 Nov 2026 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUA6i95p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9541F1F0089F;
	Sat,  7 Nov 2026 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065455;
	bh=ZkRirIZu+RaMj13DH4UybH+8jYENrv7xfvXO0wOL6SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUA6i95pPjZgIyf2K2x1oXecX88KwcaVzaahMWNWs0vi7CqQ4Aal0OP7FC52O+AEw
	 ECnBs0ykNf/qIC+xBX78SEwK3fFNuIafPx34Xk+iO71+7QNHfq/dluF1/LDqjKFk05
	 rvnPNt/6koIxF4ttREhqjW4rd1Y7ubqWbCPZ2JFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1155/1257] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Sat,  7 Nov 2026 08:57:31 -0500
Message-ID: <20261107135011.103423276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 758c20678bf6c..f15a5cae5c639 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1708,8 +1708,10 @@ static int lo_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	switch(cmd) {
 	case LOOP_SET_STATUS:
-		err = loop_set_status_compat(lo,
-			     (const struct compat_loop_info __user *)arg);
+		err = -EPERM;
+		if ((mode & BLK_OPEN_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status_compat(lo,
+				(const struct compat_loop_info __user *)arg);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_compat(lo,
-- 
2.53.0



