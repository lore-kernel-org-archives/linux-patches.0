Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038224;
	b=s+XavIy+V5o/NEd18ruiCTmaZcwzSCsVLCeWE4TizUr1xnZtaKGQG6ovN8WdgS7uTgT5
	 ln2B6QIpF/42/V9OvfRF0DjVUyhlZ/w0gB40Zgn/vVXX0ppYfnCpQxehwT8LpddPV/aX0
	 apc5+5zASPEIUk4p7fTSYQDm2S9TroR94KnVGEs4LYDvK+HkTUCajOKX7VYXISOgl7RrJ
	 i1VW9o/lUpXvrErJVJJdJr4X0XnDVDRqIMbc7HoW8aHUeVkClRomsIMpMsd2tf3e1yo+2
	 RBsaKekArjAO+8S0YKxXsVX2PPgzPWfTcDW8/eE+gMOWTuTV1EgmQEN4D4reysqHDvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90i0xAkJfkaGyInNtyH1TZ+m0WgtOjzCeT3VPUwuUpQ=;
	b=3XPOZ5LGOA3w4RyJ2p9IQcfTltyJHWL7R9LcfTZZvXrWeVOd9biAI1ymujkSDteWzRtP
	 wefgzq/T9Myflku7eiQp2tIgWdu+sKJz2y4R1oW/+s3myL1oE1pxS4YIOpLo+4wo0qnFC
	 mOenV46x6M9tJqLC/wAKLUN+3kK+iPQsK6EKcV9jYcZvSJb/CfkKob8GcmkJFkHvYuqXC
	 qG868hM1DBv4XNCLWPYI+zFJZ6OXuKltepWst5QZhypzRf2D9Xp5eB0M+bkjQf7+SBSxO
	 Xz1G7/Z1xpzQO0s703SGPcEniIEL7vTXK1MIhQ85+/9ZCW7//RCdTFjMwJRArMmQQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKbKS5sl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C5E606A325;
	Wed, 18 Nov 2026 21:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKbKS5sl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAD01F000C4;
	Wed, 18 Nov 2026 21:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038224;
	bh=90i0xAkJfkaGyInNtyH1TZ+m0WgtOjzCeT3VPUwuUpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKbKS5sl/kP6r4DONBnHlOCgEnCQl3u1FgPR7ZQtySZQA2cUhcveGhq8qRFCoDxpB
	 cWAbQYasge2Os0UqpT2W/qkDA0F2LSSlGS9NlTivFsmurdBen/0xRpl2YyBtmYXm5n
	 743+e1lhwty8K/43Ho60crXxzKrz3bLnzgQrq638=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1669/3318] nvme-auth: fail when the controller does not authenticate itself
Date: Wed, 18 Nov 2026 15:38:11 +0100
Message-ID: <20261118150411.861911737@linuxfoundation.org>
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
index 6903c1a4e7692..03d05a71e6616 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -367,8 +367,21 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
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
 	if (crypto_memneq(chap->response, data->rval, data->hl)) {
-- 
2.53.0



