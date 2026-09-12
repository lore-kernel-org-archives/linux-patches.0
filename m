Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BF63DB31A;
	Sat, 12 Sep 2026 12:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215757; cv=none; b=c5rcl50xOcRgCmIXyRXD/CC2IJ+0gT1TT6pKCmpv/L0jD/EiZJqjyS12llmCrMUqdXTC7SwFGVW2AG5SxjRJSVHCBnvZ0NDwEKcQitO1dMy8nut/Zq/D9MIroepX5bLDvNNLitqERe6PwnZTHalkfP6NWqnZ3QrdjQ1VbSTqGqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215757; c=relaxed/simple;
	bh=M+Zd8rYNfmIn9/+ovXmB3YgTXqiWQCBRZI+9epi+pgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlB/X5oBnCzIG41qPn6v5cufQ4P95L2Sty+wBrj5NE8K4F/dO37MxnkN0o3YMqnai3aq9KjFUzDz/CzbzrXRfAkxfVPWeQvhxqIcO/tAt92eUkQ/FLJEpc+Sprm+IugvYKIIdLp1aD8KafO+VepOl6zHHb9J3+E/Cm11AqUiA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joRRXaSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joRRXaSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02E81F000FF;
	Sat, 12 Sep 2026 12:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215756;
	bh=YCNScwCUc7146vPFZCQA76Vj4MndY8EfeoOMp6mU80k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joRRXaSUZQ1ig5w403pT36MBq4Y5wXws6DnAJbA9ci64xbykNha1e3f5dwdr5/a8A
	 Qh0rtSRnBCpf3mp+y4y69vgSeMx+s420D1iSQhGzR+peA4qmGJXkwxnVvnmO9KHSyO
	 p1iWn0Sv/awOh7Sz8ENrb17yvuySxI3ejdCfL/pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranam V G Tejaswi <puranam.tejaswi@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0596/1376] drm/msm/a6xx: Fix RBBM_CLOCK_CNTL3_TP0 value in a730_hwcg
Date: Sat, 12 Sep 2026 08:50:22 +0200
Message-ID: <20260912065620.817382687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Puranam V G Tejaswi <puranam.tejaswi@oss.qualcomm.com>

[ Upstream commit 01bcc0398f43099acb407a6067481e635c3e1b84 ]

The RBBM_CLOCK_CNTL3_TP0 entry in a730_hwcg has bits[19:16] set to 2
(clock gating enabled for that TP0 stage). As per the latest
recommendation, clear this nibble to disable clock gating for this
particular stage.

Fixes: 9588d2f860a4 ("drm/msm/a6xx: Add A730 support")
Signed-off-by: Puranam V G Tejaswi <puranam.tejaswi@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/740955/
Message-ID: <20260718-eliza-gpu-v2-1-64379dbebd7a@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index a763fe5d6e2d6..8bb23012994c6 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1117,7 +1117,7 @@ static const struct adreno_reglist a730_hwcg[] = {
 	{ REG_A6XX_RBBM_CLOCK_DELAY_SP0, 0x00000080 },
 	{ REG_A6XX_RBBM_CLOCK_CNTL_TP0, 0x22222220 },
 	{ REG_A6XX_RBBM_CLOCK_CNTL2_TP0, 0x22222222 },
-	{ REG_A6XX_RBBM_CLOCK_CNTL3_TP0, 0x22222222 },
+	{ REG_A6XX_RBBM_CLOCK_CNTL3_TP0, 0x22220222 },
 	{ REG_A6XX_RBBM_CLOCK_CNTL4_TP0, 0x00222222 },
 	{ REG_A6XX_RBBM_CLOCK_HYST_TP0, 0x77777777 },
 	{ REG_A6XX_RBBM_CLOCK_HYST2_TP0, 0x77777777 },
-- 
2.53.0



