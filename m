Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D013EBF2C;
	Sat, 14 Feb 2026 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031064; cv=none; b=BsYlIDEocWaD+ddbDUqDJpsJOf5TICsiOQ/Ae8xgpAmCoBh3bZHRBbqERDfxKb1gE9HdR7oIOXdsPW9w2LHPwv7+SmuKqGeOIZd03Pc65MVfAqNjKYe+T5utQw+7kP7lxSWJ6J+rIBs+nTBiGQN8oMWnB8ZL8zrUZye9jzkkrkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031064; c=relaxed/simple;
	bh=2ZNKYHG8Y4eGuc+VQdRTJSCscahI2I5IbNbnttleSbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sE5AjwJKpA02clixyJ/JUsIodKSTOyXVzbf19dYbBwpqFNJ1yFPhm8qPZKXQkWVMK5tQCYJM6Ssn+2eVEaedLBhmR4WMWPcEAuPHpGZT/L29/AAX4RuGUbe6bZMDD4cxVKLIY578EFIN9UeqLXLdc7XWo3DnJlYsl/8o/umFnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fW6gcsa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fW6gcsa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DCCC16AAE;
	Sat, 14 Feb 2026 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031063;
	bh=2ZNKYHG8Y4eGuc+VQdRTJSCscahI2I5IbNbnttleSbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW6gcsa0sobAfGE1lhTKooL0+lZTpRmwMJigjNVzqZto0HxgmXOenOcIVg1SO6YsK
	 nM0cEwZ1rcvzOaudGZjXIiE0CHhamWlZ07u5BMXrPli0dZZXO0ObZeTjQaPKHT0zBX
	 /JJ0+LvXjP8ykRQHfxTcwD7BbR9NO/I3bb2HttLhrFKf2GNLeaAy+UZGw5JlbmuPgp
	 k0k3yh1IpLHt8fYnvDEMfgtUHXhV+S643LcG4T14P0q3gldS0Ete++E2ji6UwUJYOM
	 8Mh9cx2IaDN0lh18zwonWXImDqkzkAUmQWdRm+CjfOUMba6SY/g42m/RuTm5TBbXcr
	 vuEtjiiwxTl5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A9dric=20Bellegarde?= <cedric.bellegarde@adishatz.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	srinivas.kandagatla@oss.qualcomm.com,
	krzysztof.kozlowski@oss.qualcomm.com,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19] ASoC: qcom: q6asm: drop DSP responses for closed data streams
Date: Fri, 13 Feb 2026 19:58:46 -0500
Message-ID: <20260214010245.3671907-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Now I have the full picture.

### 7. Dependency Analysis

The commit being analyzed fixes a bug introduced by `a354f030dbce1`
(October 2025). The dependency commit was a well-intentioned fix for
"not expecting rsp" errors, but it made a mistake: it used `break`
instead of `goto done`, which means the DSP responses for closed streams
were *acknowledged* (not hitting the error log) but *still fully
processed* (wake_up and callback invoked), causing lockups.

For backporting: Both `a354f030dbce1` AND this fix should go to stable
together. If `a354f030dbce1` is already in a stable tree, this fix is
critical to prevent lockups. If it's not, they should be considered as a
pair.

### Summary

| Criteria | Assessment |
|----------|-----------|
| **Bug type** | System lockup/hang |
| **Severity** | High — system becomes unresponsive |
| **Fix size** | Very small — ~4 lines changed |
| **Risk** | Very low — only affects already-closed streams |
| **Scope** | Contained to one function in one file |
| **Dependencies** | Requires `a354f030dbce1` to be present |
| **Testing** | Signed-off by maintainer (Mark Brown) |
| **User impact** | Qualcomm audio users (phones, tablets, embedded) |

This is a textbook stable backport candidate: a small, surgical fix for
a serious bug (lockup) in a single driver file, with no risk of
regression. The fix simply ensures that DSP responses for closed audio
streams are properly dropped instead of being processed, preventing the
system from hanging.

**YES**

 sound/soc/qcom/qdsp6/q6asm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index e7295b7b24610..3c4a24c9dba22 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -638,7 +638,6 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			client_event = ASM_CLIENT_EVENT_CMD_OUT_FLUSH_DONE;
 			break;
 		case ASM_STREAM_CMD_OPEN_WRITE_V3:
-		case ASM_DATA_CMD_WRITE_V2:
 		case ASM_STREAM_CMD_OPEN_READ_V3:
 		case ASM_STREAM_CMD_OPEN_READWRITE_V2:
 		case ASM_STREAM_CMD_SET_ENCDEC_PARAM:
@@ -657,8 +656,9 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
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
2.51.0

