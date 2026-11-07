Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062339;
	b=mT9Sc7tm9nbtam78GBBokacv9QijQ37Bpkwi9TQDEf0zU/1H7fTr/evBFjvdlrhlIgRO
	 9toz/vz42TuEY/Nf3CJfHy09YgwVAiARTMh3pLmHm5zuN2EPIbmYBd6ErwtOP90V0lKaj
	 iG1bwu6+D7eEPj2SgtRwtT0ThE7OvPZQH0MjQtRniTi8nLrgwCAIa4+9Oib9nhHJkA83r
	 LNYHvHXv4Zi5Jot/mdDWVrPCCs1CJKNHd2jF3nPDu8OWbL6lZd4anFm4PoVKe6K1cGlSU
	 htjlqZVZqUp6+cihZNKp/SBvoU+N7+WU7nGO9J2OGMcYPLLUj+tJO27FkqLOhKjru2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFYh3E/RWjTSNkUR9nnXlPo+EggG7myW07C6px8R6lk=;
	b=e0YB8EcnIPo2qs3p2cDKG+Z33aHDcERW/ayyL3P+a1Iw9viEe4D98i63lzG3AF+vDqYG
	 T1iEu3vrDTqtfLx320lrLj9pB12nV/UVQAkVjGYUiZQW5xZcxP1QS+fU79hM/ThrGS0rz
	 jHhsd7VoDl2LF5F9lQzwtsCbWD1Hk8xcJKIIXOzAQ+UbAONWUf2wf+5n2OgFszYLmHwxe
	 A5l/w7wtWD1syAJsFbITbUjFymZyVL4TgC6kN5Krvna+fl06BxKyV6k93APAujrXk4dKs
	 tM1JEiSy4PCTE87DJel5D702kAQSQUdOwf0HyChy3F4aBUf+pXfkza5OWDwSqMzAIcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qp/uA/qR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55CB606D807;
	Sat,  7 Nov 2026 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qp/uA/qR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591C01F0089F;
	Sat,  7 Nov 2026 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062338;
	bh=gFYh3E/RWjTSNkUR9nnXlPo+EggG7myW07C6px8R6lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qp/uA/qRAxm1MKjM2748r/ywlvnsp7ZaJp11Dp6cO5iklGzR9qySnIaHZidHVVa6X
	 Fdds1Vp/RONeYcfX/+uE6Ha4oeTWird3jGQEAsy7cZCWSdgIe4CYuS1uE3a0pofQ9O
	 ZrMgY8uWlto9jdMKM4eMmQc2To/SFuULPB2EsH0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1267/1536] nvme-auth: fail when the controller does not authenticate itself
Date: Sat,  7 Nov 2026 08:54:43 -0500
Message-ID: <20261107135033.359201153@linuxfoundation.org>
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
index 3812448aa9864..9aeab36c2578c 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -362,8 +362,21 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
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



