Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590DA384;
	Thu, 13 Jun 2024 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282943; cv=none; b=M8Leul+CXoUL90lpxMD4MIuvyE+oBwJEmuLd5HXaosZ71Dgp4xb/fXDCQOOOkxdLm0GCgiLXMBgIfhLvnATCZI20/OcJNopVNpkBjvgZkiPAbxOBjD7wkd0RjDm242blpHVXsw0yaEpv6VBSw8MmEwlZaB5xPrHw1HpTQfQtAow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282943; c=relaxed/simple;
	bh=bdVmSXhUC3h3e9Dek3AsWUqZwZaE3rk5Jtl1X6RqXvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdhFsMRtNt9JP27DYyM1X7a5cBnpSAm0GmYObAC+cCopbsyDhA1pVVFaE+XUs5lxLPl7BxL1TB2KN1yFf69HJaQuCY5C2U4JV0ftmfgkJNZxD9ON4raVygx7t9LVKeR1eQEyrnH9qzQME/b3skLl/XMpjA+XSH5IQLkgm5BjFuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWvxAc3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWvxAc3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA221C2BBFC;
	Thu, 13 Jun 2024 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282943;
	bh=bdVmSXhUC3h3e9Dek3AsWUqZwZaE3rk5Jtl1X6RqXvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWvxAc3RBiNHbPcXUJWDFGBHwuwH3/rzTMtkqIiYJ4SzfqF1+wjTJ4sYFeepdZZK3
	 mOMyXlpCBumKsiDW0XqCwLm8YQpIg/FVcbXLrJtR4Dd0LptLA+TAxZzRYqb1lPvt/X
	 2AVd/++ZS+9XnuiRE1dLjuXCq2jOx3Ecwq8zBtPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ma <li.ma@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 45/85] drm/amdgpu/atomfirmware: add intergrated info v2.3 table
Date: Thu, 13 Jun 2024 13:35:43 +0200
Message-ID: <20240613113215.882023347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ma <li.ma@amd.com>

commit e64e8f7c178e5228e0b2dbb504b9dc75953a319f upstream.

[Why]
The vram width value is 0.
Because the integratedsysteminfo table in VBIOS has updated to 2.3.

[How]
Driver needs a new intergrated info v2.3 table too.
Then the vram width value will be correct.

Signed-off-by: Li Ma <li.ma@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c |   15 ++++++++
 drivers/gpu/drm/amd/include/atomfirmware.h       |   43 +++++++++++++++++++++++
 2 files changed, 58 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -207,6 +207,7 @@ union igp_info {
 	struct atom_integrated_system_info_v1_11 v11;
 	struct atom_integrated_system_info_v1_12 v12;
 	struct atom_integrated_system_info_v2_1 v21;
+	struct atom_integrated_system_info_v2_3 v23;
 };
 
 union umc_info {
@@ -347,6 +348,20 @@ amdgpu_atomfirmware_get_vram_info(struct
 					if (vram_type)
 						*vram_type = convert_atom_mem_type_to_vram_type(adev, mem_type);
 					break;
+				case 3:
+					mem_channel_number = igp_info->v23.umachannelnumber;
+					if (!mem_channel_number)
+						mem_channel_number = 1;
+					mem_type = igp_info->v23.memorytype;
+					if (mem_type == LpDdr5MemType)
+						mem_channel_width = 32;
+					else
+						mem_channel_width = 64;
+					if (vram_width)
+						*vram_width = mem_channel_number * mem_channel_width;
+					if (vram_type)
+						*vram_type = convert_atom_mem_type_to_vram_type(adev, mem_type);
+					break;
 				default:
 					return -EINVAL;
 				}
--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -1624,6 +1624,49 @@ struct atom_integrated_system_info_v2_2
 	uint32_t  reserved4[189];
 };
 
+struct uma_carveout_option {
+  char       optionName[29];        //max length of string is 28chars + '\0'. Current design is for "minimum", "Medium", "High". This makes entire struct size 64bits
+  uint8_t    memoryCarvedGb;        //memory carved out with setting
+  uint8_t    memoryRemainingGb;     //memory remaining on system
+  union {
+    struct _flags {
+      uint8_t Auto     : 1;
+      uint8_t Custom   : 1;
+      uint8_t Reserved : 6;
+    } flags;
+    uint8_t all8;
+  } uma_carveout_option_flags;
+};
+
+struct atom_integrated_system_info_v2_3 {
+  struct  atom_common_table_header table_header;
+  uint32_t  vbios_misc; // enum of atom_system_vbiosmisc_def
+  uint32_t  gpucapinfo; // enum of atom_system_gpucapinf_def
+  uint32_t  system_config;
+  uint32_t  cpucapinfo;
+  uint16_t  gpuclk_ss_percentage; // unit of 0.001%,   1000 mean 1%
+  uint16_t  gpuclk_ss_type;
+  uint16_t  dpphy_override;  // bit vector, enum of atom_sysinfo_dpphy_override_def
+  uint8_t memorytype;       // enum of atom_dmi_t17_mem_type_def, APU memory type indication.
+  uint8_t umachannelnumber; // number of memory channels
+  uint8_t htc_hyst_limit;
+  uint8_t htc_tmp_limit;
+  uint8_t reserved1; // dp_ss_control
+  uint8_t gpu_package_id;
+  struct  edp_info_table  edp1_info;
+  struct  edp_info_table  edp2_info;
+  uint32_t  reserved2[8];
+  struct  atom_external_display_connection_info extdispconninfo;
+  uint8_t UMACarveoutVersion;
+  uint8_t UMACarveoutIndexMax;
+  uint8_t UMACarveoutTypeDefault;
+  uint8_t UMACarveoutIndexDefault;
+  uint8_t UMACarveoutType;           //Auto or Custom
+  uint8_t UMACarveoutIndex;
+  struct  uma_carveout_option UMASizeControlOption[20];
+  uint8_t reserved3[110];
+};
+
 // system_config
 enum atom_system_vbiosmisc_def{
   INTEGRATED_SYSTEM_INFO__GET_EDID_CALLBACK_FUNC_SUPPORT = 0x01,


