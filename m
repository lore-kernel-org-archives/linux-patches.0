Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037563;
	b=xMB3jq2qEOBTQCwdqedYQAN8A0T8jSnXJ/pOu5igs8cwPjI7i0XN9tRpuCdHaVCwsx+I
	 k1bcw3MX4DG01uPCXsSDTbjGCUVUG1lqXFxflXAER7ar5c4WcnlaaNkMf0/Wbgi8jrvtB
	 DftNyIbMbdPH4Kom9TKNnOI5XQEzKxNTdkfMFyfIx+uombAb/QBqNdC7hrPGGkSAMSBDR
	 kz2PJQyzKo5cOo7zWjl0nV/ux7TJAB54A47u15qfHkoAE14aqr61daeTaxBZpl9qt/Wq0
	 VIsvZwPK4xsradAdUxCIsZ8g5NjzK63oA1Co+6o/8cZ2hy8IJUe+J/qoTY8oWXmP2eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D7Or21B/fpYenGv8+OCBOaGpzVf4gVjFWmBqGt1rPm8=;
	b=Jt1AIpAcDR6jsDgnIqHehawQ0ZFqzJA1yDGFFzxZsAJBR2iYIjVC++udB31Zrjga217h
	 ML8sLsdUwt9lu6R6iZ8/VGgpGJlG7NGMAKOLOZuNb8E52vhnO5gtRUE1Hu9bes0ZnajJi
	 xWbfYSVRfbmH35A7upqDrOn94ZzQ1X+EU0AFSqVK+ViGM5elO/u1aBHpTP4LRaGyaQwEV
	 JFLsqZBRs553NTBDiGwsr8rVQ913HGH2TpwgbJg/ytjVWyJwoaf8YS/i1AStohaUQJlqM
	 P1oI7GeX2w/UVIHll1o+OYb2mZQKaw2gImoPdYkBdKpjxVELHfX8Q5om0cMCUj7IdAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ObgJ2h/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4AA606A31C;
	Wed, 18 Nov 2026 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObgJ2h/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40F21F000C4;
	Wed, 18 Nov 2026 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037563;
	bh=D7Or21B/fpYenGv8+OCBOaGpzVf4gVjFWmBqGt1rPm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObgJ2h/abvMg5QwLQVgPJz6Jw1MNHsDKnYlmBwXOq4SJ0dBE6sit8SYE8mpkQN154
	 R4WcKroYvBFoto4LuI9xDRH8B2REnekouAz37rOm8aza/jtGIWKG4vB1ddXPtIc6Pn
	 FjKIbPw+Y30v7f4JWTvblqA6wa+QaSglpHHVRi2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1424/3318] scsi: bsg: Report synchronous data copyback failures
Date: Wed, 18 Nov 2026 15:34:06 +0100
Message-ID: <20261118150403.434778794@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_bsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index a9a9ec086a7e3..e2e4b8bb559f9 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -15,7 +15,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
-	int ret;
+	int ret, unmap_ret;
 
 	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
 	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
@@ -89,7 +89,9 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	else
 		hdr->dout_resid = scmd->resid_len;
 
-	blk_rq_unmap_user(bio);
+	unmap_ret = blk_rq_unmap_user(bio);
+	if (!ret)
+		ret = unmap_ret;
 
 out_put_request:
 	blk_mq_free_request(rq);
-- 
2.53.0



