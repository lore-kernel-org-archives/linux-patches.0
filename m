Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065290;
	b=OxlSmbIwHd8z15D6OVjcw18u5umG3FoSJs7NzMm9QaTCtjyCqPOgY4mbW+hD+bJWC2gO
	 w7T8iGBzqpZn6QsnKZQ1LW8GE9PvwpuFbPzbjijmQtgIeF1qOLPGCWBqMgl8DvPHixbg8
	 eYtJ+NBL/5b4XUfMBwJ0PjwEjAs6G4QezqnugudxcjW9wtOqiZjMqpdBWlRqNS3Nwlkjd
	 kxkBr5XfbVvGplfK5vik5VAhc2a2oaUEmKCPJrgi61949YJq3cGBxKS6WgBAbBvmL+rGD
	 e77VzO6JJ4hdxHltBdLidsidMWHnm0GIVTN/9J99/DQHPTMh+GAyO0tXoPYVVJR4UYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1vWb4Ak/iTjOYX0YqTRWtPI9sbORN4qCc1KRlrt+eGk=;
	b=SlBcVNsoqEfhL/G1P5NlwQOPsIwqfaLESA+sQa935S2xy5v/1zY/ah1nhr6364h2PFBY
	 3NdYHub6+6VLvFsufrH7t9EjChRvi+nP7zISbPFiANqS3rA+5T5S3jPIRfG1+KC5Wkrpd
	 EzbEK/0uSB5A6MvllxGyEW/GWNxm9kUt8LfTjNZLWayu8G8AUbqSD7yChN5m3ahOBNwj2
	 ZtX7v+Ij43o2SOvaTeh4lJmhgnxBRvXh20KJcIAs01Ikv275CjjKZEPL/qQuLeexJTHPu
	 sE2FOjhCDFwpBAdgWAZpFYX25jjzLB4Z9tBv10yi2ZF/msUm+dDYXNnKZGbtqcogUQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEhGVMSZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE456606D802;
	Sat,  7 Nov 2026 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEhGVMSZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EC01F008A1;
	Sat,  7 Nov 2026 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065289;
	bh=1vWb4Ak/iTjOYX0YqTRWtPI9sbORN4qCc1KRlrt+eGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEhGVMSZO6RPgaE5AolE/tUgDlWjZCTA4lRXWNKS7gjOjy2VaOLYEdCYX1KtMjqip
	 nF8MvwVAYGBZ72QStlejrvQuUFvINUiDjhN4r3vNbJXopCRBCuTgKDtgaAdybFtU79
	 sCaiZaQp3AoXEEbZyQP9wwd1/PcCvis84ss58Z9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1048/1257] scsi: ufs: bsg: Complete the job on error
Date: Sat,  7 Nov 2026 08:55:44 -0500
Message-ID: <20261107135008.244736264@linuxfoundation.org>
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

[ Upstream commit cc0ce3fe8fac073ecded4f32c8ee5b89da1397e8 ]

When ufs_bsg_request() fails, it returns a non-zero status without calling
bsg_job_done(). bsg_queue_rq() then ends the request with BLK_STS_IOERR
without running bsg_complete(), leaking the job's device reference and
mapped scatterlists.

Always complete the job via bsg_job_done() and return 0, matching other BSG
transports. Requests failing with a negative errno now return it from SG_IO
with the 4-byte result in the reply, while positive status codes still
return 0 from SG_IO with the reply header.

Fixes: b13a3539eb2a ("scsi: ufs-bsg: complete ufs-bsg job only if no error")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-2-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 156637dd76c8e..1519a9ab9a43a 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -195,14 +195,12 @@ static int ufs_bsg_request(struct bsg_job *job)
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
 	bsg_reply->result = ret;
-	/* complete the job here only if no error */
-	if (ret == 0) {
+	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
 					sizeof(struct ufs_bsg_reply);
-		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
-	}
+	bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.53.0



