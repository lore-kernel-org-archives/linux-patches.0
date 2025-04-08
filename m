Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C19526B2CD;
	Tue,  8 Apr 2025 12:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116233; cv=none; b=PURcP/pQ6odygpEEOenXMRFuyGBA2qIIrZXbRuOyVTXsfBngExYaZOzJC9SToTpYibBwNf7U/QS1EU+k2XFnvLm3kiE9Yrqpf1BnETNCb65Zk+3cAxphMiSlUQgN/sUnzCrcnzZwi0NO1yVy8ubqRCrGMSYE3H4jA9ZOq4qc5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116233; c=relaxed/simple;
	bh=Stgv6x7VjuMezyJXiOXyo5GBOIQTZFY/hp/+VpHCuRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZX7rZuMh4E/bQWcPeGghQtuw8UQwOaGxsDCOzKN8F1BZDWwPakzZn83tDJf735kGMfWd1hIW1Y101quvIgj3AHrXq1bVxZ/SIhRRvQRVZBW+N5qw16dtTM8NxlXuzgP5SYo+cK2E2Owyg2LqQliQ9q7sxTiyeDmj8KpavJSzTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCTcx35J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCTcx35J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F314C4CEE5;
	Tue,  8 Apr 2025 12:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116233;
	bh=Stgv6x7VjuMezyJXiOXyo5GBOIQTZFY/hp/+VpHCuRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCTcx35JnCcytxtdNhxvM6/iE6aFxrpGGGVmlurb0yk7QBr+zO+FwleUtdHCrcmuj
	 5Xw4DG3NoiYRZhpPs8t/GmItfY4zHuNg3V2Qlo1NvEQQi3a1bYhZpyYIN1gLtRFg9h
	 7CZyBDK9jxV+G9cFywExqpf3iP8yM/rIJlV0aebo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/423] drm/amd/display: fix an indent issue in DML21
Date: Tue,  8 Apr 2025 12:46:31 +0200
Message-ID: <20250408104847.262930789@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit a1addcf8499a566496847f1e36e1cf0b4ad72a26 ]

Remove extraneous tab and newline in dml2_core_dcn4.c that was
reported by the bot

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502211920.txUfwtSj-lkp@intel.com/
Fixes: 70839da6360 ("drm/amd/display: Add new DCN401 sources")
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.c   | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.c
index 0aa4e4d343b04..2c1316d1b6eb8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.c
@@ -139,9 +139,8 @@ bool core_dcn4_initialize(struct dml2_core_initialize_in_out *in_out)
 		core->clean_me_up.mode_lib.ip.subvp_fw_processing_delay_us = core_dcn4_ip_caps_base.subvp_pstate_allow_width_us;
 		core->clean_me_up.mode_lib.ip.subvp_swath_height_margin_lines = core_dcn4_ip_caps_base.subvp_swath_height_margin_lines;
 	} else {
-			memcpy(&core->clean_me_up.mode_lib.ip, &core_dcn4_ip_caps_base, sizeof(struct dml2_core_ip_params));
+		memcpy(&core->clean_me_up.mode_lib.ip, &core_dcn4_ip_caps_base, sizeof(struct dml2_core_ip_params));
 		patch_ip_params_with_ip_caps(&core->clean_me_up.mode_lib.ip, in_out->ip_caps);
-
 		core->clean_me_up.mode_lib.ip.imall_supported = false;
 	}
 
-- 
2.39.5



