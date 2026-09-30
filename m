Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F39A549373;
	Wed, 30 Sep 2026 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789732; cv=none; b=i4exYC9VnX1gQmiHDhOfvrqjtlGqO9Dmkc9vFsaXlD0D/FsPct15mI1eCZZEr0x0lqNHQFDUWniIwOLiqstqs32e5gUQqrn7G37LvNJgv27nHpJaK9uv4XrHxQ2ACTI0P+m/We65SLLvyl9qXgAlSu/IGc38NJXgOUaL10TR4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789732; c=relaxed/simple;
	bh=w82juoWewfnceDnDON4bBVMKMTRqhPHW6mPhFqfitC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkIeFJlfzeMjc/SYnC54E9vcX7UKsyVTd22JiVwxVwNcl0iJcphEZo+O5BhRvIXzA1aU77LHifYAiopCHVgxiesFOhsr30ok1qcvnCj/Jd+DYsVl6SSV73v53h7OFxhPdNb90ESFlSck/G0r2PumPwv2zMRhlawJ8MkoIEdq4oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW+gA6bG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW+gA6bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A6A1F008A5;
	Wed, 30 Sep 2026 17:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789729;
	bh=NAPcPaGVJmUqqVUh1WWpibjl9pIrl/B/XXwrtkUzx8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gW+gA6bGHbIIp9DrZaSo7gzGJX/uBmDYaKq47CMrd+EciDKujx4Dpp+MThKiMHx13
	 WUQxXLBmmO8H1EIVEQZE0S57LK8ofW7+NTK9oguPcYYUzG52qkqVZhBjIRlD4fGTfI
	 Zp2N7W3V/AT3XPQG4NASy2uutq0u4BUxCBzOGieA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 579/877] platform/x86: ISST: Check for admin capability for write commands
Date: Wed, 30 Sep 2026 17:24:50 +0200
Message-ID: <20260930152427.138431957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -620,7 +620,7 @@ static long isst_if_core_power_state(voi
 		return -EINVAL;
 
 	if (core_power.get_set) {
-		if (power_domain_info->write_blocked)
+		if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
 		if (core_power.enable > SST_CP_MAX_ENABLE ||
@@ -679,7 +679,7 @@ static long isst_if_clos_param(void __us
 		return -EINVAL;
 
 	if (clos_param.get_set) {
-		if (power_domain_info->write_blocked)
+		if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
 		if (!in_range(clos_param.min_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
@@ -790,7 +790,8 @@ static long isst_if_clos_assoc(void __us
 
 		power_domain_info = &sst_inst->power_domain_info[part][punit_id];
 
-		if (assoc_cmds.get_set && power_domain_info->write_blocked)
+		if (assoc_cmds.get_set && (power_domain_info->write_blocked ||
+					   !capable(CAP_SYS_ADMIN)))
 			return -EPERM;
 
 		offset = SST_CLOS_ASSOC_0_OFFSET +
@@ -968,7 +969,7 @@ static int isst_if_set_perf_level(void _
 	if (!power_domain_info)
 		return -EINVAL;
 
-	if (power_domain_info->write_blocked)
+	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (!(power_domain_info->pp_header.allowed_level_mask & BIT(perf_level.level)))
@@ -1028,7 +1029,7 @@ static int isst_if_set_perf_feature(void
 	if (!power_domain_info)
 		return -EINVAL;
 
-	if (power_domain_info->write_blocked)
+	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)


