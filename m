Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2122936A376;
	Wed, 20 May 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298000; cv=none; b=MZhDO7YF05edDWLsJsVbglQZfFiMaHqX1KgjWJfrJ5GkYnw4TWd0ftLjTIla/BTj00F/vUYgv2lZgGmUMzd2tII3/DEG6v8h5U+55hYsCUJRKcD3RZ0oLmw5SHk7IBsz19nhE1GdAGKbSaO7USgX9TNTJ+wsRTYbHAkvh1ZZlms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298000; c=relaxed/simple;
	bh=356qkZ5ww+gdSCfqh7/PHauFGoyl88sky/qYSvq5xRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUPQYwaUU7FvuWh6a9H7ZQgU8L1bmynIKV6arrYDGDWyLcKxipHrL9jUB3E8uTk7YtUnhGBTb4REKNG/BkouYLuaHhpcEH2SWIB9cbFKRtKP4Uamj1o/+8UvP3/9+1WsyngMVZHAgNcMCR4J2iinfcRsIDdJxPHWHCuFvw5QISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC1AWD0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC1AWD0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8637A1F000E9;
	Wed, 20 May 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297999;
	bh=swv0K8T4OveL+N5ANKX0y7e/s+3hqFGz4TyCssPkh9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC1AWD0Cb5rNnupfrbY22Sj10yYJwlP9ssh67diDSVrud4uCyj4ilsw5CvrPALeTm
	 VvYAkeu+fsca0VS+37nix9xwoXE4aOWd9qbolFPynZ7xdva7Ei2KnU5c6DWnbIExow
	 Wu/kophmZ0/DvKCokHrRyZJtWGtREOjs2rsZAXmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/957] drm/msm/dpu: dont try using 2 LMs if only one DSC is available
Date: Wed, 20 May 2026 18:12:07 +0200
Message-ID: <20260520162139.834557728@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b9699dd862760e642807a2bc226e4d127e35dcb7 ]

Current topology code will try using 2 LMs with just one DSC, which
breaks cases like SC7280 / Fairphone5. Forbid using 2 LMs split in such
a case.

Fixes: 1ce69c265a53 ("drm/msm/dpu: move resource allocation to CRTC")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Closes: https://lore.kernel.org/r/DH1IKLU0YZYU.2SW4WYO7H3H4R@fairphone.com/
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcm6490-fairphone-fp5
Patchwork: https://patchwork.freedesktop.org/patch/712386/
Link: https://lore.kernel.org/r/20260317-fix-3d-dsc-v1-1-88b54f62f659@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 2f8156051d9b0..6f5d90b7ba7d4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1354,7 +1354,8 @@ static struct msm_display_topology dpu_crtc_get_topology(
 		topology.num_lm = 2;
 	else if (topology.num_dsc == 2)
 		topology.num_lm = 2;
-	else if (dpu_kms->catalog->caps->has_3d_merge)
+	else if (dpu_kms->catalog->caps->has_3d_merge &&
+		 topology.num_dsc == 0)
 		topology.num_lm = (mode->hdisplay > MAX_HDISPLAY_SPLIT) ? 2 : 1;
 	else
 		topology.num_lm = 1;
-- 
2.53.0



