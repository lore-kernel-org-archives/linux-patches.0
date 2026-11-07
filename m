Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065292;
	b=PQjsspCfbE7iOg3u4GYycXRA/JGjPsFCMBF7yDDfYsUhkuQfaZ6uFm8RHJsG2WAreVbw
	 20UHivkh5mdf3j4umotkDsLn5kzN3VUhU+9Xxt8wXgtE/P7FEHNfM5jms591sj1Wq7add
	 kqF3DYgFwojnrSZgtuG7TylVJ0ud+yUFL2WV2Iq30wvSOpaePOVrgBbdxdQpeGq+BqilE
	 +S6kl/uEkY4OOfzZwx30x2bfdi3ia3h7qx9EioTD01OCKBTGJm1E1/KUAfbrQ+Tj1xnYR
	 /GIm2CiC98I1cN5oy63SQu1zzKzloU64qX8aCwU9S8LLGPODm82rdFIzLescCcQdj6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOvu8/OUGUI/WAPFlospSBRxN6zWkBCqbS1Eb4W//ck=;
	b=umNosiIZqJmCv4hf9BQ273TE8EHJc/PHM/42+9tbh6j6kx/Dz4w/L370bwiF8i8gfh6a
	 j/gicdSXTwfXb+LsxU8OqBdrByb7GTpi4Y93QjvBdvvuHh19ouvnXJQuZZxJ4G5gQSg19
	 JxlKJbd2T7v+0YtpKrChF26kfG6m8vqQ0KxvxWPlRygsASdKHMtcKbQQPxdrFEiPlBNzn
	 FNC/GA6t7ysbWKrVFfTFj4Pf3lt1Xwhn3IhwoGUKV0EzCN7l3b9Nw8AZFF92j49u4mp4N
	 zdJYP4mKfWSOD90awLNmsq8PNXBK4Eawh39g//qZNy1t1DkGqIyoY277n84We21dffw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olrrvFWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7686D606A32C;
	Sat,  7 Nov 2026 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olrrvFWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204911F0089F;
	Sat,  7 Nov 2026 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065292;
	bh=wOvu8/OUGUI/WAPFlospSBRxN6zWkBCqbS1Eb4W//ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olrrvFWxF5R54O0goUtt5fCMGD+9RZ9VcQ4aDGkQmYkYZ17EvIZT44sk9RzROjDI1
	 gcB7qDHKCvSz5Ot/TLnEOygboe/habmI21tnt3oJOAQHWiSZME2Ipz7Tagh2NUAVOP
	 pb/FCqAvYeKA19gDywQpndCkl/IO5sqx9SUQv4o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1050/1257] scsi: ufs: bsg: Validate request_len before accessing request
Date: Sat,  7 Nov 2026 08:55:46 -0500
Message-ID: <20261107135008.297821663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 42aa443718104d10dbdb6f258810b425eb2451f8 ]

ufs_bsg_request() and ufs_bsg_exec_advanced_rpmb_req() read the request
buffer without checking job->request_len, which userspace controls. A short
request causes an out-of-bounds read. Found by syzkaller.

Reject requests shorter than the structure each path reads.

Fixes: 64d4864714c2 ("scsi: ufs: bsg: Remove unnecessary length checkup")
Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-4-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 0fd4dc18e2729..7aecbb290e658 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -73,6 +73,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *j
 	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en)
 		return -EINVAL;
 
+	if (job->request_len < sizeof(*rpmb_request))
+		return -EINVAL;
+
 	if (rpmb_request->ehs_req.length != 2 || rpmb_request->ehs_req.ehs_type != 1)
 		return -EINVAL;
 
@@ -142,6 +145,11 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	memset(job->reply, 0, job->reply_len);
 
+	if (job->request_len < sizeof(*bsg_request)) {
+		ret = -EINVAL;
+		goto out_complete;
+	}
+
 	ufshcd_rpm_get_sync(hba);
 
 	msgcode = bsg_request->msgcode;
@@ -194,6 +202,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 out:
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
+out_complete:
 	bsg_reply->result = ret;
 	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
-- 
2.53.0



