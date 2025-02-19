Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C781DEFE6;
	Wed, 19 Feb 2025 09:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955952; cv=none; b=feMfxvk07BmnaSi3BNyoa57vl6rMnT8n6+AjA+JKl4JqVbdHw25lZEHsza+cyPjsSIztktlPaXKTC5Y51TzX0YsJTD/Y22BDzy/sREG2sfsoTk+wOL4TNE08ypIaB0h526lzAJymtCzfOKSSopIOqNYBDUc7YPoKRFi31VxHrlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955952; c=relaxed/simple;
	bh=SsR5L1vdhG9eiMx1uiR62r8e0/zqwPl0y99FT/8VAC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvqS6drsOR9CZP/MDRfBJhksI+Lw295XvnxSgakgO5yPu30Tm6Qgheumh1quH3bDxjwCvM6ZuzXUcTESbUTugpF4Mxmn/eZSXc2osvBv2y3D0o4d/yCVB+cjMpqe992JFQ5SW9U9EQz8DWDpvJRWmkbsNnV4bZvwUKk+H3zuKck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RvxIFDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RvxIFDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A195CC4CEE7;
	Wed, 19 Feb 2025 09:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955952;
	bh=SsR5L1vdhG9eiMx1uiR62r8e0/zqwPl0y99FT/8VAC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RvxIFDs6xlFZRemgeNlF0zIUiJ4keKIgzPw0FZrCWyJQhgay0SvbST55epPTHKh1
	 WR3/KY94o0wvuFt/d6RIvWNvin/54ixFfHxiYaCpoG4B4wO7GWAmisrYyv8A7G2CFe
	 1Fn9xGhMxJ63e57aIe28FYPFvhvHsAhveKIwh8Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/578] drm/msm/dp: set safe_to_exit_level before printing it
Date: Wed, 19 Feb 2025 09:20:19 +0100
Message-ID: <20250219082653.490917031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7dee35d79bb046bfd425aa9e58a82414f67c1cec ]

Rather than printing random garbage from stack and pretending that it is
the default safe_to_exit_level, set the variable beforehand.

Fixes: d13e36d7d222 ("drm/msm/dp: add audio support for Display Port on MSM")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411081748.0PPL9MIj-lkp@intel.com/
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/626804/
Link: https://lore.kernel.org/r/20241202-fd-dp-audio-fixup-v2-1-d9187ea96dad@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_audio.c b/drivers/gpu/drm/msm/dp/dp_audio.c
index 1245c7aa49df8..a2113d6a022b5 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.c
+++ b/drivers/gpu/drm/msm/dp/dp_audio.c
@@ -410,10 +410,10 @@ static void dp_audio_safe_to_exit_level(struct dp_audio_private *audio)
 		safe_to_exit_level = 5;
 		break;
 	default:
+		safe_to_exit_level = 14;
 		drm_dbg_dp(audio->drm_dev,
 				"setting the default safe_to_exit_level = %u\n",
 				safe_to_exit_level);
-		safe_to_exit_level = 14;
 		break;
 	}
 
-- 
2.39.5



