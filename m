Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC972561A7;
	Tue, 11 Nov 2025 01:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824387; cv=none; b=nG2oO3Qez0GnrP5qC/0LVAWMZXEyT9kKOFs+TSfCXkLaxZVpKJllJu8/Q1rfl7PY2T0ETNbXnNijYR7HuU9MBTCi6ut+mjW9XUCsP9iaJ8d1RN51aCrM7Jf0zuXlRQ6J/pEJfYqh+iXMy/ZWD1gAX2fmY1pKabKHrEzr+Hb2Hp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824387; c=relaxed/simple;
	bh=s+LIl5bwpGjjVMrMi0dEyBqRGFbKUUFv1qeUx7UxONQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RO+RTf5fSmJeYBxkYhGevrL8aCOnNOtn5xFw3z5E8p4F7865hvPv4xj9GDbf/f9MPXE0UV9o7qENSiPEN0YBo04MZq+KohWhfDJ16GUHHgHJtNqN5nSYaOzxnyKJQBJXhD9d86Cbuaifbg/aDUB0TAOjKvpIlmT8HD8a3T0WYOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEOlaU1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEOlaU1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C473CC113D0;
	Tue, 11 Nov 2025 01:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824387;
	bh=s+LIl5bwpGjjVMrMi0dEyBqRGFbKUUFv1qeUx7UxONQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEOlaU1/jXFP4zRvHG7957N1a8O3lxztHnM8k/IqfKGnWIoed9uuRiAAPJ7Gs6vHf
	 kJM4b3gTjKqxMe8PuQts9/TM3uixRQAkDoaLKnrO692CiOjfUTJztJWumBqsLHFYCw
	 GRwAe1NFSQtFlMpnepbTwgj3X7h+gryWEiHaxMX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 485/849] media: i2c: og01a1b: Specify monochrome media bus format instead of Bayer
Date: Tue, 11 Nov 2025 09:40:55 +0900
Message-ID: <20251111004548.168098136@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 78d5d406e4b72..b7d0b677975d5 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -682,7 +682,7 @@ static void og01a1b_update_pad_format(const struct og01a1b_mode *mode,
 {
 	fmt->width = mode->width;
 	fmt->height = mode->height;
-	fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->code = MEDIA_BUS_FMT_Y10_1X10;
 	fmt->field = V4L2_FIELD_NONE;
 }
 
@@ -828,7 +828,7 @@ static int og01a1b_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	code->code = MEDIA_BUS_FMT_Y10_1X10;
 
 	return 0;
 }
@@ -840,7 +840,7 @@ static int og01a1b_enum_frame_size(struct v4l2_subdev *sd,
 	if (fse->index >= ARRAY_SIZE(supported_modes))
 		return -EINVAL;
 
-	if (fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
+	if (fse->code != MEDIA_BUS_FMT_Y10_1X10)
 		return -EINVAL;
 
 	fse->min_width = supported_modes[fse->index].width;
-- 
2.51.0



