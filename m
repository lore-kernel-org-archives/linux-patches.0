Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065426;
	b=SyS579ouhLI6zHMoOwnFgYp3NaS4BLjqOr3/DojJDqghSUoNZ3Ik3QwddfGvf7L4ZwLK
	 8HVNXDNCDfLLziCOqPtNvaug8jjQCQpvLn7IeDS1gs3yn0Qu2zE08YHJMNc16tjJWKhco
	 6wgIP3BsJMcO6OcwaH2MSDCqbW58ojcX8LmNl8xIkqm1oI5tWUxJZqOssY1Xt7m+c++X1
	 6HFVSNxG8yTgher/e9t5dmtxeF3VrN1dGWiy9/lfwugBgACwrci8/IvXLYOi9W3Uyp34w
	 ntld3qSO5/sJL69m+poUMyPeYQr7fGf5yB/+8trkn54hqZqbr2SJpaRzEKSF8vrvYEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oi3JZvxpOIvTX/45AXvnt+lHdrQoPRKsKbdfhBsTp9k=;
	b=wh+JjOlpLFBdXoPqioWQIuNyMBsUVJViVMWDAolcQpiR4FXDRpehBfts0iWDN1oce6AP
	 ugAWO3ghdG0L2eEnUu6Ouo9zR+BxJ4Fwu7QnRRvsnftOMyCsQOBbUDQU3mQ5tEELe9OCj
	 hyMjwhqHqJz4tP+EOg0P6/ROJ6SWiQGNV8yKW1pqJnvhx3q+hFnbAtWYtgWHiQW0XWOB7
	 S+BZeBo7dvQ604zD8ehOy/EqKA/V9pE1yVgmLiBQMXPPRweMYW2wV0GbSk40J80gosaTt
	 xFqeSeD2QA7hvj0imHxA26oS1qgtF6nRBcjUxk3Oqb93vwQMalm1X/nszODr6zyJ1ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9LAt1N+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E5606A33D;
	Sat,  7 Nov 2026 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9LAt1N+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5801F0089F;
	Sat,  7 Nov 2026 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065426;
	bh=oi3JZvxpOIvTX/45AXvnt+lHdrQoPRKsKbdfhBsTp9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9LAt1N+PFus8Ekj2psAIsr67gmNObWZXCp7EbRrpyhIH2KmSoZb5dbq2tQ4WQdPX
	 EIounib9aEL9kNwhuggi5FYpC5K37QM6pBjhgOIBi7Al85JsGogNz1fbwHDXKheIB+
	 JRAT3mgAe7wnUdTaoD7eYPVjxsurNaY8cBboGVBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1138/1257] ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch
Date: Sat,  7 Nov 2026 08:57:14 -0500
Message-ID: <20261107135010.660347538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f0ff1350e9dde..9ac51c304ead0 100644
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -393,6 +393,7 @@ struct q6afe {
 	struct q6core_svc_api_info ainfo;
 	struct mutex lock;
 	struct aprv2_ibasic_rsp_result_t result;
+	uint32_t vote_result;
 	wait_queue_head_t wait;
 	struct list_head port_list;
 	spinlock_t port_list_lock;
@@ -1010,13 +1011,14 @@ static int q6afe_callback(struct apr_device *adev, const struct apr_resp_pkt *da
 	const struct aprv2_ibasic_rsp_result_t *res;
 	const struct apr_hdr *hdr = &data->hdr;
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
@@ -1043,8 +1045,10 @@ static int q6afe_callback(struct apr_device *adev, const struct apr_resp_pkt *da
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
@@ -1955,6 +1959,8 @@ int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 			       AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST);
 	if (ret)
 		dev_err(afe->dev, "AFE failed to vote (%d)\n", hw_block_id);
+	else
+		*client_handle = afe->vote_result;
 
 	return ret;
 }
-- 
2.53.0



