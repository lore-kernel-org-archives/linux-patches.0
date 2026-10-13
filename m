Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF094EFFD4;
	Tue, 13 Oct 2026 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894967; cv=none; b=MWTik+ynSJ1mWk2RGO9b9rzgoV0gEeOBNPsFh4TMGlnBeOflPu1rRWD1y//R+YQLQ6yckcKYYJT7IskGzZth+8Ud/16qqf2zm5TBLjuiyG68zsHE7dLpX/ZQICtobe2BYVJpZ31dvCJ9l58yO6nlHUxhP4oG78mhozk8ziv4U9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894967; c=relaxed/simple;
	bh=182LrB4ZZYmI2yqLOMKpELCqJFRZy0il7Hoe1Z6z3hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbCvUPpyZcVqzwsSzT3n1NzhfjcHTKCbRcOeIQQhRnHcVL/ziX4z7mqw1pAl1BsUxyuojKDCOCbUCIEb/gD61jvWHQLVHrh+zC19TYmcZKS0O1Y/1Xpwd4yvoi6v4h967DoZU/f1+3oRHQiRIBeVMEGglkbmw/L3I9R/MEA5Evk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYc/P/Fx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYc/P/Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ADD1F000FF;
	Tue, 13 Oct 2026 12:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894965;
	bh=pgG+du5JXmiqrUJtjharSPr+Beh6SXBaQBHaXRdLjkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYc/P/FxUZHB5NC6NyA+64xQnDzFfOn/B/hBpwFU6HTHIL+vR0YTdfZpXbgHZQRJ4
	 4C57WqyFGY3nJiQqrnMrNh/ERQKLb7aNPTD2cj13nAA3tiTZcvQWnVPbrftRp1uOCb
	 6SngJQxPeJ7QhaKqn2QZSB8KNhKxcXcqXlI95FIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 115/497] drm/amd/pm/si: Fix updating clock limits on AC/DC
Date: Tue, 13 Oct 2026 13:34:42 +0200
Message-ID: <20261013112910.620093740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7207,6 +7207,19 @@ static void si_parse_pplib_non_clock_inf
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
@@ -7215,7 +7228,6 @@ static void si_parse_pplib_clock_info(st
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(adev);
 	struct si_power_info *si_pi = si_get_pi(adev);
 	struct  si_ps *ps = si_get_ps(rps);
-	struct amdgpu_clock_and_voltage_limits *limits;
 	u16 leakage_voltage;
 	struct rv7xx_pl *pl = &ps->performance_levels[index];
 	int ret;
@@ -7280,26 +7292,14 @@ static void si_parse_pplib_clock_info(st
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


