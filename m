Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032710;
	b=vy9P0fD9m6f6JSdmZZFy5BYFaldxYlzNBgPWdFELL820KHXu8kMiBk4pN8/3M1J70ipe
	 p1mXT3Nb0PHdgk5qaRHJgz962w5bbGvyXNSankauc+0pC38nlyQ12n8JIXLiPSMrkkvaO
	 V24Swj3a3y35ptWZUCCU2o6BwO7KMCOPvWCW4ecgwlEd5t0NlX33iHqN1RML/yW2A66HK
	 Q57BtzdFARiIUITqSmD2y0Mr1Zxy0ifuTkuzH8/bBWjK7g3Mne5AjQ4aeVfcPu66AAhTG
	 8CUVRbvvNHAQ99k3bVgpH3SQDPdCKiSQ0ed2ZJ1tHeICaD6A5MfH3tv4X/no7JdtO4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7SoFxgsMKRlwTMKO+rNWYxKugmkOWvbtQmhaw54e9sc=;
	b=kgdVrJnk2onTZ38UJJpYsBoulWQQnDngGlWdKlTX1JzYWxVAW1AA+pmjZB9wML2kX5HZ
	 9F82KAiGAuC0qxIvwCPmwkD+3lgE0Z3KdEH66lSRSEssNtm4RlGeeLX6sjns2mwjVR3SM
	 OyWTvWLN0zzkusdd9ZezW2VP+WsxFMlmCvW/RkctvPgszcl2ZLuMXBfiis3enYkz1VCCF
	 vZj3vr+VY/euDj2ikMrcKC1k8FScgH7Q+XRAhkBOGynqTLnTjJMwnk6vwc4Si0gARv308
	 xUU6cZEYqxZSonL9ayRmBqQY/aIe7nktgsLVoIImXYuzpqXf1Hcfh36bzMPp4JGZOXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hpsv9JbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC83B60A2611;
	Wed, 18 Nov 2026 20:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hpsv9JbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A551F000C4;
	Wed, 18 Nov 2026 20:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032709;
	bh=7SoFxgsMKRlwTMKO+rNWYxKugmkOWvbtQmhaw54e9sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hpsv9JbQQYRZdAWXwzDs25uyEWC5XQRj6QF7dleg9hsKf9bM7i9Q0A+7yZwr2s5Ex
	 g9D4L9SEzgWx0h1HJhdf0OqmKnZXqPYe9TejiLQRVCHFrF9wkaSqJMW5p/mr1EgkS2
	 zHbc2vcoX3zw627qsqf/X/cArzQ0m0V1vcoFFTww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1506/1756] nvme-fabrics: clear the poll map if no poll queues are mapped
Date: Wed, 18 Nov 2026 16:00:33 +0100
Message-ID: <20261118150108.865463397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 36ede1aa85d5d74c39ed375a906f6eadb15cee5b ]

blk_mq_alloc_tag_set sets the nr_queues of every map to nr_hw_queues.
When nr_poll_queues is set but no queues are left for polling,
nvmf_map_queues skips the poll map and leaves it this way, with all CPUs
mapped to hctx 0.  The queue then claims poll support, polled I/O ends
up on hctx 0, which isn't a poll queue, and hctx 0 is marked as a poll
hctx, so even the Connect command of the first I/O queue is marked as
polled.

Clear the poll map when no poll queues are mapped, so polled I/O is
rejected with -EOPNOTSUPP.

Fixes: 1a9460cef571 ("nvme-tcp: support simple polling")
Fixes: 5651cd3c4336 ("nvme-rdma: fix queue mapping when queue count is limited")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 438cd602f641f..25fe35f05e28a 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1171,6 +1171,13 @@ void nvmf_map_queues(struct blk_mq_tag_set *set, struct nvme_ctrl *ctrl,
 			io_queues[HCTX_TYPE_DEFAULT] +
 			io_queues[HCTX_TYPE_READ];
 		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
+	} else {
+		/*
+		 * blk_mq_alloc_tag_set sets nr_queues of all maps to
+		 * nr_hw_queues.  Clear the poll map, otherwise the queue claims
+		 * poll support and polled I/O ends up on hctx 0.
+		 */
+		set->map[HCTX_TYPE_POLL].nr_queues = 0;
 	}
 
 	dev_info(ctrl->device,
-- 
2.53.0



