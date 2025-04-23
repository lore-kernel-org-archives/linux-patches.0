Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C9D28A400;
	Wed, 23 Apr 2025 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420973; cv=none; b=gUPB9pKbIDaPE+/3vcGHl0kDDabkf3Qm0IBhNAlUyqHMspMmcyRQkFS/fX3DeCFh4XyL+LOUAI2FYC3GnPVYv4wX20zPjquirdGlYwJhZWdRnJWbjsm0nnYltqWG5PPsbV3Fm9vC+64oqP/7Cqb7ZFGB+no2L/8kr1zCgiu6Q2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420973; c=relaxed/simple;
	bh=XRXdCmsa41wUED8SumZ2K6tSfydhWeICS1neiC24zzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7rF89TWcykoFt29xDWIFBo8kqg8CA6IN5f4dVcO7/On31dciT0OGPDun7Ip7SBf8z4c4Cub8K4SIE66xlUWLfXNacSpd6pGGUUcuZbbRj8bwFfrVxxznwNQ4WE77Im/h99xplkwGLVVwmi6L2cU8tJbklOiOxtqWVfXyb7ibEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4suVVoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4suVVoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDDAC4CEE2;
	Wed, 23 Apr 2025 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420973;
	bh=XRXdCmsa41wUED8SumZ2K6tSfydhWeICS1neiC24zzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4suVVoes+G+XP27BCQ81ht+0zd3RpmrOuwYQiP7EDkB0u3P10K08RF8AXOhK/AQO
	 pIzGQ2lLEhu+UTS8AnDf88FECz8iBQm17EegRFxJbfRqrJFc+yq72yTsnBXcO5j+Bh
	 MjcGcxdg6HyfQnWpxYAOnhpRG/lkqFMlwnKxedr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 097/291] media: i2c: ov7251: Set enable GPIO low in probe
Date: Wed, 23 Apr 2025 16:41:26 +0200
Message-ID: <20250423142628.320527769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit a1963698d59cec83df640ded343af08b76c8e9c5 upstream.

Set the enable GPIO low when acquiring it.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -1675,7 +1675,7 @@ static int ov7251_probe(struct i2c_clien
 		return PTR_ERR(ov7251->analog_regulator);
 	}
 
-	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
+	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ov7251->enable_gpio)) {
 		dev_err(dev, "cannot get enable gpio\n");
 		return PTR_ERR(ov7251->enable_gpio);


