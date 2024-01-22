Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D274912AAC4;
	Tue, 23 Jan 2024 00:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971059; cv=none; b=nMt6dk35pu4HD9jtb/g7iq3xlyUZ2Gq6ErocvZxB169YO5KkeRXds0FheWygiPLb6a3prgqcGlTatkYhSfC4OX6Ck3p+Bw0icPY7F5k4Rn3BqhmXNB2Bwhfbi1HIfCz4LGCFx0orSb/Z7zOqUO8eKrZDvu1MoK3xbtb7RM5Bhdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971059; c=relaxed/simple;
	bh=nEsA1Q5BFTcmb0znObJ9QPiVGMC82vqn5EOZID2NHec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu8xiouAMgvh878z3yGcd6/mHT4ckAi+AhAeDG4NpST3KDmljHBCrqJMPpAtOgJlvhuLUTbI1d679WHRg+jzaPkle1QbjuJhfqhRE9sQOyxvWYYvsMAnUTzD0kQ/DxCVlVCvAgiyKs6gVqjUeoI7vLGAYZPf0WveaSUToiyRmYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4JfAWfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4JfAWfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F259C433F1;
	Tue, 23 Jan 2024 00:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971059;
	bh=nEsA1Q5BFTcmb0znObJ9QPiVGMC82vqn5EOZID2NHec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4JfAWfw0qYd4IKmMaVmL5Vi11HdP4JBKebGRq6pZwux3hOS5+HZ4QVWz2QHf/WZ1
	 cGktI+myFL7eERT2Hlh95PsUsNg7oVCXnXY78q14vcTUyRA0OFGh/MwuPoH4+ibi7x
	 FiDJ8mV70ahF9zpxXe9UmQzkiDDjUHqoL7IMxCq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/286] virtio-crypto: change code style
Date: Mon, 22 Jan 2024 15:56:26 -0800
Message-ID: <20240122235735.121062889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit 6fd763d155860eb7ea3a93c8b3bf926940ffa3fb ]

Use temporary variable to make code easy to read and maintain.
	/* Pad cipher's parameters */
        vcrypto->ctrl.u.sym_create_session.op_type =
                cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
        vcrypto->ctrl.u.sym_create_session.u.cipher.para.algo =
                vcrypto->ctrl.header.algo;
        vcrypto->ctrl.u.sym_create_session.u.cipher.para.keylen =
                cpu_to_le32(keylen);
        vcrypto->ctrl.u.sym_create_session.u.cipher.para.op =
                cpu_to_le32(op);
-->
	sym_create_session = &ctrl->u.sym_create_session;
	sym_create_session->op_type = cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
	sym_create_session->u.cipher.para.algo = ctrl->header.algo;
	sym_create_session->u.cipher.para.keylen = cpu_to_le32(keylen);
	sym_create_session->u.cipher.para.op = cpu_to_le32(op);

The new style shows more obviously:
- the variable we want to operate.
- an assignment statement in a single line.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Message-Id: <20220506131627.180784-2-pizhenwei@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../virtio/virtio_crypto_akcipher_algs.c      | 40 ++++++-----
 drivers/crypto/virtio/virtio_crypto_algs.c    | 72 +++++++++----------
 2 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index f3ec9420215e..20901a263fc8 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -106,23 +106,27 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	unsigned int inlen;
 	int err;
 	unsigned int num_out = 0, num_in = 0;
+	struct virtio_crypto_op_ctrl_req *ctrl;
+	struct virtio_crypto_session_input *input;
 
 	pkey = kmemdup(key, keylen, GFP_ATOMIC);
 	if (!pkey)
 		return -ENOMEM;
 
 	spin_lock(&vcrypto->ctrl_lock);
-	memcpy(&vcrypto->ctrl.header, header, sizeof(vcrypto->ctrl.header));
-	memcpy(&vcrypto->ctrl.u, para, sizeof(vcrypto->ctrl.u));
-	vcrypto->input.status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
+	ctrl = &vcrypto->ctrl;
+	memcpy(&ctrl->header, header, sizeof(ctrl->header));
+	memcpy(&ctrl->u, para, sizeof(ctrl->u));
+	input = &vcrypto->input;
+	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 
-	sg_init_one(&outhdr_sg, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
+	sg_init_one(&outhdr_sg, ctrl, sizeof(*ctrl));
 	sgs[num_out++] = &outhdr_sg;
 
 	sg_init_one(&key_sg, pkey, keylen);
 	sgs[num_out++] = &key_sg;
 
-	sg_init_one(&inhdr_sg, &vcrypto->input, sizeof(vcrypto->input));
+	sg_init_one(&inhdr_sg, input, sizeof(*input));
 	sgs[num_out + num_in++] = &inhdr_sg;
 
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
@@ -134,12 +138,12 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
 
-	if (le32_to_cpu(vcrypto->input.status) != VIRTIO_CRYPTO_OK) {
+	if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	ctx->session_id = le64_to_cpu(vcrypto->input.session_id);
+	ctx->session_id = le64_to_cpu(input->session_id);
 	ctx->session_valid = true;
 	err = 0;
 
@@ -149,7 +153,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 
 	if (err < 0)
 		pr_err("virtio_crypto: Create session failed status: %u\n",
-			le32_to_cpu(vcrypto->input.status));
+			le32_to_cpu(input->status));
 
 	return err;
 }
@@ -161,23 +165,27 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	unsigned int num_out = 0, num_in = 0, inlen;
 	int err;
+	struct virtio_crypto_op_ctrl_req *ctrl;
+	struct virtio_crypto_inhdr *ctrl_status;
 
 	spin_lock(&vcrypto->ctrl_lock);
 	if (!ctx->session_valid) {
 		err = 0;
 		goto out;
 	}
-	vcrypto->ctrl_status.status = VIRTIO_CRYPTO_ERR;
-	vcrypto->ctrl.header.opcode = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION);
-	vcrypto->ctrl.header.queue_id = 0;
+	ctrl_status = &vcrypto->ctrl_status;
+	ctrl_status->status = VIRTIO_CRYPTO_ERR;
+	ctrl = &vcrypto->ctrl;
+	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION);
+	ctrl->header.queue_id = 0;
 
-	destroy_session = &vcrypto->ctrl.u.destroy_session;
+	destroy_session = &ctrl->u.destroy_session;
 	destroy_session->session_id = cpu_to_le64(ctx->session_id);
 
-	sg_init_one(&outhdr_sg, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
+	sg_init_one(&outhdr_sg, ctrl, sizeof(*ctrl));
 	sgs[num_out++] = &outhdr_sg;
 
-	sg_init_one(&inhdr_sg, &vcrypto->ctrl_status.status, sizeof(vcrypto->ctrl_status.status));
+	sg_init_one(&inhdr_sg, &ctrl_status->status, sizeof(ctrl_status->status));
 	sgs[num_out + num_in++] = &inhdr_sg;
 
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out, num_in, vcrypto, GFP_ATOMIC);
@@ -189,7 +197,7 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
 
-	if (vcrypto->ctrl_status.status != VIRTIO_CRYPTO_OK) {
+	if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -201,7 +209,7 @@ static int virtio_crypto_alg_akcipher_close_session(struct virtio_crypto_akciphe
 	spin_unlock(&vcrypto->ctrl_lock);
 	if (err < 0) {
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
-			vcrypto->ctrl_status.status, destroy_session->session_id);
+			ctrl_status->status, destroy_session->session_id);
 	}
 
 	return err;
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 583c0b535d13..12e2001235a6 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -123,6 +123,9 @@ static int virtio_crypto_alg_skcipher_init_session(
 	int op = encrypt ? VIRTIO_CRYPTO_OP_ENCRYPT : VIRTIO_CRYPTO_OP_DECRYPT;
 	int err;
 	unsigned int num_out = 0, num_in = 0;
+	struct virtio_crypto_op_ctrl_req *ctrl;
+	struct virtio_crypto_session_input *input;
+	struct virtio_crypto_sym_create_session_req *sym_create_session;
 
 	/*
 	 * Avoid to do DMA from the stack, switch to using
@@ -135,24 +138,22 @@ static int virtio_crypto_alg_skcipher_init_session(
 
 	spin_lock(&vcrypto->ctrl_lock);
 	/* Pad ctrl header */
-	vcrypto->ctrl.header.opcode =
-		cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
-	vcrypto->ctrl.header.algo = cpu_to_le32(alg);
+	ctrl = &vcrypto->ctrl;
+	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_CREATE_SESSION);
+	ctrl->header.algo = cpu_to_le32(alg);
 	/* Set the default dataqueue id to 0 */
-	vcrypto->ctrl.header.queue_id = 0;
+	ctrl->header.queue_id = 0;
 
-	vcrypto->input.status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
+	input = &vcrypto->input;
+	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 	/* Pad cipher's parameters */
-	vcrypto->ctrl.u.sym_create_session.op_type =
-		cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
-	vcrypto->ctrl.u.sym_create_session.u.cipher.para.algo =
-		vcrypto->ctrl.header.algo;
-	vcrypto->ctrl.u.sym_create_session.u.cipher.para.keylen =
-		cpu_to_le32(keylen);
-	vcrypto->ctrl.u.sym_create_session.u.cipher.para.op =
-		cpu_to_le32(op);
-
-	sg_init_one(&outhdr, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
+	sym_create_session = &ctrl->u.sym_create_session;
+	sym_create_session->op_type = cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
+	sym_create_session->u.cipher.para.algo = ctrl->header.algo;
+	sym_create_session->u.cipher.para.keylen = cpu_to_le32(keylen);
+	sym_create_session->u.cipher.para.op = cpu_to_le32(op);
+
+	sg_init_one(&outhdr, ctrl, sizeof(*ctrl));
 	sgs[num_out++] = &outhdr;
 
 	/* Set key */
@@ -160,7 +161,7 @@ static int virtio_crypto_alg_skcipher_init_session(
 	sgs[num_out++] = &key_sg;
 
 	/* Return status and session id back */
-	sg_init_one(&inhdr, &vcrypto->input, sizeof(vcrypto->input));
+	sg_init_one(&inhdr, input, sizeof(*input));
 	sgs[num_out + num_in++] = &inhdr;
 
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
@@ -180,20 +181,18 @@ static int virtio_crypto_alg_skcipher_init_session(
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
 
-	if (le32_to_cpu(vcrypto->input.status) != VIRTIO_CRYPTO_OK) {
+	if (le32_to_cpu(input->status) != VIRTIO_CRYPTO_OK) {
 		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Create session failed status: %u\n",
-			le32_to_cpu(vcrypto->input.status));
+			le32_to_cpu(input->status));
 		kfree_sensitive(cipher_key);
 		return -EINVAL;
 	}
 
 	if (encrypt)
-		ctx->enc_sess_info.session_id =
-			le64_to_cpu(vcrypto->input.session_id);
+		ctx->enc_sess_info.session_id = le64_to_cpu(input->session_id);
 	else
-		ctx->dec_sess_info.session_id =
-			le64_to_cpu(vcrypto->input.session_id);
+		ctx->dec_sess_info.session_id = le64_to_cpu(input->session_id);
 
 	spin_unlock(&vcrypto->ctrl_lock);
 
@@ -211,30 +210,30 @@ static int virtio_crypto_alg_skcipher_close_session(
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	int err;
 	unsigned int num_out = 0, num_in = 0;
+	struct virtio_crypto_op_ctrl_req *ctrl;
+	struct virtio_crypto_inhdr *ctrl_status;
 
 	spin_lock(&vcrypto->ctrl_lock);
-	vcrypto->ctrl_status.status = VIRTIO_CRYPTO_ERR;
+	ctrl_status = &vcrypto->ctrl_status;
+	ctrl_status->status = VIRTIO_CRYPTO_ERR;
 	/* Pad ctrl header */
-	vcrypto->ctrl.header.opcode =
-		cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION);
+	ctrl = &vcrypto->ctrl;
+	ctrl->header.opcode = cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION);
 	/* Set the default virtqueue id to 0 */
-	vcrypto->ctrl.header.queue_id = 0;
+	ctrl->header.queue_id = 0;
 
-	destroy_session = &vcrypto->ctrl.u.destroy_session;
+	destroy_session = &ctrl->u.destroy_session;
 
 	if (encrypt)
-		destroy_session->session_id =
-			cpu_to_le64(ctx->enc_sess_info.session_id);
+		destroy_session->session_id = cpu_to_le64(ctx->enc_sess_info.session_id);
 	else
-		destroy_session->session_id =
-			cpu_to_le64(ctx->dec_sess_info.session_id);
+		destroy_session->session_id = cpu_to_le64(ctx->dec_sess_info.session_id);
 
-	sg_init_one(&outhdr, &vcrypto->ctrl, sizeof(vcrypto->ctrl));
+	sg_init_one(&outhdr, ctrl, sizeof(*ctrl));
 	sgs[num_out++] = &outhdr;
 
 	/* Return status and session id back */
-	sg_init_one(&status_sg, &vcrypto->ctrl_status.status,
-		sizeof(vcrypto->ctrl_status.status));
+	sg_init_one(&status_sg, &ctrl_status->status, sizeof(ctrl_status->status));
 	sgs[num_out + num_in++] = &status_sg;
 
 	err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, num_out,
@@ -249,11 +248,10 @@ static int virtio_crypto_alg_skcipher_close_session(
 	       !virtqueue_is_broken(vcrypto->ctrl_vq))
 		cpu_relax();
 
-	if (vcrypto->ctrl_status.status != VIRTIO_CRYPTO_OK) {
+	if (ctrl_status->status != VIRTIO_CRYPTO_OK) {
 		spin_unlock(&vcrypto->ctrl_lock);
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
-			vcrypto->ctrl_status.status,
-			destroy_session->session_id);
+			ctrl_status->status, destroy_session->session_id);
 
 		return -EINVAL;
 	}
-- 
2.43.0



