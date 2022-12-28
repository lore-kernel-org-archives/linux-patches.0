Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479C91863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ECBC433D2;
	Wed, 28 Dec 2022 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241328;
	bh=oXaQCjD+enSqgAp1tguXhNS78M0iMCXrjTaJmeGwTuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ilm85YD5cRGu+Dz9Lvm8prrBwkcDXO/X7RTl18FYsczPVILTeSz2PMsvBEB8ck49v
	 cnkpNCaxKB2YtQKohL/ZbMZ2AUIZwmJi/BdHdhJGRfGUZRurHrTn1rhdVSu7JE8OTa
	 6MDsEom85C1ph41zIAAefcJk4HNFCo2Mrn07BvQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0233/1146] media: v4l2-ioctl.c: Unify YCbCr/YUV terms in format descriptions
Date: Wed, 28 Dec 2022 15:29:32 +0100
Message-Id: <20221228144336.468217568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 6a394d563dffb60c150d87dc6678994ef8028c53 ]

Format descriptions use YCbCr and YUV terms interchangeably. Let's unify
them so they all use YUV. While YCbCr is actually correct term here, YUV
is shorter and thus it also fixes too long description of P010 tiled
format.

Fixes: 3c8e19d3d3f9 ("media: Add P010 tiled format")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 34 ++++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index fddba75d9074..6876ec25bc51 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1347,23 +1347,23 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_YUV420:	descr = "Planar YUV 4:2:0"; break;
 	case V4L2_PIX_FMT_HI240:	descr = "8-bit Dithered RGB (BTTV)"; break;
 	case V4L2_PIX_FMT_M420:		descr = "YUV 4:2:0 (M420)"; break;
-	case V4L2_PIX_FMT_NV12:		descr = "Y/CbCr 4:2:0"; break;
-	case V4L2_PIX_FMT_NV21:		descr = "Y/CrCb 4:2:0"; break;
-	case V4L2_PIX_FMT_NV16:		descr = "Y/CbCr 4:2:2"; break;
-	case V4L2_PIX_FMT_NV61:		descr = "Y/CrCb 4:2:2"; break;
-	case V4L2_PIX_FMT_NV24:		descr = "Y/CbCr 4:4:4"; break;
-	case V4L2_PIX_FMT_NV42:		descr = "Y/CrCb 4:4:4"; break;
-	case V4L2_PIX_FMT_P010:		descr = "10-bit Y/CbCr 4:2:0"; break;
-	case V4L2_PIX_FMT_NV12_4L4:	descr = "Y/CbCr 4:2:0 (4x4 Linear)"; break;
-	case V4L2_PIX_FMT_NV12_16L16:	descr = "Y/CbCr 4:2:0 (16x16 Linear)"; break;
-	case V4L2_PIX_FMT_NV12_32L32:   descr = "Y/CbCr 4:2:0 (32x32 Linear)"; break;
-	case V4L2_PIX_FMT_P010_4L4:	descr = "10-bit Y/CbCr 4:2:0 (4x4 Linear)"; break;
-	case V4L2_PIX_FMT_NV12M:	descr = "Y/CbCr 4:2:0 (N-C)"; break;
-	case V4L2_PIX_FMT_NV21M:	descr = "Y/CrCb 4:2:0 (N-C)"; break;
-	case V4L2_PIX_FMT_NV16M:	descr = "Y/CbCr 4:2:2 (N-C)"; break;
-	case V4L2_PIX_FMT_NV61M:	descr = "Y/CrCb 4:2:2 (N-C)"; break;
-	case V4L2_PIX_FMT_NV12MT:	descr = "Y/CbCr 4:2:0 (64x32 MB, N-C)"; break;
-	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/CbCr 4:2:0 (16x16 MB, N-C)"; break;
+	case V4L2_PIX_FMT_NV12:		descr = "Y/UV 4:2:0"; break;
+	case V4L2_PIX_FMT_NV21:		descr = "Y/VU 4:2:0"; break;
+	case V4L2_PIX_FMT_NV16:		descr = "Y/UV 4:2:2"; break;
+	case V4L2_PIX_FMT_NV61:		descr = "Y/VU 4:2:2"; break;
+	case V4L2_PIX_FMT_NV24:		descr = "Y/UV 4:4:4"; break;
+	case V4L2_PIX_FMT_NV42:		descr = "Y/VU 4:4:4"; break;
+	case V4L2_PIX_FMT_P010:		descr = "10-bit Y/UV 4:2:0"; break;
+	case V4L2_PIX_FMT_NV12_4L4:	descr = "Y/UV 4:2:0 (4x4 Linear)"; break;
+	case V4L2_PIX_FMT_NV12_16L16:	descr = "Y/UV 4:2:0 (16x16 Linear)"; break;
+	case V4L2_PIX_FMT_NV12_32L32:   descr = "Y/UV 4:2:0 (32x32 Linear)"; break;
+	case V4L2_PIX_FMT_P010_4L4:	descr = "10-bit Y/UV 4:2:0 (4x4 Linear)"; break;
+	case V4L2_PIX_FMT_NV12M:	descr = "Y/UV 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_NV21M:	descr = "Y/VU 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_NV16M:	descr = "Y/UV 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_NV61M:	descr = "Y/VU 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_NV12MT:	descr = "Y/UV 4:2:0 (64x32 MB, N-C)"; break;
+	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/UV 4:2:0 (16x16 MB, N-C)"; break;
 	case V4L2_PIX_FMT_YUV420M:	descr = "Planar YUV 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_YVU420M:	descr = "Planar YVU 4:2:0 (N-C)"; break;
 	case V4L2_PIX_FMT_YUV422M:	descr = "Planar YUV 4:2:2 (N-C)"; break;
-- 
2.35.1



