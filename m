Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208889;
	b=uq3pPh0x9XrN1lJtu3z0WV9dbfFCyjK2QyP0nG0t8iDdZZhuXheSq3HFG3a30yqY6ylb
	 NA1v+eDiB/QZHvoOQOS6xcEWLNIZZ5k6bA23jZIBiIovGLn69+kcRMTUU6K4TP65Cqzmn
	 PAvYAtnF9cRv4LtSyqBf9DL0aPBjfQ/5WnCQVA2hBslE9lDdt2SkpTdOA/CDA8lIiXyIm
	 digCD1rbd2YrwyaYPwN7Xi00mfrUTJHRCGRY14XKXFikQnwwCukgYDQDOdojO9I8xI0c6
	 ONkz+SUKbuhkSTw5d5qK7S1QiHTm+xExw1BYk1oF8EpFvc+cp+Mv3p2qwXa/SvzntcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/+qYmLEDhAUcm2iTBcOXLbvd2QAQf5RP78DWuVb3UBU=;
	b=p/QW/CV0lswl52eLwqXzfJSayUFgsl3xXD1tcw4fde8LForGnmeimkVBSFPRRhU0ZuLh
	 nTo0eK+3oHRcX8v2Dyjbnj/+gJ7U5QckUJLPbfCM4I7JWj3vc+nY4yn8aPtjC0X4CC8vO
	 ff+m3lTlshy98yNkVKjpub7FMgrUynT1dSBiEYyS9mpW+jHLtvC2jsifuvonycgLxGCj3
	 uAC+LexPQgZ2xdz3odbC57OgtbZzKzp+4usngMC0kgt5GkJAqn2du4Ewp7WRjwU+8Dk1R
	 jAL6KCq0LdUXoSQUIYRurYrrWqGC4eFOZrVAqSji4927YeZWDXGMeWb5s2jqs8n37ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XejP66GH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246CE60A2607;
	Wed, 28 Oct 2026 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XejP66GH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752921F01825;
	Wed, 28 Oct 2026 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208889;
	bh=/+qYmLEDhAUcm2iTBcOXLbvd2QAQf5RP78DWuVb3UBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XejP66GHeYtlYHstXsx+s0ljoWd1I1eg1BUHugkv3aKdLGcvM95+ubiHm4u7Hw4/p
	 DkgZmez8+fGb/Dd2+JFaHXqb00C+Nldi8fY92Yxv5M9i2pIjHT+JdX8G/96G93aQv4
	 98dJfdDaO6KVPIKkr9Cx3gk8YxIeBDLCV8x3lDOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/516] drm/amd/pm/si: Fix updating clock limits on AC/DC
Date: Wed, 28 Oct 2026 17:57:08 +0100
Message-ID: <20261028170010.030530252@linuxfoundation.org>
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

[ Upstream commit 08c9100f65299c64439e22e6057d750ae0e6c660 ]

Assume that the AC limits are the maximum of all power states,
and the DC limits are the maximum of battery power states.
This shouldn't make any difference in practice, but is
cleaner and more robust against bogus information in the VBIOS.

Fixes: e6c5d36756e7 ("drm/amd/pm/si: Fix updating clock limits from power states")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923120354.1027996-2-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ef8cb9dcc7db7b7abcbdbe870a080cc81e4f0bf3)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 36 +++++++++++------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index 79e23092c052a..4c4b1ff219c94 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -7136,6 +7136,19 @@ static void si_parse_pplib_non_clock_info(struct amdgpu_device *adev,
 		adev->pm.dpm.uvd_ps = rps;
 }
 
+static void si_update_limits(struct amdgpu_clock_and_voltage_limits *limits,
+			     struct rv7xx_pl *pl)
+{
+	if (pl->sclk > limits->sclk)
+		limits->sclk = pl->sclk;
+	if (pl->mclk > limits->mclk)
+		limits->mclk = pl->mclk;
+	if (pl->vddc > limits->vddc)
+		limits->vddc = pl->vddc;
+	if (pl->vddci > limits->vddci)
+		limits->vddci = pl->vddci;
+}
+
 static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 				      struct amdgpu_ps *rps, int index,
 				      union pplib_clock_info *clock_info)
@@ -7144,7 +7157,6 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(adev);
 	struct si_power_info *si_pi = si_get_pi(adev);
 	struct  si_ps *ps = si_get_ps(rps);
-	struct amdgpu_clock_and_voltage_limits *limits;
 	u16 leakage_voltage;
 	struct rv7xx_pl *pl = &ps->performance_levels[index];
 	int ret;
@@ -7209,26 +7221,14 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 	 * VBIOS can contain conflicting values between:
 	 * - the maximum allowed clocks and voltages on AC or DC
 	 * - the clocks and voltages in power states on AC or DC
+	 *
+	 * Assume that the AC limits are the maximum of all power states,
+	 * and the DC limits are the maximum of battery power states.
 	 */
+	si_update_limits(&adev->pm.dpm.dyn_state.max_clock_voltage_on_ac, pl);
 	if ((rps->class & ATOM_PPLIB_CLASSIFICATION_UI_MASK) ==
-	    ATOM_PPLIB_CLASSIFICATION_UI_PERFORMANCE)
-		limits = &adev->pm.dpm.dyn_state.max_clock_voltage_on_ac;
-	else if ((rps->class & ATOM_PPLIB_CLASSIFICATION_UI_MASK) ==
 		 ATOM_PPLIB_CLASSIFICATION_UI_BATTERY)
-		limits = &adev->pm.dpm.dyn_state.max_clock_voltage_on_dc;
-	else
-		limits = NULL;
-
-	if (limits) {
-		if (pl->sclk > limits->sclk)
-			limits->sclk = pl->sclk;
-		if (pl->mclk > limits->mclk)
-			limits->mclk = pl->mclk;
-		if (pl->vddc > limits->vddc)
-			limits->vddc = pl->vddc;
-		if (pl->vddci > limits->vddci)
-			limits->vddci = pl->vddci;
-	}
+		si_update_limits(&adev->pm.dpm.dyn_state.max_clock_voltage_on_dc, pl);
 }
 
 union pplib_power_state {
-- 
2.53.0



