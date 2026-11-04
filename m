Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831282;
	b=0hya0UpWDjbVkSdFrF1lg2JHRxeZMF8hnoP2Zg7fEx/9qJI7qaoZetJ+hOtDrEng9Igg
	 HyU009ZdO4b0QZSlFQw3CUZBXwa88T5PHhMaLZcaIk1AWay77N5YRiFigrjENoRzczgJx
	 WE+K/ZIfhM0QNy1yU1roUcFwKR1s0nLzWr8bJrrWJJ/9FQ5s1QKWIdiz/EzBkOHwX6c59
	 dU7RT60/2bYTUt/qMUHVWAcS1rXrXWSmWr7L9amgDo5Zjp+KgeMJLm9POQGbJFT8Ks74G
	 A0tPnqxxsuPObQdjNfuU3JEyohBXoIVzofqVaOvCfwHWeaeXo2sqis1CwrgSkk8msYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oJfmzu7FaUcxpkOXZcnjunS+4QZCz91JuuQDSDQKeFA=;
	b=P0Ul101MgRf20yTf2WiBwzHoqs2nR3H1rLEfiKANcY8NPoTwUPVo86iogY/pPBrcx5Rf
	 VmP5FykihtdMa03nymRmooxArrjq8UeFTFWiZaocGfC90AqwhCAAEq2xOhfQ2f8YpFV+u
	 wDEm8hi96gSaKMPh1ak28XQqKb/GdvHu1oKxPUlUUaDzriFFLmApfHbsJnF/S54x4dIcw
	 sRErb7fphuvO34aRv803E/+L6rkR1r510h71EPOrhAHO3ncEcps+f6yK/cE+oy/3dp+VC
	 n2WrgZxAPtUoF16jCw1gaeRRJf6a/FCUb2Nwz7ixoNla7F2zLjY5YQIwOIO1qgVxMNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H76f/Svl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0CB606A335;
	Wed,  4 Nov 2026 22:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H76f/Svl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6476F1F00919;
	Wed,  4 Nov 2026 22:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831281;
	bh=oJfmzu7FaUcxpkOXZcnjunS+4QZCz91JuuQDSDQKeFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H76f/SvllCanZhJRFzelrmE05ggD3Go50dDBujokKjFN/1LhZ3ACYQh8BAzISm+dr
	 wqwc1ws7sGrz9virrtSg+LL25lr7UWLb9DP3HLcuujILw8O9McW/XTOV5TE8bMNQk0
	 X2uiEHBUTwCqsX9UhQMYI6Tl0AH3ulRpTOzX7v9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0610/1005] drm/amd/display: Fix fast updates on DCE 6.x
Date: Wed,  4 Nov 2026 16:05:43 -0500
Message-ID: <20261104211100.934747068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the missing dc_check_config flag with dc->debug = debug_defaults, setting enable_legacy_fast_update = true in the DCE6 constructors, and adjusted the dce64_construct context because is_apu was already removed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index e67c73807f371..9fa6c01f32c84 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -439,6 +439,10 @@ static const struct dce_abm_mask abm_mask = {
 		ABM_MASK_SH_LIST_DCE110(_MASK)
 };
 
+static const struct dc_debug_options debug_defaults = {
+	.enable_legacy_fast_update = true,
+};
+
 #define CTX  ctx
 #define REG(reg) mm ## reg
 
@@ -912,6 +916,7 @@ static bool dce60_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.dual_link_dvi = true;
 	dc->caps.extended_aux_timeout_support = false;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
@@ -1109,6 +1114,7 @@ static bool dce61_construct(
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
@@ -1306,6 +1312,7 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



