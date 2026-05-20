Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCCB369D6E;
	Wed, 20 May 2026 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295187; cv=none; b=dDPpwjJTd444oWqu5DX2EWWgsenV6kwzwkeQjX91Q/cYKwFXjRbKPXLuOaKfq2SXI1BBOU1izxLBg4vVkAL+jlbmcUpqBqimQVzSKXLjdIfGbcYONgo9BODImOwTAW7JcKS4h8QBOghJvnqWOs7ixzUxK51pN8G9qPtq4g/S5AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295187; c=relaxed/simple;
	bh=9SKUJ0d1ZA6Hw+5tyc/ZSuY6nocdPEmzfBxuSatdxTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjYRTGaANd7eRO01bkeftBs86V47QJTtzwpYoWPNdRLmmGl15BEq5MQwzUmvMSa1ya+0QDGgLbgO+4UhQZsLQrbVAlKFq/PWjrjNDi+aIoy0vniIuisrWLrQWy5dtL+6XuMiugh4d3cfENE6nnQaKooXeDLF/WnP+U/TElVUIC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRaq9vuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRaq9vuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D31A1F000E9;
	Wed, 20 May 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295184;
	bh=MGNu2Cdtd/9Y2sH8XmDkG/ZEI+/f8JT+uzoXuYuuCtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRaq9vuhh8XTti6yASyAZgq+Q1AWnx5rMzCFpSbLjZm10orKQjceT+rRoYE0VZ2Ip
	 3pJP4l8+f3BwvU+0rBO8Se2F1QIFTVxl/bXGjGKgoso72VDe+bjU3fid4uQ4Q1qg88
	 wmqJ0rlNOiXdmg5foJ7mDYywCHXBSsfU/yMPUgIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0323/1146] drm/msm/dsi: fix hdisplay calculation for CMD mode panel
Date: Wed, 20 May 2026 18:09:33 +0200
Message-ID: <20260520162155.509604048@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 82159db4371f5cef56444ebd0b8f96e2a6d709ff ]

Commit ac47870fd795 ("drm/msm/dsi: fix hdisplay calculation when
programming dsi registers") incorrecly broke hdisplay calculation for
CMD mode by specifying incorrect number of bytes per transfer, fix it.

Fixes: ac47870fd795 ("drm/msm/dsi: fix hdisplay calculation when programming dsi registers")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/709917/
Link: https://lore.kernel.org/r/20260307111250.105772-2-mitltlatltl@gmail.com
[DB: fixed commit message]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 3efcc3f6c381c..1c0841a1c1013 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1034,8 +1034,9 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		/*
 		 * DPU sends 3 bytes per pclk cycle to DSI. If widebus is
 		 * enabled, MDP always sends out 48-bit compressed data per
-		 * pclk and on average, DSI consumes an amount of compressed
-		 * data equivalent to the uncompressed pixel depth per pclk.
+		 * pclk and on average, for video mode, DSI consumes only an
+		 * amount of compressed data equivalent to the uncompressed
+		 * pixel depth per pclk.
 		 *
 		 * Calculate the number of pclks needed to transmit one line of
 		 * the compressed data.
@@ -1047,10 +1048,14 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		 * unused anyway.
 		 */
 		h_total -= hdisplay;
-		if (wide_bus_enabled)
-			bits_per_pclk = dsc->bits_per_component * 3;
-		else
+		if (wide_bus_enabled) {
+			if (msm_host->mode_flags & MIPI_DSI_MODE_VIDEO)
+				bits_per_pclk = dsc->bits_per_component * 3;
+			else
+				bits_per_pclk = 48;
+		} else {
 			bits_per_pclk = 24;
+		}
 
 		hdisplay = DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_host->dsc) * 8, bits_per_pclk);
 
-- 
2.53.0



