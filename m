Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590224;
	b=aq+nwynjvTkKbbyUZwnm2HXA1yifNgI5UW8l+5Xuf1BTK9WjgZRsNE6OdGJKxaGxBcXU
	 pzqNqnWSGOUd7IRiF615Baa+FLt/9vtHbA/vobIiRu241pl4yD3VJdurC+Jnl3JWRUYyQ
	 X7lRCb+iiOoTHlfzLZuM2NWs2A25vv6zqyRYJIVe6CMztgsaBu6ImEvPYClRMw0IMQ2Lp
	 J32ZoY1X+y3tTFLnBd1aegWSKccKO4I3konoWVkOE7j3AtX8XM6MSBOF9GTjDwNT2fcqo
	 EC96gKVMuV1lu3dOQMmepztUnTYCK/BcDFv6Iyt09OfRPZ11RWq5bflURn9KWPF8SJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nmcDQ98y1kT2kH7vqd/RmMDWlyiZJZeXPW/IDsLkG+8=;
	b=Ww2NkhDrs8vqWRu1IvD0jjVhYNBL9hzKmZ223TGQ7wsqgSjCa1Z8BbdHFFqoAvlntfUt
	 smzT/Q8PIZO7yqonoYBZi1EoMSCJgEQgt8xZNmH3aZPcUNfzhxHM9JqH2zyI8+kgPExSO
	 RZYHhntbBA685UgevCuD8/WHwvDwq6yL9S8B6vWpLfM1phDME78gsptFRS1YhVsFgttvG
	 NY/dRNzPFIxbd4074Dh6XXb1Um45LDGbUiEsOtCc4kiwl/VO4W7w9IFf22L4ORBT8VLLm
	 tkWYAi2S4lbZrklm5dqhpu+X1Qo6YeFSw4RcNxuC0o/b2C3NPBTUoDW6EDpymDzChDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1LvQGSs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D5606C08A;
	Fri, 13 Nov 2026 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1LvQGSs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC5C1F000C6;
	Fri, 13 Nov 2026 17:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590224;
	bh=nmcDQ98y1kT2kH7vqd/RmMDWlyiZJZeXPW/IDsLkG+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1LvQGSsH/6/n8sUPdim7KWCJAM7iqCTD7oBQ3be37aRcGJ0TY5o+8o5Dp3UfGvX/
	 +/ph0eHDpaW+IhuGTkcT8LxGCsNp8Adr6m0S390/JxjwyVr8SlyOY3BWfqil+UbT3J
	 WTJHhzeU97SONuwtiqy4UGXml/sfoGuGweRMTRbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/686] scsi: bsg: Report synchronous data copyback failures
Date: Fri, 13 Nov 2026 10:45:56 -0500
Message-ID: <20261113153828.584164845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



