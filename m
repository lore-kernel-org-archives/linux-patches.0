Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585799;
	b=o4Hq0fxpzzBASSg9hxi54klMbrmq7nkK2vRhOmNGXH/96/UVNjal5gCbRj+tGG8Tyfv4
	 uWIIyDRSSDBpL2O+wR1O9RWy6NkeBeC8vlcNwleZFrperJgwEvZ5qr25b8ZtC3dymyEUV
	 pIIViNOGrlFBHCPJI5NrPbQXZX78AQ9hPyYF/wcVSlDUGjpF9B1oWTz5NIWEHbMSRkglY
	 TaqwYTT8K5pm+2CXRiXBov8xN7JZpKmJV2m/UZonEfvEl3pHsxHpt6NUGVJGur6lDNL0V
	 O3dMFy/5Pl1tMq7+JV0ej6bDu2NFk+ucS3f90HwhNFwAdcGqy7mbe8Yg1nVuf5r+gFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ViruiqdkvNiOMEyULu8HmvhZ5FH568Ni6m1vFFBc6NA=;
	b=tW8MYuR/k4z2pC3TGxKwc8Pyleyq9GIEVHl74noctjmy2k3UlPsI5jIcNpEU6hv7439X
	 hn6jvLkcTU9RCSQOfD2kuk8na3YrcgHtftNYZzKZ9Ec8cuG1we+R6ZZYqc+CTyowqOiNz
	 E0kqYE8x1XQl5zkFPNwrBly7I84TG/P1UYLBIpFE3OKyw4NOL52X99wviV340fHox53AY
	 kdjuGvm/FJH8J4Wh8d9n90r9VyctFccb/u9oALc6dKtI9ZM9QlSa6G9CeCTqPRue3sfpG
	 gvOuIDQhQTDsWBzNHTSwV6P8fXr4G+IYvMYwE539f1CpudmLJvZ/wGzUoL2kZQZLt9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lC8pflVv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F95E606BA99;
	Fri, 13 Nov 2026 16:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lC8pflVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC881F000C4;
	Fri, 13 Nov 2026 16:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585799;
	bh=ViruiqdkvNiOMEyULu8HmvhZ5FH568Ni6m1vFFBc6NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC8pflVv2QurKi3AabxRdDTLEYxvJAvPXMK1xUM1mMny67y/75xiZc73KxDHV2ig0
	 9EFByya9i7PR+M2efYE2cnwZuz1qZI4hFNmhwTlugY5zHEBpyNHRPqwM6rnW+8TYqa
	 o2j7r3fQV6cV5wQH6PkL+begMhpmpnN0XaW+UI6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kylie C <kyliepc@proton.me>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 368/507] drm/amd/display: Dont select zero V_TOTAL_MIN/MAX on seamless boot
Date: Fri, 13 Nov 2026 10:51:12 -0500
Message-ID: <20261113153808.534346362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
index 73cc8a713556b..2cdfe3d7a0ea6 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
@@ -449,6 +449,13 @@ void optc2_lock_doublebuffer_disable(struct timing_generator *optc)
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



