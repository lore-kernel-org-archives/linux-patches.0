Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019313;
	b=5C0erwJN4/zxfzMVqKgmem31zsskGoB9SLb9OayLJylK1ZGODkhlCezbBCk85/2b4KCi
	 DhlNWVJEQ58eGFihJ/U5L6jUIZP2uOi1QqcSVpKMJEiwXYBIWNngCo57PKzClSzHz8xPN
	 AbR7BvOejyYwZulaER0+SSvAkYbQG3/XpcEA3iJu/oxZvATVGnwrd0WoUZ8LZ5PQzAUmM
	 Mn9uNxSylPO8yC6SlB+qWeMSg//q/jLhNyd3eplBM1eA13/G/qn3nHzMTHvw2A2SIl4GO
	 nAivY0Dj/fsEmMByQf6x/Wdgg3YeZwIuvNEGA5JpNb/gEQZESEGEvZ48N77W0HhTSHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aWpg+p0xFvFxlCrMPj0+flrs+LSwD2q6obBbEQtWEdU=;
	b=4vs6S1lwE8SotK4pI3OjF8mGMCqZ5+lw6oqxxe8+vvyEAPEJ4Fs2mSBNuvOcN9Rni5i9
	 TotXZLQeRKc3oAse1+2c407bIu1Tqs2Nw6/CPHW5IOos25KKWj5dfnDX7ry4rJK/8c2uT
	 CSdMGO1pR9xoHPhulsYTNPAkpsQKh+TuqemiCuJ8HqTE2WBBy0CGE36voy5i9NhTVsw5z
	 l9Yy5KF2ksMpoa6nasxdGUssC93Zz57xk5t/R0qG0bC9D/pj1xWLvFBNMKDt4VGmRSU7t
	 blufjcuBkaN4SB+bJaF+NdL0teNKaJEd1nQMtXgplvrI9d9jm/F932y04nmz/FVKxKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jwpx3aZ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563F4606A31C;
	Wed, 18 Nov 2026 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jwpx3aZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1B51F000C4;
	Wed, 18 Nov 2026 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019312;
	bh=aWpg+p0xFvFxlCrMPj0+flrs+LSwD2q6obBbEQtWEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jwpx3aZ9BrCiYHH+Ty0n1oY1B0XyCiIPCMUw9qFcq25fiGBhNhQW/nK/G+UuC6GaS
	 yJJqqSNtQeabv6GqgYeZfNIRD0QE2IhUpSur4NNt689NF+elAWav/UoYO9Z98iBNIb
	 QZ4nJE8gkTK4L6xpIkuoyITxetAOAosZxayLaljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1551/2651] ASoC: fsl_asrc_m2m: Fix bogus compress task pointer assignments
Date: Wed, 18 Nov 2026 15:46:31 +0100
Message-ID: <20261118150343.796209661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 8bd2a144dbf91..a90a1c8ed34d4 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -475,6 +475,7 @@ static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,
 	task->input = dma_buf_export(&exp_info_in);
 	if (IS_ERR(task->input)) {
 		ret = PTR_ERR(task->input);
+		task->input = NULL;
 		return ret;
 	}
 
@@ -485,6 +486,7 @@ static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,
 	task->output = dma_buf_export(&exp_info_out);
 	if (IS_ERR(task->output)) {
 		ret = PTR_ERR(task->output);
+		task->output = NULL;
 		return ret;
 	}
 
-- 
2.53.0



