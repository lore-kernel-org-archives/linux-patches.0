Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046811;
	b=PSd56B0lzbWGnEZYgTCqcKrnSmaT6s6QwGlsitk+7pw8movfxlc6YHMqcR6+1GIxA+UY
	 rjkDLhHZW9auGwphUHCkBVxnZO5c6T+fBrQJwqqFze9BJdyOnqGkjFLeSzuuP6No5JSRo
	 I2cY07ej9pNkEXTI+JMguiGyxrUbblBt8vMjDA2aPcftRDimnm5oe8BUHrRG1Cstrt54H
	 T/i+3bV1jhuNoHbCygNRBXu4VZz1mZCa75fDj+dNuBH5uDj8HEnVubYmOJAJdb26KJHea
	 NoJDm1HkNtycdcq3t100tmRR8KIW6ADLfgBjkgKiq4+1kEDb3hpaXNXxWRyfcdemDSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E8TNic8K7be9mTsY0YD4N1mGvBYEXVrU1qgqIpF3KuM=;
	b=TjUas1td5AXkPbO+WfS9+2XTN1pCgp7LXHys1s+YwMeLdIPftPalBdJoCWZ05c8S9d1r
	 RiFmXpUJwB9JTH2UGwBhu75hdWqqyrIBfaU5qpZbJOYpKGwfxFC77ZxXirU526JiLCGiQ
	 XnDSBX4Wqbz3R5OVHo8hZL+eJv7l8qUqiUDXD6l2xPsxQJKr1sLhTrUVFDVgkucXJU2SL
	 XqdAemsCctIjKsXUCahfiv0fb6Ef9cqW6/P05I5ALHbgqjMiTUvQPM6nmfkMTDZ1JSdhS
	 L6iSqgFZ9FWU+460fHgdGQ0A+DFel7X2m/jrVkVZzeUWtT06AwPQ6GQIKCcZ+6MyaHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKzrRB0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2830606A320;
	Thu, 19 Nov 2026 00:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKzrRB0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB71F000C5;
	Thu, 19 Nov 2026 00:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046810;
	bh=E8TNic8K7be9mTsY0YD4N1mGvBYEXVrU1qgqIpF3KuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKzrRB0gesdxgjPNUgbhDyj7kiKzSAt23PvEzJKm9tI6cyiR4K/u5KBimdinXsfuY
	 3SGTP1efyJBgc7bOupRBewatPye7cPiXxcpjKbtOQ3cR4Kv3uwSuYQ88zHMDQfE53+
	 3ifu4SoQ658hrQic4oAjv17KFvNS8K8rpqaMV6v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1413/2857] nvme-auth: fail when the controller does not authenticate itself
Date: Wed, 18 Nov 2026 15:40:47 +0100
Message-ID: <20261118150252.209910633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit f9e43d924bc74feeb56197de82b2845de2a4b85a ]

nvme_auth_process_dhchap_success1() returns success as soon as the
controller clears the rvalid flag in its DH-HMAC-CHAP success1 message,
without looking at whether the host had asked the controller to
authenticate.  A host configured with a controller secret sends a
challenge in its reply, computes the expected controller response, and
sets chap->bi_directional; if the controller then answers with
rvalid = 0 the response is never compared, the host still sends
success2, and the queue is marked as authenticated.

A malicious or man-in-the-middle controller therefore only has to clear
one flag to turn the configured bidirectional authentication into a
one-way one, without holding any secret of its own.  The target side
already treats the mirror image of this as fatal: when the host supplied
a challenge but no controller key is configured, nvmet_auth_success1()
fails the authentication rather than answering with rvalid = 0.

Refuse the connection if the controller returns no response although
bidirectional authentication was requested.  chap->bi_directional is the
right condition rather than ctrl->ctrl_key, because secure concatenation
sends a challenge only to derive the PSK and deliberately clears
bi_directional; a one-way setup without a controller secret keeps
returning success as before.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 5bac8a34a9a43..a6dd41057737e 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -369,8 +369,21 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 			 nvme_auth_hmac_name(chap->hash_id),
 			 nvme_auth_dhgroup_name(chap->dhgroup_id));
 
-	if (!data->rvalid)
+	if (!data->rvalid) {
+		/*
+		 * The controller did not return a response.  If we asked it to
+		 * authenticate itself the session must not be used, otherwise
+		 * mutual authentication would silently degrade to one-way.
+		 */
+		if (chap->bi_directional) {
+			dev_warn(ctrl->device,
+				 "qid %d: controller did not authenticate\n",
+				 chap->qid);
+			chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
+			return -ECONNREFUSED;
+		}
 		return 0;
+	}
 
 	/* Validate controller response */
 	if (memcmp(chap->response, data->rval, data->hl)) {
-- 
2.53.0



