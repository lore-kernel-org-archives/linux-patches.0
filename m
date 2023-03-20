Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512211C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57E3C433D2;
	Mon, 20 Mar 2023 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324728;
	bh=vZeEPlFUIhyls7IQBBIzpmVtBpAtwPe1H1yLz9J0tH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqX/5buQaxm3kRV+Fjv/N/Nz85XRPc5zFt8B1kglvPVMi2sLAjp/OH0pdi2LvXYqs
	 TejspuA3ckABdYJLQPCImLGTrxmtlJij3MVI8uKAwn93NzpWEiiCEsVQbeGppmtwzo
	 4AbjwR0s9Z5VzrO2Xq4exB/LmRcARG7pAfAt1968=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/115] drm/i915/display: clean up comments
Date: Mon, 20 Mar 2023 15:53:56 +0100
Message-Id: <20230320145450.436481736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

[ Upstream commit 3461b040a90d723c93c9d1c7c11e3464f5cadc0e ]

spelling changes
resoluition -> resolution
dont        -> don't
commmit     -> commit
Invalidade  -> Invalidate

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220701203236.1871668-1-trix@redhat.com
Stable-dep-of: 71c602103c74 ("drm/i915/psr: Use calculated io and fast wake lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 21d58d22c82ee..5f9894e3c7aa7 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -580,7 +580,7 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 		/*
 		 * TODO: 7 lines of IO_BUFFER_WAKE and FAST_WAKE are default
 		 * values from BSpec. In order to setting an optimal power
-		 * consumption, lower than 4k resoluition mode needs to decrese
+		 * consumption, lower than 4k resolution mode needs to decrease
 		 * IO_BUFFER_WAKE and FAST_WAKE. And higher than 4K resolution
 		 * mode needs to increase IO_BUFFER_WAKE and FAST_WAKE.
 		 */
@@ -986,7 +986,7 @@ void intel_psr_compute_config(struct intel_dp *intel_dp,
 	int psr_setup_time;
 
 	/*
-	 * Current PSR panels dont work reliably with VRR enabled
+	 * Current PSR panels don't work reliably with VRR enabled
 	 * So if VRR is enabled, do not enable PSR.
 	 */
 	if (crtc_state->vrr.enable)
@@ -1619,7 +1619,7 @@ static void cursor_area_workaround(const struct intel_plane_state *new_plane_sta
  *
  * Plane scaling and rotation is not supported by selective fetch and both
  * properties can change without a modeset, so need to be check at every
- * atomic commmit.
+ * atomic commit.
  */
 static bool psr2_sel_fetch_plane_state_supported(const struct intel_plane_state *plane_state)
 {
@@ -2067,7 +2067,7 @@ static void intel_psr_work(struct work_struct *work)
 }
 
 /**
- * intel_psr_invalidate - Invalidade PSR
+ * intel_psr_invalidate - Invalidate PSR
  * @dev_priv: i915 device
  * @frontbuffer_bits: frontbuffer plane tracking bits
  * @origin: which operation caused the invalidate
-- 
2.39.2



