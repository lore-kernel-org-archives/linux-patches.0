Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211220;
	b=3Nd7azNl/2sRQOxL/Ig4VUxakJ6a47DOXmaMWbENbXdw1rzlrq0eH61SrcMN8RoXxT6t
	 GeXSKBGGJn54ilsnYROXhE14udO6y63V3rwvFNMoe8WXVqxEeYzMeAFrJB4IfUYHnVIWT
	 w+ouSYoiJztLyARkJriGDBD0BbGXonKl7zeDuEveLhJf8Q2zwXPmGr5eu9uy/5MBipKNk
	 AT2fjK5fxcfaLo3dtgU8dD2SR2EgtklESeFDyuw4+md4BqhzoCCWMU5n3lI+R9WYr+r5q
	 1MG5G7TaE25V1DzHpiqicAUBNnTCArqxmjbIbEX0BKGna1uKjuypxj1XGEnGhft8WQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UqaY8fo1TGVSs1K8D3InogOK/b+y1qhlloOzymLNFbY=;
	b=B818dAM9Ohx60TgYf4We4/GU5bn16zwbjmYXbuVvHwifdX0jdGegCC1Ovy1l9Ae+4uw7
	 86l626dADOi0lJ44tJLJaAAY81uk0bCdNd+3tc2ZwvnFywBSIGX+pk4KI0Uaus3SvRH1b
	 Qhi1zvHiykqXzmmFEZwAjCggQxhgcOdC67B67Y+cy5jC1Qv7vbn1TsWjAH3r+3yEOwRyn
	 RPbifV6xpHXqHAdKTSeNzadS8GJs2u7LD9ioSIARKD2r/8kurBZJ1zSaUJmZl95ncjwoY
	 NK0LIe1E2Cz/EMpgKkIU+Dht2IFcOke/wXidWRUoNij6tsF7UiLDQMtNq9ojjM9QkGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M9wg1R1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF0606A97B;
	Wed, 28 Oct 2026 18:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M9wg1R1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC9C1F01828;
	Wed, 28 Oct 2026 18:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211220;
	bh=UqaY8fo1TGVSs1K8D3InogOK/b+y1qhlloOzymLNFbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1M9wg1R18rdf38yVJNJElnxndtGqF+gQB+NPzkYFxPCToY0GO+EbJXuukm3uFrW6m
	 t3joLSoepIJvGCy2oFWjUwJ+JfNo1PZLhcwoZiKNbG0a97HL9td/QPUMq0SH7z2eSs
	 1DKAG73roaWQ8y4IKYVtNtOVNTHxXUgpMwY/fYto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/571] drm/amd/pm/si: Fix updating clock limits on AC/DC
Date: Wed, 28 Oct 2026 17:57:27 +0100
Message-ID: <20261028170015.116877969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be459903139fb..f24eda530e210 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -7133,6 +7133,19 @@ static void si_parse_pplib_non_clock_info(struct amdgpu_device *adev,
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
@@ -7141,7 +7154,6 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(adev);
 	struct si_power_info *si_pi = si_get_pi(adev);
 	struct  si_ps *ps = si_get_ps(rps);
-	struct amdgpu_clock_and_voltage_limits *limits;
 	u16 leakage_voltage;
 	struct rv7xx_pl *pl = &ps->performance_levels[index];
 	int ret;
@@ -7206,26 +7218,14 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
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



