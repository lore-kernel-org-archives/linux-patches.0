Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E71D3FF1BD;
	Fri, 15 May 2026 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862340; cv=none; b=lk8a3KPCREJv8PJ0XiY+lzZJMSYMrOcoo2Volo2D9ikqyzJ9QZ9/mwryCSLsxlVVCC/u0Gdno7/EU3l9ShozWqwWW8cV2gfh/FimMNVR6cOsrWvOmiZlGfXsrQzaaIeWWl8HI55gdVBFwT6or6Sj7LsZEo6gvumvU6Oqe2xIJZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862340; c=relaxed/simple;
	bh=Mr9jYFF7SpQNTy9YThp5D1fbZNkSQEL+aJy6nuXei2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AeVqftHr70j3VNnV//MfJYQeCradncp/4buq+mwv9CeiCKNVdfxh9dmrsujpF8CqdqvaCj9R/7ud+fMCzREXcHKle5iNDH/cbk8O2Sya+3XDycI+w7QHmSSVQE8MRQubdGdGUWqsVnhlKfbN5JUPMzDpqIEXMje+TtXSD1B2K9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZZ+pbZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZZ+pbZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24329C2BCF5;
	Fri, 15 May 2026 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862340;
	bh=Mr9jYFF7SpQNTy9YThp5D1fbZNkSQEL+aJy6nuXei2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZZ+pbZxufJhwh2NxIepERgMZIHdU4VF/bheWQDWXPev93v41jQpaoYoEutJYkTVH
	 otBsf8eG7VL+KdlhQxSJG0CbWH2jzlyVdz5RndCLMlySVHOMTCE611iW98fFCR7KER
	 snHbjnxY4BMWW3hDFyndshXU/G/zgmpNlsTTCLrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 012/201] media: rzv2h-ivc: Fix FM_STOP register write
Date: Fri, 15 May 2026 17:47:10 +0200
Message-ID: <20260515154658.802363217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>

commit 562d2e0a672075292e92538dad61664e89b34d30 upstream.

Bit 20 should be written in this register to stop frame processing.
So fix that, as well as the poll condition.

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c |    5 +++--
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h       |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -300,9 +300,10 @@ static void rzv2h_ivc_stop_streaming(str
 	struct rzv2h_ivc *ivc = vb2_get_drv_priv(q);
 	u32 val = 0;
 
-	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_FM_STOP, 0x1);
+	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_FM_STOP, RZV2H_IVC_REG_FM_STOP_FSTOP);
 	readl_poll_timeout(ivc->base + RZV2H_IVC_REG_FM_STOP,
-			   val, !val, 10 * USEC_PER_MSEC, 250 * USEC_PER_MSEC);
+			   val, !(val & RZV2H_IVC_REG_FM_STOP_FSTOP),
+			   10 * USEC_PER_MSEC, 250 * USEC_PER_MSEC);
 
 	rzv2h_ivc_return_buffers(ivc, VB2_BUF_STATE_ERROR);
 	video_device_pipeline_stop(&ivc->vdev.dev);
--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h
@@ -46,6 +46,7 @@
 #define RZV2H_IVC_REG_FM_MCON				0x0104
 #define RZV2H_IVC_REG_FM_FRCON				0x0108
 #define RZV2H_IVC_REG_FM_STOP				0x010c
+#define RZV2H_IVC_REG_FM_STOP_FSTOP			BIT(20)
 #define RZV2H_IVC_REG_FM_INT_EN				0x0120
 #define RZV2H_IVC_VVAL_IFPE				BIT(0)
 #define RZV2H_IVC_REG_FM_INT_STA			0x0124


