Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045826;
	b=2m6/FcauyTr1PIspY0exm0XjvQfp/SOwT7DSBdlVBEoMdvjDK/N7d4pLd5DKH6C5FgK+
	 lZ05lJhl60n7Pbv5Xv5rfAXDuh+xw2R5IKM0odHINn16rYFHmRICMcFODE/EjkVJu3FEr
	 GRuNOQ95hOPbFun9un0pTxNpDULQEf3EDU1VnT5UFgQgZbcPYuyNBy+jhpMim9uhdftwi
	 MY1uh/dORulRyuXDXuouTFxCLKTVZigeoiEDUA2l8KRE5q2M19K6+jIgE9Pa/KEaw9Vkt
	 KBEDnkqLlplVnOiFBwIGTwf3yKFZ8m5a55MpDRWVNTizCIiKODVn71ZfT5h3KP3OLxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kqZ/v0USqF2UV2XsTFzlLZrXl5jUzxucT2CaD22BlVM=;
	b=n9amfm7vnLnz3rKIFxzLO0MkSljVb1H+jaBdgQC/14I59tAhQdx/XPchXOPfYa/pyygJ
	 EYrJYAnjpC/Pg/J/3Z0d5QcrIl8lW6/7e66C0Z7LTicv9+1DLo2OlIKOxJC6+FAA1XfHn
	 8VGZthTh0nDGXThMaE6FFWAUAn4q5J8Ruur599Fdlahnvf9JaIEU5ptfQLGF5O+ggxoNy
	 V57unQeaRCCGhHjqJdZtxwrVELaSlBs+jP9RTxyolhXSf9H7ghkBfaxy5j8Ik5xv0G7Aw
	 AkeYmEYWB2+G4FmLUn55yQTU6R0eKpP45fVrpG60FvSAcaAAZylu+qYnLgZNEZ896Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QKQ/DOwo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18D8606A320;
	Wed, 18 Nov 2026 23:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKQ/DOwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4FB1F000C5;
	Wed, 18 Nov 2026 23:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045826;
	bh=kqZ/v0USqF2UV2XsTFzlLZrXl5jUzxucT2CaD22BlVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKQ/DOwoIckgo78Y0S4Zkq0Ozml3F6n3vqpBKm2lI3gNv4Sbn/spedv3EH1WDTJW4
	 iNEtOASIxv1Mkv15sg/qwT4z5yj79F6/3Y6yEarnNdzhXTXOgwdV419nDujfJu6FYJ
	 k6ZC0ZLFGlUnvtGJsHUt1Lpc4WS+rtscJ4+3O1f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1061/2857] ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch
Date: Wed, 18 Nov 2026 15:34:55 +0100
Message-ID: <20261118150239.795766842@linuxfoundation.org>
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
index 919e326b9462b..5a77ce28cc07b 100644
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



