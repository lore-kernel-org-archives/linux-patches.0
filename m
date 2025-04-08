Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7426B0A9;
	Tue,  8 Apr 2025 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114375; cv=none; b=UDZVZk+xO/tGwfhtiY/zDpc5VYMTNAG0H0nh34AdBnXMCz849UjXSz4XwSi7fJDyBTtK/2FYXIFjppj2na8Fe2Ag1FG7espibCNrAN4AbAO2Nj5K8Hhfvhtb0fUTe36DBg8UWQyr/iLA5fSGBHK/Qa6ElVrAcefAQMSrhK8rjSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114375; c=relaxed/simple;
	bh=4KenFOrGQ0OtXmHIJ0OHtTbbpVP6W/5Sf97E93zQbhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgvGTT5IZ4/My2DJ355PmQ1yNdELmIHa5Iyjbgxx7iSGIkpik7KSmomQ/zwbsk9s8R7od4mHXL2e5MgQVIjO7X0cV/Lxab1sV2shNCYsvQRZYag2y/yx87ZpL0jzm41hCEYpgIGJq3wcHTpNClPDh01aTbm6CCmRoxxmNOtnGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7tnnTD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7tnnTD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B2CC4CEE5;
	Tue,  8 Apr 2025 12:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114375;
	bh=4KenFOrGQ0OtXmHIJ0OHtTbbpVP6W/5Sf97E93zQbhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7tnnTD/hqF9H8jXNIg6IwV20YcD496ETtyNxqIu5EaNT2PwgVtLI9nMmOYOUuZCZ
	 ZtZ/M7IDMI/14KL0Sotk/aQ1bbKWs9ZqCbUs6JdIDYXVnxdup+rLH+6slwXmOajZD/
	 TFYa0NF60FEJWOMkBI1VmQkfknhxeDTb56fwmoiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 081/499] drm/amd/display: fix an indent issue in DML21
Date: Tue,  8 Apr 2025 12:44:53 +0200
Message-ID: <20250408104853.244418377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3d41ffde91c1b..32611ce93f589 100644
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



