Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432773F4DE2;
	Sat, 12 Sep 2026 09:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205513; cv=none; b=rNm8uEqYex237+XK903ZHGXzG+2+jn9p5/GLEWmLEZiClY/SBLHwg19yXcy3NFzLpo9sMVfJQwIBrzaufHcWJTqWy+Twdl7fCnBAzbmECr3Yq0ZxhVnHD5pTdmiuajR5nRJ5annXOrfvwLi0MmxzRPp2gQKECYLSJpdt6PBlwkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205513; c=relaxed/simple;
	bh=3JWDh6vVpbgyVdSFZBLUD6zqM98BQwZD7hhqSQ2LnCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDBJXWe6aGmbM4e53CqQOukvsjgtNxIcuBejYFAoLI4OAfqMKoS+S9FV/Ecy7iXZ+yGJnIe+KvV/ORqEPfyMWeSMeU8XB7vQOiWuJz2ijUv/Ko9HIehy1Q2x6VhzpK15x/GJnd1A1/NGLEy+kKwnNPX2bYWZBcywELHG2DxTQ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYdTkbGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYdTkbGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD55B1F000FF;
	Sat, 12 Sep 2026 09:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205511;
	bh=fwmtbUrrkzsj+VC5u9/4cHUFnyBq8W6EmE7r3HD9SMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYdTkbGwajyVKLsFnICBsy4ZdgMFBPpO1eEzbUI2CVjFmIHH1+3nDWtgdfrqf04rF
	 yy1QPgVngBJ80LAXp8DIMjkr4ZQ/4GAoxxfFWLBieTGsfICcE2vqENrGMS7Mpjdb95
	 ULoM4V8y3rrNLtI9yUQI7+eRF3/JIqB7pLj3iFEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0018/1518] platform/x86: ISST: Check for admin capability for write commands
Date: Sat, 12 Sep 2026 08:36:27 +0200
Message-ID: <20260912065623.830471111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 69cd1ca440a96c85dcedcddfa5e0af6012f60b8b ]

In some SST deployments, administrators want to allow reading SST
capabilities for non-root users. This can be achieved by changing file
permissions for "/dev/isst_interface", but they still want to prevent
any changes to the SST configuration by non-root users.

This capability was available before for non-TPMI SST. Extend the same
capability for TPMI SST by adding a check for CAP_SYS_ADMIN for all
write commands.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260107060729.1634420-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: e45d6b847286 ("platform/x86: ISST: Validate max level for set feature")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -625,7 +625,7 @@ static long isst_if_core_power_state(voi
 		return -EINVAL;
 
 	if (core_power.get_set) {
-		if (power_domain_info->write_blocked)
+		if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
 		if (core_power.enable > SST_CP_MAX_ENABLE ||
@@ -684,7 +684,7 @@ static long isst_if_clos_param(void __us
 		return -EINVAL;
 
 	if (clos_param.get_set) {
-		if (power_domain_info->write_blocked)
+		if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
 		if (!in_range(clos_param.min_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
@@ -795,7 +795,8 @@ static long isst_if_clos_assoc(void __us
 
 		power_domain_info = &sst_inst->power_domain_info[part][punit_id];
 
-		if (assoc_cmds.get_set && power_domain_info->write_blocked)
+		if (assoc_cmds.get_set && (power_domain_info->write_blocked ||
+					   !capable(CAP_SYS_ADMIN)))
 			return -EPERM;
 
 		offset = SST_CLOS_ASSOC_0_OFFSET +
@@ -973,7 +974,7 @@ static int isst_if_set_perf_level(void _
 	if (!power_domain_info)
 		return -EINVAL;
 
-	if (power_domain_info->write_blocked)
+	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (!(power_domain_info->pp_header.allowed_level_mask & BIT(perf_level.level)))
@@ -1033,7 +1034,7 @@ static int isst_if_set_perf_feature(void
 	if (!power_domain_info)
 		return -EINVAL;
 
-	if (power_domain_info->write_blocked)
+	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)


