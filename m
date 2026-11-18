Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031714;
	b=mS0phoke1TeU53JVUCceJcJwrc3Mj4ZxreYj2gud6lVl+e0+x4veA7SkZRoPUqGpEYBo
	 qItBQVsVkurygKpboOBF19m5OQ3h1q8ZqzQSB0N2yMg8t62iJrFSgca4tIACx8Za8LvQx
	 KVa5Gi5ghoRrtTqHs/d7EljHXz+0wys5NuYXk/iv62rxqL/QEylcpooZlUAqdp1ojHmxK
	 j8WfaHqWyviF79d1nQsnZWVdR83S0EwZ9pIW9GuVqMll1bHPradR9jhRKvdEN0jpKeWYs
	 DeGIUYn7k4MhkEMpliRDBFcDrY1G4kouyY+7KSyirhEGx2/y22rkYSr7AmVcyALap+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GzELDKd/QuhTlVmGGZRu8kLG16Hq4SK0FcebKqsXJRs=;
	b=hBQeliH6CeA3XXNQF0jj3ld51wWZJ5TOWQSdZpXUo6Hb6uofJj7PoBYjU+GC4BKrt794
	 fjUHM6c0Ib3iRePiTWNd85ZacZ6vMiWzftZ3grdBTnrXms5/VYEoycUVEQVWH9nYUYcdD
	 r7KeIX2EorWPExXtO0IXPCMGGL2JXaPckdVy6Oh98OcyYkALHvK+UVTvQKuXQu9dEA2qA
	 jQGBfK7mbaEpgnKfCZvtYdg5u0RBzPLU8O/iXfZqm4tDZnYYvG0DIUEKa/lWBIcDd/DeU
	 t+aEDRtUxI06ZJYyjgI+rvb/LdCQi+GkTKzJSWl3CfnDLs0InpKT4zYxXLJe8jpzb+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEMt6T64;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C2C606A31C;
	Wed, 18 Nov 2026 19:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEMt6T64
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568611F000C5;
	Wed, 18 Nov 2026 19:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031713;
	bh=GzELDKd/QuhTlVmGGZRu8kLG16Hq4SK0FcebKqsXJRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEMt6T64MiRa/60Jh0VUn1GWznqmXnsaezyycJoo/iWBAnA+jSuvZk+TcdnGOA565
	 jHLsda+7S3AFk4zvPG16noqLIZ0oYixNlqnt3XuUGTjEL4w/rlVHP6tBKPPY69l69C
	 XZ0pSkl7RVUE0FZ/h7i6bqDEFQIuVGmrelIU73OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1156/1756] ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:43 +0100
Message-ID: <20261118150056.042735823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 06654a3ef5137719be880a6cd12bd453050eafc5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp6x_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: ceb4fcc13ae5 ("ASoC: amd: add acp6x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index be81d80e81420..d5a3045c4b3c7 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -209,7 +209,7 @@ static int acp6x_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp6x_base = adata->acp6x_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp6x_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



