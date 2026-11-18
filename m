Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037826;
	b=T2/0E18J4G/d3FFAcJXibiQPWJIRM0dhxRrgPLMzCqkLSeRTjmut8PxvSK9Nx8Iql7HS
	 /rKcIuBio1DlYFVS/ZEXTpcV+1DDNFD9DvZEK64cvaa48dyLNUP8r7tmb40+t8f867E8f
	 V4uGqKw3Ij4pRFb+cvqjy40YUw+YPa4YqEBlCySqMdcbfRXJldEtxI6mHEhw1bYwo+QYh
	 oqnjgFhGHeZTnc8OEb9gsnaqtmZXDdN/jibmh4ydDTopj/l1/gPMoHDs4HYw1iSmO4Pjd
	 hn4L7du6l61BAPtyAA+T2Yby8hydzT6p8be3OaNbByCMI97VqCGs8LrUZ1igD7jcAdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kk2eh0R0gMjXvgH9+SErkf64iQdTqcfUEaDIIPqhHbM=;
	b=M+0yPavTZe7V0gVZDYd7acxJ8+gL+5bWAprwFQ7BXVo4woo0VswzNI1PgvhGZSBWhqXx
	 8QX/JB+oUaCSq994XukxkipEk1JkP5DemSxHxchb+RigD32b6bdyeyCjAlC36osaVKFxJ
	 usHQox9orWP/2H01GMV84pHC5pQkqcQljBXlLElKHtCEL8KFlyKp79JuBjFtkFqz3c2zg
	 do4v5Ry7cxfck9vwhA5e95/KkFvAn7wSJuRq40lHje56KFhJ1OHoYei488PmPymJQeEhP
	 QvNdMmXBAflVZmZnWhg3HEcnqCzzDmDp++lGL+cvalpHhIawwyehJk+T1Jqh0lRlDpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjqqjGXn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C3A606A330;
	Wed, 18 Nov 2026 21:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjqqjGXn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5304C1F000C8;
	Wed, 18 Nov 2026 21:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037825;
	bh=Kk2eh0R0gMjXvgH9+SErkf64iQdTqcfUEaDIIPqhHbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjqqjGXnFeo06SNEg9aZd+AIBFTHUlpKgbv4MsmfiIUUCf7Sb3N+LwtnCzihXIj7U
	 lk6q+KhFOzIAwQ+UCdv3eBDYbi1ABSLHvIDSNrt7cUyRb1KAE5Fb96UMj72MT3hmcB
	 3FPOBx8Rjds4D2ZhV41LERwXUbdFTh+wKc9FsoEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kylie C <kyliepc@proton.me>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1531/3318] drm/amd/display: Dont select zero V_TOTAL_MIN/MAX on seamless boot
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118150406.904286901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kylie C <kyliepc@proton.me>

[ Upstream commit d13f36e4e055cce03761de590bc8dc6346b1d5c8 ]

Initialize V_TOTAL_MIN/MAX to V_TOTAL before enabling the selectors if
they are still 0, as optc1_program_timing() does without seamless boot.

Tested on Renoir (DCN 2.1) eDP with amdgpu.seamless=1.

This removes the flash between the bios logo & plymouth on my laptop.

Signed-off-by: Kylie C <kyliepc@proton.me>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ad7473e82b9242c4ee7eea82ab16d3f82f01651)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index 58bdbd859bf9b..3933f332b1b6a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -461,6 +461,13 @@ void optc2_lock_doublebuffer_disable(struct timing_generator *optc)
 void optc2_setup_manual_trigger(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
+	uint32_t v_total, v_total_max;
+
+	REG_GET(OTG_V_TOTAL_MAX, OTG_V_TOTAL_MAX, &v_total_max);
+	if (!v_total_max) {
+		REG_GET(OTG_V_TOTAL, OTG_V_TOTAL, &v_total);
+		optc->funcs->set_vtotal_min_max(optc, v_total, v_total);
+	}
 
 	/* Set the min/max selectors unconditionally so that
 	 * DMCUB fw may change OTG timings when necessary
-- 
2.53.0



