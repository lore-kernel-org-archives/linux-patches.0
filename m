Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1659436B05E;
	Wed, 20 May 2026 16:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295273; cv=none; b=HfxawJGi6gLwDvHQTgzCxYRBx1y2Y7LoOJyGapS5UaUNan14VbsqA26712Jy93KrDCVLWd/r2SnELOBxLffEv/XAuwJ9zxJ9/SWvzE+QH+hW+amGkVAd9WjQQxmkyUGGKeAHKLeVfbT6wc3U5utehYU2f7Xc3Dm5EcVUPb4p5sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295273; c=relaxed/simple;
	bh=7xOt70/IWiQ+qLGqDtpYyd16dLTKwwUlhxFvYGbt05g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgWFp3s9ZtN1ZsvAeWH3IjwWgvhPTxS/PfydYbweO+q7vnclpn+eEUOXB8i+oPZlHVcfo1qbVJPmocRNdsgZB2iQ1nAd1XX768Kk17zAPROAt78Yv6zKdTBy+SKy/faS4IubO2B7dOuOfONZc1I65cH27b9Sq2F4CrNbplMK+JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK8akIUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK8akIUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4B01F000E9;
	Wed, 20 May 2026 16:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295272;
	bh=7vkzVM3tlNEuVox6UFJzPl488IHyR/1V9VW0+UvOYNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rK8akIUuh/JBgRbRsDk9JtkMj9PmmAJqIdhp+IdQdA0QXGC4zOROix2lDaKkjxDtB
	 hulDDh7w7+9KvS6WdBmImnKn8uqYZfEOQGFxsX3UzOXmc5UpjdxguNR1e1WQF3x7aP
	 +Eeep6H1POgXywKm9G+tFEUvTfS5vXmQHPT/n7oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0357/1146] drm/msm/a6xx: Fix dumping A650+ debugbus blocks
Date: Wed, 20 May 2026 18:10:07 +0200
Message-ID: <20260520162156.281775320@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 72c4bb360acd5..e9a23d471f374 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -361,7 +361,7 @@ static void a6xx_get_debugbus_blocks(struct msm_gpu *gpu,
 			sizeof(*a6xx_state->debugbus));
 
 	if (a6xx_state->debugbus) {
-		int i;
+		int i, j;
 
 		for (i = 0; i < ARRAY_SIZE(a6xx_debugbus_blocks); i++)
 			a6xx_get_debugbus_block(gpu,
@@ -369,8 +369,6 @@ static void a6xx_get_debugbus_blocks(struct msm_gpu *gpu,
 				&a6xx_debugbus_blocks[i],
 				&a6xx_state->debugbus[i]);
 
-		a6xx_state->nr_debugbus = ARRAY_SIZE(a6xx_debugbus_blocks);
-
 		/*
 		 * GBIF has same debugbus as of other GPU blocks, fall back to
 		 * default path if GPU uses GBIF, also GBIF uses exactly same
@@ -381,17 +379,19 @@ static void a6xx_get_debugbus_blocks(struct msm_gpu *gpu,
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



