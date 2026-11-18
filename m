Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053729;
	b=qho4oHD3w+zjnZ8g0U/Ac/1XnR+dMUo6ASk2T+OwJqmfe2b2WUjAQzW0cu+Pqp0oP8lo
	 OYK+D+3L7Q15dJJ04o72vla+v08vbUEa4NKHfclCPkf8Yw2S+jiE4pPbbhhS2e0TYwX11
	 1Zwg7x01hQUxmSriUs3GYJe/9g6T0z+1IyPXb3SkLizOpuDDiRB3Pp6u2vD9QdZCXuLxM
	 oStojK4E8JnA91lNTiyjTR4lkUZLN4avz6khvZld6Dp5vxfu0icPNQhavK7ztv2JrDsi1
	 c7RVAETE8Csfq21qbPqU+SYV+O9kr4uJ5UrbOSmG/nB7gyJp5JDWcH4R8wMCTWgZZ0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0i6pJ1JLyXlrmMEZ22Xq4s6DsCI1tZh9atHPm8AWljM=;
	b=xsMuXHxW35s9SKptDqDDFhnSRuRZMTnHdB1CuCTC5KNjbYMpOap8X4OFVqMosazSr03T
	 /tHl/WFi2y9eS7KVs1i94EgZ6BE7kB1Vn4ljoSiltjpLKymupZ/RyYCdBQAqwIh+jQRl0
	 /gxpSHUXN/2pkHOGBBa3FTEsOeIyl/NUS9quvCDkfag1CTyJ4vH90ANbaH6u6NUFboffM
	 lJIIDuCn3CGxDKMPu2aKsCzA99GtC3XCb7Gth562cEV7YPwW4SFfX3KqSc9Jo7vOLkodP
	 oB/AG9KjRs+/56BbV6FTSS7fwAPeXuXWOxL5Fnznky8J3UYWGZrfeXS/WDvvPX4aU+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GreHFDzd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EAC606A325;
	Thu, 19 Nov 2026 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GreHFDzd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795681F000C4;
	Thu, 19 Nov 2026 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053729;
	bh=0i6pJ1JLyXlrmMEZ22Xq4s6DsCI1tZh9atHPm8AWljM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GreHFDzdb0RJd5srit/wa6ULaK9uQ+zuKZIvYcEFIci8A9taN3S/k3CEXzoSj0v8M
	 BwdQh0ftcxCwQhDeK8uAjkvWCQ5VXD5utMEdG2zFgzVL16nAc24SLy36xh7g/M8WeV
	 gJhQErkEn8eosrISo9crO4Uz3OLOf/HY2cd4MAnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1020/2214] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118150053.169740542@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 45684136e8376..f130024ffd5f5 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2020,8 +2020,10 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 
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



