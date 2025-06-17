Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E3C2DFF22;
	Tue, 17 Jun 2025 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175989; cv=none; b=mxfgv/CXg+H08eC/rRUbzugCe811w03svK+MHa+aWDG8DbHyyh2kmNigcdSHvUh0xXFl7rGeijBWQG5tdgbP995H8epSPLrsg2JtUzCRqLPHjnUTxiWLoPkD1vTfe5dR4jfribUFcwxOt6Oj5zRxQCXEt5h49HL0YMcQQt/7J7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175989; c=relaxed/simple;
	bh=DEJkTf2BXgJtkwY1C4K737sO5Da0zzraa0V3nwF972k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+KT2/W0bLWyI306r9TQg2NMIzWWooGNzaiGSlhWmG5HyfDVYzQqV8xQ99wFu8h2WdGLlh9jSiUJq8m2qDNJfvOwmH3MJbBO6siiBgp4GJ1BcpIdYg4rtwMRgjlG9di6OBtvz5fuArBoPwqp7R35T6igeeXcwc0Cl3MTcVRYQQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=br5muKzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="br5muKzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48492C4CEE3;
	Tue, 17 Jun 2025 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175989;
	bh=DEJkTf2BXgJtkwY1C4K737sO5Da0zzraa0V3nwF972k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=br5muKzFiRBg9zY4NfWS0dSeA14sO6mNXMmeiudo4xe0HDJOUOGX+8wJsk0OtCalJ
	 fwBwYTj+3yV0DG7TJWHYk7LscrLyYlszIyg/zNqo3ryI6QLRf65XkHtQbHxX4HiG7o
	 LPjgxP/8x1cAgSPDIPVVKssb2HgXpHzBDSExhdeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 141/780] media: synopsys: hdmirx: Renamed frame_idx to sequence
Date: Tue, 17 Jun 2025 17:17:29 +0200
Message-ID: <20250617152457.244141557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 0400bee67f49753b878c2576c02c1bc454f091ed ]

This variable is used to fill the v4l2_buffer.sequence, let's name it
the exact same way to reduce confusion.

No functional changes.

Fixes: 7b59b132ad439 ("media: platform: synopsys: Add support for HDMI input driver")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
index 3d2913de9a86c..f5b3f5010ede5 100644
--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -114,7 +114,7 @@ struct hdmirx_stream {
 	spinlock_t vbq_lock; /* to lock video buffer queue */
 	bool stopping;
 	wait_queue_head_t wq_stopped;
-	u32 frame_idx;
+	u32 sequence;
 	u32 line_flag_int_cnt;
 	u32 irq_stat;
 };
@@ -1540,7 +1540,7 @@ static int hdmirx_start_streaming(struct vb2_queue *queue, unsigned int count)
 	int line_flag;
 
 	mutex_lock(&hdmirx_dev->stream_lock);
-	stream->frame_idx = 0;
+	stream->sequence = 0;
 	stream->line_flag_int_cnt = 0;
 	stream->curr_buf = NULL;
 	stream->next_buf = NULL;
@@ -1948,7 +1948,7 @@ static void dma_idle_int_handler(struct snps_hdmirx_dev *hdmirx_dev,
 
 			if (vb_done) {
 				vb_done->vb2_buf.timestamp = ktime_get_ns();
-				vb_done->sequence = stream->frame_idx;
+				vb_done->sequence = stream->sequence;
 
 				if (bt->interlaced)
 					vb_done->field = V4L2_FIELD_INTERLACED_TB;
@@ -1956,8 +1956,8 @@ static void dma_idle_int_handler(struct snps_hdmirx_dev *hdmirx_dev,
 					vb_done->field = V4L2_FIELD_NONE;
 
 				hdmirx_vb_done(stream, vb_done);
-				stream->frame_idx++;
-				if (stream->frame_idx == 30)
+				stream->sequence++;
+				if (stream->sequence == 30)
 					v4l2_dbg(1, debug, v4l2_dev,
 						 "rcv frames\n");
 			}
-- 
2.39.5



