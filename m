Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709636A02E;
	Wed, 20 May 2026 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300489; cv=none; b=anURCcVERM8wBWosQTthdFd7HsSnjL04o4OVA7Y7vFWLLf/R7NQrXINu480KbM+8Mrsxvz1zDTTemUL3o5r3W/dCGcQtoz3Npo7S8GygHH/Ug+Xa558dmX8YugPTCYtALUbOM9Etc7+pJgyBOySAELYw6W3vCD/EuGH17wZ9InM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300489; c=relaxed/simple;
	bh=1oL98J7Ts+bls1wCKx3UX5rhIPc5N0MPcCR+3o1hDZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SObDstuEIwDTjM6W1WikwUncurVQnZ23HMGiY2cIVQS8aPVusHC/EgqqZY7+rqBvYd53CsrSd4qtX0eHV4JVj7VeIQfgpxPct6SdcIOcsSaJqIzb/LbHCzjJVCjFXBPGi+AvGdoYAL/cCH5INcFf3Qb5LPUkpZome0iQeld2UsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrYPgCGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrYPgCGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092241F000E9;
	Wed, 20 May 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300488;
	bh=PG54tiLZlXIfpPtCoNGIVfcZUpxSLXrq60KaJlIiRdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrYPgCGRHWfoFFiz3XAJLQ5zrpotwGnS8O5NrrPRu34WfS6Jhh7fP8n43RhwPqm3X
	 FlhjTCKklGnte3QCu8wWLbabY68kE8H/i0u34EvlhjrXBbWZWGO5oU671DLnnZzmz+
	 ovdQSoo9inEdzn436UGvw8RsbuOD1F2SGMQhFRLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/666] drm/msm/a6xx: Fix dumping A650+ debugbus blocks
Date: Wed, 20 May 2026 18:16:44 +0200
Message-ID: <20260520162115.384116131@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit cc83f71c9be0715fe93b963ffa9767d5d84354ed ]

These should be appended after the existing debugbus blocks, instead of
replacing them.

Fixes: 1e05bba5e2b8 ("drm/msm/a6xx: Update a6xx gpu coredump")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/714270/
Message-ID: <20260325-drm-msm-a650-debugbus-v1-1-dfbf358890a7@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 8f104f7fcaa29..dac88af9b3d09 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -346,7 +346,7 @@ static void a6xx_get_debugbus_blocks(struct msm_gpu *gpu,
 			sizeof(*a6xx_state->debugbus));
 
 	if (a6xx_state->debugbus) {
-		int i;
+		int i, j;
 
 		for (i = 0; i < ARRAY_SIZE(a6xx_debugbus_blocks); i++)
 			a6xx_get_debugbus_block(gpu,
@@ -354,8 +354,6 @@ static void a6xx_get_debugbus_blocks(struct msm_gpu *gpu,
 				&a6xx_debugbus_blocks[i],
 				&a6xx_state->debugbus[i]);
 
-		a6xx_state->nr_debugbus = ARRAY_SIZE(a6xx_debugbus_blocks);
-
 		/*
 		 * GBIF has same debugbus as of other GPU blocks, fall back to
 		 * default path if GPU uses GBIF, also GBIF uses exactly same
@@ -366,17 +364,19 @@ static void a6xx_get_debugbus_blocks(struct msm_gpu *gpu,
 				&a6xx_gbif_debugbus_block,
 				&a6xx_state->debugbus[i]);
 
-			a6xx_state->nr_debugbus += 1;
+			i++;
 		}
 
 
 		if (adreno_is_a650_family(to_adreno_gpu(gpu))) {
-			for (i = 0; i < ARRAY_SIZE(a650_debugbus_blocks); i++)
+			for (j = 0; j < ARRAY_SIZE(a650_debugbus_blocks); i++, j++)
 				a6xx_get_debugbus_block(gpu,
 					a6xx_state,
-					&a650_debugbus_blocks[i],
+					&a650_debugbus_blocks[j],
 					&a6xx_state->debugbus[i]);
 		}
+
+		a6xx_state->nr_debugbus = i;
 	}
 }
 
-- 
2.53.0



