Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35CFBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42D7C433EF;
	Tue,  7 Mar 2023 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213472;
	bh=dUpq22EcPIUXhWVJWeCv7GvmWOePXscZy5LHRVYAUE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjE7JwZ8WYWW8dwWpDulm4/6V4NL4qUsFym3ZWoJS2kgJEylis/dbfkFlQHQfLhsN
	 7P6V1oYkBVR6B3CM2vrREflpPINyBCQCVjbW9qU8BXG+ygFvRmh57p7ZfGCd+x/sio
	 wFn+DoSkGg6jlLDrdoeExqkO7MdDu/EswZcrlHEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 518/885] media: amphion: correct the unspecified color space
Date: Tue,  7 Mar 2023 17:57:32 +0100
Message-Id: <20230307170024.977948954@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 809060c8a357e020010dd8f797a5efd3c5432b13 ]

in the E.2.1 of Rec. ITU-T H.264 (06/2019),
0 of colour primaries is reserved, and 2 is unspecified.
driver can map V4L2_COLORSPACE_LAST to 0,
and map V4L2_COLORSPACE_DEFAULT to 2.

v4l2_xfer_func and v4l2_ycbcr_encoding are similar case.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_color.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_color.c b/drivers/media/platform/amphion/vpu_color.c
index 80b9a53fd1c14..4ae435cbc5cda 100644
--- a/drivers/media/platform/amphion/vpu_color.c
+++ b/drivers/media/platform/amphion/vpu_color.c
@@ -17,7 +17,7 @@
 #include "vpu_helpers.h"
 
 static const u8 colorprimaries[] = {
-	0,
+	V4L2_COLORSPACE_LAST,
 	V4L2_COLORSPACE_REC709,         /*Rec. ITU-R BT.709-6*/
 	0,
 	0,
@@ -31,7 +31,7 @@ static const u8 colorprimaries[] = {
 };
 
 static const u8 colortransfers[] = {
-	0,
+	V4L2_XFER_FUNC_LAST,
 	V4L2_XFER_FUNC_709,             /*Rec. ITU-R BT.709-6*/
 	0,
 	0,
@@ -53,7 +53,7 @@ static const u8 colortransfers[] = {
 };
 
 static const u8 colormatrixcoefs[] = {
-	0,
+	V4L2_YCBCR_ENC_LAST,
 	V4L2_YCBCR_ENC_709,              /*Rec. ITU-R BT.709-6*/
 	0,
 	0,
-- 
2.39.2



