Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09F836728D;
	Sat, 12 Sep 2026 10:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207713; cv=none; b=k2BizDuFcs4cZnDPRKs0MuOXCjFIJbPyIANVc8OFJrGHth0FW2kdAMsK8UjvuQ2zv7jVquQkFirg3H7J60ri+ERSElsi6KMOWEp8x4BpK9M9Eg2sZF44pdOLZ+u85RE2cSD6o8GX+gZ8SCYwvRMjvl1/OVCXdwSIhwFw5z1M9BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207713; c=relaxed/simple;
	bh=80S69A2GoOAgydmKuaIma/fgvQK4Fs0hKzSduhY8tPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSSfXO/Q3s4huCPCsTgE8bgBHz53pO/vwD4t5QwOmj5mZ/44/IxhkznbdHXFrrXTpomwcCNIJvlFt3szvZt0LylvuFm9BFRFLM1eiJUB6TKW2bmdHQKZFz7XmdjTv8MJZPS4IETP0PG4NgI5XaL3nQGoS/qw0/GIgemJ2G57NRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oc3e7gfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oc3e7gfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2251F000FF;
	Sat, 12 Sep 2026 10:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207712;
	bh=1HJyHvPp6RIIDycDE2vPAhegZfUI57O3q4wHwXH5b/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oc3e7gfJLxOjuy5zjGwNsQNmS7dOknEUrOSXXlkMcgiefyNyZfHJ70QnFR0Q10pk3
	 MjvEoUnK1cnRolA35c8rJ5BOjG283tIRtJY2lK5PnUghS9WIcm/Uec0NMzwm9zKRVU
	 AmdOVPK8BNB2SN4CErHmORPXAcA2dEYSwBp0l+cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranam V G Tejaswi <puranam.tejaswi@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0470/1518] drm/msm/a6xx: Fix RBBM_CLOCK_CNTL3_TP0 value in a730_hwcg
Date: Sat, 12 Sep 2026 08:43:59 +0200
Message-ID: <20260912065634.081555154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 31974a4d7e14b..b43850966a5f6 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1167,7 +1167,7 @@ static const struct adreno_reglist a730_hwcg[] = {
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



