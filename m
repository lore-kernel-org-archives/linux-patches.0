Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043969;
	b=f6tw164raG/ScAmZ3ZL4tD4jmuFIFEPz8p1gDjvkUAvNalG1UR1r6fQkYqTj6yGFkEiw
	 +9QbehD964P9FJUF8iomd0ymAM/Sn9qTAouH4p+CoxJE/+Q9mbPbW1OPmblEaq3fSDfo4
	 2Mq1wB1iVc8GOFfhM41sLUqHNRnGHyzQiagSss84AoSGDQlxdEKGhqaVVX4M8mfTQULPx
	 jG0+huj1AKPF7284WgXo8G4jMCRcJME26J2haRo7VX0wfwVvlI2VhX1SE/apg3EoyVI73
	 sbrJbQwN4TOEJizhlNMcNH15dl6PFHsBUEJvEyva782xXSOBdMAPehqIIyiekfLj2Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HJ/any6BxJ3uiqAX4Q/B5GzzmE7Zy7bjFYumWrWwxxU=;
	b=SlfwRCLNOsrSiZcpkOAgW1kskNxBEulAX5/x9SJ+hBjeqUMsnPI+IPmkt6qSR9DoWPTr
	 sucRNhGPeOKOObDCj344VrsrxTriucicmiCRJyjfM5SYypJ4VQ65kzahFDjCw/S+4IZye
	 0kLvzzUV9EFurEMJBSjYCYkhnh/DBrfK45g+vBiLb1LooUvHRtse7HU9Kqj6UmGSmw/cy
	 KnTczMkOioqfsyVlJEeBmCu/jLuIJAeUJ1YU+Zk1iQid5P7xP6kcH8JzUzcQJkZ/jXVCf
	 pBgdIL8XneJkzA3a3cpw+eRrlhsKcfu2tFewgNmGrv505pTHm9iJD39nqnwovszumVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pgVPNEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B514606A32A;
	Wed, 18 Nov 2026 23:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pgVPNEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C421F000C4;
	Wed, 18 Nov 2026 23:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043969;
	bh=HJ/any6BxJ3uiqAX4Q/B5GzzmE7Zy7bjFYumWrWwxxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pgVPNEZzRYcn/XYdK8IbxJgqiHiOsIiRFQ55C5o65rVmPfnIxE+g1fsTtTAzNqeN
	 jcKfoX/mUvKILrWR6F6figUtYZhUpkcVoo1jK1oZph/sn1d5E4vTDdBIwNclo/hukg
	 n1yXFBpvT958UHboIfaTZgLPfSDoXPg/2FOAboiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Chen <wenchao.chen@unisoc.com>,
	Michael Wu <michael@allwinnertech.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0399/2857] mmc: mmc-hsq: Use fifo to dispatch mmc_request
Date: Wed, 18 Nov 2026 15:23:53 +0100
Message-ID: <20261118150215.756909336@linuxfoundation.org>
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

From: Michael Wu <michael@allwinnertech.com>

[ Upstream commit e026a3f9172f5c9aacff270b929a166c3ea1b6f7 ]

Current next_tag selection will cause a large delay in some requests and
destroy the scheduling results of the block scheduling layer. Because the
issued mrq tags cannot ensure that each time is sequential, especially when
the IO load is heavy. In the fio performance test, we found that 4k random
read data was sent to mmc_hsq to start calling request_atomic It takes
nearly 200ms to process the request, while mmc_hsq has processed thousands
of other requests. So we use fifo here to ensure the first in, first out
feature of the request and avoid adding additional delay to the request.

Reviewed-by: Wenchao Chen <wenchao.chen@unisoc.com>
Signed-off-by: Michael Wu <michael@allwinnertech.com>
Link: https://lore.kernel.org/r/20221128093847.22768-1-michael@allwinnertech.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 5d132990475f ("mmc: hsq: Fix use-after-free in retry work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmc_hsq.c | 40 ++++++++++++++------------------------
 drivers/mmc/host/mmc_hsq.h |  5 +++++
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/mmc_hsq.c b/drivers/mmc/host/mmc_hsq.c
index 9d35453e7371b..424dc7b07858f 100644
--- a/drivers/mmc/host/mmc_hsq.c
+++ b/drivers/mmc/host/mmc_hsq.c
@@ -13,9 +13,6 @@
 
 #include "mmc_hsq.h"
 
-#define HSQ_NUM_SLOTS	64
-#define HSQ_INVALID_TAG	HSQ_NUM_SLOTS
-
 static void mmc_hsq_retry_handler(struct work_struct *work)
 {
 	struct mmc_hsq *hsq = container_of(work, struct mmc_hsq, retry_work);
@@ -73,7 +70,6 @@ static void mmc_hsq_pump_requests(struct mmc_hsq *hsq)
 
 static void mmc_hsq_update_next_tag(struct mmc_hsq *hsq, int remains)
 {
-	struct hsq_slot *slot;
 	int tag;
 
 	/*
@@ -82,29 +78,12 @@ static void mmc_hsq_update_next_tag(struct mmc_hsq *hsq, int remains)
 	 */
 	if (!remains) {
 		hsq->next_tag = HSQ_INVALID_TAG;
+		hsq->tail_tag = HSQ_INVALID_TAG;
 		return;
 	}
 
-	/*
-	 * Increasing the next tag and check if the corresponding request is
-	 * available, if yes, then we found a candidate request.
-	 */
-	if (++hsq->next_tag != HSQ_INVALID_TAG) {
-		slot = &hsq->slot[hsq->next_tag];
-		if (slot->mrq)
-			return;
-	}
-
-	/* Othersie we should iterate all slots to find a available tag. */
-	for (tag = 0; tag < HSQ_NUM_SLOTS; tag++) {
-		slot = &hsq->slot[tag];
-		if (slot->mrq)
-			break;
-	}
-
-	if (tag == HSQ_NUM_SLOTS)
-		tag = HSQ_INVALID_TAG;
-
+	tag = hsq->tag_slot[hsq->next_tag];
+	hsq->tag_slot[hsq->next_tag] = HSQ_INVALID_TAG;
 	hsq->next_tag = tag;
 }
 
@@ -233,8 +212,14 @@ static int mmc_hsq_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	 * Set the next tag as current request tag if no available
 	 * next tag.
 	 */
-	if (hsq->next_tag == HSQ_INVALID_TAG)
+	if (hsq->next_tag == HSQ_INVALID_TAG) {
 		hsq->next_tag = tag;
+		hsq->tail_tag = tag;
+		hsq->tag_slot[hsq->tail_tag] = HSQ_INVALID_TAG;
+	} else {
+		hsq->tag_slot[hsq->tail_tag] = tag;
+		hsq->tail_tag = tag;
+	}
 
 	hsq->qcnt++;
 
@@ -339,8 +324,10 @@ static const struct mmc_cqe_ops mmc_hsq_ops = {
 
 int mmc_hsq_init(struct mmc_hsq *hsq, struct mmc_host *mmc)
 {
+	int i;
 	hsq->num_slots = HSQ_NUM_SLOTS;
 	hsq->next_tag = HSQ_INVALID_TAG;
+	hsq->tail_tag = HSQ_INVALID_TAG;
 
 	hsq->slot = devm_kcalloc(mmc_dev(mmc), hsq->num_slots,
 				 sizeof(struct hsq_slot), GFP_KERNEL);
@@ -351,6 +338,9 @@ int mmc_hsq_init(struct mmc_hsq *hsq, struct mmc_host *mmc)
 	hsq->mmc->cqe_private = hsq;
 	mmc->cqe_ops = &mmc_hsq_ops;
 
+	for (i = 0; i < HSQ_NUM_SLOTS; i++)
+		hsq->tag_slot[i] = HSQ_INVALID_TAG;
+
 	INIT_WORK(&hsq->retry_work, mmc_hsq_retry_handler);
 	spin_lock_init(&hsq->lock);
 	init_waitqueue_head(&hsq->wait_queue);
diff --git a/drivers/mmc/host/mmc_hsq.h b/drivers/mmc/host/mmc_hsq.h
index ffdd9cd172c34..1808024fc6c5d 100644
--- a/drivers/mmc/host/mmc_hsq.h
+++ b/drivers/mmc/host/mmc_hsq.h
@@ -2,6 +2,9 @@
 #ifndef LINUX_MMC_HSQ_H
 #define LINUX_MMC_HSQ_H
 
+#define HSQ_NUM_SLOTS	64
+#define HSQ_INVALID_TAG	HSQ_NUM_SLOTS
+
 struct hsq_slot {
 	struct mmc_request *mrq;
 };
@@ -17,6 +20,8 @@ struct mmc_hsq {
 	int next_tag;
 	int num_slots;
 	int qcnt;
+	int tail_tag;
+	int tag_slot[HSQ_NUM_SLOTS];
 
 	bool enabled;
 	bool waiting_for_idle;
-- 
2.53.0



