Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC6A1757E;
	Sat,  3 Feb 2024 04:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933947; cv=none; b=fnzzsnKM/sUQteomIpC7IqGyx30lUGi5vqVZYQfvKX91fPPXclDHWKrfKcNnAwHbq53QROYtpFCXrzav4E5UJSfPPTYG++Dmu65KnR1dEiIevDRfKCzl46Sa7qtDjAnCq+Ea1pDX+dPzSpYQpDf96eXlkNOxAd0VscHq7FQYzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933947; c=relaxed/simple;
	bh=RaASrHI6Z0rn3VK6p21sh16uBvdYceb7F1XG2vuKEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hcr4MHxuvVALqLwaHJzKTqEAG0/0eP9qlG1LJw1gijVc76Q3yQoS7XTWXot4K6RVX5DF7yHRh3JkHa5VjP7ehzrz+yx1eYuLTvl44OJuMnmCHjSFnnX4FRc4ejRXBXapOmUleMmgM248DTYqVdj40AhoMeolhPCXCbkBRbUm7fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3B45xGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3B45xGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4519FC43390;
	Sat,  3 Feb 2024 04:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933947;
	bh=RaASrHI6Z0rn3VK6p21sh16uBvdYceb7F1XG2vuKEag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3B45xGH5TiWgmzRXb5G/OOmD3WqlQBpTgKDdfj4rTaeFOk3zz94w5rzwALOkmOi6
	 34UOxCi5d5rzK2G+NmniCoJJ2m0bbMAOUBDzfFzvozIACXSF9ErxLn1e9N7crsZGhw
	 VeU1xdId1oBS1hX/12Cx9vt1x+PMj089mEmRyV20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Rob Clark <robdclark@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 290/353] drm/msm/dpu: Correct UBWC settings for sc8280xp
Date: Fri,  2 Feb 2024 20:06:48 -0800
Message-ID: <20240203035412.965660051@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 0b414c731432917c83353c446e60ee838c9a9cfd ]

The UBWC settings need to match between the display and GPU.  When we
updated the GPU settings, we forgot to make the corresponding update on
the display side.

Reported-by: Steev Klimaszewski <steev@kali.org>
Fixes: 07e6de738aa6 ("drm/msm/a690: Fix reg values for a690")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/569817/
Link: https://lore.kernel.org/r/20231130192119.32538-1-robdclark@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_mdss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_mdss.c b/drivers/gpu/drm/msm/msm_mdss.c
index 6865db1e3ce8..29bb38f0bb2c 100644
--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -545,7 +545,7 @@ static const struct msm_mdss_data sc8280xp_data = {
 	.ubwc_dec_version = UBWC_4_0,
 	.ubwc_swizzle = 6,
 	.ubwc_static = 1,
-	.highest_bank_bit = 2,
+	.highest_bank_bit = 3,
 	.macrotile_mode = 1,
 };
 
-- 
2.43.0



