Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038221;
	b=vsRj7saoa4qa+iW7CgVYnR2plN45ueX4XXxMRI9KzTiKUGshgMK3kEU3Aj75AMY5MhZE
	 PPcxp0bJgnXAdIvwuOLltdbk8cuH+kreGVlw5L4EC92WWwdah9eYYiHrSrysNG4zKnqfr
	 4ACVCUPVNN0w+rcIK+E4xhzRweXub7FQx2nRbWf9e1WB9VolJXW9Us+WaWIqd0snBdupf
	 mDmiCkhXTliHd5HgV+j4t09D0ry7eDUDGrnoOU2J44HEugzOFqITEQAsuq6SgrsujskMh
	 u35IjkxWy+iYSOTimRc11EmO/hW5mRTOAg/T4z1HzSJ/XayVWV63wvlgT7kvvwiH3MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTUR/m3emV9i82TPECL/fcAF06ds3d8z+qvc/VqHgTA=;
	b=s0AwQ00UcbL3KV0HmqfIsk21+7vzeCxO9/3xgysH1yG2Ee6JPJUqwI21eG/rOp8dlKlL
	 hdv/v7CBsqYsWgBokYA8ZX5Nk47aW9gZDNt73wqcLVZaaHslur+2SkON7CX1oMswn/dR9
	 4AjWYRUd+m05f32nMReakbxdq5miUyubTq4mn0/2aGaO4Je/yXUf2/iUa/9tfekYzsuqS
	 g/iWxFaniyyv8AXZzkT0YMTmRsSdl80+kQ4tTX6Du0VFaOhAixWVrXevgo5CrogOyMlU4
	 nOFp3i5QeiQMe9cl1wSW2Rh4vBPUP4LCFKRjc0KLmiL4SZwkjIyb+WEdUcWFFtv2bkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbgR9h4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A185F606A325;
	Wed, 18 Nov 2026 21:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbgR9h4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FD11F000C4;
	Wed, 18 Nov 2026 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038221;
	bh=bTUR/m3emV9i82TPECL/fcAF06ds3d8z+qvc/VqHgTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbgR9h4+0jc69IRkYhmaCD20aLcCbfoEORA1B2P6K4RCJY34c2vPiR/cRtA9GYW+E
	 qY/lq3FBeQkzZaFXdyexiwEyBS0TKTcdtwiLBtfl5p7ICAQaeMzTux1iQtHsRkDcNk
	 iGMmSJ/wYpaANhn0rwQ9P5V9VbgcDS+Ty/Aj3yME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark ODonovan <shiftee@posteo.net>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1668/3318] nvme-auth: add flag for bi-directional auth
Date: Wed, 18 Nov 2026 15:38:10 +0100
Message-ID: <20261118150411.827593929@linuxfoundation.org>
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

From: Mark O'Donovan <shiftee@posteo.net>

[ Upstream commit fc1e03eacac8e5ff8664ce2ebadabba8604f09f4 ]

Introduces an explicit variable for bi-directional auth.
The currently used variable chap->s2 is incorrectly zeroed for
uni-directional auth. That will be fixed in the next patch so this
needs to change to avoid sending unexpected success2 messages

Signed-off-by: Mark O'Donovan <shiftee@posteo.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Stable-dep-of: f9e43d924bc7 ("nvme-auth: fail when the controller does not authenticate itself")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 9f2a6472802e7..6903c1a4e7692 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -29,6 +29,7 @@ struct nvme_dhchap_queue_context {
 	int error;
 	u32 s1;
 	u32 s2;
+	bool bi_directional;
 	u16 transaction;
 	u8 status;
 	u8 dhgroup_id;
@@ -313,6 +314,7 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	data->dhvlen = cpu_to_le16(chap->host_key_len);
 	memcpy(data->rval, chap->response, chap->hash_len);
 	if (ctrl->ctrl_key) {
+		chap->bi_directional = true;
 		get_random_bytes(chap->c2, chap->hash_len);
 		data->cvalid = 1;
 		chap->s2 = nvme_auth_get_seqnum();
@@ -664,6 +666,7 @@ static void nvme_auth_reset_dhchap(struct nvme_dhchap_queue_context *chap)
 	chap->error = 0;
 	chap->s1 = 0;
 	chap->s2 = 0;
+	chap->bi_directional = false;
 	chap->transaction = 0;
 	memset(chap->c1, 0, sizeof(chap->c1));
 	memset(chap->c2, 0, sizeof(chap->c2));
@@ -826,7 +829,7 @@ static void nvme_queue_auth_work(struct work_struct *work)
 		goto fail2;
 	}
 
-	if (chap->s2) {
+	if (chap->bi_directional) {
 		/* DH-HMAC-CHAP Step 5: send success2 */
 		dev_dbg(ctrl->device, "%s: qid %d send success2\n",
 			__func__, chap->qid);
-- 
2.53.0



