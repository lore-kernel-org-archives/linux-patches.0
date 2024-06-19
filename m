Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75475149C43;
	Wed, 19 Jun 2024 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803654; cv=none; b=OGWlZS5Buvz9OPYLaUwE7wqd37Fykahsibgi7qAVZC4GiAX+boPCvYyYmnjPQvJXfghhZSEix5PAvBlWsa1+YD9lUWV9s3mvAwkMcAtyBt6pMUbLSSfe3Ke0vC+i6WlX/fIECUR2TqT+jPjJOa/OPTN949yCJQWBffAk/lk3RX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803654; c=relaxed/simple;
	bh=OXsgAqexVK+DCYngVWMRmJUQqY+T44O0P3CAmt0aSlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmqdoNPRQ6KyKkXEXQWaxExAcYP4b8l6vQm552XLTbLN5rjbelvjP4J14hnjQ1SDYP3gdaVnamK9samBBeKaoVGxaILSmXblAKI6div7jEvdgtmN7JqmRQ/MPMwmR7JHIF6Br2DHrA5JAimSs9pGzruV7cnQ9o2uE3/LhPGlESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSF2BCbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSF2BCbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DA4C2BBFC;
	Wed, 19 Jun 2024 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803654;
	bh=OXsgAqexVK+DCYngVWMRmJUQqY+T44O0P3CAmt0aSlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSF2BCbfuWJrgQ2uA3nW2qXZ+0gVnyGnZlbXEdQdA40oGkKV5np7t3UdTz+ZdNEt5
	 CaA/54zHXsyrtKJ6GqlXfAt91yxEf8G1TzZQsP9cJwkpd1gHN5w3VRDmvMnk3g6Ul8
	 RQ10qvIcL14y0SxUzIdiI0Lq5cSEwDa0CFWfY7MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/217] drm/amd/display: drop unnecessary NULL checks in debugfs
Date: Wed, 19 Jun 2024 14:55:01 +0200
Message-ID: <20240619125558.918144539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
index ff7dd17ad0763..35ea58fbc1d9d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1369,16 +1369,11 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 
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
@@ -1475,12 +1470,12 @@ static ssize_t dp_dsc_clock_en_write(struct file *f, const char __user *buf,
 
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
@@ -1560,16 +1555,11 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 
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
@@ -1664,12 +1654,12 @@ static ssize_t dp_dsc_slice_width_write(struct file *f, const char __user *buf,
 
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
@@ -1749,16 +1739,11 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 
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
@@ -1853,12 +1838,12 @@ static ssize_t dp_dsc_slice_height_write(struct file *f, const char __user *buf,
 
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
@@ -1934,16 +1919,11 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 
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
@@ -2035,12 +2015,12 @@ static ssize_t dp_dsc_bits_per_pixel_write(struct file *f, const char __user *bu
 
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
@@ -2114,16 +2094,11 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 
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
@@ -2175,16 +2150,11 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 
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
@@ -2251,16 +2221,11 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 
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
@@ -2327,16 +2292,11 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 
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



