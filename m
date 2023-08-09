Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F10E17744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233FAC433C7;
	Wed,  9 Aug 2023 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580608;
	bh=b1JltFsDS8pZU/BREqghDy4F6kNw2qUw677MfruGTuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6qHKkSRkg0O9AmEkyLRjlxrJunA+MFI0FQck+QvU2ybZ8dNe3rpfZJmrieCfjXYP
	 ncjtl2dj0WaUH9fkIVc5gt5eTl14F+fVdRNBfR51lYuqph7IArueLtXS+31B8lKJAB
	 cYipSzQ5GLFYaqErU9Y/ZUac8t+NVbLTMSM8cFug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/154] drm/msm/adreno: Fix snapshot BINDLESS_DATA size
Date: Wed,  9 Aug 2023 12:41:18 +0200
Message-ID: <20230809103638.567321274@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit bd846ceee9c478d0397428f02696602ba5eb264a ]

The incorrect size was causing "CP | AHB bus error" when snapshotting
the GPU state on a6xx gen4 (a660 family).

Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/26
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Fixes: 1707add81551 ("drm/msm/a6xx: Add a6xx gpu state")
Patchwork: https://patchwork.freedesktop.org/patch/546763/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h
index 68cccfa2870a3..9c8eb1ae4acfc 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h
@@ -200,7 +200,7 @@ static const struct a6xx_shader_block {
 	SHADER(A6XX_SP_LB_3_DATA, 0x800),
 	SHADER(A6XX_SP_LB_4_DATA, 0x800),
 	SHADER(A6XX_SP_LB_5_DATA, 0x200),
-	SHADER(A6XX_SP_CB_BINDLESS_DATA, 0x2000),
+	SHADER(A6XX_SP_CB_BINDLESS_DATA, 0x800),
 	SHADER(A6XX_SP_CB_LEGACY_DATA, 0x280),
 	SHADER(A6XX_SP_UAV_DATA, 0x80),
 	SHADER(A6XX_SP_INST_TAG, 0x80),
-- 
2.40.1



