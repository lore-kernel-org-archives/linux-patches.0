Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621477;
	b=18Ybllz4aSj6nP2BAdgnkxyMOp/nMyF2NTtUQaW3GhMfm0Kp1G9oqRYsXTT1+x0Yb3LO
	 KNpjEiBa9LX9CP97lM4Cn+xLH3kAF6aEKUcXVuDFGkJZXYxlv3VD9KqDf01Wzi2Q9vK5a
	 BvY1b/JdR/bYSjLXVffr7ZkweZ2+Qmg6LUI+0KTmTlh2swgsFYJkXaQFtyHUCx75Vu2Ty
	 Cwdr58/3XTIymx5JYgkOBKARY0lurqI59B3g8fcHQPPEpBUSQ2o1+6m/wpiPOFTN5bCsW
	 kA1hcNQFrkjE9LTrL/ue5R0qfyge3970+XBLzu24BYNNzSA9nDMs7Kxvb54RQxvaBuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PeULXbG7vi4MSenJsjTOfmbGbYXn6F3RHyXrTfKgBBc=;
	b=qfPIj8MlPmmHTyXSfQf//+CuTP6gP15JrUT1ITqpaqd6rXU+QwUr/OYKkS8p5T0OCPnA
	 EHguvn5TPHBWk6j1EHpOt5MfYn+3QTn/m5/J8My0ElIpxzMYzanuOyv6IvEyzX1AtpGKh
	 qBUsltbjy6YXOF+XYcLm3fdZlTRhLtWfBiXIe0j628EoPAyVqK9aEgUEMQh3/rp9q4ggA
	 Ni92Rolm22bjzvuzrIT47t1qcXZDY+iJdvpnT+NIQSi9rghGZYPV0jG30EgjxJB/eZMqZ
	 5GXXlNwEkRM62O6KfjekmrCyzDpsSD9SgF/27Bwb/czjwOhFx1IyQz6/ueaKNDVazhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=faUyE7+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B06606A321;
	Wed, 25 Nov 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=faUyE7+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928211F000C4;
	Wed, 25 Nov 2026 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621477;
	bh=PeULXbG7vi4MSenJsjTOfmbGbYXn6F3RHyXrTfKgBBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faUyE7+jn36SOeKPTwbN0Pj8IMZsZKLYXBnoWDiytpf8TkfJ7wFqQd3E9e2AQMqrA
	 mLo5Pt3rpj7t1VQSO9VSpbVq/3czxs3KN/s2z+uVsrx6bRYMmQ5t3imTHz6yYtxrkd
	 r5ZZLexVdoewhmJS16KWHki8u4aaU3I+ks5l1cro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/990] nvmet-auth: Do not print DH-HMAC-CHAP secrets
Date: Wed, 25 Nov 2026 15:26:43 +0100
Message-ID: <20261125143827.618008490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit a891962ae5e48fb5476c23631df759482e62ab16 ]

>From a security standpoint we should not allow to print out the DH-HMAC-CHAP
secrets, but at the same time having them is useful for debugging
authentication failures.
So add a Kconfig option NVME_TARGET_AUTH_DEBUG to only enable debugging
if explictly requested at build time.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 41ad4af45ac9 ("nvmet-auth: keep the old keys if the new ones fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/Kconfig |  9 +++++++++
 drivers/nvme/target/auth.c  | 13 ++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index 4904097dfd490..69bde270115e2 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -117,6 +117,15 @@ config NVME_TARGET_AUTH
 
 	  If unsure, say N.
 
+config NVME_TARGET_AUTH_DEBUG
+	bool "NVMe over Fabrics In-band Authentication debug messages"
+	depends on NVME_TARGET_AUTH
+	help
+	  This enables additional debug messages including the generated
+	  DH-HMAC-CHAP secrets to help debugging authentication failures.
+
+	  If unsure, say N.
+
 config NVME_TARGET_PCI_EPF
 	tristate "NVMe PCI Endpoint Function target support"
 	depends on NVME_TARGET && PCI_ENDPOINT
diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index d36cb3c0fd11d..1cb821a18532f 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -154,7 +154,6 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 		goto out_unlock;
 
 	list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
-		pr_debug("check %s\n", nvmet_host_name(p->host));
 		if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
 			continue;
 		host = p->host;
@@ -199,11 +198,12 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 		ctrl->host_key = NULL;
 		goto out_free_hash;
 	}
+#ifdef CONFIG_NVME_TARGET_AUTH_DEBUG
 	pr_debug("%s: using hash %s key %*ph\n", __func__,
 		 ctrl->host_key->hash > 0 ?
 		 nvme_auth_hmac_name(ctrl->host_key->hash) : "none",
 		 (int)ctrl->host_key->len, ctrl->host_key->key);
-
+#endif
 	nvme_auth_free_key(ctrl->ctrl_key);
 	if (!host->dhchap_ctrl_secret) {
 		ctrl->ctrl_key = NULL;
@@ -217,11 +217,12 @@ u8 nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq, bool reset)
 		ctrl->ctrl_key = NULL;
 		goto out_free_hash;
 	}
+#ifdef CONFIG_NVME_TARGET_AUTH_DEBUG
 	pr_debug("%s: using ctrl hash %s key %*ph\n", __func__,
 		 ctrl->ctrl_key->hash > 0 ?
 		 nvme_auth_hmac_name(ctrl->ctrl_key->hash) : "none",
 		 (int)ctrl->ctrl_key->len, ctrl->ctrl_key->key);
-
+#endif
 out_free_hash:
 	if (ret) {
 		if (ctrl->host_key) {
@@ -355,7 +356,6 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 		if (ret)
 			goto out;
 	}
-
 	pr_debug("ctrl %d qid %d host response seq %u transaction %d\n",
 		 ctrl->cntlid, req->sq->qid, req->sq->dhchap_s1,
 		 req->sq->dhchap_tid);
@@ -531,8 +531,10 @@ int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
 		ret = -EINVAL;
 	} else {
 		memcpy(buf, ctrl->dh_key, buf_size);
+#ifdef CONFIG_NVME_TARGET_AUTH_DEBUG
 		pr_debug("%s: ctrl %d public key %*ph\n", __func__,
 			 ctrl->cntlid, (int)buf_size, buf);
+#endif
 	}
 
 	return ret;
@@ -555,11 +557,12 @@ int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
 					ctrl->shash_id);
 	if (ret)
 		pr_debug("failed to compute session key, err %d\n", ret);
+#ifdef CONFIG_NVME_TARGET_AUTH_DEBUG
 	else
 		pr_debug("%s: session key %*ph\n", __func__,
 			 (int)req->sq->dhchap_skey_len,
 			 req->sq->dhchap_skey);
-
+#endif
 	return ret;
 }
 
-- 
2.53.0



