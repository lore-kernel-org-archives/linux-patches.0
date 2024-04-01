Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8AD3FE2D;
	Mon,  1 Apr 2024 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986576; cv=none; b=e3MyUmrX8FNv+k8ADPGBPSXIyI+GNzSyFLhahiV967tIMc3pkMHKFEYyIP43e95+P5rDNSH2qI1llwIKrk6CdPjM44+usiYtt+TjvnOIy3XLUTSWILnTro0a+cqNOUtO3QPy915c/vAgP6PBAaS3mvq35FbQGvQrRk0dl4KaFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986576; c=relaxed/simple;
	bh=hDBFu8KBq0fUbJ3lYvPOI6F1C6bwPDXEU/FF72P9asQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWDx95Z6cOSfJb+YJblX8Q2lY4iUPcYGepMkETPjhqN5VahUXmJOotyk6vqJjYb9fxNX29TLdDsU8iCp3O+wRArmD/g2pHuMLAF2g7KFVMxbsVR1bdcDt/qOG0yvrV+nYwSvpBLlSg5XW1o8CyaAs27bzFOgbWfyy8xk3/u2hE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNVngm3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNVngm3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B4CC433C7;
	Mon,  1 Apr 2024 15:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986576;
	bh=hDBFu8KBq0fUbJ3lYvPOI6F1C6bwPDXEU/FF72P9asQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNVngm3vw6vS25cXvznjBDAWGNVWK4TQYbwb7I+PNWUfdHDEtdEtM8VxP0oNFN0TP
	 onOhjirUJSuzIaJVEkKCa36bIdngYDTE0GxA7+w30OkrljAcgYl6/LNJ7+TYhnGmD6
	 c9uSIajOFRyujSrflSTSJVHVuAtEn9iXsdPq7dAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Fabio Estevam <festevam@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 019/399] media: nxp: imx8-isi: Check whether crossbar pad is non-NULL before access
Date: Mon,  1 Apr 2024 17:39:45 +0200
Message-ID: <20240401152549.734846162@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit eb2f932100288dbb881eadfed02e1459c6b9504c ]

When translating source to sink streams in the crossbar subdev, the
driver tries to locate the remote subdev connected to the sink pad. The
remote pad may be NULL, if userspace tries to enable a stream that ends
at an unconnected crossbar sink. When that occurs, the driver
dereferences the NULL pad, leading to a crash.

Prevent the crash by checking if the pad is NULL before using it, and
return an error if it is.

Cc: stable@vger.kernel.org # 6.1
Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20231201150614.63300-1-marex@denx.de
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
index 575f173373887..1bb1334ec6f2b 100644
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
@@ -160,8 +160,14 @@ mxc_isi_crossbar_xlate_streams(struct mxc_isi_crossbar *xbar,
 	}
 
 	pad = media_pad_remote_pad_first(&xbar->pads[sink_pad]);
-	sd = media_entity_to_v4l2_subdev(pad->entity);
+	if (!pad) {
+		dev_dbg(xbar->isi->dev,
+			"no pad connected to crossbar input %u\n",
+			sink_pad);
+		return ERR_PTR(-EPIPE);
+	}
 
+	sd = media_entity_to_v4l2_subdev(pad->entity);
 	if (!sd) {
 		dev_dbg(xbar->isi->dev,
 			"no entity connected to crossbar input %u\n",
-- 
2.43.0



