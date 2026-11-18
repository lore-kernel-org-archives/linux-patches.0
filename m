Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017513;
	b=d5hExfOJQRWtK5ISd6LaoaUgqHEe4hZs9oLLOhemoXiA4jGHVouaVeG+YRbO1AK/Y4PQ
	 JDVcVkFg719WPUF8L9tIzfgjtMZV9CCd/6PAVtzfdpOkl0vSEWKeyoXf8ut4zbdshoj0g
	 PUAWDMrBBt6HvdZbYJKxbepNbftxxJz9pDUm5aZoWaepIpT7+1ZMDxeCRcmpev9OmO5EE
	 d5na6tjceg3SH3LI3sU7BryxkbVsJBolR2W2jMLkIGsB2XMaIu7MiaBglhzxPgpcdL6cd
	 N6ODpIYQ6cusz9uTMpxJ+TnxC6D/23G4hv1zzjzTaTijcruXZeWS0o5bE06x7LtKRCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NyCt2UXKSzbedsaLdKoNsNeImkCtIsMrPcUt7us5LxA=;
	b=j9yBJ3yhS1X5FE4KEHJ754/BSvY5xX9zsLNNZaiyH0zg75xCPOSeJonRpivgXoDtkg0E
	 kg6Z8tII/I4YnxGW6XfqswKqNCBq3FZbW2fGL62u2tVJ9MN3Y+RxUgATc78izfSk79DW5
	 pJ4qOZ+3eUNU2+U2Tpq5nzX3Q/tXtBvBNZldp/ymGggAPHlqa5BZPTfYe2aqg1s8hpUoe
	 eG3A8f9GP3e70S+tFC1qALC31TclqrN+X9x4/GiWbt+oblQa3c2+U8p5i+YhZLNeA9WLE
	 QwQBoFaUEzzK7wbPFdiwa4fFK/8zgP9LEda7J7Fln/89Tkeb5wrTBann2MkdpJ+QLlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNzeyU3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7D6606A31C;
	Wed, 18 Nov 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNzeyU3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CD41F000C5;
	Wed, 18 Nov 2026 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017513;
	bh=NyCt2UXKSzbedsaLdKoNsNeImkCtIsMrPcUt7us5LxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNzeyU3kfiVbbLdzZ4YoSFcxmTg8kj1cRMzlMWHsIyXMz6r8icQzlruZcd6yqsibf
	 GdYXWc3mFO31qyJ0MsmrF94fwcATS74vdr7Hn6vui2jE0IFArfuJh1oSV/dn5VbxVV
	 Pbne1C5OdbhEDT/yNlkUG9fDr35iA3raGT4J/ywg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0909/2651] drm/msm/a6xx: Fix RPMH dependency votes
Date: Wed, 18 Nov 2026 15:35:49 +0100
Message-ID: <20261118150320.608746967@linuxfoundation.org>
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

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit eab0aff8965ee17cf972a37eb6456032c45b7acd ]

a6xx_gmu_rpmh_dep_votes_init() iterates the GPU frequency list
(gmu->gpu_freqs) but was passed gmu->dev to resolve each frequency to an
arc level. This results in generation of incorrect dependency votes
table. To fix this, pass gpu->pdev->dev, which owns the GPU OPP table.

Also, reorder the dependency vote init to improve clarity.

Fixes: 06cfbca0e1c6 ("drm/msm/a6xx: Share dependency vote table with GMU")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/755593/
Message-ID: <20260923-hawi-gpu-v1-3-0c3c79a1a470@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index d072646093a13..161b360bf3ebb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1868,13 +1868,13 @@ static int a6xx_gmu_rpmh_votes_init(struct a6xx_gmu *gmu)
 	ret = a6xx_gmu_rpmh_arc_votes_init(&gpu->pdev->dev, gmu->gx_arc_votes,
 		gmu->gpu_freqs, gmu->nr_gpu_freqs, "gfx.lvl", sec_id);
 
+	ret |= a6xx_gmu_rpmh_dep_votes_init(&gpu->pdev->dev, gmu->dep_arc_votes,
+		gmu->gpu_freqs, gmu->nr_gpu_freqs);
+
 	/* Build the CX votes */
 	ret |= a6xx_gmu_rpmh_arc_votes_init(gmu->dev, gmu->cx_arc_votes,
 		gmu->gmu_freqs, gmu->nr_gmu_freqs, "cx.lvl", "mx.lvl");
 
-	ret |= a6xx_gmu_rpmh_dep_votes_init(gmu->dev, gmu->dep_arc_votes,
-		gmu->gpu_freqs, gmu->nr_gpu_freqs);
-
 	/* Build the interconnect votes */
 	if (info->bcms && gmu->nr_gpu_bws > 1)
 		ret |= a6xx_gmu_rpmh_bw_votes_init(adreno_gpu, info, gmu);
-- 
2.53.0



