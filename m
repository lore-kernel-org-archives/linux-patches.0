Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037011;
	b=Z57fStncAY4Ku91Kusb1RBTlna0SU7ekh7Xnr91HZ4Nq2id0jmo1b5cWX6Bd5YP6JRiQ
	 ryNYa+b65x9htH4VLu6s3075TSpJrkyF27kEuSVidXB2OM9cy++2nDDMGcoULbljjO0rT
	 oh6zG2QkA44Oq17rN1HggY3HsvoBYvBKUj1ZD5jkEWKG0QeADmSAv7GxYgnxEAwTY6pvi
	 3jJlxQug+pCVU8jlw65AmpZe7QkZnmNSpS91py0NOJHT9Jpf5d0XyrmD0T1QtBLpttDek
	 kmDf5DULi5ONC0w8eaSgKLAZeEYAzSC+oU0wcVzFzmGxUkH9J15bt9pKQvonBKCMbfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K4RzZ6hQrWmOCnZpTr1YqtN4lfHyeelWQ3xIj6Ar4nw=;
	b=Syc3q4mJYidprU1lPxdHFPOFhfijA1QOly9NFY247O9mUQqtxHfFyVxY1hyMibxvc/GK
	 adupzuGbxJX81icJ1YU5g6XAbR5xByUO6J2crndHiX8RhHLCr33KAljGutmFJeCebh2ax
	 zmozp4rZHIyB5zhaX9ajTEGHYPVf6OVg1N2eAWj2/Q1OP4Hs3p9+xFXmWgtdjPZ6wgcyG
	 aX/jSVQU79bTVaN6Fbt8pJhEfKaJ6apt+s9nUCEPAhYKMoJ/ZnzKcedRskXDZ9TrQblM3
	 o2p3H47HvMueozb6C9X2UHA7EPUy7efzuzP0RDjFja0aFD87RHHequL3m5UvvgcaBSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gt9qIRNe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92205606A338;
	Wed, 18 Nov 2026 21:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gt9qIRNe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81421F000C6;
	Wed, 18 Nov 2026 21:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037011;
	bh=K4RzZ6hQrWmOCnZpTr1YqtN4lfHyeelWQ3xIj6Ar4nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gt9qIRNehuW53PFv9DrSh729JMFaYGSr3YdkV1zqiaXdRWvn2dMA/jtvfVAjSprCJ
	 QVsXFwkXU2JaxQEizvg5pWaEDRCe0TqqdndUyrsFl4hSNJ/sZt1/pqY1Kn39fWKWGJ
	 DNVqOlegBj3eG/yo763mn3fvBsil2sIPAkQE2zrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1245/3318] ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch
Date: Wed, 18 Nov 2026 15:31:07 +0100
Message-ID: <20261118150357.540050589@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit f3c7bee984aa0ba2b48a44e16a6f3ec2c27f851e ]

The response sent by the firmware when requesting a clock vote (opcode
AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST) does not actually have
the same opcode + status payload as APR_BASIC_RSP_RESULT. Rather, it
returns one single u32 which is the client_handle that must be used in
future unvote requests for the same clock.

As a result of this type confusion, the status returned by the callback
to q6afe_vote_lpass_core_hw was actually an out-of-bounds read. It was
only interpreted as success (0) most of the time due to luck, but there
are some reports of random errors such as:

[   20.961100] qcom-q6afe aprsvc:service:4:4: AFE failed to vote (3)
[   20.961131] Failed to prepare clk 'core': -110

Fix by correctly interpreting the response as a single u32, and actually
store it as the client_handle to ensure unvote would work correctly.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/5976946.DvuYhMxLoT@antlia/
Fixes: 55e07531d922 ("ASoC: q6dsp: q6afe: add lpass hw voting support")
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Signed-off-by: Val Packett <val@packett.cool>
Link: https://patch.msgid.link/20261016063536.598610-1-val@packett.cool
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6afe.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6afe.c b/sound/soc/qcom/qdsp6/q6afe.c
index fcef53b97ff98..1cdc36475a838 100644
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -369,6 +369,7 @@ struct q6afe {
 	struct q6core_svc_api_info ainfo;
 	struct mutex lock;
 	struct aprv2_ibasic_rsp_result_t result;
+	uint32_t vote_result;
 	wait_queue_head_t wait;
 	struct list_head port_list;
 	spinlock_t port_list_lock;
@@ -873,13 +874,14 @@ static int q6afe_callback(struct apr_device *adev, struct apr_resp_pkt *data)
 	struct aprv2_ibasic_rsp_result_t *res;
 	struct apr_hdr *hdr = &data->hdr;
 	struct q6afe_port *port;
+	uint32_t *vote_res;
 
 	if (!data->payload_size)
 		return 0;
 
-	res = data->payload;
 	switch (hdr->opcode) {
 	case APR_BASIC_RSP_RESULT: {
+		res = data->payload;
 		if (res->status) {
 			dev_err(afe->dev, "cmd = 0x%x returned error = 0x%x\n",
 				res->opcode, res->status);
@@ -906,8 +908,10 @@ static int q6afe_callback(struct apr_device *adev, struct apr_resp_pkt *data)
 	}
 		break;
 	case AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST:
+		vote_res = data->payload;
 		afe->result.opcode = hdr->opcode;
-		afe->result.status = res->status;
+		afe->result.status = 0;
+		afe->vote_result = *vote_res;
 		wake_up(&afe->wait);
 		break;
 	default:
@@ -1721,6 +1725,8 @@ int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 			       AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST);
 	if (ret)
 		dev_err(afe->dev, "AFE failed to vote (%d)\n", hw_block_id);
+	else
+		*client_handle = afe->vote_result;
 
 
 	kfree(pkt);
-- 
2.53.0



