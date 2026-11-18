Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046242;
	b=2UzC4OqmYu8ewUGUuFfKo8eQSqHZTak4yht6DEq/tgNLPm5DatHJx5LZxTChVl7H4QB5
	 YaRcuqObSwioEUAgS0Rzr6NdbXAxPF/LSDFvhnEpoJgOKhvEqAYE3x4elg/a0jZzu4ezh
	 zYtksAelZv0FvqXCHFBPwfa0K4Il98E0BPsAnw0DqmxV/0xg9+R54o6RIvM+XPv1X9uje
	 wktfk2gzBX+oRCeToXo08JLJbOSDhjwXGK5lIqi2uqwyfKIwnh8fHyFQ3h2y4xRhPjDVl
	 5G3JcGHDwEFY3oAh+1dz8bKB1Ksnb04gdK8ILt+SFjHzVhb0T69bXZvKoMoBXi4oUIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p0nRnlq/hX8iA/hrfP1ouYfjffdV3+m9S6FiIjfqOUo=;
	b=EVNoi4BvqD3SUH8c0hhN+7R5l/aScHuG6gOrA7gfMn1++92A8PuJqpX3Qp6fyPwiyp6Q
	 XcVo0hPAZMJeQ69uTSBO66p/pMokYWZlwlM3pmUR4fl6+YM+px3vR3G1Jjaifcf6YM1j0
	 jxGBH8xcI3QOcUuCdzCQMX8P+tEPpYzNhH1wm80XO3vTXQfXm+r5nKNG6Xh5p6y8mVBcE
	 ngaic2bg8siLegS1k67mS7LoAlOQ7fkbFMm/6LE4DqH5AVHOkdqlmzsq5XEtebJF51tso
	 42xsPpzSJYmvhiph+cUFEnwVXJBfAEBOJQqVUMaKtR7hRyHM08hev7ceqzHSKF06+OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6AkLqFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8092606A31C;
	Wed, 18 Nov 2026 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6AkLqFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1691F000C4;
	Wed, 18 Nov 2026 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046242;
	bh=p0nRnlq/hX8iA/hrfP1ouYfjffdV3+m9S6FiIjfqOUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6AkLqFaIC63uebhP39OZAjCmrlJZOzegZrbdreJSQZD8ZvNFVsylSdRnPE7PwkW4
	 LDmuu/6TKbvDKSR41dkbiOHNxS3B0T/uzsGnMF8J0cLgR84d1snxNUeAgSs2tHWGoH
	 wrFxoNjG5Reyh5F4mQ/sUN4K0GjCJ7TkhNWUDCzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1212/2857] scsi: bsg: Report synchronous data copyback failures
Date: Wed, 18 Nov 2026 15:37:26 +0100
Message-ID: <20261118150245.228469238@linuxfoundation.org>
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
index 96ee35256a168..461f14d4b253a 100644
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



