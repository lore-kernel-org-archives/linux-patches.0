Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214822;
	b=AVIyK5xme1JzPDW1Rrj3GvLvdHuPc46p5jCrkCfVqlSxmY4X2xoUGRocNQnPQJQu8nZB
	 hC0e6z4LoAZ1u0o6YMZWGIIYYG71wudCtTq/Q1yQ9BhyqsyJdJbmu5jw+GPObUgje+eyk
	 J61hPVYOInozDsWmYkR2xSeNpvWadxumU7VsJjZ6zrl8rhT4Z7OTylaMfYmcd6b46soVW
	 gNE5NDH3QnMaQtImnMKxfKirxYOx/MHO4TmrN8iTIk+MJ8QAxm0PBZvOebkzH4N5DHrfo
	 g5/ZSvNQtGCX2DLfjHA3WM0Na54v6iq7dZr+K25D2mCpcU4i/ALV6kJrLsVPg4sJmng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qs1qAXeXmidxhg79VoKPrQDnp6l/Px65vtU/ACjkHxY=;
	b=XRE/mCruZ5jXPbfhZWpsYNka45tlkUjeqF1LBsUPIMLlWlYomIOSi79tH3Ai9Uc4b6CO
	 ysLl8kyVD4SvqlS1bZ7mxwl+iVZLFZtjL9BvX2g/ENAUS9eV5CU+znUgzwNAeya9AqYL7
	 MfaPB6gujrXGi05Q2eOVltr39l8CI2ZXCqoDLfu4MAINH9nOeoKkMFwj3L3Heko4t/raY
	 3TLPAI2KFs1ZKvG2T3OFCJQlv1bV8C81B9GpNz2nVG02bQbLJK5fGWgOUfaCrKoCygBDj
	 UfrvwzzRy4Xc5CGhm6JB/0dAWNNZeSouPXijqPyQGrabNZFA1qhLV5mIX9fHUun4c1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvlVq2ON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D247F606A33B;
	Wed, 28 Oct 2026 19:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvlVq2ON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7EE1F01825;
	Wed, 28 Oct 2026 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214821;
	bh=qs1qAXeXmidxhg79VoKPrQDnp6l/Px65vtU/ACjkHxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvlVq2ON6UjkAq/Ln+3fMpfWhQhmkD3u7753rpxh7WNApxPAnjU1z9KP2THOfxX4b
	 Z1mbCO7I6SnAJxurShdjONcvx2JHjYW0rAxyvjnmSiN32jg+Iatrz7JUcqM4eqKQHi
	 KDxxCxx5B+KmMiKMmIg/ZzALnMnNZXhyjow8Tppw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Facchin <m.facchin@arduino.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.1 0992/1887] ASoC: qcom: q6asm: handle the responses after closing
Date: Wed, 28 Oct 2026 17:51:28 +0100
Message-ID: <20261028170521.986960751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit a354f030dbce17ab3cf299660a38b162d97f7151 ]

For record path, multiple read requests are queued to dsp in advance.
However when data stream is closed, the pending read requests are rejected
by the dsp and a response is sent to the driver, this case is not handled
in the driver resulting in errors like below

q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: command[0x10dac] not expecting rsp
q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: command[0x10dac] not expecting rsp
q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: command[0x10dac] not expecting rsp

This is same for both write and eos.

Fix this by allowing ASM_DATA_CMD_READ_V2, ASM_DATA_CMD_EOS and
ASM_DATA_CMD_WRITE_V2 as expected response.

Reported-by: Martino Facchin <m.facchin@arduino.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5, RB3
Link: https://patch.msgid.link/20251023102444.88158-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8a066a81ee0c ("ASoC: qcom: q6asm: drop DSP responses for closed data streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index 9f53cffe5184e..85abf2ce091fe 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -637,6 +637,7 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			client_event = ASM_CLIENT_EVENT_CMD_OUT_FLUSH_DONE;
 			break;
 		case ASM_STREAM_CMD_OPEN_WRITE_V3:
+		case ASM_DATA_CMD_WRITE_V2:
 		case ASM_STREAM_CMD_OPEN_READ_V3:
 		case ASM_STREAM_CMD_OPEN_READWRITE_V2:
 		case ASM_STREAM_CMD_SET_ENCDEC_PARAM:
@@ -653,6 +654,10 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 				goto done;
 			}
 			break;
+		case ASM_DATA_CMD_EOS:
+		case ASM_DATA_CMD_READ_V2:
+			/* response as result of close stream */
+			break;
 		default:
 			dev_err(ac->dev, "command[0x%x] not expecting rsp\n",
 				result->opcode);
-- 
2.53.0



