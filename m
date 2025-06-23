Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D531224E4C3;
	Mon, 23 Jun 2025 13:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684580; cv=none; b=t+43/xaLUiA4hIQrrLAsrEhtiBPjInkT4SNuZvIvnhqEAwtsusw9Ov6/3fcbxKM5PqnH4gDRx5Uzof2yglkuGTW8HGgzHxSpP9KQmqNPncYewKy3q8Plou+trFUm562uF42oxO6Ph0IEI4OHWZtA3jZ64eH5Dle5ztL9bMMLq3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684580; c=relaxed/simple;
	bh=ZiYw6DGd7T69Xkq5sH/sWqbzak2tAfQXb1lzqyNx1iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SpNFRCx0jaUrKzcSEGXY+WI8ksqdrMz8pXozUtw0bPRYMbOtToTOklq9yQCydOxggmkoLDh88V07lSE/2QJZ0ypPCES0q93Z5ox0irB/DLNwLtAr6tNvlPQZTEwLjCtaQU/C5K4Ub1G248c6fUc/voA2L7U+fsr8pWS6khMJLnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDHCt9k5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDHCt9k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BD1C4CEEA;
	Mon, 23 Jun 2025 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684580;
	bh=ZiYw6DGd7T69Xkq5sH/sWqbzak2tAfQXb1lzqyNx1iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDHCt9k55Z0+uSHA2F/r4/N4lUXXbwv5+Fxc/Hw9OnE5VWFenERKuY3TALXDTF0wf
	 WwZ0nsQYMaSnT9uvCHHeI8deQUiwe/FhJGUPq+yAMl4vZ5eMMknsMLCgle+eh2Zd3r
	 koD/O4dXpgrCXjz1/dmSTKmfdVGqoYS1vvdOtGek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 079/592] media: rcar-vin: Fix RAW10
Date: Mon, 23 Jun 2025 15:00:37 +0200
Message-ID: <20250623130702.152064314@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

commit 94bf847ae5a61e0ab0b971ed186a443688eb793f upstream.

Fix the following to get RAW10 formats working:

In rvin_formats, the bpp is set to 4 for RAW10. As VIN unpacks RAW10 to
16-bit containers, the bpp should be 2.

Don't set VNDMR_YC_THR to the VNDMR register. The YC_THR is "YC Data
Through Mode", used for YUV formats and should not be set for RAW10.

Fixes: 1b7e7240eaf3 ("media: rcar-vin: Add support for RAW10")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20250424-rcar-fix-raw-v2-4-f6afca378124@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c  |    2 +-
 drivers/media/platform/renesas/rcar-vin/rcar-v4l2.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
@@ -910,7 +910,7 @@ static int rvin_setup(struct rvin_dev *v
 	case V4L2_PIX_FMT_SGBRG10:
 	case V4L2_PIX_FMT_SGRBG10:
 	case V4L2_PIX_FMT_SRGGB10:
-		dmr = VNDMR_RMODE_RAW10 | VNDMR_YC_THR;
+		dmr = VNDMR_RMODE_RAW10;
 		break;
 	default:
 		vin_err(vin, "Invalid pixelformat (0x%x)\n",
--- a/drivers/media/platform/renesas/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-v4l2.c
@@ -88,19 +88,19 @@ static const struct rvin_video_format rv
 	},
 	{
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
-		.bpp			= 4,
+		.bpp			= 2,
 	},
 	{
 		.fourcc			= V4L2_PIX_FMT_SGBRG10,
-		.bpp			= 4,
+		.bpp			= 2,
 	},
 	{
 		.fourcc			= V4L2_PIX_FMT_SGRBG10,
-		.bpp			= 4,
+		.bpp			= 2,
 	},
 	{
 		.fourcc			= V4L2_PIX_FMT_SRGGB10,
-		.bpp			= 4,
+		.bpp			= 2,
 	},
 };
 


