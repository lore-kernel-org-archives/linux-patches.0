Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585473;
	b=WtGOSapqRurSbRQEbL2evoKuaElacQSHv7hDZ9bQdtlhz1VYRTUYja/0woWzxOPpYkSl
	 BchuHYVAA6cERYp1geBeYFD0YPy+v8x5moTSTnxMbRIaPd4a2fU857s0u1iR86zUJ1i35
	 0y6SVM/sRU6TSytG6s/e+oQ1RQ4w2h5RBc18fgLAqaxw8eoC6SlF/HvJSpcOdPVb7r2Bu
	 TE6Vp6af9VIMqIHTTyF8fUPG7VssS+2Eq43Id2kOJ0nl6fb3UGlnHtv4PhKRLYpaXehTt
	 yvBFVxA/+eBZHDQAF++jBohY7m7v1m/y1sU/I887HUpgw9qw91V8+XE4DoLE3mJMidw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aab7Xt755EGB7+KQtbUYM/cEEA6OijSGMbIVa66Y64I=;
	b=icgCgMfAOVfHdwCeuU151HTTxrJclIfMf5xWu+fsz4CXoo+CoxOyu+9wL6pdQ508f6TL
	 YM7bLlXQq30F4h1aFvd7tRAKb2gLFDEv67uY9mtrCpAUNcASJHP9WY6t1KLPW6y93SvoU
	 4p4PWgbRrys2dJmmnPfnBd9Xa4P7P6LzXxIzInq0Z3bwkA5f/LbZ6gvw37OPy40tjPo8C
	 /Tdvu2NOzPExI80xHo5lEOpiBVf615NtwlccMW7OoagAZQtxPG6s4DEAxbz9l5fhdepKP
	 vxpi4iiCEqqd5Dd2yHMJltKm5s/ChtYys4BNMGvhzIw9AqgZt1FZEFoP9d8OrZeYsRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lu+KYmdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D0D606EB88;
	Fri, 13 Nov 2026 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lu+KYmdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB861F000C6;
	Fri, 13 Nov 2026 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585472;
	bh=aab7Xt755EGB7+KQtbUYM/cEEA6OijSGMbIVa66Y64I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lu+KYmdumF1aJr5h4okfLUAOW5uLszYE5GrXw44p50hf404JVxoxgQVAVcsxj9PQK
	 xsAgxwiiHpUYYvULS8wrqu9SV0iujdqy5UaoLVNUjeMu+eKCJ9rAaSasaKJZtLtvGe
	 4Capq021p1B8dFSUju14j/EgOdyW8YHEWKRz5/uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 099/507] scsi: bsg: Report synchronous data copyback failures
Date: Fri, 13 Nov 2026 10:46:43 -0500
Message-ID: <20261113153757.531227080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 5eec248a77a6b..37393a8dedd84 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -199,7 +199,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
-	int ret;
+	int ret, unmap_ret;
 
 	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
 	    hdr->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
@@ -273,7 +273,9 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
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



