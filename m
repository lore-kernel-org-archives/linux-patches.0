Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037420;
	b=QwGo8xKjYhN6Q2QZ7SZQuq8inPWgQJEWrKTjNC2u/Wj126CZIpEwXig8MqDkYZZ8roz4
	 FXWLTxd5gQBjTJkWgeQWiddK0x1sOHuSxL7RWKXd+c0zyX1aWZtq5/uBP61U4Hh7wU+Ir
	 sVeOV6RGJ+aOkfihz/iVuNKnyPixk7mAuJW8cM4Wgla7Hg1YaXoEWLYUEtOuh4fD34jbo
	 vIsMq6HzeybbpfawQ2wp9ifZR0j5R/4J1prK2qMA1P/bZ9O6GtgUT5Dvb7SU8XY2PW1Di
	 UzeR2smEfA2YGOXgbMk+hYHzflwnO4tMMvC/jG1XVoIqIzXssRl7D4cleg4xjcXTC6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+4RbI8H0Dr+NscXaX3xQFmGxxXoi3RFRjv2oJRNU50k=;
	b=0lji41Wnawp5rYtnO/sUv52Z7z9ko5ppatb45OrJ+qkuOapfTAwmLiTcaInCcuZ8b8LE
	 93OUmWR2iipSi97UB4rQfu1Dxvc/Q09KqOX7poydeE4GQP4ohCo0q6DaEvvOCYx9JPspv
	 kT1E6jyDsGyexA9S6rBjElZD6wBosjfMDvkVXxtJpwaKAwQLVDEQJNASW9hcAWt5PNQl2
	 Q6094G9jGvWKRzpwnVWQWkLX+yd7y07gSAp+BPuFwW53E3Fk4Cpt/z+z0eC7aITXZur1f
	 PpwKnJap/bsY2OoHjyW5iiICaSCGUqWV4bphd1pw3ACfOn0B1Zk77WlUWZFqiSjFbmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yXLP97cA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B60B606A325;
	Wed, 18 Nov 2026 21:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yXLP97cA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761F21F000C4;
	Wed, 18 Nov 2026 21:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037420;
	bh=+4RbI8H0Dr+NscXaX3xQFmGxxXoi3RFRjv2oJRNU50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXLP97cAb9Zg5l8AbY9sxvYdrPFdXxPAtJcGhK06mNAewvVdJqBnrQeNS/mO8hD6v
	 Sj+qXD6WmnDsTHAMVkE4R4ohLCpq6Mzph1F5IQY461mt0tRtOyn16CE6B3s/9WVRXV
	 bErdtzQONF0rzyISUlxBaR+s5GpiOtDpZOK2xMgc=
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
Subject: [PATCH 6.6 1395/3318] scsi: ufs: bsg: Validate request_len before accessing request
Date: Wed, 18 Nov 2026 15:33:37 +0100
Message-ID: <20261118150402.442008700@linuxfoundation.org>
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
index 0d7ef0cc0055e..d3e929d084221 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -79,6 +79,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *j
 	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en)
 		return -EINVAL;
 
+	if (job->request_len < sizeof(*rpmb_request))
+		return -EINVAL;
+
 	if (rpmb_request->ehs_req.length != 2 || rpmb_request->ehs_req.ehs_type != 1)
 		return -EINVAL;
 
@@ -144,6 +147,11 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	memset(job->reply, 0, job->reply_len);
 
+	if (job->request_len < sizeof(*bsg_request)) {
+		ret = -EINVAL;
+		goto out_complete;
+	}
+
 	ufshcd_rpm_get_sync(hba);
 
 	msgcode = bsg_request->msgcode;
@@ -193,6 +201,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 out:
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
+out_complete:
 	bsg_reply->result = ret;
 	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
-- 
2.53.0



