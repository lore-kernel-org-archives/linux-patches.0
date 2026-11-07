Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061439;
	b=m0O1C15p405ehK+WaXcVmvOaNJaOijOYQOUtsZQqnAX9JuLIpzsOlfoA2nag1XxxHdho
	 fm+9pZFh0sXWiTg0AoCdFEAyvIvQ+lEHB2merwWaCLr1EOAgQipEVIiV5tL7jXRk7vsgE
	 /URCiURG+fb0Tc4lmtaJOGFOfendW4VAOU9+bA/cYnxMj8T0wKbELexcwpUJki6x3C9ec
	 TxowPjfz9xDjg0pyiPodD2iiQh+gD7aDQKpJzHGt756d4glriZajzTugdXW5giWLWU6wZ
	 I+jSn9mk9PAWpVJbeP1Y8L/mrgIXDYWwsb7VwVoRp00PaBZm6Bd3lYeRx55NKYs86FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bjyqhVatNSlSXCHObYRf7kxutveOEiykbc8mTmx4Lz4=;
	b=uv+tWlr9O/Z8lySvxlezD6weC1xHbwEY2O3YGtp/J1J/k2hPoDPLDw7VDjK5QLeip4OV
	 o4SCa6ZHrTmAfgWaUl8RMZDwV+TBoFnpZZnnRorR/smAqqCvG8M64+MixJ7lZIHGcyC+0
	 9B0TJ1rbxOb+om52CiWJ2UVjlTg56ur7ehzs7oDbtKajEy/rMkMSQ210sYQE8a7HWsOpR
	 gVdalxRFe2Hl5qVXKZghWRX3VqcxXgex2TPUSjzgWU10H0cQ8121bgbav6vlH3J6nJIJW
	 K3MQP8gj9QQIIFpRNFC54v+OoL4Kpj9o5YHokElyr5TAyVf+9nKUYRHHSBuNkO9bH9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGX1fCwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA7E606A326;
	Sat,  7 Nov 2026 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGX1fCwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2F21F0089F;
	Sat,  7 Nov 2026 14:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061439;
	bh=bjyqhVatNSlSXCHObYRf7kxutveOEiykbc8mTmx4Lz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGX1fCwy1I8UQPF5k00S1oKXN75kra6F1nZc6BXaRTvnaCGD41Ek7I+0gL0LWzTN6
	 gjTQt9p2oUl337HVAvQ7LpKNapC/IGL70LjMNwaLXmoz61LiIQQiZcuTw9BRlts3eF
	 Mh8JepHrAAsjW7Y4DSPyPkk0NhlBSOS2iC6Rrlzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0548/1536] drm/amd/display: Fix fast updates on DCE 6.x
Date: Sat,  7 Nov 2026 08:42:44 -0500
Message-ID: <20261107135013.001056561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 88427119e1f039c8cdffd63726c136a986ef519f ]

DCE6 should use legacy fast updates, just like all DCE8 - DCN2.
Set that flag for DCE 6.0, 6.1 and 6.4 (all DCE6 versions).

Technically DCE6 should have been included when the fast update
code was refactored, but it just happened to work until now.

A recent commit "Attach only plane updates that actually changed"
has exposed this issue because with that commit, DC accidentally
took the new fast update code path for DCE6 as well, which caused
it to boot into a black screen with a flip done timeout.

This fix should be backported to all kernel versions that
have "Refactor fast update to use new HWSS build sequence",
but this patch won't apply cleanly to older kernels due to
another refactor in "Remove dc param from check_update".

Fixes: 0baae6246307 ("drm/amd/display: Refactor fast update to use new HWSS build sequence")
Fixes: 9ec11bb842b6 ("drm/amd/display: Remove dc param from check_update")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 698fda6e360625850413a2d1a90b72ae5f03073d)
Cc: stable@vger.kernel.org
[ sashal: Set enable_legacy_fast_update in debug_defaults instead of a separate config_defaults/check_config, and dropped the is_apu context line in dce64_construct. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index c5bf95b71b1a1..3f27dbd4f99b2 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -438,6 +438,10 @@ static const struct dce_abm_mask abm_mask = {
 		ABM_MASK_SH_LIST_DCE110(_MASK)
 };
 
+static const struct dc_debug_options debug_defaults = {
+	.enable_legacy_fast_update = true,
+};
+
 #define CTX  ctx
 #define REG(reg) mm ## reg
 
@@ -973,6 +977,7 @@ static bool dce60_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.dual_link_dvi = true;
 	dc->caps.extended_aux_timeout_support = false;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
@@ -1170,6 +1175,7 @@ static bool dce61_construct(
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
@@ -1367,6 +1373,7 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



