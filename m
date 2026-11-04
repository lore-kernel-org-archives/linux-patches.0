Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830957;
	b=zXPAC0L15xn7hw9viYzzjl1B1eQAFQOvhQrcrmUGCL7MINLmcHhYN1Cv+7Kpq/Bw+DbR
	 WHEg3j2pd1SipQoAScjbVQB6Ecd3odfWAw9UkhUlN4leXSUtF/74fiyjUgK7lzhAMxLXG
	 PPLNTnYr1ZTiRspcnJLAFNdHWIhRU6IYftQNO/O59vrgBaEKhWlyKSaO3YDCRNC2UzDo9
	 eBp7Ur0ELXViwX8urCOzvRtBzD0PO6KoCwxDnHdUFqDUDz3egfJ2cFoMHMFInI58ZLG3B
	 4uZSNrHiWA9IUioix0Gc9z4mlhgIV+EVf07jDS4BB9OSPEK6H5G4s3ZeFf439FxPkOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hcx40YL0l+MlTE36hLHYgrbybLZpmOM28jXg8k+CAtc=;
	b=ODfLIAGrDwKHLQ3O9zXTKvTBFPJU0xZQlyW0JuLoe+SFXBIHEvklrWXPW1XfnbcC+fHC
	 z0ijILxveJZN0DlomOnKj2IPulueJuEZLwtgluPtYPzGWeJLPFYpy9aRBY6LxgS6tH6Uz
	 4KUKIhpdP3NqWUpDRPqOitLWvbJk6i2JgqIaLHgmoelpJ4Af+mA2n0yvhogP+RTppT9FM
	 vEwv5uvneCaREKOIrxINWnHXBHJ8KkIAIABXRsX2f9mmkERYxW5UVQfjCPJEjX6fNS5gz
	 9NdObbUfLnVso1SdV4grgb4xse3C8M3gyOJFM6h5T7nJFGNU0iRJnFGz8++dzQdY/oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sg968Rxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66D5606A844;
	Wed,  4 Nov 2026 22:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sg968Rxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4123A1F000C1;
	Wed,  4 Nov 2026 22:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830956;
	bh=hcx40YL0l+MlTE36hLHYgrbybLZpmOM28jXg8k+CAtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sg968Rxe+QatzRh84xM4wbmjdYAWzdBk538L+gUKbKtQVwvDZvOdIpdzvM7C4Sx13
	 eNqQ7dXqt6Cd+q3l+gH3KWxX9ZWiHzrjRUPtty8hI2iLxKODSfXtiLuKSIKyRv8JM1
	 5tMy+ejrXLUnN9R2/8eEvIq0Wy6ZMbdKSyPwDG+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0384/1005] nvme: ratelimit the completion-path messages driven by device data
Date: Wed,  4 Nov 2026 16:01:57 -0500
Message-ID: <20261104211054.848808555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index ec03a07617af1..b28c1a82f79e6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -672,12 +672,12 @@ static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
 
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
index 4efb55f1e3833..6e4261b0a0821 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1375,9 +1375,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 
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



