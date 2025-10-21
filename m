Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1E26C3BE;
	Tue, 21 Oct 2025 19:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076412; cv=none; b=cdOXQ/v82ti58Mih3JfcksuWRzRylSAlaj68NOkh4WcUvdMC82Y1PZbQuXqDOkaNMlupxsLTUd69FQsY+sgUA7KMnak4a380L608T5zLjDp6IzxvLeTiUy4DWdIGNeSK/wa1E6a0LPnmahiLYYqqqZZTYs0nie4TmRBWNpX+RmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076412; c=relaxed/simple;
	bh=sFvRo7wFSThEHtZfMRAwrs1FQ7OH+g3Eyt6YnQaUpW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEbHX9CBDvyUAmu/l2dt/u+z7M52osOIQfREzSbYF3gsAWFOLr7g6R4VxPlK0xOhO7htKjHc2JFMF9nN4hNqcaqgzQtjI5xtCDS+nl5cDuAIF+k+Fgljrg6h7Ax49GC+LMS/1oP2Zj3k78wobhYAOSjgn2XHOJNVm1+wEZl2fk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqwOTQTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqwOTQTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF57C4CEF1;
	Tue, 21 Oct 2025 19:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076412;
	bh=sFvRo7wFSThEHtZfMRAwrs1FQ7OH+g3Eyt6YnQaUpW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqwOTQTA4+NljJ6hJG6zPzvYAMpTlbbtc4dOzqU/BVSTxVDp/kWgjzPXA4kW0LlTb
	 LOHeR+/w4JHcqc2Xld2m/wYE8iN60Mpjbz6utSymZffUhDdM47yZpVF3yh5qaBd5m8
	 XdmMNjuhBvACMnGbTGa43XJVuRYxTqvt3+DxYWBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/105] media: nxp: imx8-isi: Drop unused argument to mxc_isi_channel_chain()
Date: Tue, 21 Oct 2025 21:50:35 +0200
Message-ID: <20251021195022.320505489@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 9a21ffeade25cbf310f5db39a1f9932695dd41bb ]

The bypass argument to the mxc_isi_channel_chain() function is unused.
Drop it.

Link: https://lore.kernel.org/r/20250813225501.20762-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: 178aa3360220 ("media: nxp: imx8-isi: m2m: Fix streaming cleanup on release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.h |    2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c   |    2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c  |   11 +++++------
 drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c |    2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.h
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.h
@@ -361,7 +361,7 @@ void mxc_isi_channel_get(struct mxc_isi_
 void mxc_isi_channel_put(struct mxc_isi_pipe *pipe);
 void mxc_isi_channel_enable(struct mxc_isi_pipe *pipe);
 void mxc_isi_channel_disable(struct mxc_isi_pipe *pipe);
-int mxc_isi_channel_chain(struct mxc_isi_pipe *pipe, bool bypass);
+int mxc_isi_channel_chain(struct mxc_isi_pipe *pipe);
 void mxc_isi_channel_unchain(struct mxc_isi_pipe *pipe);
 
 void mxc_isi_channel_config(struct mxc_isi_pipe *pipe,
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
@@ -589,7 +589,7 @@ void mxc_isi_channel_release(struct mxc_
  *
  * TODO: Support secondary line buffer for downscaling YUV420 images.
  */
-int mxc_isi_channel_chain(struct mxc_isi_pipe *pipe, bool bypass)
+int mxc_isi_channel_chain(struct mxc_isi_pipe *pipe)
 {
 	/* Channel chaining requires both line and output buffer. */
 	const u8 resources = MXC_ISI_CHANNEL_RES_OUTPUT_BUF
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
@@ -493,7 +493,6 @@ static int mxc_isi_m2m_streamon(struct f
 	const struct mxc_isi_format_info *cap_info = ctx->queues.cap.info;
 	const struct mxc_isi_format_info *out_info = ctx->queues.out.info;
 	struct mxc_isi_m2m *m2m = ctx->m2m;
-	bool bypass;
 	int ret;
 
 	if (q->streaming)
@@ -506,15 +505,15 @@ static int mxc_isi_m2m_streamon(struct f
 		goto unlock;
 	}
 
-	bypass = cap_pix->width == out_pix->width &&
-		 cap_pix->height == out_pix->height &&
-		 cap_info->encoding == out_info->encoding;
-
 	/*
 	 * Acquire the pipe and initialize the channel with the first user of
 	 * the M2M device.
 	 */
 	if (m2m->usage_count == 0) {
+		bool bypass = cap_pix->width == out_pix->width &&
+			      cap_pix->height == out_pix->height &&
+			      cap_info->encoding == out_info->encoding;
+
 		ret = mxc_isi_channel_acquire(m2m->pipe,
 					      &mxc_isi_m2m_frame_write_done,
 					      bypass);
@@ -531,7 +530,7 @@ static int mxc_isi_m2m_streamon(struct f
 	 * buffer chaining.
 	 */
 	if (!ctx->chained && out_pix->width > MXC_ISI_MAX_WIDTH_UNCHAINED) {
-		ret = mxc_isi_channel_chain(m2m->pipe, bypass);
+		ret = mxc_isi_channel_chain(m2m->pipe);
 		if (ret)
 			goto deinit;
 
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
@@ -851,7 +851,7 @@ int mxc_isi_pipe_acquire(struct mxc_isi_
 
 	/* Chain the channel if needed for wide resolutions. */
 	if (sink_fmt->width > MXC_ISI_MAX_WIDTH_UNCHAINED) {
-		ret = mxc_isi_channel_chain(pipe, bypass);
+		ret = mxc_isi_channel_chain(pipe);
 		if (ret)
 			mxc_isi_channel_release(pipe);
 	}


