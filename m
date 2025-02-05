Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F321519AA;
	Wed,  5 Feb 2025 14:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764063; cv=none; b=ANqSnjomEmhmgXajwl5I1D1/2EZ70mTiTN0O+Gvv7LAsLspJWZYyKlNxFfEQuNgg3tf/wySLNM/xQ1tr3hoPE7XVXphtGHYK33CyWeZrAshYRTNPR1jrCfp9fCEq+6/2xf5WWLi8Kr2YYcJV7UCga/eO98Z/nZpqqY3EgGDy/CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764063; c=relaxed/simple;
	bh=7dR5BKXEmLKSL4IIlWrkea/mhv9LAbiWzIO0ejMCK3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNWz1m31cK8SO1cbEyd6qfgj18VUMKuPlQouxGTDfzsEiVgJnY10F2hDDvZGCBya+zpLAbuBC7Lcn1ilYDe3TEC1c5nfm4txmhROt8GibhCPGGLfWv+UY/8qVrQeQNg8R9KBCfQUppvgdpkkNp8wfLQqlfv2CSw7JKWur1mfoCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1L8EiWVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1L8EiWVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E5C4CED1;
	Wed,  5 Feb 2025 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764063;
	bh=7dR5BKXEmLKSL4IIlWrkea/mhv9LAbiWzIO0ejMCK3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1L8EiWViAnx6ndB+bVCOj2peQ72qBhIEC+eDmuIxpNohPleLPmPiuSnrVPY9hixiP
	 eZ+d4GL8PvVQl5TZeCQd1zqdSN7BBxRh6ZRfFSF+pdyGykJ4CCnKb90dZh36JitN1d
	 Kb8QUDL7IYIktfTfI1dUBhJ0fwS+OJyLk9+awVtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Nie <rex.nie@jaguarmicro.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 044/623] drm/msm/hdmi: simplify code in pll_get_integloop_gain
Date: Wed,  5 Feb 2025 14:36:26 +0100
Message-ID: <20250205134457.915252266@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Nie <rex.nie@jaguarmicro.com>

[ Upstream commit c1beb6f75d5e60e4e57a837c665a52eb79eb19ba ]

In pll_get_integloop_gain(), digclk_divsel=1 or 2, base=63 or 196ULL,
so the base may be 63, 126, 196, 392. The condition base <= 2046
always true.

Fixes: caedbf17c48d ("drm/msm: add msm8998 hdmi phy/pll support")
Signed-off-by: Rex Nie <rex.nie@jaguarmicro.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/624153/
Link: https://lore.kernel.org/r/20241112074101.2206-1-rex.nie@jaguarmicro.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c
index a719fd33d9d8d..33bb48ae58a2d 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c
@@ -137,7 +137,7 @@ static inline u32 pll_get_integloop_gain(u64 frac_start, u64 bclk, u32 ref_clk,
 
 	base <<= (digclk_divsel == 2 ? 1 : 0);
 
-	return (base <= 2046 ? base : 2046);
+	return base;
 }
 
 static inline u32 pll_get_pll_cmp(u64 fdata, unsigned long ref_clk)
-- 
2.39.5



