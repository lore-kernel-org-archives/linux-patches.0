Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F02121ADC7;
	Tue, 29 Apr 2025 17:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947207; cv=none; b=fZ+c5I7z80FgKt4jhmbIAgetkV1pH1yQtzK4LA2y5v3lJ05iBsCgm4DuUqRNMm9S+ocnvHngxuHW3WV2FPan5y8uimZgcNnmzxzdVealjmtzWLgV38QrId/RI6Z0NcQy/t7qrk7poj4Hb0nbf6y1E0qmGpdI4GWunONypT+JlzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947207; c=relaxed/simple;
	bh=CEUM0RMPCBkNyPplMuNYjQso9n1kd9VHjZhuYYmaNok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhJIlhmmp7+EirpqGRO66NdlpxvOou1va9FUdzM5yP99fZCppeHtFW8JQh7b7r6/OP4pCBhUgJ3UXRj+y93uZvHzZqmB7UW2UJGL7yADhnSRdaFajodaGbddAWxdLKYLX7HOsWMMkEFhaGM1GeISMBlllawiqhIWjFiCP93uTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/zi/af+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/zi/af+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39952C4CEE3;
	Tue, 29 Apr 2025 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947206;
	bh=CEUM0RMPCBkNyPplMuNYjQso9n1kd9VHjZhuYYmaNok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/zi/af+h564VujNRKFeL5b6bWxzE30wNHE3F0HhmGys+0uAt94j6fn581ZYq7W3V
	 0saVZ97+jdRoH7uri8USW1cNVBTqwyldus6f+NH8OJ/ylx40Kff0z3+ORYObsT8juC
	 k7p0/wjEtZUy8maqFa5ar3VZsnMDVrSda5d8tah4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/286] media: venus: Rename venus_caps to hfi_plat_caps
Date: Tue, 29 Apr 2025 18:41:51 +0200
Message-ID: <20250429161116.469067057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit 8f3b41dcfb9a0fa2d2ca0af51c3eebd670dc153b ]

Now when we have hfi platform make venus capabilities an
hfi platform capabilities.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9edaaa8e3e15 ("media: venus: hfi_parser: refactor hfi packet parsing logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.h      | 30 ++-----------------
 drivers/media/platform/qcom/venus/helpers.c   |  6 ++--
 .../media/platform/qcom/venus/hfi_parser.c    | 18 +++++------
 .../media/platform/qcom/venus/hfi_parser.h    |  2 +-
 .../media/platform/qcom/venus/hfi_platform.h  | 25 ++++++++++++++++
 5 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 53d3202460ae9..785a5bbb19c3c 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -14,6 +14,7 @@
 
 #include "dbgfs.h"
 #include "hfi.h"
+#include "hfi_platform.h"
 
 #define VDBGL	"VenusLow : "
 #define VDBGM	"VenusMed : "
@@ -82,31 +83,6 @@ struct venus_format {
 	u32 flags;
 };
 
-#define MAX_PLANES		4
-#define MAX_FMT_ENTRIES		32
-#define MAX_CAP_ENTRIES		32
-#define MAX_ALLOC_MODE_ENTRIES	16
-#define MAX_CODEC_NUM		32
-#define MAX_SESSIONS		16
-
-struct raw_formats {
-	u32 buftype;
-	u32 fmt;
-};
-
-struct venus_caps {
-	u32 codec;
-	u32 domain;
-	bool cap_bufs_mode_dynamic;
-	unsigned int num_caps;
-	struct hfi_capability caps[MAX_CAP_ENTRIES];
-	unsigned int num_pl;
-	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
-	unsigned int num_fmts;
-	struct raw_formats fmts[MAX_FMT_ENTRIES];
-	bool valid;	/* used only for Venus v1xx */
-};
-
 /**
  * struct venus_core - holds core parameters valid for all instances
  *
@@ -199,7 +175,7 @@ struct venus_core {
 	void *priv;
 	const struct hfi_ops *ops;
 	struct delayed_work work;
-	struct venus_caps caps[MAX_CODEC_NUM];
+	struct hfi_plat_caps caps[MAX_CODEC_NUM];
 	unsigned int codecs_count;
 	unsigned int core0_usage_count;
 	unsigned int core1_usage_count;
@@ -434,7 +410,7 @@ static inline void *to_hfi_priv(struct venus_core *core)
 	return core->priv;
 }
 
-static inline struct venus_caps *
+static inline struct hfi_plat_caps *
 venus_caps_by_codec(struct venus_core *core, u32 codec, u32 domain)
 {
 	unsigned int c;
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 9ad8abdc4d4f2..dcf9fc0da1ce4 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -481,7 +481,7 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
 static bool is_dynamic_bufmode(struct venus_inst *inst)
 {
 	struct venus_core *core = inst->core;
-	struct venus_caps *caps;
+	struct hfi_plat_caps *caps;
 
 	/*
 	 * v4 doesn't send BUFFER_ALLOC_MODE_SUPPORTED property and supports
@@ -1539,7 +1539,7 @@ void venus_helper_init_instance(struct venus_inst *inst)
 }
 EXPORT_SYMBOL_GPL(venus_helper_init_instance);
 
-static bool find_fmt_from_caps(struct venus_caps *caps, u32 buftype, u32 fmt)
+static bool find_fmt_from_caps(struct hfi_plat_caps *caps, u32 buftype, u32 fmt)
 {
 	unsigned int i;
 
@@ -1556,7 +1556,7 @@ int venus_helper_get_out_fmts(struct venus_inst *inst, u32 v4l2_fmt,
 			      u32 *out_fmt, u32 *out2_fmt, bool ubwc)
 {
 	struct venus_core *core = inst->core;
-	struct venus_caps *caps;
+	struct hfi_plat_caps *caps;
 	u32 ubwc_fmt, fmt = to_hfi_raw_fmt(v4l2_fmt);
 	bool found, found_ubwc;
 
diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index 94981a5e8e9af..be9a58ef04d86 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -11,12 +11,12 @@
 #include "hfi_helper.h"
 #include "hfi_parser.h"
 
-typedef void (*func)(struct venus_caps *cap, const void *data,
+typedef void (*func)(struct hfi_plat_caps *cap, const void *data,
 		     unsigned int size);
 
 static void init_codecs(struct venus_core *core)
 {
-	struct venus_caps *caps = core->caps, *cap;
+	struct hfi_plat_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
 	core->codecs_count = 0;
@@ -39,11 +39,11 @@ static void init_codecs(struct venus_core *core)
 	}
 }
 
-static void for_each_codec(struct venus_caps *caps, unsigned int caps_num,
+static void for_each_codec(struct hfi_plat_caps *caps, unsigned int caps_num,
 			   u32 codecs, u32 domain, func cb, void *data,
 			   unsigned int size)
 {
-	struct venus_caps *cap;
+	struct hfi_plat_caps *cap;
 	unsigned int i;
 
 	for (i = 0; i < caps_num; i++) {
@@ -56,7 +56,7 @@ static void for_each_codec(struct venus_caps *caps, unsigned int caps_num,
 }
 
 static void
-fill_buf_mode(struct venus_caps *cap, const void *data, unsigned int num)
+fill_buf_mode(struct hfi_plat_caps *cap, const void *data, unsigned int num)
 {
 	const u32 *type = data;
 
@@ -86,7 +86,7 @@ parse_alloc_mode(struct venus_core *core, u32 codecs, u32 domain, void *data)
 	}
 }
 
-static void fill_profile_level(struct venus_caps *cap, const void *data,
+static void fill_profile_level(struct hfi_plat_caps *cap, const void *data,
 			       unsigned int num)
 {
 	const struct hfi_profile_level *pl = data;
@@ -115,7 +115,7 @@ parse_profile_level(struct venus_core *core, u32 codecs, u32 domain, void *data)
 }
 
 static void
-fill_caps(struct venus_caps *cap, const void *data, unsigned int num)
+fill_caps(struct hfi_plat_caps *cap, const void *data, unsigned int num)
 {
 	const struct hfi_capability *caps = data;
 
@@ -143,7 +143,7 @@ parse_caps(struct venus_core *core, u32 codecs, u32 domain, void *data)
 		       fill_caps, caps_arr, num_caps);
 }
 
-static void fill_raw_fmts(struct venus_caps *cap, const void *fmts,
+static void fill_raw_fmts(struct hfi_plat_caps *cap, const void *fmts,
 			  unsigned int num_fmts)
 {
 	const struct raw_formats *formats = fmts;
@@ -228,7 +228,7 @@ static void parser_init(struct venus_inst *inst, u32 *codecs, u32 *domain)
 
 static void parser_fini(struct venus_inst *inst, u32 codecs, u32 domain)
 {
-	struct venus_caps *caps, *cap;
+	struct hfi_plat_caps *caps, *cap;
 	unsigned int i;
 	u32 dom;
 
diff --git a/drivers/media/platform/qcom/venus/hfi_parser.h b/drivers/media/platform/qcom/venus/hfi_parser.h
index 264e6dd2415fe..7f59d82110f9c 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.h
+++ b/drivers/media/platform/qcom/venus/hfi_parser.h
@@ -16,7 +16,7 @@ static inline u32 get_cap(struct venus_inst *inst, u32 type, u32 which)
 {
 	struct venus_core *core = inst->core;
 	struct hfi_capability *cap = NULL;
-	struct venus_caps *caps;
+	struct hfi_plat_caps *caps;
 	unsigned int i;
 
 	caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
diff --git a/drivers/media/platform/qcom/venus/hfi_platform.h b/drivers/media/platform/qcom/venus/hfi_platform.h
index 8b07ecbb4c825..6794232322557 100644
--- a/drivers/media/platform/qcom/venus/hfi_platform.h
+++ b/drivers/media/platform/qcom/venus/hfi_platform.h
@@ -12,6 +12,31 @@
 #include "hfi.h"
 #include "hfi_helper.h"
 
+#define MAX_PLANES		4
+#define MAX_FMT_ENTRIES		32
+#define MAX_CAP_ENTRIES		32
+#define MAX_ALLOC_MODE_ENTRIES	16
+#define MAX_CODEC_NUM		32
+#define MAX_SESSIONS		16
+
+struct raw_formats {
+	u32 buftype;
+	u32 fmt;
+};
+
+struct hfi_plat_caps {
+	u32 codec;
+	u32 domain;
+	bool cap_bufs_mode_dynamic;
+	unsigned int num_caps;
+	struct hfi_capability caps[MAX_CAP_ENTRIES];
+	unsigned int num_pl;
+	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
+	unsigned int num_fmts;
+	struct raw_formats fmts[MAX_FMT_ENTRIES];
+	bool valid;	/* used only for Venus v1xx */
+};
+
 struct hfi_platform_codec_freq_data {
 	u32 pixfmt;
 	u32 session_type;
-- 
2.39.5



