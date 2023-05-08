Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31189125B3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECEAC4339C;
	Mon,  8 May 2023 10:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541084;
	bh=W4hZw9M6ovAMzEaquCs9lcNPtFYHjVZFJSAMrw3tZh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjkOR++rzoqVCUfSaYpXYF0QcDjtdyvO1dc6lunf6vv7O7MQTSaotvKsTmjcKjUGw
	 i9NSk4s+xFgglVG5d801oi6oA7550q4qo+5ukw/mGVwOD2Mfuvk5xpQr7U/o11xXD1
	 NJyUCt8Gb4//2mQuoUmVz9K/Q27OpLWr65wGdn4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 6.1 609/611] drm/amd/display (gcc13): fix enum mismatch
Date: Mon,  8 May 2023 11:47:31 +0200
Message-Id: <20230508094441.697916770@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 545094d993f4639482018becda5f2a47d126f0ab upstream.

rn_vbios_smu_set_dcn_low_power_state() produces a valid warning with
gcc-13:
  drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c:237:6: error: conflicting types for 'rn_vbios_smu_set_dcn_low_power_state' due to enum/integer mismatch; have 'void(struct clk_mgr_internal *, enum dcn_pwr_state)'
  drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.h:36:6: note: previous declaration of 'rn_vbios_smu_set_dcn_low_power_state' with type 'void(struct clk_mgr_internal *, int)'

I.e. the type of the 2nd parameter of
rn_vbios_smu_set_dcn_low_power_state() in the declaration is int, while
the definition spells enum dcn_pwr_state. Synchronize them to the
latter (and add a forward enum declaration).

Cc: Martin Liska <mliska@suse.cz>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.h
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.h
@@ -26,6 +26,8 @@
 #ifndef DAL_DC_RN_CLK_MGR_VBIOS_SMU_H_
 #define DAL_DC_RN_CLK_MGR_VBIOS_SMU_H_
 
+enum dcn_pwr_state;
+
 int rn_vbios_smu_get_smu_version(struct clk_mgr_internal *clk_mgr);
 int rn_vbios_smu_set_dispclk(struct clk_mgr_internal *clk_mgr, int requested_dispclk_khz);
 int rn_vbios_smu_set_dprefclk(struct clk_mgr_internal *clk_mgr);
@@ -33,7 +35,7 @@ int rn_vbios_smu_set_hard_min_dcfclk(str
 int rn_vbios_smu_set_min_deep_sleep_dcfclk(struct clk_mgr_internal *clk_mgr, int requested_min_ds_dcfclk_khz);
 void rn_vbios_smu_set_phyclk(struct clk_mgr_internal *clk_mgr, int requested_phyclk_khz);
 int rn_vbios_smu_set_dppclk(struct clk_mgr_internal *clk_mgr, int requested_dpp_khz);
-void rn_vbios_smu_set_dcn_low_power_state(struct clk_mgr_internal *clk_mgr, int display_count);
+void rn_vbios_smu_set_dcn_low_power_state(struct clk_mgr_internal *clk_mgr, enum dcn_pwr_state);
 void rn_vbios_smu_enable_48mhz_tmdp_refclk_pwrdwn(struct clk_mgr_internal *clk_mgr, bool enable);
 void rn_vbios_smu_enable_pme_wa(struct clk_mgr_internal *clk_mgr);
 int rn_vbios_smu_is_periodic_retraining_disabled(struct clk_mgr_internal *clk_mgr);


