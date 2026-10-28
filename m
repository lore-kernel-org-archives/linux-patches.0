Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214970;
	b=A0k5yTJx43hGMAQHPhumZ9hn3AvoEhonj2yMEmUHtHw6RZoFVlO+t91MO4f0LqnrmQ5f
	 6M+Omy0As+ylO+SStvnbSvLxIMoA7zi+Ct2hMWHEM8Tc6fMOwO+ni+SfX3jBV+/mdZRoO
	 gyfJZ1nsJo0bPOO9RnSwKFvpwETCzUWKqkQ9Y5A+v8xW3bptOUm6plh0uanIeeZ9Nw8Mu
	 LtwA+dFhDKBBdaxpzSJuQSA1qlB3zdki4rbT3YUA2yI/P/6nsxXZuq3r1xiFrWwoMWObr
	 n8hIIHJLVUQyvv7YGLwz+8CvWGwQtO4kuZ0pKlTfOndFJPg0cNxcENRWABOvfRP/0MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ygnHabAhUiF5cLke/ORb6aHs48wTSHdb+i5U7SiY4LE=;
	b=vIXu0wnsefGGur64hjzJhcufl0mC5/8e3kYT4+tBkbW8VojopOtFjFmJ6J7Z44fG3/hU
	 bxFhXzjmFB6HgiJvOr+/9Oy+CpgonEsJ3QI3E4MnyH3ZCs2tjjkpCEiAakhGNTgE7JlJ3
	 6wl6i7V6Wf86vonAS02/5P58ETUbizbD7yYqIxiGu33Dp5tfBZX2JzmSuDB/JRJRNvCSy
	 tuLvhZ42ie10Nax4Z7cAqy26ca6qjfZbG0Hp9wbBrPCsKgwjFPlsx7P676EY+g0XqaSPG
	 /8cQImmn0iVLfVxx1IOhlUT8DZjZ1CcecR4cbDNOl+4/CHkFTShDLyrSNrs4QyQDmBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVmyrPIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB21B606A32E;
	Wed, 28 Oct 2026 19:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVmyrPIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0A61F01829;
	Wed, 28 Oct 2026 19:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214969;
	bh=ygnHabAhUiF5cLke/ORb6aHs48wTSHdb+i5U7SiY4LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVmyrPIZW53QUmfJOs8vkp5qVeAm5YYNzPnwHJHxSY/tlH5B+UC6NMSTG4RtY87RA
	 kb+Yg6h8jqndJxqtks3lXSSNggvOEP8hv389k1TcOFt1mCnP3p5i7bX/OyogXrrgkB
	 1LIAubV7AEPBRkcivPaeFa13rLYJG83ouQsJBKWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Bellegarde?= <cedric.bellegarde@adishatz.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0993/1887] ASoC: qcom: q6asm: drop DSP responses for closed data streams
Date: Wed, 28 Oct 2026 17:51:29 +0100
Message-ID: <20261028170522.011114822@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cédric Bellegarde <cedric.bellegarde@adishatz.org>

[ Upstream commit 8a066a81ee0c1b6cdbd81393536c3b2d19ccef25 ]

'Commit a354f030dbce ("ASoC: qcom: q6asm: handle the responses
after closing")' attempted to ignore DSP responses arriving
after a stream had been closed.

However, those responses were still handled, causing lockups.

Fix this by unconditionally dropping all DSP responses associated with
closed data streams.

Signed-off-by: Cédric Bellegarde <cedric.bellegarde@adishatz.org>
Link: https://patch.msgid.link/20260102215225.609166-1-cedric.bellegarde@adishatz.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index 85abf2ce091fe..b6bdb977029da 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -637,7 +637,6 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			client_event = ASM_CLIENT_EVENT_CMD_OUT_FLUSH_DONE;
 			break;
 		case ASM_STREAM_CMD_OPEN_WRITE_V3:
-		case ASM_DATA_CMD_WRITE_V2:
 		case ASM_STREAM_CMD_OPEN_READ_V3:
 		case ASM_STREAM_CMD_OPEN_READWRITE_V2:
 		case ASM_STREAM_CMD_SET_ENCDEC_PARAM:
@@ -656,8 +655,9 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			break;
 		case ASM_DATA_CMD_EOS:
 		case ASM_DATA_CMD_READ_V2:
+		case ASM_DATA_CMD_WRITE_V2:
 			/* response as result of close stream */
-			break;
+			goto done;
 		default:
 			dev_err(ac->dev, "command[0x%x] not expecting rsp\n",
 				result->opcode);
-- 
2.53.0



