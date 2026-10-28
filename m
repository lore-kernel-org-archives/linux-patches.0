Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208864;
	b=Xeed7UZUzr3KsWQAJi/Pczs/ltq9voUgHhZDYarJXwedj8hvsZDugK+O39bDWCu5b2DT
	 XF8qyhC9z8RxvLyVzdTeXGGLua7fQsr7Gcek8H0SlwX8PBErNmuTY0gKCji2zoq4C3QNb
	 B1WkcURNa4Fv5I2MFAX+uj9Tt34hQl3Qe8SsvBHVXwb40o6EOeYeXZnNwiKbj3izUAfB3
	 RPMgAp9Fdd9Y0kK/ofdMxvwtCC4iHBPVQz9umlEphplRVdurlpQFokFnqE9QjT6A2Fp48
	 14Xd5DlC33AfItQfYbPDPYLJ2T9uhhb5z76Mq+KoKKH7UIZtostnOURBy6nZmLk+Q5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6Du0bvhCO2mNDloa++0dqA+HiawQtYMdzpoaxpQFK1g=;
	b=W+7NnQY9GvkkscUTjGnR4lp7vm8s6YJzTXfPyiSM7bGsfCZj00aOqxZqK3kpRFULqbz5
	 CvZ87vj/7lW0gHC85JKbCyWNo16X/wlh3es9JzNsPFtrm7+wm+XE0ol0f5EIx3hKL8am5
	 pjiyF3Vu4nrSe0O4Xr6QBupM81dhyZ1ssdnfg/x9Se77ceCAt6aAkxzv8vTptaHuikzbI
	 Hl2y6vTiApAYZ+4Pd/X3G6E9UQ+wnu3K0ElO95xODS3xCzyz7LCf4MW9cuhRNpUTDW7Mk
	 yjENQUQ86BDhT3G1FutzCEB61z0nkW2r8/7xed609UHMZ8cYGeS3K6zI7ZfiPAG5LSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt8Q94d1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD286606A31A;
	Wed, 28 Oct 2026 17:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt8Q94d1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093ED1F01825;
	Wed, 28 Oct 2026 17:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208863;
	bh=6Du0bvhCO2mNDloa++0dqA+HiawQtYMdzpoaxpQFK1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt8Q94d1ez8PWsq0dcdseiiu4KDigwsJQCIhx17aB8zwHDVxR7SJoOq6RubNAsffi
	 hPchzWTvVLtYxCsgavBcpt1gESWV4d2qRzTPX/PBE2TBS2m05uJf3jCTE3dnGPt+XM
	 vsPamCIISZKe1dxAfpIdf91xvFBosQu+hEjZcCFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/516] drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC
Date: Wed, 28 Oct 2026 17:57:00 +0100
Message-ID: <20261028170009.841881215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit cd883d0a3937df82a5ea03709ba8ba623b868419 ]

Unfortunately, some desktop boards eg. the FirePro D500
have the HARDWAREDC platform flag set and also have
a battery power state configured in their VBIOS.
This makes no sense for a desktop GPU and results in
incorrect behaviour: the clocks are stuck at lowest.

We observed that the kernel driver can work around
the issue in two possible ways:
1. Set PPSMC_SWSTATE_FLAG_DC on all power states
2. Clear PPSMC_SYSTEMFLAG_GPIO_DC

We think that the PPSMC_SYSTEMFLAG_GPIO_DC flag
makes the SMC assume it's running on battery even
though this is a desktop machine with no battery,
and that's why it doesn't do DPM on power states
without PPSMC_SYSTEMFLAG_GPIO_DC.

Issue was uncovered by "Fix updating clock limits from
power states" because previously the limits for the
battery state were not tracked separately. However,
battery power state has lower frequencies and voltages,
so the kernel doesn't set the DC flag on the current
power state anymore. That causes the SMC to be stuck
on the lowest clocks.

Let's clear PPSMC_SYSTEMFLAG_GPIO_DC on desktop GPUs.
We can use the AMD_IS_MOBILITY flag to determine that.

Fixes: e6c5d36756e7 ("drm/amd/pm/si: Fix updating clock limits from power states")
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/16352
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923120354.1027996-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 58473c7c49ce9f5f5a4a1c24ffb9aa1d3c8771f4)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index f4bb4d2c3f77b..79e23092c052a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -5164,7 +5164,8 @@ static int si_init_smc_table(struct amdgpu_device *adev)
 		break;
 	}
 
-	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC)
+	if ((adev->flags & AMD_IS_MOBILITY) &&
+	    (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC))
 		table->systemFlags |= PPSMC_SYSTEMFLAG_GPIO_DC;
 
 	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_REGULATOR_HOT) {
-- 
2.53.0



