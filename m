Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CD0361967;
	Thu, 17 Sep 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665630; cv=none; b=mzZ7dQp064kxtqzqdtMmxnxBhZKhlgXk54wa3B/Tj+9XJ3cYg9YpgAoF39qqkzqjhF3NlEMN+5U0+6MrNMcCHv2pMFWkxLI/FaUEJh81DxV5m0zRfwpLZN+6cKSyjxUfLhWJ4+l1Zf2/vfh/nvPV5f/0iu3h5T9vwXfts4ucUPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665630; c=relaxed/simple;
	bh=ysqEpd1k0kHScMs9o2XgWpgFONcfnJEHwAdyVOsA/is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sv9ew+kHmYR8Vr+4QzBi8IuVgwSaG+4BQbbh49A0JwVBBiRGDL5H2gBEL9Wm0jU4E/2OX8aAPXG3IqJ6oP5V0Ncjf2cgJh6ifOZG4U565/TMvN595sDuLroYgn/LWijE3cNL1AqKQwMmBfFwW2ML3PoIHnPLIM1Wx030BuyVNj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2dwQQmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2dwQQmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3781F00893;
	Thu, 17 Sep 2026 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665629;
	bh=5Qi1TGoALrz41Jc+4YtXkjmxZJZoUbPnADY4wKb3rB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2dwQQmPcHX+mVF5SBx71J1O1Ft+DtWIneCYhy5+XjEYN16JauxWB8wTTjjJo3SYw
	 5K54LAUW27bSmBfO3zu5apRHFyRjlKpFkA5K6CdN/g2m1Yye2Z1kx2Uzw3/KvQ/rXf
	 nCZ/toyQM50TKtFfmtCgPCvesNfxt1IuK1eMFyaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0767/1250] ASoC: Intel: avs: Honor NHLT override when setting up a path
Date: Thu, 17 Sep 2026 16:09:22 +0100
Message-ID: <20260917151612.666466686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit d5c8b7902a41625ea328b52c78ebe750fbf6fef7 ]

In case topology provides NHLT configuration, use it instead of relying
on the table in ACPI tree. Only gateway-related modules e.g.: Copier
care about the process. For those the order of fetching for hardware
configuration becomes:

1) check if NHLT override is set,
2) check if NHLT descriptor override is set,
3) use NHLT from ACPI directly

Such approach ensures no conflicts exist between 1) and 2) and that 1)
always takes precedence.

Co-developed-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251115180627.3589520-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 681e91035dc7 ("ASoC: Intel: avs: Refactor and fix init_config access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/sound/intel/avs/tokens.h |  1 +
 sound/soc/intel/avs/path.c            | 13 +++++++++----
 sound/soc/intel/avs/topology.c        |  7 +++++++
 sound/soc/intel/avs/topology.h        |  1 +
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/uapi/sound/intel/avs/tokens.h b/include/uapi/sound/intel/avs/tokens.h
index f7cbbfb00227a..3ff6d9150822f 100644
--- a/include/uapi/sound/intel/avs/tokens.h
+++ b/include/uapi/sound/intel/avs/tokens.h
@@ -125,6 +125,7 @@ enum avs_tplg_token {
 	AVS_TKN_MOD_KCONTROL_ID_U32			= 1707,
 	AVS_TKN_MOD_INIT_CONFIG_NUM_IDS_U32		= 1708,
 	AVS_TKN_MOD_INIT_CONFIG_ID_U32			= 1709,
+	AVS_TKN_MOD_NHLT_CONFIG_ID_U32			= 1710,
 
 	/* struct avs_tplg_path_template */
 	AVS_TKN_PATH_TMPL_ID_U32			= 1801,
diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index 0c66c8bb2f89d..899906e0bcb46 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -210,9 +210,11 @@ int avs_path_set_constraint(struct avs_dev *adev, struct avs_tplg_path_template
 					continue;
 				}
 
-				blob = avs_nhlt_config_or_default(adev, module_template);
-				if (IS_ERR(blob))
-					continue;
+				if (!module_template->nhlt_config) {
+					blob = avs_nhlt_config_or_default(adev, module_template);
+					if (IS_ERR(blob))
+						continue;
+				}
 
 				rlist[i] = path_template->fe_fmt->sampling_freq;
 				clist[i] = path_template->fe_fmt->num_channels;
@@ -382,7 +384,10 @@ static int avs_fill_gtw_config(struct avs_dev *adev, struct avs_copier_gtw_cfg *
 	struct acpi_nhlt_config *blob;
 	size_t gtw_size;
 
-	blob = avs_nhlt_config_or_default(adev, t);
+	if (t->nhlt_config)
+		blob = t->nhlt_config->blob;
+	else
+		blob = avs_nhlt_config_or_default(adev, t);
 	if (IS_ERR(blob))
 		return PTR_ERR(blob);
 
diff --git a/sound/soc/intel/avs/topology.c b/sound/soc/intel/avs/topology.c
index 67461d27766d9..0a267937044de 100644
--- a/sound/soc/intel/avs/topology.c
+++ b/sound/soc/intel/avs/topology.c
@@ -350,6 +350,7 @@ AVS_DEFINE_PTR_PARSER(modcfg_base, struct avs_tplg_modcfg_base, modcfgs_base);
 AVS_DEFINE_PTR_PARSER(modcfg_ext, struct avs_tplg_modcfg_ext, modcfgs_ext);
 AVS_DEFINE_PTR_PARSER(pplcfg, struct avs_tplg_pplcfg, pplcfgs);
 AVS_DEFINE_PTR_PARSER(binding, struct avs_tplg_binding, bindings);
+AVS_DEFINE_PTR_PARSER(nhlt_config, struct avs_tplg_nhlt_config, nhlt_configs);
 
 static int
 parse_audio_format_bitfield(struct snd_soc_component *comp, void *elem, void *object, u32 offset)
@@ -1200,6 +1201,12 @@ static const struct avs_tplg_token_parser module_parsers[] = {
 		.offset = offsetof(struct avs_tplg_module, num_config_ids),
 		.parse = avs_parse_byte_token,
 	},
+	{
+		.token = AVS_TKN_MOD_NHLT_CONFIG_ID_U32,
+		.type = SND_SOC_TPLG_TUPLE_TYPE_WORD,
+		.offset = offsetof(struct avs_tplg_module, nhlt_config),
+		.parse = avs_parse_nhlt_config_ptr,
+	},
 };
 
 static const struct avs_tplg_token_parser init_config_parsers[] = {
diff --git a/sound/soc/intel/avs/topology.h b/sound/soc/intel/avs/topology.h
index 2d8674bad89a5..b5799c994b887 100644
--- a/sound/soc/intel/avs/topology.h
+++ b/sound/soc/intel/avs/topology.h
@@ -223,6 +223,7 @@ struct avs_tplg_module {
 	u32 ctl_id;
 	u32 num_config_ids;
 	u32 *config_ids;
+	struct avs_tplg_nhlt_config *nhlt_config;
 
 	struct avs_tplg_pipeline *owner;
 	/* Pipeline modules management. */
-- 
2.53.0



