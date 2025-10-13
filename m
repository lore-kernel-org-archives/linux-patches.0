Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209BA3126D0;
	Mon, 13 Oct 2025 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368246; cv=none; b=SHGg/tMxA2yCwhAAKremzmcUCKYJm5YEwfHUqgfpBp4QuwqqpCat34VvtN/+DnQN1m5sBXCMValgsddJHZHWl6glW9+rYljBfYWAu7H2N5vb0CHCGYmvRtgc9bjqJyt6FXPCp/4HwrAlEnrZDJk7G3xArQshjKHgraOeB0xgg80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368246; c=relaxed/simple;
	bh=6ZoFtuEH6Des+p283L0HjsEVQeylKDjqJSJFYmhPyGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvgN5rzRAgpL2zFOEThenAYc2AYfx3o3C2DFBRhW3g4alzMWdfwVqy5DMM9ZAof2JyA0SG4gvYLzc4sGtDfR+SVs45zbponE+Tgj0ecWcSC2B2xvbNbejLB75LGB3yUFTGAwE4O//u4KvXyb3jDWNY1XupFvEwQF4cB9eLOoKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la/XP9VN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la/XP9VN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5C7C4CEE7;
	Mon, 13 Oct 2025 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368246;
	bh=6ZoFtuEH6Des+p283L0HjsEVQeylKDjqJSJFYmhPyGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la/XP9VN+/74cuBvxaAQwY0p48ULFNq9e1Hu7bIjGluokU0eqip53ArKhslSMDgyZ
	 2y5E96aQCNXQEQRc8eRG7GFteW2WkkJSFxdyRm8KT41UhqdcsAAVbdjPMt9tC4COCd
	 8IPf0aoT5zuq0CDKRs/PPaK+fgoXtCjM0WTMut/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/262] media: zoran: Remove zoran_fh structure
Date: Mon, 13 Oct 2025 16:43:56 +0200
Message-ID: <20251013144329.513493137@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

[ Upstream commit dc322d13cf417552b59e313e809a6da40b8b36ef ]

The zoran_fh structure is a wrapper around v4l2_fh. Its usage has been
mostly removed by commit 83f89a8bcbc3 ("media: zoran: convert to vb2"),
but the structure stayed by mistake. It is now used in a single
location, assigned from a void pointer and then recast to a void
pointer, without being every accessed. Drop it.

Fixes: 83f89a8bcbc3 ("media: zoran: convert to vb2")
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/zoran/zoran.h        | 6 ------
 drivers/media/pci/zoran/zoran_driver.c | 3 +--
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
index 1cd990468d3de..d05e222b39215 100644
--- a/drivers/media/pci/zoran/zoran.h
+++ b/drivers/media/pci/zoran/zoran.h
@@ -154,12 +154,6 @@ struct zoran_jpg_settings {
 
 struct zoran;
 
-/* zoran_fh contains per-open() settings */
-struct zoran_fh {
-	struct v4l2_fh fh;
-	struct zoran *zr;
-};
-
 struct card_info {
 	enum card_type type;
 	char name[32];
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 5c05e64c71a90..80377992a6073 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -511,12 +511,11 @@ static int zoran_s_fmt_vid_cap(struct file *file, void *__fh,
 			       struct v4l2_format *fmt)
 {
 	struct zoran *zr = video_drvdata(file);
-	struct zoran_fh *fh = __fh;
 	int i;
 	int res = 0;
 
 	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_MJPEG)
-		return zoran_s_fmt_vid_out(file, fh, fmt);
+		return zoran_s_fmt_vid_out(file, __fh, fmt);
 
 	for (i = 0; i < NUM_FORMATS; i++)
 		if (fmt->fmt.pix.pixelformat == zoran_formats[i].fourcc)
-- 
2.51.0



