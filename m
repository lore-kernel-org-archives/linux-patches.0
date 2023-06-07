Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2946D19E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD51C433D2;
	Wed,  7 Jun 2023 20:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170141;
	bh=dW1NgTsNOzopuYcGNJ5kIrt/3hgndm+ge9v3hE0088I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYgrqgA0bGJeBRcPBUw6oTNbmwqN7IuCk+24yfsuJ6+TTNoeR9g/hztXoq1Dbe7YB
	 NnBx0OTR8JG2ecPdOsEe+fufDXSt0N3EViSFIqRjrBhp5DPFyJwdx4kC9F6iM/fBVk
	 wKl2ynffflcQNvoJmIXhlQ1+KZzNRbec1xSj2zO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/88] media: rcar-vin: Select correct interrupt mode for V4L2_FIELD_ALTERNATE
Date: Wed,  7 Jun 2023 22:15:48 +0200
Message-ID: <20230607200900.148536350@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit e10707d5865c90d3dfe4ef589ce02ff4287fef85 ]

When adding proper support for V4L2_FIELD_ALTERNATE it was missed that
this field format should trigger an interrupt for each field, not just
for the whole frame. Fix this by marking it as progressive in the
capture setup, which will then select the correct interrupt mode.

Tested on both Gen2 and Gen3 with the result of a doubling of the frame
rate for V4L2_FIELD_ALTERNATE. From a PAL video source the frame rate is
now 50, which is expected for alternate field capture.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 70a8cc433a03f..cc28e2cb23f11 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -633,6 +633,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
 	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_ALTERNATE:
 		vnmc = VNMC_IM_ODD_EVEN;
 		progressive = true;
 		break;
-- 
2.39.2



