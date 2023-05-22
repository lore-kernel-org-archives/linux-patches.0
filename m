Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA7171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A225C433EF;
	Mon, 22 May 2023 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784282;
	bh=r7Cjps+L3uL44zxj5kytwHfHh8I9+X06le3pmyt7P3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nULVBRon0xUMMqHQ4utvzdr5k0Ao3IZHeORhTMZYPPpSAx5ZVpG3Wst4j+4/og+ix
	 CVr7WwPXm84ihjPIK3lYcDltFl86fx1ljxfhw7QmgQbSlldMUvUY/XvIZ1W+/JmdyC
	 xy7vfLCOdFLPQ447+kCoLEl+4nkW78fEZSXloT+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 003/364] drm/dsc: fix DP_DSC_MAX_BPP_DELTA_* macro values
Date: Mon, 22 May 2023 20:05:08 +0100
Message-Id: <20230522190412.892775375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 0d68683838f2850dd8ff31f1121e05bfb7a2def0 ]

The macro values just don't match the specs. Fix them.

Fixes: 1482ec00be4a ("drm: Add missing DP DSC extended capability definitions.")
Cc: Vinod Govindapillai <vinod.govindapillai@intel.com>
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230406134615.1422509-2-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/display/drm_dp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index 4545ed6109584..b8b7f990d67f6 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -286,8 +286,8 @@
 
 #define DP_DSC_MAX_BITS_PER_PIXEL_HI        0x068   /* eDP 1.4 */
 # define DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK  (0x3 << 0)
-# define DP_DSC_MAX_BPP_DELTA_VERSION_MASK  0x06
-# define DP_DSC_MAX_BPP_DELTA_AVAILABILITY  0x08
+# define DP_DSC_MAX_BPP_DELTA_VERSION_MASK  (0x3 << 5)	/* eDP 1.5 & DP 2.0 */
+# define DP_DSC_MAX_BPP_DELTA_AVAILABILITY  (1 << 7)	/* eDP 1.5 & DP 2.0 */
 
 #define DP_DSC_DEC_COLOR_FORMAT_CAP         0x069
 # define DP_DSC_RGB                         (1 << 0)
-- 
2.39.2



