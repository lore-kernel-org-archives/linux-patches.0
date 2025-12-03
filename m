Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F29E33E37D;
	Wed,  3 Dec 2025 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779267; cv=none; b=WmmUzORqkwfST7GAKka28EmbTXSGMqs3AXovb4nTAR5CFbTJiEQJO1DYJwhAs7u1qxcDi7nGyCXUZhHN9kQd+RafYXCDQE0AfGglijkAKaSezfKRyjkID6hi+IGLCn0OWjNu8JUBxrySP2zwJCL1foaKZMUW512U1LbXmH5RCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779267; c=relaxed/simple;
	bh=8xrwT4TnMO/MUdPsRQh7+5RGmM7QBDW3Qelqa/6WbkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctk6mp4I/dwYsMWYqeB27Ozc+dm8a1aH42m7dS53b6zo7wC1FKU46nNOczUZwcL8Q9c/r4ZvpPHHhRGRCN1k3W58r1BwOaNH4mbx+lmbxkQCv95wXtiirNVUw2l6WwhXP6Gz3KXVXyC1exFjJ7QsZ/PW0X4Fwz7uQ8cwNQoNZ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmWYBng3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmWYBng3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E6FC4CEF5;
	Wed,  3 Dec 2025 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779266;
	bh=8xrwT4TnMO/MUdPsRQh7+5RGmM7QBDW3Qelqa/6WbkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmWYBng3suO3v4jAeOjJ4T8kHdd8MOX8/G8BodbJaMxeN6qbCm6ya8pLosnQMCyQG
	 G0W5poZr95dAcC9hAem7toTye/frCLaPJvWBpE0ZSpvys0A+hBuLzDngXoW+BGXhyv
	 +BunPs5NXGYMiuSXGSsEObFAEa4Qi5wgGas8hRHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/568] media: i2c: og01a1b: Specify monochrome media bus format instead of Bayer
Date: Wed,  3 Dec 2025 16:23:27 +0100
Message-ID: <20251203152448.234405731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit bfbd5aa5347fbd11ade188b316b800bfb27d9e22 ]

The OmniVision OG01A1B image sensor is a monochrome sensor, it supports
8-bit and 10-bit RAW output formats only.

That said the planar greyscale Y8/Y10 media formats are more appropriate
for the sensor instead of the originally and arbitrary selected SGRBG one,
since there is no red, green or blue color components.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/og01a1b.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/og01a1b.c b/drivers/media/i2c/og01a1b.c
index 35663c10fcd9f..0ceb46d947a16 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -676,7 +676,7 @@ static void og01a1b_update_pad_format(const struct og01a1b_mode *mode,
 {
 	fmt->width = mode->width;
 	fmt->height = mode->height;
-	fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->code = MEDIA_BUS_FMT_Y10_1X10;
 	fmt->field = V4L2_FIELD_NONE;
 }
 
@@ -867,7 +867,7 @@ static int og01a1b_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	code->code = MEDIA_BUS_FMT_Y10_1X10;
 
 	return 0;
 }
@@ -879,7 +879,7 @@ static int og01a1b_enum_frame_size(struct v4l2_subdev *sd,
 	if (fse->index >= ARRAY_SIZE(supported_modes))
 		return -EINVAL;
 
-	if (fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
+	if (fse->code != MEDIA_BUS_FMT_Y10_1X10)
 		return -EINVAL;
 
 	fse->min_width = supported_modes[fse->index].width;
-- 
2.51.0



