Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058717;
	b=VpvoNqtBrhdhjKxdeqCejJJTMeLFcdWulD6Wp+kv+rL4SYXId2RnZMMFV5Y2ftZiE1bs
	 9UEuQNCmqUFmccGIOw8e2oAEEvnuAXJqCQWV6HOxZ1PJ0jQFvbYczsxAJCwmdumX1KMxI
	 0emRv63e+DUfkTGRvIFWkWorL0aje2HCoEl5e7Yh/OF+EVzIfGOqW/cIVNc+KVpO5CPOL
	 CVZIDb7eAetDibOQUhwZ2GLUi5M1jtXCiR1aX95Lqk0QBai+UXnS7Q1BLgbo0o74hmtkq
	 6mKRb3cHHhjp2tNedSc8VwGjWNoFFHftFFUNBrSTU7NIJ35R6ZckLuFwYFwXaWywf7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R5FPIZt9eDQqMr1Ik5Ya0qmk37EL41SF7d/nK4Vbppg=;
	b=mkYUyQlRtLuuLFexFv+H0LVgQIHzrMdjmY3DqNeKHmlnZ0J9RoEsxemjJ+pKobErk6im
	 ehNspUAxnK5WZwTG+vzRDyGfk4IoF1d0OXg2X6giL+gdhumWUz+2XSsv14VoJ00b77R/r
	 LlY4QqQ41RaT6Zawb5g6wMLKbi/ieLhXRlisaQui5z+fCTx8L2NTQORGdmuwFQ5m6M4Po
	 dTGbDXKsG3qFUzeHt4z14JmKavcZy849Y+5MsMR2fmQVwDiKXhOlCREKSji5ztyEqgOOb
	 A81gjIJ66hiVbNULDRgPWJmZWL6S6ZqwNRqFPml6EQ0EL+EWRlgRQYfQGVBj2ITUsWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsl3TMgn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1CF606A320;
	Thu, 19 Nov 2026 03:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsl3TMgn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D05E1F000C4;
	Thu, 19 Nov 2026 03:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058717;
	bh=R5FPIZt9eDQqMr1Ik5Ya0qmk37EL41SF7d/nK4Vbppg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsl3TMgnrJiV7ghE2+mtBiiON5kKQ4MqoA6hb9U9c5Jyz/nnbYNHVuHmtf6C8eyBP
	 QuGIlxSAxhXQ9tJy3C3J/wQo+NfSoENQZTphy+nE4teSsLVW4S8IbG7BBq+gnx2Whs
	 FYJPQlNwfVIAp32ja6pydh0ZL0ckeS94Y6xwS1HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0586/1848] ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch
Date: Wed, 18 Nov 2026 15:43:44 +0100
Message-ID: <20261118145939.969120158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7be495336446b..f27a2ebb3d3f4 100644
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -367,6 +367,7 @@ struct q6afe {
 	struct q6core_svc_api_info ainfo;
 	struct mutex lock;
 	struct aprv2_ibasic_rsp_result_t result;
+	uint32_t vote_result;
 	wait_queue_head_t wait;
 	struct list_head port_list;
 	spinlock_t port_list_lock;
@@ -867,13 +868,14 @@ static int q6afe_callback(struct apr_device *adev, struct apr_resp_pkt *data)
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
@@ -900,8 +902,10 @@ static int q6afe_callback(struct apr_device *adev, struct apr_resp_pkt *data)
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
@@ -1714,6 +1718,8 @@ int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 			       AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST);
 	if (ret)
 		dev_err(afe->dev, "AFE failed to vote (%d)\n", hw_block_id);
+	else
+		*client_handle = afe->vote_result;
 
 
 	kfree(pkt);
-- 
2.53.0



