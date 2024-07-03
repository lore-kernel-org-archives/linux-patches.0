Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F513776F;
	Wed,  3 Jul 2024 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005443; cv=none; b=dQ7GzFPu+okbet8O1OUzXW4OXefLk33vdrTJ47Ui8sY/Bhp/wOJEJ76/+KMGV4xFadkQ3UVED0tHRreUuICnVrfZ6UMNKbRDOQkTpa7KFrEvsN//N2zG24J47FcwLi62GElPyrteNtyQLhenPBumZmQASJTzSF6uTPHfZx9w4BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005443; c=relaxed/simple;
	bh=Zqu5jC+tTWSruFlsvochXnUY9LmzvezWBX5rMgqj/eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNArux/5fWi5F9PjXlK5TDudM1HEZMeZ+VyTwX0xWm5PLXXQsr1Y8zpEPnL04si1bPxMlVvP8J2GfauS4OBJjoRPjokvlu+2uDuBcoSG09gZRpSIXt2/ixTO5Im1RYxnhUebyb04WdYc/DxdDdpodNzsOfmFpk7fU2sNzqaS93k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcpdLWJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcpdLWJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA4EC2BD10;
	Wed,  3 Jul 2024 11:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005443;
	bh=Zqu5jC+tTWSruFlsvochXnUY9LmzvezWBX5rMgqj/eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcpdLWJ0r5qT2TdVI10xWNdlwe3L2y0xKOn74Ip0Pp4j/aNnvLo0TaPwDIHPO6HRN
	 +MIgfwe39HuOCfyEnq2xTIAh0gUj1XogPz5Gt2sgyfX5fymbnE0D5rNiJOQMp4KFC9
	 KG+8CjpeRRG7I3ZLiaKyFTr4QoiHXIK3zExEl/1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/356] drm/amd/display: Clean up some inconsistent indenting
Date: Wed,  3 Jul 2024 12:36:17 +0200
Message-ID: <20240703102914.650021553@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 1da2fcc435114ea5a65d7e15fc31b4d0ce11113c ]

Eliminate the follow smatch warning:

drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_srv.c:622
dmub_srv_cmd_execute() warn: inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 892b41b16f61 ("drm/amd/display: Fix incorrect DSC instance for MST")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 72 +++++++++----------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index ed2f6802b0e20..fc0f6b0089ba0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1315,9 +1315,9 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -1421,9 +1421,9 @@ static ssize_t dp_dsc_clock_en_write(struct file *f, const char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx || !pipe_ctx->stream)
@@ -1506,9 +1506,9 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -1610,9 +1610,9 @@ static ssize_t dp_dsc_slice_width_write(struct file *f, const char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx || !pipe_ctx->stream)
@@ -1695,9 +1695,9 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -1799,9 +1799,9 @@ static ssize_t dp_dsc_slice_height_write(struct file *f, const char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx || !pipe_ctx->stream)
@@ -1880,9 +1880,9 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -1981,9 +1981,9 @@ static ssize_t dp_dsc_bits_per_pixel_write(struct file *f, const char __user *bu
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx || !pipe_ctx->stream)
@@ -2060,9 +2060,9 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -2121,9 +2121,9 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -2197,9 +2197,9 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
@@ -2273,9 +2273,9 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream &&
-			    pipe_ctx->stream->link == aconnector->dc_link)
-				break;
+		if (pipe_ctx && pipe_ctx->stream &&
+		    pipe_ctx->stream->link == aconnector->dc_link)
+			break;
 	}
 
 	if (!pipe_ctx) {
-- 
2.43.0



