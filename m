Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590158;
	b=4yadOXK+T2ltVxjQPBxSIY0dA8+uvZbI+ZRBBvfZ4OBDsySBLityEEOOZxs2/zaMTNMn
	 t7Cx7kvBBelk9c2j1aKdFVz/+VsOfr5pDPa5S1GngQJFhirKhkDK5MvE5OL5wxxELqtXN
	 dCph5LaS5woYgMAtztPlbabTFJlrI/8Jm80J2E00FC39h27HYsbY41qH47Yn3s7pfgVbU
	 X1v8wPmrOLSmmI0vPNj136tQqaTGYohLitoqgUWdTfB3jFsVkqVSMlDp6878QQlyG7d8O
	 6SFS6YZ1cuYr7ifaLQKZ4SoCHSy0c+SIn58O3g9I7dBpNt0BoP3pvuQGw5YzPQxWrbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+wHoouWeju+JR7JJeDcTKj4iU2raH6YoR5YIT8fTpkE=;
	b=vwXe1LOxmWMNOZASL2+CInKI9rmRnN/1l1DGrrgQKIxLSoawIjlcUJQcq6f8H3bgT3zu
	 ltjMfNGjVv8jArJSyPY2RqSFbmW8sFfGP0ZJGibHLf/W+jB0NIoarjmbGOnM1KYwXfLMe
	 Mjz/wpYsjDsj7xcOZ1DpChA/5zlb/WejoieQDUFdTSUTbksywMnkPQLqBe5oDTntAy7v6
	 uxqUJbSEDsGyNQjF5jt10vRQW2VP7CdwuxM0DGairoFslyu4Q62i5ZLvCDLr+Zjmf5IBh
	 K+VvEzQTKRMPvuaG+lC0swbWlDIS5OdeQbhGKskzi8KkwL8jY1B0+RpsSczoJcSpJWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWW8h5Xu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D0F606D4B5;
	Fri, 13 Nov 2026 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWW8h5Xu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872861F000C4;
	Fri, 13 Nov 2026 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590157;
	bh=+wHoouWeju+JR7JJeDcTKj4iU2raH6YoR5YIT8fTpkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWW8h5XuvD1cJLUaJwqJSDH1AQb5GAgXjZF2mACTFO6JCBiL29X6F/FP7Myk4H0uw
	 Xnld2ZDw1vY07lEvoq0Il8hHobm1gYuI6IzKMS/c/42gCcX4gBG+nQU3FOVSh414ES
	 O4RuOOmRKtbBM8HUDZIUZD7qsc+EtMeJgeUGCh/s=
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
Subject: [PATCH 6.18 170/686] scsi: ufs: bsg: Validate request_len before accessing request
Date: Fri, 13 Nov 2026 10:45:03 -0500
Message-ID: <20261113153826.720361972@linuxfoundation.org>
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
index 0e0b08a3821c4..36def5ef24d62 100644
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



