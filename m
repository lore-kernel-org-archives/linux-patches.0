Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591040;
	b=wqNCv6gMCxyYzu6GbQaKZjZaetdGQce5TgfkFljpYSxGb+NCkjKg3HRGUwn284B8YaWT
	 auJr+wKFP6MT9VVDAlP7sbI+Oh+94j8DVqHtZ7NAPG30tzJECu+eW7wQwvxHFiK0JKAfr
	 HTT84V9amV9JTryE4Ohs/oQ5wKGrsIaIQ0F5FINBDWHL/PwW75BDCu6VSh5gxSjgNeVb/
	 RTtmU6CA0//CGfQd77MZCPwwcZJ8fsiugC1unX7fQiwTupavXCIuCVhqthLF1+qtmInQ0
	 l1p6W+iYhuB/cmJMKeL1SiZaDFrswNgD2qkeqCUPpdSwY8XMpwocHG/8xE/GjL/gETQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=npTy7UNpfHYZAwtpyj8xLpPeRuhNhQk35KwKGnHdIK8=;
	b=NraOuijVVOZUev8o9YpFyFXOhpunjTm+FZ4kRvCWyqObDqkr2DGAKlKPhtXQlI9HF14K
	 j2SzFc5nrx/aeNem/0Z0ORP/eS0jyU3n89zu2EBzjMUHE15sGp4fLJmxi3Gea9bqx+TL6
	 WEDI3LIY7p2MXl1U+9EdpSVg1er+a8Y2ewvUBE+VGfpG0Bg8BBp6Xgl/wxoOkXRH817jB
	 IQ/anLoUI3zEK6fc8jAu75I8Jfu4we4q/DrFHY+EFBM2WOcRDUa4TuwmaaKlpNAAieC39
	 jTQQNgeOpY4ujZr2KAvQsdaw9nZGd9Cf246bApjrH9/DrcVJ0K9+oEmDd6+HjgMk69w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zr7z2wHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F91606B471;
	Fri, 13 Nov 2026 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zr7z2wHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D57A1F000C4;
	Fri, 13 Nov 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591040;
	bh=npTy7UNpfHYZAwtpyj8xLpPeRuhNhQk35KwKGnHdIK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zr7z2wHyJ82b/KSo8o8jRZeL4rrAyyqupGqvf1XtzMb7HCSN0Ev4PFK+sNS4DtJ4T
	 Zzz5Isb71HYy7/uE5nerBiPbRa74tWlex78jbianTYw28eu1B4uZFUNvxgcrtkravw
	 Pgvl7MsPWmwoHWGNT69IYz6js7aZ9yLzsuM5xFVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/670] scsi: bsg: Report synchronous data copyback failures
Date: Fri, 13 Nov 2026 10:46:10 -0500
Message-ID: <20261113153818.928268432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



