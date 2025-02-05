Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34AD1459EA;
	Wed,  5 Feb 2025 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763258; cv=none; b=XDp5p1RTihG048SoUyNCFv3d/dEcrcrCx2z6SfE/dxKj+BCkCgxn5bPCScDIiYzZ4WYDL1QIfhYzzF/Grb1zgita5EJjS/1Dg3fbpXddCnEgnaBEN7+iEtD1u0u7S/VR1xZEq0qyvD30nqE8l8Iyxkl/j12CvL+qizYZSaI/vlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763258; c=relaxed/simple;
	bh=Q+OvS9KjrAHqPQCTjEKLLYwm4/rZEdf1iB6rnAKeqsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkMpRDeMq6OeXJx6eCjFNzu/kZgp+tvcu0ugFyOqZVBEqZcYHPRrTXcQIeJXdWGFGtfQRmPlZhvoLHcBGP9oE8hZgbbjLh1UyOGr4iS5It9iiTxOTS3CH+JdmT9u+1mMprnRB/wrEuiAdvDaiftGQ4EWDUxZiIfZ9D+3KlGA7Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Anyw56tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Anyw56tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF834C4CED1;
	Wed,  5 Feb 2025 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763257;
	bh=Q+OvS9KjrAHqPQCTjEKLLYwm4/rZEdf1iB6rnAKeqsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Anyw56tI6gI2Oihbat9HSkl1NuLSll6eECRSfOSPY5wuMaKBIMmR3StksxBaRdU5o
	 C5FU7VeM8H+zZoaCLmBUVo/7cCYVDh0rQHfLqcr01rfJow8zj2Tqn2rEem7fd6H8Wn
	 ys9mxuzpx0UWKoYyvx2NVErS5Jb4UNoQ0WrRsJRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/393] drm/msm/dp: set safe_to_exit_level before printing it
Date: Wed,  5 Feb 2025 14:39:01 +0100
Message-ID: <20250205134421.150515632@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a2e479723a85..610cbe23aa839 100644
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



