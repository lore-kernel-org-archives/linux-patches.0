Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043519;
	b=PJQSxcCK0U8p8M/1D9MZ4gEuiHdc5VSMJ78Zh+YzYAH97bxfO6p5gQs55Hpd9esl79z4
	 VGq8TEvmeU9advKguvTnA/7kIY5MYwWq2I/S3vSdvH4crmgiADJ0uIcsbXa0oSFa2uBgR
	 ENo7sjdwt+ywJv7VZZM9OiV8SXFiXMP2lZ8lTMJ2yvZuGQBTrBY6hzpRkptJ+AP67NzuI
	 kecYxddjq/qipmB1V1EgkLG8CRFqscQP+YO9eviOCUABH2GBdCQx2M+lbBLK/7ziuKWrm
	 ryOm6KH8Bwxl7eWs4lI/0cuXB2F7bUa/it7Da7QztUSK1rVYNs6iq9Mfci9RQ9OEqUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/27154ExNmldk4zbO8wqgZd8dK8Hc7of5Jci8Oh5U3Y=;
	b=LO5pZ0zS6cxG1fUXd2nJMm0/2UswDHN+vPiy27lg2Dx+cUoVSEcD+fpkpLVu8jPNcdDk
	 P9zoUa5akXNGgw1uvptCjioi2Nuy5z1E87P9OW3GGq7uVkEvM3SmpA74es/IR/4V2okIB
	 dPTMW9BAuYdR8a60fLfbAj4L1hhewsRZ5hEHsrfCSJhQR+3cKz9ds9nqZgqkdVGYM6TfA
	 AHL7JRrxOCS5daN4u//pFwAyjKYWZJy7Oa4gwsNkBhlkhcOufRpiR5/ieW8+5M7Y/OhRr
	 2XzmnjulcoEL7X2EVAX0ICIwP6nalvC3iNuGQhmmXaFlv7+p1SJ1Xv2+DTZRRlyLrsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBccseci;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08808606A320;
	Wed, 18 Nov 2026 23:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBccseci
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C10F1F000C4;
	Wed, 18 Nov 2026 23:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043518;
	bh=/27154ExNmldk4zbO8wqgZd8dK8Hc7of5Jci8Oh5U3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBccseciZOmp2c7w9aFV8DZdABg7BiGhz87qdwVomGGViugvd2xg93SGnojir0A3m
	 sM4az4VEz69FNkxQLwqIEPYHQxBag1Y7quiwqKNdmqh1mqJFN2dTIrOOq0Hvr2OiYB
	 dwuB2hGuC+cAwNe4HgB2cCbgq6qLsny/9xsQqnbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0232/2857] nvme: ratelimit the completion-path messages driven by device data
Date: Wed, 18 Nov 2026 15:21:06 +0100
Message-ID: <20261118150209.809866401@linuxfoundation.org>
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
index be940d4148c20..338f98b45c893 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -570,12 +570,12 @@ static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
 
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
index 0ed96b0ecb9e3..8639c8f2066f3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1075,9 +1075,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 
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



