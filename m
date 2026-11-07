Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065428;
	b=Y9VF1oA0WMErXD4PlPM/MQjkurDPHuhw9iRrqneAwK0QVr8gZA+7YGzMt6FsojUPh8v7
	 H13xMyhqsmILtq8/KeysVdYjeL50OebxzancmggVpUfMgshyL1dSxdmQXkI7DnVK/E5XQ
	 rQ0riv0xuLt8hxTGb/c+Ox25CER86wzXoOYt8oIDFRnOjZJwlkT1GNL+sbuj0FsWgxp8q
	 CBzLAD5gU7uOwuxh4o6ijrq+DYk6jNlZjutD8G5/MfuivjS5FHcYBxWcwQsNF47r+Tiax
	 38SU7uxyL+lhxwF66RI0r/JzuqcrZhiiDyksFi8cxjCIJGRCp+X/MTDNU8JYgqF+ZaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aot58KV/1R7rpaFWjSD0Zne0/lACh82Nsdw7xgl85a8=;
	b=yfVYdcg73NDk3eAnccKFsqH1kI1mmpbK6uOO7xFOkT9ueLmyTZ95HF7jhyOZCmLQfmPh
	 h+xmlX5m4chXHq9MUqVZVTI6v0J5T7SnqRAH/Bkw8qQ2C0dcynU7GTx+xqj4yGVa5I6hv
	 PLlGzSf9CNphe1tDV3XPi4wbjz5H8hwJK8Wa1uUPx+sSAuCQtFqVV+AiSrMShOtFSpHfW
	 KW4qx6MZ1y1YnzyE+jcyCKlq27/vN3R9oHfwk1bWZMKlMGW/Fl99Yd6EVSFHDw1ZGzZLU
	 4+2m2W0S2YKQcEHWssy/5+2TnORSWDQ6U/yUvemsRecUV01ztI/4Hu4mLww9DIAiBLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eY20Fuoq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAA1606A32C;
	Sat,  7 Nov 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eY20Fuoq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C491F0089F;
	Sat,  7 Nov 2026 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065427;
	bh=Aot58KV/1R7rpaFWjSD0Zne0/lACh82Nsdw7xgl85a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eY20FuoqF4opSB3sGgujbzpRHcrTrYyQOYiiCo9toMmLq6FsduY+vqp0LVnrifXBn
	 Hi1XCxLkMSASFMc5fh9e8bw69brcl/O0I2c7GuX1dmQ1wSAlemlJx4DdNRLZCLjLYH
	 KLu0O1spmMLVLKMd8HKI3z3O7sFbtGM8RuXWe4WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1139/1257] ASoC: qcom: q6apm: Fix unmap regions response handling
Date: Sat,  7 Nov 2026 08:57:15 -0500
Message-ID: <20261107135010.687246049@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 4b832a2af523cbf857a977414c0f07d7f90a4c9d ]

The DSP acknowledges APM_CMD_SHARED_MEM_UNMAP_REGIONS with a
GPR_BASIC_RSP_RESULT packet whose payload carries the acknowledged
opcode and the status. apm_callback() stores hdr->opcode, i.e.
GPR_BASIC_RSP_RESULT itself, as the result opcode, so
audioreach_send_cmd_sync(), which waits for 0x0100100d, never sees a
match and gives up after five seconds even though the DSP has already
processed the command:

  qcom-apm gprsvc:service:2:1: CMD timeout for [100100d] opcode

Each mapped graph costs a five second stall on unmap, and the forced
status of 0 also hides real DSP failures from the caller.

Record the opcode and status from the response payload, like the other
basic-result commands do, and only drop the cached mapping handle when
the DSP reports success.

Fixes: 8ea6e25c8536 ("ASoC: qcom: q6apm: Add support for early buffer mapping on DSP")
Cc: stable@vger.kernel.org
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20261021041044.2080369-2-shengchao.guo@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 4467652aeb044..ed55747923ea9 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -953,16 +953,15 @@ static int apm_callback(const struct gpr_resp_pkt *data, void *priv, int op)
 			wake_up(&apm->wait);
 			break;
 		case APM_CMD_SHARED_MEM_UNMAP_REGIONS:
-			apm->result.opcode = hdr->opcode;
-			apm->result.status = 0;
-			rsp = data->payload;
+			apm->result.opcode = result->opcode;
+			apm->result.status = result->status;
+			if (result->status)
+				dev_err(dev, "Error (%d) Processing 0x%08x cmd\n", result->status,
+					result->opcode);
 
 			info = idr_find(&apm->graph_info_idr, hdr->token);
-			if (info)
+			if (info && !result->status)
 				info->mem_map_handle = 0;
-			else
-				dev_err(dev, "Error (%d) Processing 0x%08x cmd\n", result->status,
-					result->opcode);
 
 			wake_up(&apm->wait);
 			break;
-- 
2.53.0



