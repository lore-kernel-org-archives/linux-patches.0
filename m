Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5E21459F6;
	Wed,  5 Feb 2025 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763664; cv=none; b=HEdrTSuu8CgMKvqxsTFWHE+C5tF9D1AWR8ShZqgt3/1FYgbOxfvH2Efuxa7AwcVA2iPX0bP55Ms4k2ZD9DnQefuni8oN8xKQs2HfcfdAWZBJcoV43HO9HKLiGm69HKItDnP19+hiFvlGCM/5bcbspkALnOMH8mBGToLHM9y263Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763664; c=relaxed/simple;
	bh=JfbOX2LewL2qHcUCkrMnMwnd/Z2LAu8ItNycCB78mdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXl5ZEJiqE8u8sqn5AJlsPPgt3lBBxULOQUMK977gwdu2BLOyaAEWqIAPsYY2Uf93y2Q8vt8u8dklgWVh/3oGSP4ZQcwHgBra8i/FeJ/+M5Nsh/9vVA06O1Ogrx6/WBg0n+v8XMa/RjJRvvuYh5g+0F6u2PqTc9ihbT+ZwPZP2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5r3wiip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5r3wiip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEEDC4CEDD;
	Wed,  5 Feb 2025 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763663;
	bh=JfbOX2LewL2qHcUCkrMnMwnd/Z2LAu8ItNycCB78mdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5r3wiipMFvwcdzlRarqSFtwsMlN641eL+9S0IO8XWvvmXDisGkOnJtLTucTM3Sd5
	 dDKPGvJkEj4NijVSZVRn/WPIt+p5D5/NTM8FPwnbEutCgaPdn9z+x5LdZJHG3dHFeG
	 xmMXsN2joTc7StzefZqsXonSoGKOuikyljpG1zpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/590] drm/msm/dp: set safe_to_exit_level before printing it
Date: Wed,  5 Feb 2025 14:36:33 +0100
Message-ID: <20250205134456.708985344@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a599fc5d63c52..f4e01da5c55b0 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.c
+++ b/drivers/gpu/drm/msm/dp/dp_audio.c
@@ -329,10 +329,10 @@ static void dp_audio_safe_to_exit_level(struct dp_audio_private *audio)
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



