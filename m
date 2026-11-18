Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053246;
	b=aIuBrVrVIsu2UFVh+V3gFwBrAlqy0+vYKZR3jFFl8JRCc8v2RVcfzasV1PCTBvjfKpRi
	 03UVDSYqLGLb5BHyMjC8s3K/OhlVckvk20U6Ur6ud1q/6u8e7VqsYBJaGePULTf1Oogqi
	 GgXUnzpnlUWYaxPirBEdNowCZppDjuanDYuDayvqRGcKylIFqR22XdeUu0++/hg5qH7sy
	 s5svexnCkyBGcO0LTHYq+06+if+O10SktD/l5Im8NvjSik758R52tqszsEEveQRxAWr6M
	 OfBOL63CR3Gzbw/uVwc3vZuR4hIWqKnr9a2ZBEDf9ia8EThFdcrDEvXGmtKUL30csag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isV2TmILhglBJuTSA5c15vPGHlEqJhnvLlbWRl5fuuE=;
	b=wYCFq5ijOVSILSsG5yMv54QQQ0PE6fIZrSscBenyv+6kfJuhpYH8OjbkU0ik8UFjV8Db
	 4rUmXqzyTXjloCTEwHE2/jZY3okDFBwJF5O6To6uLwb9neNnvKpaiomP3jTt7uf+1lucT
	 xfoc7zt5BV+BV/f/ooDQoo9BhESBMVwLEIg7B6KkL6ho+L1V0fvsaRvmOrD3vhxsZxoOx
	 qxB6enBoAGAPOPUqKNi9xmS+m6aOazVrHY0Ku3rgIJi4E4zaKxkfiN/mR59sXWzZ0+iqX
	 0PiCcb70yUeg0uK1oCkV8ULgJZMS2XmnKQ06Np9McOnxU/ZhbUAbJk+ZPBKZjBqJLsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3ytOLm5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979E160A2602;
	Thu, 19 Nov 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3ytOLm5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970BB1F000C4;
	Thu, 19 Nov 2026 01:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053246;
	bh=isV2TmILhglBJuTSA5c15vPGHlEqJhnvLlbWRl5fuuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3ytOLm5EGFmjnIA7BEy1LyUW96JfnWPnbB8E7Ofoc0ZR//SDou5GfF9PfWHoM9yR
	 NM1vjjqhb9fYEINs9vTGFuS03ZGplC9/gWHDc5FQsp1oid7yhDcNS8FVXz9A8oygPO
	 RxUnTkG2LClibWESuPDHKMJjynJoAbYjPNrhU/rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0852/2214] scsi: bsg: Report synchronous data copyback failures
Date: Wed, 18 Nov 2026 15:42:08 +0100
Message-ID: <20261118150046.238688308@linuxfoundation.org>
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
index 81c3853a2a800..e09b816dc0b1e 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -15,7 +15,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	struct scsi_request *sreq;
 	struct request *rq;
 	struct bio *bio;
-	int ret;
+	int ret, unmap_ret;
 
 	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
 	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
@@ -90,7 +90,9 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	else
 		hdr->dout_resid = sreq->resid_len;
 
-	blk_rq_unmap_user(bio);
+	unmap_ret = blk_rq_unmap_user(bio);
+	if (!ret)
+		ret = unmap_ret;
 
 out_free_cmd:
 	scsi_req_free_cmd(scsi_req(rq));
-- 
2.53.0



