Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D03E1FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA91C433D2;
	Fri,  3 Feb 2023 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419354;
	bh=UnE3vT5uESBE6CIl+3rDhCyUoCgqJKfhAFu6i7XDVl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0cDtN5jcJtoDvTs2ykZs3e3uu/J4kxmrp+rdx8C95GYMZ04GeXeq7gq81KCCMX/Y
	 ghF2Zv6Trl0ReR4CF0a+GeVRw5//B2OuwpfRaqq5y1wNhpfgP2w+9Do1rNMxhFPyL5
	 HdCMDruUogBukAasLDlaJgwY2E2DjFmy472vcIOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.14 41/62] drm/radeon/dp: make radeon_dp_get_dp_link_config static
Date: Fri,  3 Feb 2023 11:12:37 +0100
Message-Id: <20230203101014.732770326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit d3f04c98ead2b89887e1e3c09b26e4917bacdd9e upstream.

It's not used outside this file any longer.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_dp.c |    8 ++++----
 drivers/gpu/drm/radeon/radeon_mode.h |    4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -302,10 +302,10 @@ static int convert_bpc_to_bpp(int bpc)
 
 /***** radeon specific DP functions *****/
 
-int radeon_dp_get_dp_link_config(struct drm_connector *connector,
-				 const u8 dpcd[DP_DPCD_SIZE],
-				 unsigned pix_clock,
-				 unsigned *dp_lanes, unsigned *dp_rate)
+static int radeon_dp_get_dp_link_config(struct drm_connector *connector,
+					const u8 dpcd[DP_DPCD_SIZE],
+					unsigned pix_clock,
+					unsigned *dp_lanes, unsigned *dp_rate)
 {
 	int bpp = convert_bpc_to_bpp(radeon_get_monitor_bpc(connector));
 	static const unsigned link_rates[3] = { 162000, 270000, 540000 };
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -762,10 +762,6 @@ extern u8 radeon_dp_getsinktype(struct r
 extern bool radeon_dp_getdpcd(struct radeon_connector *radeon_connector);
 extern int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
 				    struct drm_connector *connector);
-extern int radeon_dp_get_dp_link_config(struct drm_connector *connector,
-					const u8 *dpcd,
-					unsigned pix_clock,
-					unsigned *dp_lanes, unsigned *dp_rate);
 extern void radeon_dp_set_rx_power_state(struct drm_connector *connector,
 					 u8 power_state);
 extern void radeon_dp_aux_init(struct radeon_connector *radeon_connector);


