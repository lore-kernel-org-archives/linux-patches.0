Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7597C171083;
	Wed,  3 Jul 2024 11:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005343; cv=none; b=mQgRtQxl0N2ET/8a41lWGygs0cTowzlCJa1WlYAey2n7sENl0WNc+9JI2kiQc39h1geCrkCqutqp0NB65d0vdVJVkzNI8OlkPEzqe5hyDnHL79HIjq6wxsdQPTo/Am3TDKp6yjzRJ2N2O5xu4whuJYpv0UCM8+eN4qcekeA4p0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005343; c=relaxed/simple;
	bh=Vk6YvqEMhaKXyjikk/6SSdJEWuWz46vRh3O1nwzY7lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoya/LaQ75hyY6h65QFG5zUg/OJZtiav6pHlqsrWoo+KcP/j5mF5fbjLq3S9QshTKPNRpmkOgr0H/tchImyUY91tJY3UQQ47Nac9b23IFdNXNXHbtl99nxbpKPAE7pxI1w0i8xWA/EaY0pBEgnG0Cfmc/DZn0jTUKixo+abSLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cz+wFS5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cz+wFS5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A529C2BD10;
	Wed,  3 Jul 2024 11:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005343;
	bh=Vk6YvqEMhaKXyjikk/6SSdJEWuWz46vRh3O1nwzY7lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cz+wFS5JoA8K9cmbnoT+MWuFfLcHELkyLNqpargqN+Ui+4x1Kbo2I5KsqXFFqvdNX
	 LoDVF5CI4nsvkAdq8pZIwEZFQxcYiYpZJ6Khw+XivsCSVvQhT8FDkhu8Ndw+zB5lUh
	 bGz9cX2+36zVRBaWyN4uII3H/38+w5xvzLs2nrvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/356] drm/amd/display: drop unnecessary NULL checks in debugfs
Date: Wed,  3 Jul 2024 12:36:18 +0200
Message-ID: <20240703102914.687838203@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit f8e12e770e8049917f82387033b3cf44bc43b915 ]

pipe_ctx pointer cannot be NULL when getting the address of
an element of the pipe_ctx array. Moreover, the MAX_PIPES is
defined as 6, so pipe_ctx is not NULL after the loop either.

Detected using the static analysis tool - Svace.

Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 892b41b16f61 ("drm/amd/display: Fix incorrect DSC instance for MST")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 72 +++++--------------
 1 file changed, 16 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index fc0f6b0089ba0..939734eecf709 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1315,16 +1315,11 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -1421,12 +1416,12 @@ static ssize_t dp_dsc_clock_en_write(struct file *f, const char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx || !pipe_ctx->stream)
+	if (!pipe_ctx->stream)
 		goto done;
 
 	// Get CRTC state
@@ -1506,16 +1501,11 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -1610,12 +1600,12 @@ static ssize_t dp_dsc_slice_width_write(struct file *f, const char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx || !pipe_ctx->stream)
+	if (!pipe_ctx->stream)
 		goto done;
 
 	// Safely get CRTC state
@@ -1695,16 +1685,11 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -1799,12 +1784,12 @@ static ssize_t dp_dsc_slice_height_write(struct file *f, const char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx || !pipe_ctx->stream)
+	if (!pipe_ctx->stream)
 		goto done;
 
 	// Get CRTC state
@@ -1880,16 +1865,11 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -1981,12 +1961,12 @@ static ssize_t dp_dsc_bits_per_pixel_write(struct file *f, const char __user *bu
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx || !pipe_ctx->stream)
+	if (!pipe_ctx->stream)
 		goto done;
 
 	// Get CRTC state
@@ -2060,16 +2040,11 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -2121,16 +2096,11 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -2197,16 +2167,11 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
@@ -2273,16 +2238,11 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
-		if (pipe_ctx && pipe_ctx->stream &&
+		if (pipe_ctx->stream &&
 		    pipe_ctx->stream->link == aconnector->dc_link)
 			break;
 	}
 
-	if (!pipe_ctx) {
-		kfree(rd_buf);
-		return -ENXIO;
-	}
-
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
 		dsc->funcs->dsc_read_state(dsc, &dsc_state);
-- 
2.43.0



