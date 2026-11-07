Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062543;
	b=QaN4vtNKq6Ml2OGlcAsdXU+m7mkczNI0Q9RiPmEnVRWRBYdZ60SFvzbJHtg09DTk8P4P
	 BxNUEwyFJWRC5+V8elccnUF2FvEg6Yjow2JDZKMBMtof5T4tBe7CVa1vCTThSMRJrbeqk
	 BJ/UFYkfLv4lvh9JfiRT/9oMlBLSidFxf3c3ckDtuSCZxCs5AZElKysD6Heku5SgSOgA+
	 jg1Os96hwAuxiF0r9jwWYk2M9KJJduv8Mmx61itncoux60KMnNl4EN51e1ZcpSR6CxWML
	 ytMOyJD6hFo0z34vib3DLMVTMkKEVQc8Uyy7zN6j+jEYHF5WghUz9T/g/p1IeLnQdkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fmF0iCSZZNDg2Lsxq6dEgh93pH9XGcQ6c69iHF5QsqA=;
	b=1Nm3xt4ZD9cbjdTCo7hqM9lAwClHewkZnkERcljbp9Z/ITqtcbiUjE1wJwBmycHRQ3tQ
	 DX9q+lpjGhn2KA/yuH9qd4rRrF4UtDaARiwJuodxBcPB7Apb4MWBkjEFY7+/vj90JTiYw
	 QuTucB3Q3biJAJkItechNWEEq09YN9jvlzmIZFgL/cMZvDS2oNY7/hKQyRr2w0l7CM6dK
	 Z+cpbWOa1Fd1LfD9xiteVqWmScF4RiqyJvJfdNmCFGrIjr5gGtZGLNMSyxfay5ExxtfIx
	 qBy45st8aZ8SPNnjsQZfX76bwcmo6L4IyHHhrgsc+XoljK17o6hYFgXE+eNZbNjGn0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6ugz2pL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED9B606A334;
	Sat,  7 Nov 2026 14:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6ugz2pL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B401F0089F;
	Sat,  7 Nov 2026 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062542;
	bh=fmF0iCSZZNDg2Lsxq6dEgh93pH9XGcQ6c69iHF5QsqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6ugz2pLsNWBzlN8qwAJOVJjmjV2eW513Zsblkx4spTDcfTR/9ZQZbG+k3nYNzy/f
	 QhdzHouSOCYRGDVQsDQcJnnUgYKsiDCdCMmjLirq7vg4NsZ8Otrst3BwF3lMoh0oGQ
	 ZFGfiDs5EqZ8GZWr40tJRU2qkGtwRg73UFOrJlCc=
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
Subject: [PATCH 6.12 1431/1536] scsi: ufs: bsg: Complete the job on error
Date: Sat,  7 Nov 2026 08:57:27 -0500
Message-ID: <20261107135038.026718720@linuxfoundation.org>
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
index bb6ff8ca5c7a8..237ade1f0cd83 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -194,14 +194,12 @@ static int ufs_bsg_request(struct bsg_job *job)
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



