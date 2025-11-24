Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76782E03E6;
	Mon, 24 Nov 2025 08:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971616; cv=none; b=sEF+xmcyXGBFN9NIT2oEUeTdArxjyGJqKWFBNpn2BgtRCNLj5JkT02PSElq68N/VM+RHQJHSH7yisN+GWz7NB/HOcWusgJ9ULZMI4pcmF21+zAp275FeZNny0qDvEoNwv/Xsc6vkDDbIqWuhMJAF95pubgAGgThWdxlbAVZ3AE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971616; c=relaxed/simple;
	bh=25K/SZ3uMvx1LjPKnyF10T/8NBDtY9DShcqCidGqSeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RsFaufxaFHwq9Xn+ss4Pz/g+vr2V4WnK1B7w+fQRzal7luO01zVpS/adU8zfnluveXwryFJtK0Dvq/Qon/1iRHmtM20Ecw9DbuONB7CIPfnzHd9hm2LfItuMIllfu0P/nKa6HMyimkupyXesGa/vBC9vz3UomG3UysYZ4VAjfaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uAe18yvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAe18yvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1235AC4CEF1;
	Mon, 24 Nov 2025 08:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971616;
	bh=25K/SZ3uMvx1LjPKnyF10T/8NBDtY9DShcqCidGqSeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAe18yvlZgM+XQ0ZEz82ygqX9cSQZIkEDM6zEkLIZ49Rgu17BjHKnoJID/B4ucK7z
	 EeMY7zSgqGbgQsoUd74Mmf3IrSVtu5IBwrmrgClx8iYU1A77bkAnq6nGFlpObfohiV
	 buanO8YdDYBMXeg0eOiSYuS5urzg97zEP7O+q5/BjfwbKNu4cnFjXK368zfg7Fti8+
	 /xiSTQLUmcvz6eQDntWdawc9XQUSBAdN/lU9IohAqQs+ZXiBfcdamuQveNwE3zXgn/
	 2Z837ixN6nKgbZ7ikkkP6TK338Wc5PDzhb/7C54f82aUhue8MrIkjAzqPydXOB3m7A
	 qFa0Tr2l3YQEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mpearson-lenovo@squebb.ca,
	mario.limonciello@amd.com,
	kuurtb@gmail.com,
	luzmaximilian@gmail.com,
	edip@medip.dev,
	julien.robin28@free.fr,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] platform/x86: hp-wmi: Add Omen 16-wf1xxx fan support
Date: Mon, 24 Nov 2025 03:06:21 -0500
Message-ID: <20251124080644.3871678-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit fb146a38cb119c8d69633851c7a2ce2c8d34861a ]

The newer HP Omen laptops, such as Omen 16-wf1xxx, use the same
WMI-based thermal profile interface as Victus 16-r1000 and 16-s1000
models.

Add the DMI board name "8C78" to the victus_s_thermal_profile_boards
list to enable proper fan and thermal mode control.

Tested on: HP Omen 16-wf1xxx (board 8C78)
Result:
* Fan RPMs are readable
* echo 0 | sudo tee /sys/devices/platform/hp-wmi/hwmon/*/pwm1_enable
  allows the fans to run on max RPM.

Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20251018111001.56625-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

1. **Commit Message Analysis**:
   - **Subject**: "platform/x86: hp-wmi: Add Omen 16-wf1xxx fan support"
   - **Problem**: HP Omen 16-wf1xxx laptops (board ID "8C78") lack fan
     and thermal profile control.
   - **Fix**: Adds the board ID to the driver's whitelist
     (`victus_s_thermal_profile_boards`), enabling the existing WMI
     thermal interface for this model.
   - **Signals**: Tested on hardware (positive), Reviewed by maintainer
     (positive). No "Fixes:" tag, but fixes a hardware support gap.

2. **Deep Code Research**:
   - **File**: `drivers/platform/x86/hp/hp-wmi.c`
   - **Mechanism**: The driver uses
     `dmi_get_system_info(DMI_BOARD_NAME)` to match against
     `victus_s_thermal_profile_boards`. If matched,
     `is_victus_s_thermal_profile()` returns true, enabling
     `hp_wmi_hwmon_read`/`write` callbacks to handle fan speed and
     thermal profiles via the EC.
   - **Codebase Context**: The `victus_s` infrastructure was introduced
     in commit `6e4ab59b8391a` (Jan 2025) and is present in the current
     stable tree (linux-6.17.y).
   - **Precedent**: Commit `748f897511446` (Jul 2025) previously added
     board IDs "8C99" and "8C9C" to the same array and was
     backported/present in the stable tree.
   - **Backport Detail**: The patch context shows IDs ("8BBE", "8BD4")
     that are missing from the current stable tree. This indicates the
     patch will not apply cleanly (`git apply` will fail on context),
     but the logic is independent. A trivial backport (manual context
     adjustment) is required to insert "8C78" into the existing array.

3. **Stable Kernel Rules Compliance**:
   - **Exception Category**: **New Device IDs** (Explicitly allowed).
     The stable rules permit adding PCI/USB/ACPI IDs to existing drivers
     to enable hardware support. Adding a DMI board string functions
     identically to adding a Device ID.
   - **User Impact**: High for owners of this hardware (fixes broken
     thermal management). Low for everyone else.
   - **Risk**: Negligible. The change is isolated to a specific hardware
     signature.
   - **Criteria**: obviously correct (adding string to array), fixes
     real bug (missing functionality), small scope (1 line).

4. **Conclusion**:
  The commit effectively acts as a Device ID / Quirk addition, which is
  a standard exception for stable backports. It enables essential
  hardware functionality using existing, tested driver paths. The
  missing context in the stable tree is a minor logistical issue
  (requires fuzz/manual merge) but does not invalidate the technical
  correctness or safety of the fix.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 9a668e2587952..e10c75d91f248 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -95,7 +95,7 @@ static const char * const victus_thermal_profile_boards[] = {
 /* DMI Board names of Victus 16-r and Victus 16-s laptops */
 static const char * const victus_s_thermal_profile_boards[] = {
 	"8BBE", "8BD4", "8BD5",
-	"8C99", "8C9C"
+	"8C78", "8C99", "8C9C",
 };
 
 enum hp_wmi_radio {
-- 
2.51.0

