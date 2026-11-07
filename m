Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063679;
	b=BGMy4zUPj+qMsgHVbxqQ8GOua+Pk/olAiU6vNEcfHJHnvShkGQ/XCpEPWQplYrUOItFT
	 AoNQbKjwvC3FF5aliPtkS1PelRRDiV4aH/haSNMzlRpq6XNB3hCNrW7fKSa01EvYgH8CY
	 5DgVu+e+6JiayqJOpsLs2jyRn6j3U7WFrh//fKurV3kdxvoNfLUzJ9u2IWwNnc17v6tLw
	 qY626KwtD2BTZCnjcjOE3GSPds9qCdcWPqex2F28zo06cN6dlTBkQaIRVZayFmq7AzgnB
	 k5U4ww+9Wamhyc7EVuuFDCtrF9Hy7t1BpTLWK+stI15UWDMGxWkvp59AyM2YhiPQitg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aDcpwiELvT+q/JHwoFJq+Lq/zjuAZM1I02LgpE00xo=;
	b=SIxWXjM4iXTz0blENI0L4rLgYA2stPMqUnGAAvMm2IZrAplhND/OLNCUZTEng8FCiwIt
	 5yJWYAglWQ/2nsVmQCKLUZu4rIUexww3T2hd+20LekOevghXXAy6z97jEDJo6HwJ9FnOa
	 pgM8pldu9++LfbTfGcUAB57kjSvHRlBvNK3GFezPu1O3HZbcvmtg34mXbj9sAzqJDSnMe
	 ufBR886aGMeHZmQ6ZM5Kuf6puWwHI3Wy2cxP5O6rO7XKUXtPI9ZzVs0CWRUyDh8y5sKVx
	 v7ZpSsKQbjXwgjIZHEv7OXaN553sKeedTgPvXWSnLs2qB+Dsqm9xMl7e2+E01AhvR6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vF3XV5vg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE8606B881;
	Sat,  7 Nov 2026 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vF3XV5vg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D74A1F0089F;
	Sat,  7 Nov 2026 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063678;
	bh=+aDcpwiELvT+q/JHwoFJq+Lq/zjuAZM1I02LgpE00xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vF3XV5vg+/8fcZ4LaFVcpZab7vcuVQRFPJkzhgCcywOo6ao+wNBDLZe9xMQrMuGSB
	 BE/ltwbGSOQ0YtcYkl1hOAJ43GvOyCVzjtIOJWJ+z+G1EMgGR2SxBdCCAQGA3x4f2m
	 2FwZNbxn6Ba1A9XqCDH7r9vx4x+fK8ca0GJaeIyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 788/869] ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch
Date: Sat,  7 Nov 2026 08:57:50 -0500
Message-ID: <20261107134919.447126671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 7b59d514b432a..d2cb0ccd34562 100644
--- a/sound/soc/qcom/qdsp6/q6afe.c
+++ b/sound/soc/qcom/qdsp6/q6afe.c
@@ -377,6 +377,7 @@ struct q6afe {
 	struct q6core_svc_api_info ainfo;
 	struct mutex lock;
 	struct aprv2_ibasic_rsp_result_t result;
+	uint32_t vote_result;
 	wait_queue_head_t wait;
 	struct list_head port_list;
 	spinlock_t port_list_lock;
@@ -966,13 +967,14 @@ static int q6afe_callback(struct apr_device *adev, struct apr_resp_pkt *data)
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
@@ -999,8 +1001,10 @@ static int q6afe_callback(struct apr_device *adev, struct apr_resp_pkt *data)
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
@@ -1910,6 +1914,8 @@ int q6afe_vote_lpass_core_hw(struct device *dev, uint32_t hw_block_id,
 			       AFE_CMD_RSP_REMOTE_LPASS_CORE_HW_VOTE_REQUEST);
 	if (ret)
 		dev_err(afe->dev, "AFE failed to vote (%d)\n", hw_block_id);
+	else
+		*client_handle = afe->vote_result;
 
 
 	kfree(pkt);
-- 
2.53.0



