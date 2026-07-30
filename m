Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA1C217723;
	Thu, 30 Jul 2026 16:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427662; cv=none; b=NCrGpOUHJil9p5ue/AyyVVGciXiPhcSr8cUiaNJ8j2uEiyy9at5ZQDUFOO4Dkoz84/2qBR71dXL1rqw3MADTi53EHnhDW2x12av1hfraauHDpeQuz1EYr4qymYYR429C1upfdQn3gFbYNllbU21GkZG9V7OX3M4NS8J9kRAIJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427662; c=relaxed/simple;
	bh=Yp0yZJkSLGq8vaOpC/34fO8005tFzHmJiN7PPRp0Ezs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmRq0U6txZ4UPrJAEVQwTe+cpYcp/skiR+6eJiYFo4w5Ey9VwpOo0jtTelPjPDty74SVCHlV8uNM3sGwZS5shIU9STPik5ZtrYiMGLpNgvAyFzGWR+q0lEKREuiGpMRFiFKuJIwBn96M9qOlBULTlkRpmo6QArEOHKi+OAnLOsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LOzrsFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LOzrsFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EB61F000E9;
	Thu, 30 Jul 2026 16:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427661;
	bh=EjKeCx5s871sMFckUncD7P4FXYL45PrkneH8JdO3N/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LOzrsFLAFZwFCibCStiSOzlG52XVZeQYHHV24tqOAtgQbJYhw/TsAffmq15Th5nH
	 usEhV9Bba6XGROqqUC+2/0VlzJB/wa1pN/kRMsV/zhZ2UZ1cBFanfMYBP1D8gMwOxj
	 jmFSjXn7+3yLAh3ynnHVT6eGTUOluF+YrqNS9wH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 249/484] media: nxp: imx8-isi: Fix scale factor calculation for hardware rounding
Date: Thu, 30 Jul 2026 16:12:26 +0200
Message-ID: <20260730141428.894942856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Guoniu Zhou <guoniu.zhou@nxp.com>

commit 5eb54da3f874b44149556542d949909898865e29 upstream.

The ISI hardware rounds the actual output size up to an integer, as
described in i.MX93 Reference Manual section 57.7.8 (Channel 0 Scale
Factor). The scale factor must be calculated to ensure the theoretical
output value rounds up to exactly the desired size.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260323-isi-v3-2-8df53b24e622@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
index 0187d4ab97e8..16b20ea2d1db 100644
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
@@ -112,7 +112,14 @@ static u32 mxc_isi_channel_scaling_ratio(unsigned int from, unsigned int to,
 	else
 		*dec = 8;
 
-	return min_t(u32, from * 0x1000 / (to * *dec), ISI_DOWNSCALE_THRESHOLD);
+	/*
+	 * The ISI rounds output dimensions up to the next integer (i.MX93 RM
+	 * section 57.7.8). Calculate the scale factor such that the theoretical
+	 * output (input / scale_factor) rounds up to exactly the desired
+	 * output.
+	 */
+	return min_t(u32, DIV_ROUND_UP(from * 0x1000, to * *dec),
+		     ISI_DOWNSCALE_THRESHOLD);
 }
 
 static void mxc_isi_channel_set_scaling(struct mxc_isi_pipe *pipe,
-- 
2.55.0



