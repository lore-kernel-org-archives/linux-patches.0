Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D2A3A4F58;
	Sat, 17 Oct 2026 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256444; cv=none; b=rNG0hBJd0ejaGU76OflFTUNFINvWfT+nAhEcs5uSAY+kBbUljc5W/zWAyvd2Kz+sRc5IhfI+XNY2EMSO6ha6zTMMi+ygi7HNbxQkrR2WrCF9YzESpVYaZTsuND/X2tZaacCJaPMQ9QpAgAkSR2dsah/0qKO4Dht/9jR5iyzCGp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256444; c=relaxed/simple;
	bh=E/CAnSQxMxNTB8bt6cRIXBWUg/DtDdAG7TWc2c8zu5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EDXC6oyIoguaof1JaSDZCAj4+VbMnfchTg2aC9xSJicjsKhVZfi7mkbOdrIBiw/Qkn2vi+r3aiky0nPuIkUZEXed0CtKmFjcz1jHfyWwJIUF8AC6Ah9UZLheuJkYXVzRMy6riHuo87klYFB0MWnsWmDdsqFaCe3gRdwmSUtxQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsJFe+ez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsJFe+ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14141F000C4;
	Sat, 17 Oct 2026 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256443;
	bh=Q6e/kvdorMGu4dqsyrPFj8bOqcnqvPHYAHB/5oD/dAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsJFe+ezBYCPfyBXv8drgzK/k5PXQx9A4dfwEY5HvnUv6RL9NY/b4DNeDKoQjno15
	 Onf8Ix5Av+oTGqMvlB9wnAiyKDWkvgqZA300b3JzMakCv0/qilYNACg0KQbtfRV4Jw
	 HAXFz/a7r+ByrkzRrX+o80KjO1YZhfcLi4nJV/HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0237/1674] drm/amd/pm/si: Fix updating clock limits on AC/DC
Date: Sat, 17 Oct 2026 17:41:49 +0200
Message-ID: <20261017160437.216829525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 08c9100f65299c64439e22e6057d750ae0e6c660 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |   36 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7211,6 +7211,19 @@ static void si_parse_pplib_non_clock_inf
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
@@ -7219,7 +7232,6 @@ static void si_parse_pplib_clock_info(st
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(adev);
 	struct si_power_info *si_pi = si_get_pi(adev);
 	struct  si_ps *ps = si_get_ps(rps);
-	struct amdgpu_clock_and_voltage_limits *limits;
 	u16 leakage_voltage;
 	struct rv7xx_pl *pl = &ps->performance_levels[index];
 	int ret;
@@ -7284,26 +7296,14 @@ static void si_parse_pplib_clock_info(st
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


