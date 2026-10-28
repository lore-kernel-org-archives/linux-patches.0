Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217228;
	b=eV1rnRRSJmQKt61DxbGqVysHYn6WvfKP64snQsmrThsVmsFfalXFgnl62X8FWzlW7jrO
	 4KU1A7LUaU3RIUzneB0MEiHpiGM4DfQSJafIAYAPb9mFeYuvItuYTAbc0LMPJnX9d5700
	 dtsK9NLCK6d1FjShC7Q/BgkMydeRyW9iaj0hva8nuO2KSeQB2z6UWABFIjW3OgbO9SHd4
	 gk57Y24L5cDjhlaQg6iNdZnnQg5Uj/EQRJafJwqpWgZpehx7KsJ4lINr8BbzkQ0B5/OgC
	 Lq4WVKiRYbqszxTu4AOOTCsnl+sHJ38BN2fL0p9TjdrpVxUdbiybtPKM8YI7sWz64zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qT7YWxhL044NhsaD6trFwFov/sB8214SLTXcHx3cmYY=;
	b=LLfvTNMd5UMYVhB0U8l1ClToPW1tujpl6DKDn0Y4dIYrx6wxcu7AlyEuCfFgvSUpmzTV
	 seiGmvI4y9KrJ1DtTqPyFL8LO9jHIU6c4TOfwniQRzzKYb8VEXkHarwaGJXzPqN6/ijku
	 rYGL+UlWPUJCXow0vD6llIS3FAgcymumFfl66hKpSNc06E2ZQH04EULs/IxXRpSGiJpBI
	 WyA/lDZnKPbmyGgI5a+MqxikA9fQYixTnh5DGDZ1mWYXtGWHUUrb5UjPvkR3plO41bXCS
	 pSvUfx2tYRsZXkiVYmDd3OvyKnW/9wWmzPOP4eRz5S/xj6kw59Ko0lGrfLJ9EfHHhaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UABCJahD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCED606A31A;
	Wed, 28 Oct 2026 19:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UABCJahD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541F21F01825;
	Wed, 28 Oct 2026 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217227;
	bh=qT7YWxhL044NhsaD6trFwFov/sB8214SLTXcHx3cmYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UABCJahDxAHd6Bd77nGVQ74RUMW/hEuO388bLDBbH0AAuxH4zEK9jUJId9Ps8VjCF
	 ggREUYXX8pznIxR4S42O22uWPoXtdBnFdl+2tBCatfDDP5UmOzdmsywls10tBm5AKd
	 +Os5Ns5B4tJ3OyOEPAvGv9fJddlO6e84c0oCfTQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tom Rix <trix@redhat.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1829/1887] drm/amd/display: drop unused function set_abm_event()
Date: Wed, 28 Oct 2026 18:05:25 +0100
Message-ID: <20261028170541.068320997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit fd73c8507675f6bccc039cf319f183e41e447cb7 ]

set_abm_event() is never actually used. So, drop it.

Fixes: b8fe56375f78 ("drm/amd/display: Refactor ABM feature")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Tom Rix <trix@redhat.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm.c | 12 ------------
 drivers/gpu/drm/amd/display/dc/inc/hw/abm.h   |  2 --
 2 files changed, 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm.c
index 30bc598811875..3b85fc665f41e 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm.c
@@ -131,17 +131,6 @@ static bool dmub_abm_set_pipe_ex(struct abm *abm, uint32_t otg_inst, uint32_t op
 	return ret;
 }
 
-static bool dmub_abm_set_event_ex(struct abm *abm, unsigned int full_screen, unsigned int video_mode,
-		unsigned int hdr_mode, unsigned int panel_inst)
-{
-	bool ret = false;
-	unsigned int feature_support;
-
-	feature_support = abm_feature_support(abm, panel_inst);
-
-	return ret;
-}
-
 static bool dmub_abm_set_backlight_level_pwm_ex(struct abm *abm,
 		unsigned int backlight_pwm_u16_16,
 		unsigned int frame_ramp,
@@ -167,7 +156,6 @@ static const struct abm_funcs abm_funcs = {
 	.init_abm_config = dmub_abm_init_config_ex,
 	.set_abm_pause = dmub_abm_set_pause_ex,
 	.set_pipe_ex = dmub_abm_set_pipe_ex,
-	.set_abm_event = dmub_abm_set_event_ex,
 	.set_backlight_level_pwm = dmub_abm_set_backlight_level_pwm_ex,
 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/abm.h b/drivers/gpu/drm/amd/display/dc/inc/hw/abm.h
index db5cf9acafe6d..d2190a3320f64 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/abm.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/abm.h
@@ -59,8 +59,6 @@ struct abm_funcs {
 			unsigned int otg_inst,
 			unsigned int option,
 			unsigned int panel_inst);
-	bool (*set_abm_event)(struct abm *abm, unsigned int full_screen, unsigned int video_mode,
-			unsigned int hdr_mode, unsigned int panel_inst);
 };
 
 #endif
-- 
2.53.0



