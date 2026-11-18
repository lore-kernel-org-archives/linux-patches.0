Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026163;
	b=i35yzqP5sqmUz0qZmZe8/oZ/EDMoOdqWN9ncZq+dWnt+z2XiDxaVwLDB0PGGmVf14PUW
	 6RF7/iQgAkqD8vg6yvSYxHvalca1wKICI9uOE9lzJkhpj5FKRsyo/hqedTMTRm/E+pcYA
	 8vEKIdIp++gohXUiBcNWF6dntsl3oWaWW2GcVpuZcJwMaYWuL23fHv7OjoqDuinrJqV0K
	 zoDXv4GSXiqI0aLLOxea6wwBlzBvimNDdsHcIgzpZLRzY5V4uwfS1HDW5ZwuRFB5aTVRG
	 hXDRYoO+9j+rZcR2nDsG0CAKN3f0YPp90GsT1Sc+eyU7qS5ZBoXebuWTYQ5CeK5Rekg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yqoJbXmTwXNRIXmGuZR+qxtFbsDCg9s1WBxfR+QAI2c=;
	b=O5Dq/+V5GAYIogZgj9gZYO1S15DcnQdfMHXrhRcOuvsQbMG3R4y23kFORrL5HRP/6gBr
	 DgJn9+WCviZNzoDNa00poDTgpPGd3Edlek01Kfs8DybRaiZ1T/QSvdxCDSCt+srN8dUVU
	 GoE+uJICFo7mN2ZUJVc+GvzmY4dZDOWJLuy0ELHRg6givxhp8/cj2vPjcyZp326OMZiZw
	 BmWxuP0SAE7gKoDbl0+C4p8NZluJ7fUUPABxz5btu68PwSM7LEKRxs1D1EWcs31EEbJNj
	 lIT+eU64LRDERdcdbq2lOIQ4UDUuWTQyRWcrbvyOkVAlh2b8LHCMi8taL5Av2cpxR2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDOoQuE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D7560A2600;
	Wed, 18 Nov 2026 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDOoQuE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BCD1F000C5;
	Wed, 18 Nov 2026 18:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026163;
	bh=yqoJbXmTwXNRIXmGuZR+qxtFbsDCg9s1WBxfR+QAI2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDOoQuE7H4/ZRdyDNkS8gfjHqB/nGzazaCu86c4r6bZ2NWgMSvVd42hL6oDqwr8+P
	 E2HBKHC+3IjYveU3InScafvfKHduKz1nmkT/QTIDLH/DMMqTxL+IwKiNn5WAtihdMD
	 MdL9tYVPj5Z6ZHIkR/bRPk1ytakx7BL8H7tet/L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1286/2151] ASoC: fsl_asrc_m2m: Fix bogus compress task pointer assignments
Date: Wed, 18 Nov 2026 15:50:21 +0100
Message-ID: <20261118150208.981803040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 360e688f6d24ccd3e9485f57ad451ec1cecfb94c ]

When a creation of input or output compress-offload task fails in
fsl-asrc driver, the task->input or task->output pointer is left with
ERR_PTR(), which is non-NULL.  Then it's handled in the compress
offload core and it tries to release via dma_buf_put(), resulting in
an access to a wrong address.

Clear the bogus pointers properly before returning an error.

Fixes: 24a01710f627 ("ASoC: fsl_asrc_m2m: Add memory to memory function")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-9-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_m2m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_asrc_m2m.c b/sound/soc/fsl/fsl_asrc_m2m.c
index 88cbfb4cae3ad..a94ecb40f9e02 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -469,6 +469,7 @@ static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,
 	task->input = dma_buf_export(&exp_info_in);
 	if (IS_ERR(task->input)) {
 		ret = PTR_ERR(task->input);
+		task->input = NULL;
 		return ret;
 	}
 
@@ -479,6 +480,7 @@ static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,
 	task->output = dma_buf_export(&exp_info_out);
 	if (IS_ERR(task->output)) {
 		ret = PTR_ERR(task->output);
+		task->output = NULL;
 		return ret;
 	}
 
-- 
2.53.0



