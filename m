Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA565228;
	Wed,  5 Feb 2025 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764167; cv=none; b=f2wRukB58KSR3jCrOiTSkAwyJarrkJnIhnRb0X2sstgXu8SX2dXG+/gqT+bUXS2hicVofGvawAC6SlsYouI1Rm3whIEj3m2zaazMFFr1G53I0c1SMnCSCxo6fIm5u7sy8ChF6gXtRWMjyNXgchsIrJnB+iEPri78nCtmZF8naHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764167; c=relaxed/simple;
	bh=DKtbY6APvzB9r9nuzSPs3mO5ZT7mhM8cYyPL4LtgE4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZV7Kwcg+Gc+w+Gi5TeeNlCC0qHiK79QXX3l4YTXErVVA3Trj+sdS7sIhUo5cbBT1AB13ihG7zHEu4/r5jtBOeHnoctQkm/oKdR7WXT5vZykbsXk1RcPvzKUiUETL/Z2njEhUWZLmZNyYCojapd+dKaZ2rKQnqnaJWuMmcZeTDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7leT0W6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7leT0W6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597E3C4CEDD;
	Wed,  5 Feb 2025 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764166;
	bh=DKtbY6APvzB9r9nuzSPs3mO5ZT7mhM8cYyPL4LtgE4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7leT0W6RRFNt467H107MAKaPiDUlne/XxNQEgyfGqeAoPMQjOmnnrBztHhZxOemN
	 TKYaK0rwzEK3zEYXoBSKIMSBdzp1ORpOAN3CzQ0PcODlV85PeK9W5bsdmPg6GHghTj
	 HqYAq8KDBfk/Q7roKwbiW+TmdGRioxnQhDh5AmDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 041/623] drm/msm/dp: set safe_to_exit_level before printing it
Date: Wed,  5 Feb 2025 14:36:23 +0100
Message-ID: <20250205134457.800362809@linuxfoundation.org>
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
index 74e01a5dd4195..5cbb11986460d 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.c
+++ b/drivers/gpu/drm/msm/dp/dp_audio.c
@@ -329,10 +329,10 @@ static void msm_dp_audio_safe_to_exit_level(struct msm_dp_audio_private *audio)
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



