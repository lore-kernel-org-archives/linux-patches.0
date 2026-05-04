Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24865378D8C;
	Mon,  4 May 2026 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903268; cv=none; b=UI2hRyEmElDFHmRML+xYV/iJgl537GTxu1RSLnAeWmAE1WPDh7EN4NZ0VahN/36LBiHB3wlQYezvVLDJG63r1Y4us0puv8MJN80SCKT1/27fw3y3wDfZN4aOCMsw3a+Cq9hsQEWuDHSbsyJalh04GRQRmLBDutdynpERdAoGeDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903268; c=relaxed/simple;
	bh=mrUoqC/uzIVCQntpLtsiiwxbAYe/ACWVdBQbkTHbdGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NeZzBhU+xdSqibSsASuFQq5aP1Yf2rewzBAGgpicmZeK8QoE732DnMmIIM7BuCJhUKgu5Ov7eFIQkqcrq0azV1yEyrd6JxOVZR4bPpxVcrWowy9L3oNQ1HZbBuAtykg0QyN2xbq7xWd7/DUIY6eeGbnBH0E0hvBZ2Wc09jgCLyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM35zqUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM35zqUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC84DC2BCB8;
	Mon,  4 May 2026 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903268;
	bh=mrUoqC/uzIVCQntpLtsiiwxbAYe/ACWVdBQbkTHbdGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GM35zqUE32L6qzImgmHzaKgyEARHo8F5/+7vPLA+G7lu59I9+kNyynRYuZLiMfl5g
	 3H1KZO8OvatymcGfpjNsE3CBq1iTxu9KyMLDtek3paXViu+DmUgf89d+3MQxRtFD6d
	 yMEBk2Yo9l9U80wcOrp5Qa3piAJZmgVBP2zpXMXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 167/307] media: rzv2h-ivc: Fix AXIRX_VBLANK register write
Date: Mon,  4 May 2026 15:50:52 +0200
Message-ID: <20260504135149.150042667@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

commit 6139d018f043a30274071d694276c5ce59fe62d0 upstream.

According to the documentation there are writable reserved bits in the
register and those should not be set to 0. So use `rzv2h_ivc_update_bits()`
with a proper bitmask.

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c |    7 +++++--
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h       |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -7,6 +7,7 @@
 
 #include "rzv2h-ivc.h"
 
+#include <linux/bitfield.h>
 #include <linux/cleanup.h>
 #include <linux/iopoll.h>
 #include <linux/lockdep.h>
@@ -235,8 +236,10 @@ static void rzv2h_ivc_format_configure(s
 	hts = pix->width + RZV2H_IVC_FIXED_HBLANK;
 	vblank = RZV2H_IVC_MIN_VBLANK(hts);
 
-	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_AXIRX_BLANK,
-			RZV2H_IVC_VBLANK(vblank));
+	rzv2h_ivc_update_bits(ivc, RZV2H_IVC_REG_AXIRX_BLANK,
+			      RZV2H_IVC_AXIRX_BLANK_FIELD_VBLANK,
+			      FIELD_PREP(RZV2H_IVC_AXIRX_BLANK_FIELD_VBLANK,
+					 vblank));
 }
 
 static void rzv2h_ivc_return_buffers(struct rzv2h_ivc *ivc,
--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h
@@ -34,7 +34,7 @@
 #define RZV2H_IVC_REG_AXIRX_HSIZE			0x0020
 #define RZV2H_IVC_REG_AXIRX_VSIZE			0x0024
 #define RZV2H_IVC_REG_AXIRX_BLANK			0x0028
-#define RZV2H_IVC_VBLANK(x)				((x) << 16)
+#define RZV2H_IVC_AXIRX_BLANK_FIELD_VBLANK		GENMASK(25, 16)
 #define RZV2H_IVC_REG_AXIRX_STRD			0x0030
 #define RZV2H_IVC_REG_AXIRX_ISSU			0x0040
 #define RZV2H_IVC_REG_AXIRX_ERACT			0x0048


