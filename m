Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034155;
	b=UmpzLp+De+raikhj2cjlxleaNh91RimhPeJvrpvpQwDsjvGpTb3tcy767T7xjfcb+hv4
	 fILKKq23o9zi7FwaGZTT8A065SHeMY9eNw7qXVM5YCkQ/+zU51TSle/l9MWKGb+TA3lHT
	 xoFpWqyZvChV3LfibdgzYkdirHkPnXfIEmrWZ0VO53BDURAFJAvGEFyo3PFLR7ufHryQx
	 m6+NXKcAU+/edCf55Hg2DgPGs1U+/rigtOL71paFGQvuqrA/n48M4eLnkavU7bbDXR3qJ
	 QpvSzjAGU2jJaJkkuIoACNPAuiQsry+RwC3xK5BFqr6ZWc70ArtipX/AhIr52otgApA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4dBO5OGoFic4LyW6OuEyW6B+uLYxEXnjJJI1NjBx/Q=;
	b=SYgDUo9RkytTP2IU735bgDfxNa6QLKNMOYTCD6BMM+5eAFZZ233TaXymoLMTvZmI2Rub
	 OGi4rnTWmwn4e1Wmdy9w138GVPKcn9tM/qAjj9deP/NCeTYtil0yfefm6FN4wZheS6n+S
	 E22g/OlWRCGKvNpG+t161vvH+KgIWQoOnB6u9He7AID+4VXExgX1wEbcLeIXwOGqfJXFO
	 RIwYgz+fZoFO0nK35FyQ5YhQ7giTTynDHyng4m+i3LipvOX5iEoBDdccbGMKGgGFywPFB
	 V2muIDw32pHM1jqzyZJZ359mXWcPr4BqaA5e5dDJ8vhbXrmhOMKYzUuODeNqBkSq3sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffPrswn+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C64606A320;
	Wed, 18 Nov 2026 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffPrswn+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F44D1F000C4;
	Wed, 18 Nov 2026 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034154;
	bh=s4dBO5OGoFic4LyW6OuEyW6B+uLYxEXnjJJI1NjBx/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffPrswn+LglfqGHjZxfXmIr1OdhvRHHP8/d3p5OKmP9+IW0s4H9PuIHz3qjgNevQc
	 vyYu6rB3OIwvJdTMau/Wj4S/M0P0W3qOA41RZ5LFDJMxFiLZVTZqD5B68oja24FFip
	 sY7XINRDmoJiXGOYAmcc82NHdP+uk7KHVGyIQL9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0269/3318] nvme: ratelimit the completion-path messages driven by device data
Date: Wed, 18 Nov 2026 15:14:51 +0100
Message-ID: <20261118150323.503704936@linuxfoundation.org>
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

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit c05c86681170e381e24498257db3a879deb1ae89 ]

nvme_find_rq() and nvme_handle_cqe() print an unratelimited message for
every completion queue entry whose command id does not resolve to an
in-flight request.  Both are reached from the completion interrupt path
(nvme_irq() -> nvme_poll_cq() -> nvme_handle_cqe()) and the decision to
print is made entirely from device-supplied data, so a controller that
posts a stream of bogus command ids drives unbounded printk from hard
interrupt context.

This is not hypothetical.  A single boot under an emulated controller
that posts invalid completions produced 846 "could not locate request
for tag 0x0", 846 "invalid id 0 completed on queue 2" and 123 "genctr
mismatch" lines.  Once the tag set has been torn down every subsequent
completion resolves to nothing, so the print rate is bounded only by how
fast the device can post entries.

Ratelimit the three messages.  The information they carry is diagnostic
and repeats, so the suppression count printed by the ratelimit helpers
is enough to tell that the condition persists.  This matches how the
other device-driven error prints in the driver are already handled, for
example the status messages in nvme_log_error() and
nvme_log_err_passthru().

nvme_find_rq() lives in nvme.h and is shared by pci, tcp, rdma, apple and
target-loop, so all transports are covered.

Found by FuzzNvme.

Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h | 6 +++---
 drivers/nvme/host/pci.c  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index e57d7528e8590..3fe62836b7f2b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -594,12 +594,12 @@ static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
 
 	rq = blk_mq_tag_to_rq(tags, tag);
 	if (unlikely(!rq)) {
-		pr_err("could not locate request for tag %#x\n",
-			tag);
+		pr_err_ratelimited("could not locate request for tag %#x\n",
+				   tag);
 		return NULL;
 	}
 	if (unlikely(nvme_genctr_mask(nvme_req(rq)->genctr) != genctr)) {
-		dev_err(nvme_req(rq)->ctrl->device,
+		dev_err_ratelimited(nvme_req(rq)->ctrl->device,
 			"request %#x genctr mismatch (got %#x expected %#x)\n",
 			tag, genctr, nvme_genctr_mask(nvme_req(rq)->genctr));
 		return NULL;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4e8701775b99c..33069ab67b8ea 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1028,9 +1028,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 
 	req = nvme_find_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
-		dev_warn(nvmeq->dev->ctrl.device,
-			"invalid id %d completed on queue %d\n",
-			command_id, le16_to_cpu(cqe->sq_id));
+		dev_warn_ratelimited(nvmeq->dev->ctrl.device,
+				     "invalid id %d completed on queue %d\n",
+				     command_id, le16_to_cpu(cqe->sq_id));
 		return;
 	}
 
-- 
2.53.0



