Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037102;
	b=4XBaWfw+n+Q7qFPgnScrEsMLhdxS13WB175iPTiZnml9gWqyUgmfS7OChg1fDGEH3+r2
	 /Z4GHI4R1JCXdIVBlZawLbTzQoWb/qXbDjkqvha+TG+V0umNkomNTCKH26zHjUSSuOFAL
	 2lRuQHY+Yk3XMPxmhbOClJYRmTTTWvEE4wocGAyRuGVKoRLXP8zxaGTEZik3fmGq8NOou
	 ZkKy8k6tey3O3LweCEehPmFhI/7DRzUEPZSlkuTKwkHGo2SHpQejz+zn89Q4skYV1MEK2
	 7zuf3anLqRFoLKnhMNTFaAknCkb9TczbsyM9/lIXLq6Xj4GtdxSzTLj3zVyzPAodvLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AjHmG32bo0FGwvaK97PgZ7tNQp7mQNMXni0HVlfKfeU=;
	b=rUNM3tL5kt2jzqm+QRPBcpPCGecqKPO9OJCZaPsDLMILmUhPx3kG1IkEwj/aQ6guvEv5
	 w7ETjApzxb+NNJProjIg0o06nuqM+hjQ0BvM4/XUYki1ni61SRtXG/EqlVGyn3kAKlrZ7
	 Fz5KTPK8e/RQMI43d9qwRAH4fsmoD/gOrp3KWfeEnQ5gL7Ln/MYveJGNT0DIfQHSGGLdq
	 KJQbKErCt2aR9Z3VQvzPpebq/IcUVjVSbbgVl1CfwwZynECBmMXAgV9HXxT0ixV56+Jba
	 D6dWQt6dk21wOqHmOL0DuvJwYt0iNX72AlIFRj3XpEk08szpmDGYbDuzamAAwkeaiJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1EZNRjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CF3606A320;
	Wed, 18 Nov 2026 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1EZNRjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502BD1F000C6;
	Wed, 18 Nov 2026 21:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037101;
	bh=AjHmG32bo0FGwvaK97PgZ7tNQp7mQNMXni0HVlfKfeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1EZNRjAxMtX6l1IctUgPazi3SCbpID+lDN0EgQ57diqMkpZvcKrF1wcq8Zh6UnwR
	 HACKieaRYzOyGf8fUqe2lQ4CfUo0PV/IFeNMNrnBetvqduAmpaNyZHn7bZ5+85RKbV
	 lx609Hgo3XBB4YaOc+5TQBQGK/NRwYIGQkKk+8LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1252/3318] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Wed, 18 Nov 2026 15:31:14 +0100
Message-ID: <20261118150357.759269814@linuxfoundation.org>
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
index 6fe9180aafb36..7420e6bb53ce9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1715,8 +1715,10 @@ static int lo_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 
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



