Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060117;
	b=2TisNfm0FO9CK5R9TORslh/30Uv3mipmF8ThCIMPO8yN3Vex71L3lv8Wc/Vo5LAFwvyG
	 Xl9zJn7vmbV7xG8xK2CHRFW/GpDqehVToA+gGNaXMjKsA9T8G9W5qCEXglG2MiMHaJ5Hk
	 PH3J2kkHuOHfZiVQGXSo2UWKzZksAFATQzTFNywHmV19oxq8/CPJDhgTnW8sE8RM6BBx4
	 rOxeR3vDrNQMvUdZtfOIUcYRDCLRhPmk/neZXFCyc8kbfd+VGJ1G9Luutal56ZlHSWdUw
	 xaZFAN4Br0xV8ENPJ/2wwVEEBDU8rEQlUE8/GrSzU1GmxT4WTS2O7mIohYoW7rFdc5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HfC0uVNRjdv6mCyWfUoMsRGcm8wJXLq7OvrbDdtAPms=;
	b=IK3FYfEqj73BnRYVz1+rhCXb+r4WI3woh09zYULQQx0DYpdueF57NHkj+SK4TBH0FngL
	 hBac868asUprcJDKMjkwDOtOUs4Mdl+RIQND8Zv3f2rx5e+Hdk8pbG4oiU/LC2mNmwJD8
	 CvDA7vk0NqotoBzb1NM2kaJXL/zqOjESUpZPkUW+sdl2zxI/4HKEhOTUuEFFLihWkbs0a
	 GxOvSEdPICvl1DHVFRoM+kTfgFyfT7o8EbwYZ6UHrVNIx/T7NNhdm8ngemraxyi8Ec78v
	 OmlctCB+X4gCspO3ZBBDZt/s6yXY5ZZTsaVJHdHNcoLw++PEBG3z82WRp2SAjK09tqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwcSvzF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4033606A320;
	Thu, 19 Nov 2026 03:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwcSvzF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE9C1F000C4;
	Thu, 19 Nov 2026 03:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060116;
	bh=HfC0uVNRjdv6mCyWfUoMsRGcm8wJXLq7OvrbDdtAPms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwcSvzF11o4mWzhFoVNEjwTOsKSDMgHPHxdajzdmJMCoyPbBAZFUdehD3t0iSIKH5
	 iU1ny6W5xJoSkcUzSAI37d5rhqJ8mXh3ERD3HWd5kSII06npA/txB5h57tViibAQSP
	 jZG1FppBLunPtTNpK4uNy5EkoV1r7Wi/cQlLal6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1084/1848] scsi: bsg: Report synchronous data copyback failures
Date: Wed, 18 Nov 2026 15:52:02 +0100
Message-ID: <20261118150003.885045999@linuxfoundation.org>
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

From: Yingjie Wang <x-professor@outlook.com>

[ Upstream commit a52f2ad45726d788755b525adcf51f65a6b836ff ]

scsi_bsg_sg_io_fn() ignores the result of blk_rq_unmap_user(). For a
data-in command that uses a bounce buffer, unmapping copies the completed
data to userspace. If that copy fails, SG_IO can report success despite the
copyback failure.

Capture the unmap status. Preserve an earlier sense-buffer copy error and
otherwise return the data copyback error. This matches the error precedence
used by scsi_complete_sghdr_rq().

On x86_64, a virtio-scsi INQUIRY with an unaligned PROT_NONE destination
made ioctl() return 0 in 20/20 runs before this change and return -1 with
errno EFAULT in 20/20 runs afterward. Writable controls succeeded in 20/20
runs on both kernels.

Fixes: 10e8855b9451 ("bsg: add SG_IO to SG v4")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Reviewed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/2561d633cc8cef513d75eb1df260046a4971e783.1792772194.git.x-professor@outlook.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: applied the change after complete_rq() in shared bsg_sg_io() instead of the SCSI-specific scsi_bsg_sg_io_fn() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 2cbc1fcc8247b..73d2544beca29 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -137,7 +137,7 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 	struct request *rq;
 	struct bio *bio;
 	struct sg_io_v4 hdr;
-	int ret;
+	int ret, unmap_ret;
 
 	if (copy_from_user(&hdr, uarg, sizeof(hdr)))
 		return -EFAULT;
@@ -185,7 +185,9 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 
 	blk_execute_rq(q, NULL, rq, !(hdr.flags & BSG_FLAG_Q_AT_TAIL));
 	ret = rq->q->bsg_dev.ops->complete_rq(rq, &hdr);
-	blk_rq_unmap_user(bio);
+	unmap_ret = blk_rq_unmap_user(bio);
+	if (!ret)
+		ret = unmap_ret;
 
 out_free_rq:
 	rq->q->bsg_dev.ops->free_rq(rq);
-- 
2.53.0



