Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062611;
	b=dsZLjduSLjYpnOETpFVv3eL0igTpfHFTNNTbNfyK99Dg9A7x9a3mjChDKBpf2G+zSz4+
	 8aVyKMvrOeRfXPMbyorsxKreoKWQmBDX0NyS8lfyyWuLFQRvFzA+3Qbs1qcMiVseMcg6/
	 WWLxI69rNjKJCuYEQcwt4BAUraFbDarnxvVfy1VmUlQpJH8V3X6s4TzGiXW4TYB6iMZBf
	 xJWzUoR/0PKQDl1ur2+gLTx19dZonHO/wYFC1VaddRz8sMar6f6CeCUreQF5v6AAsfICB
	 K8k9eE6rMCPgcOVBs4tVzAy70mbtEF7blXZcjPiKfdn3tREMmX04SmM4oAYSvYjUchw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qvwGjwdEbhkMV1fMu3BHZLsd408qadJ63LvH0GwSQvk=;
	b=2kh4OZoPF53OgiqwHjShMpEU54HAYv0q/TbKA+dzMmbmXaFETGYElFqXurkRvB3fYyZc
	 ea7dvkXQT6rCfuZJjXJDBiZj5OS4CwIdNp6c5wgL3upVLNW6OKMawfwDVzu+D0dlRDcPr
	 Y2wl8trYCE6kHmLnRrlw8fcVGSvsvfQdHsi/uBmgbZKordFx6Y2dAh1+7LwoRu1d3PXfF
	 ElPI5Quz1eDGM79nvD3Exy9tjV+/tYzjiKXuX3SrtLMhnJ35WEo7qGUODxYPFKsFJz6la
	 MBXK7W3AZYBMlYG5sHEzGPDJJ3aLPObhqI765wVLDFSzHFW5zEPfiOfBiDnVHEBQXNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LrbXZZlH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FDB606A642;
	Sat,  7 Nov 2026 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LrbXZZlH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062881F0089F;
	Sat,  7 Nov 2026 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062611;
	bh=qvwGjwdEbhkMV1fMu3BHZLsd408qadJ63LvH0GwSQvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrbXZZlH/pdRTy6tVh+hsx6VappQmacVa6l+6lSLvBcsp+K29KpVp6cVegdmjLtZW
	 l+m4aemexJBJhUNaasWyXRwbd6DFgBG51BYbKBXO/cLfWnV2ElwklodOfeXRExjjSo
	 PzR9P8F7tBaTuCsjBApD0/kIKR43+hECjGd8ZHN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1482/1536] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Sat,  7 Nov 2026 08:58:18 -0500
Message-ID: <20261107135039.475745078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dd41171922019..de111d0d47c21 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1648,8 +1648,10 @@ static int lo_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 
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



