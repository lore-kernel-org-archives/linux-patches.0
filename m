Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC25246798;
	Tue, 21 Oct 2025 19:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076766; cv=none; b=qRn7tCgnInqCzP0leD1kxoKNOTX9ibUv/IaRmVPRN6ZIbZHgb4AmtLcwSeUnkXEVPf++wn39L6EqcbIwRkg4vzBB9PUJUyEFndbEmbc1oaqG4yIUHjFO2La8hd5lojjhJ3JBJHd/wo4TiLzEY4x7fJ6gLhpyMKIZsZjiR6ZMSf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076766; c=relaxed/simple;
	bh=ltmiJ5sqZS17RtI3/THHg9rXoT61hHoszcD0rr48SHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMUnBrb6OJ3scqa/Jb7zX4Ey0hU4/dHDq9rFOGCernQllhHBlVx3+wJi7tHygntza22dSmhbXBE96hbcj83tQrLJfgwDmF33v9G04vqlhaQYnkwJEnqvVFc7m4dh0O9++r9h0kCTJJYeVskNLlruaW9cPD0MEq6AHwHNLevFJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnDsi4FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnDsi4FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68BEC4CEF1;
	Tue, 21 Oct 2025 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076766;
	bh=ltmiJ5sqZS17RtI3/THHg9rXoT61hHoszcD0rr48SHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnDsi4FDh2pmyjUq+gbCNj4RRwVThSU+5X+wedwESg6sBQU0ZdBgQ0UzpPhAY1Umv
	 hvTewc8aRtteW3ZP59Wm6mTW95IO+rRH23bRLKoI8JjKommn6c1dqiFgKUaHZ6iaUh
	 QC3+vrUvsSZ4dDYM91Eg4ElwQxEISVu7HVnsL1oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/136] media: nxp: imx8-isi: Drop unused argument to mxc_isi_channel_chain()
Date: Tue, 21 Oct 2025 21:50:18 +0200
Message-ID: <20251021195036.696754003@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -587,7 +587,7 @@ void mxc_isi_channel_release(struct mxc_
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
@@ -855,7 +855,7 @@ int mxc_isi_pipe_acquire(struct mxc_isi_
 
 	/* Chain the channel if needed for wide resolutions. */
 	if (sink_fmt->width > MXC_ISI_MAX_WIDTH_UNCHAINED) {
-		ret = mxc_isi_channel_chain(pipe, bypass);
+		ret = mxc_isi_channel_chain(pipe);
 		if (ret)
 			mxc_isi_channel_release(pipe);
 	}


