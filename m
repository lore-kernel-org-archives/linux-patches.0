Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035669;
	b=SrLMxgulyWJ1P5lMXt3BSE8VxBgmrlZbtmCagQO0KbI2yaNY+blr4J+jck3/KYsdJ90a
	 QMrqosAWkKR+PSltDKJk3XXrPqB0yJdpo7oX84jecF6x3tPX40WRFOWApiGMW0K5eBQEt
	 jJu+HtpzP82pHG60QVjfvC3J24K9IL0CFzdscnQC80Tv6wcFQbt5CuhOLiyNNQiGsKXpU
	 mwciMHkV78y11wUreJYZs70YRfil5I+cw2On1Jye7dugZ+I3EDYhpnxf9cxw65mpBG70A
	 9Vx972DLTX0L8scNKiCodbhArs1TwfxEH0wAPgsBy2pXtZhgq3VoY95yu71BQN3vxhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5o23ZIVM//Zls9aI0yf2EqKWoeSbr0eaNHSZGxIQtWo=;
	b=ZXxT42F5LaN0C09Cy9gW0SW6mXJb2cp6ST34sY/MPHGr24YqLorlvcPQiZbkO4NP31RQ
	 L6c/6DuNNOPS81w7P4/wiju3tCJN217Myegp4NSYhWEo82Z0brsWsjzg/rCRHflKHEX0/
	 aVWnsY1WeofainDPxf23c2OlAymnHkC4N9EU0C8+S0UBQv5e1/svvrC7tDSn7ZYfbiipW
	 HHy3qqHMTV9/Y3svi0HqZLAidZ+SNoKOnLi6PMefyiZkiKA9hTltlpD2Yg09gMDaD+SjE
	 CBacnj347QIcotUMpb/Vp4RJ+pb0AX+G9AqBY3xe+lB8yZccLVGQvHTaqsQJ2BRCmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohSogulL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D33606A325;
	Wed, 18 Nov 2026 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohSogulL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C891F000C4;
	Wed, 18 Nov 2026 21:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035668;
	bh=5o23ZIVM//Zls9aI0yf2EqKWoeSbr0eaNHSZGxIQtWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohSogulLrwrRQJtrZnKR2PJWy6/wGsz4ZtIoli3UpqbSPsPnqOXCG+l1jcsXrx4wD
	 ZNYwfh0/Xaj1ZsgwTcEt1vQUjULJ1Zy1/VVvtFWwq0VHo6RaPTEkXZgH5qnZNOycdf
	 YwBJX+rusSdAoox03UB7NxoMGtMXDGlH3TtPip0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0783/3318] nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF
Date: Wed, 18 Nov 2026 15:23:25 +0100
Message-ID: <20261118150342.324576860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 53f6efe00cea0c0cf7bd99debe3cdac8567170b5 ]

A REPLY AUTH_SEND command can derive a dhchap_skey key while a
concurrent AUTH_RECEIVE command observing this REPLY state executes
the failure path and frees that key. The REPLY command then continues
and writes into freed memory, causing a use-after-free. KASAN reports
it as:

  BUG: KASAN: slab-use-after-free in __sha256_final
  Write of size 4 at addr ffff88800359c540
  ...
  nvmet_auth_sq_free (drivers/nvme/target/auth.c:237)
  nvmet_execute_auth_receive (drivers/nvme/target/fabrics-cmd-auth.c:621)

Add a mutex to each submission queue to serialize authentication
commands and timeout handling. Unlock the mutex before completing
requests and ignore outdated timeout callbacks. Limit timeout delays
to prevent immediate expiry on 32-bit kernels.

Fixes: 7a277c37d352 ("nvmet-auth: Diffie-Hellman key exchange support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c             |  1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 32 ++++++++++++++++++++++----
 drivers/nvme/target/nvmet.h            |  2 ++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index b3a0e19464539..59762bbb98da3 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -218,6 +218,7 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl)
 
 void nvmet_auth_sq_free(struct nvmet_sq *sq)
 {
+	sq->auth_expiry_active = false;
 	cancel_delayed_work(&sq->auth_expired_work);
 	kfree(sq->dhchap_c1);
 	sq->dhchap_c1 = NULL;
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 8d97ced8b1d19..c1d4e068ff721 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -6,6 +6,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/blkdev.h>
+#include <linux/jiffies.h>
 #include <linux/random.h>
 #include <linux/nvme-auth.h>
 #include <crypto/hash.h>
@@ -18,16 +19,27 @@ static void nvmet_auth_expired_work(struct work_struct *work)
 	struct nvmet_sq *sq = container_of(to_delayed_work(work),
 			struct nvmet_sq, auth_expired_work);
 
+	mutex_lock(&sq->auth_lock);
+	/* A command may have cancelled or rearmed this timeout. */
+	if (!sq->auth_expiry_active ||
+	    delayed_work_pending(&sq->auth_expired_work))
+		goto out_unlock;
+	sq->auth_expiry_active = false;
+
 	pr_debug("%s: ctrl %d qid %d transaction %u expired, resetting\n",
 		 __func__, sq->ctrl->cntlid, sq->qid, sq->dhchap_tid);
 	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 	sq->dhchap_tid = -1;
+out_unlock:
+	mutex_unlock(&sq->auth_lock);
 }
 
 void nvmet_auth_sq_init(struct nvmet_sq *sq)
 {
 	/* Initialize in-band authentication */
+	mutex_init(&sq->auth_lock);
 	INIT_DELAYED_WORK(&sq->auth_expired_work, nvmet_auth_expired_work);
+	sq->auth_expiry_active = false;
 	sq->authenticated = false;
 	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 }
@@ -211,6 +223,8 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	u16 status = 0;
 	u8 dhchap_status;
 
+	mutex_lock(&req->sq->auth_lock);
+
 	if (req->cmd->auth_send.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
@@ -236,8 +250,10 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			offsetof(struct nvmf_auth_send_command, tl);
 		goto done;
 	}
-	if (!nvmet_check_transfer_len(req, tl)) {
+	if (unlikely(tl != req->transfer_len)) {
 		pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
+		mutex_unlock(&req->sq->auth_lock);
+		nvmet_check_transfer_len(req, tl);
 		return;
 	}
 
@@ -358,10 +374,12 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			 status, req->error_loc);
 	if (req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2 &&
 	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
-		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
+		unsigned long auth_expire = min_t(u64, MAX_JIFFY_OFFSET,
+			(u64)(ctrl->kato ? ctrl->kato : 120) * HZ);
 
+		req->sq->auth_expiry_active = true;
 		mod_delayed_work(system_percpu_wq, &req->sq->auth_expired_work,
-				 auth_expire_secs * HZ);
+				 auth_expire);
 		goto complete;
 	}
 	/* Final states, clear up variables */
@@ -370,6 +388,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		nvmet_ctrl_fatal_error(ctrl);
 
 complete:
+	mutex_unlock(&req->sq->auth_lock);
 	nvmet_req_complete(req, status);
 }
 
@@ -488,6 +507,8 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 	u32 al;
 	u16 status = 0;
 
+	mutex_lock(&req->sq->auth_lock);
+
 	if (req->cmd->auth_receive.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
@@ -513,8 +534,10 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 			offsetof(struct nvmf_auth_receive_command, al);
 		goto done;
 	}
-	if (!nvmet_check_transfer_len(req, al)) {
+	if (unlikely(al != req->transfer_len)) {
 		pr_debug("%s: transfer length mismatch (%u)\n", __func__, al);
+		mutex_unlock(&req->sq->auth_lock);
+		nvmet_check_transfer_len(req, al);
 		return;
 	}
 
@@ -573,5 +596,6 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 		nvmet_auth_sq_free(req->sq);
 		nvmet_ctrl_fatal_error(ctrl);
 	}
+	mutex_unlock(&req->sq->auth_lock);
 	nvmet_req_complete(req, status);
 }
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 2189e5a5985bf..56b9bbe8c6026 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -109,8 +109,10 @@ struct nvmet_sq {
 	u32			sqhd;
 	bool			sqhd_disabled;
 #ifdef CONFIG_NVME_TARGET_AUTH
+	struct mutex		auth_lock;
 	bool			authenticated;
 	struct delayed_work	auth_expired_work;
+	bool			auth_expiry_active;
 	u16			dhchap_tid;
 	u8			dhchap_status;
 	u8			dhchap_step;
-- 
2.53.0



