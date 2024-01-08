Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6604B5AB;
	Mon,  8 Jan 2024 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3y3Xn/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801DBC43395;
	Mon,  8 Jan 2024 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726710;
	bh=9szoF4L4HUVjwl8IsnlnhBr2+3fjwJjx9+mnXGuWJWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3y3Xn/vMkzf4k4xs0BMZHD4MmZKlLLjODgwlMXKOiziRlYlPD0UWnQmLF/24rSKX
	 W9TKkh02RlQy3IG9uOVLIhrO+SinFsq8NyXiwiZVVyCpxXHU+hLYW7wrvaXnB7XFtM
	 Za6rBSzj3879wPW4L49VGLO3Bjp57KmCItgcVqts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Lee Shawn C <shawn.c.lee@intel.com>,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/124] drm/i915/dp: Fix passing the correct DPCD_REV for drm_dp_set_phy_test_pattern
Date: Mon,  8 Jan 2024 16:07:30 +0100
Message-ID: <20240108150604.086665187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khaled Almahallawy <khaled.almahallawy@intel.com>

[ Upstream commit 2bd7a06a1208aaacb4e7a2a5436c23bce8d70801 ]

Using link_status to get DPCD_REV fails when disabling/defaulting
phy pattern. Use intel_dp->dpcd to access DPCD_REV correctly.

Fixes: 8cdf72711928 ("drm/i915/dp: Program vswing, pre-emphasis, test-pattern")
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Lee Shawn C <shawn.c.lee@intel.com>
Signed-off-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231213211542.3585105-3-khaled.almahallawy@intel.com
(cherry picked from commit 3ee302ec22d6e1d7d1e6d381b0d507ee80f2135c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index b4fb7ce39d06f..18ee4f2a87f9e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3987,7 +3987,7 @@ static void intel_dp_process_phy_request(struct intel_dp *intel_dp,
 			  intel_dp->train_set, crtc_state->lane_count);
 
 	drm_dp_set_phy_test_pattern(&intel_dp->aux, data,
-				    link_status[DP_DPCD_REV]);
+				    intel_dp->dpcd[DP_DPCD_REV]);
 }
 
 static u8 intel_dp_autotest_phy_pattern(struct intel_dp *intel_dp)
-- 
2.43.0



