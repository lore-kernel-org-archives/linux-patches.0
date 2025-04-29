Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8A0254AE1;
	Tue, 29 Apr 2025 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945675; cv=none; b=kmQ7WS0UxKtJhiBhDaEIRZv/mGG0rX57a3gcFpJ0AexzrsKKVPKR7crTcQWv0MViq7ypR6a698n6gqIpWh/frKMNQQZNn04eThYKBV8UjVEawcPkdV06rfg6p3qRCqyW+Eq6bRQmgza9a0vtSL//S56o3t27z+gzSJtSEojBlHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945675; c=relaxed/simple;
	bh=0oVUmIb8bi/FujRmFgsqgjzLwKn8nH1BmnFlkhS7YNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO0U4utske1YCIy9jSLK+Eq13tmqDS904ZB2W1tz36D3vDRBQ5z1QspI7sVBpqS0XkIe3cxbHWxehOV2xKBnYftkdYWUca2yPZ2qB3PA015FQwhkg/V6dBwBwcTX2L6HQPnR8IzIYIyWll3b0HPZLY0hjLA/OL8YM20+8BI6mPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbclQEWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbclQEWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5616C4CEE3;
	Tue, 29 Apr 2025 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945675;
	bh=0oVUmIb8bi/FujRmFgsqgjzLwKn8nH1BmnFlkhS7YNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbclQEWqm/e7mkOuUshl7+ki9ciqnHFCLaUSzNjrYQkQCi1ElmcKL5nx8rTr/Y/5n
	 nF2yNrSBUsNZJLrsQlJ51YoBHOOcUuTwZLo1gwPtI2ZbgMd3K2qORTuFtF8yzNgn+n
	 47Pfx7iD12AGsa9isDzvAOGex3KlFyeH0YrQM9V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 012/311] media: ov08x40: Move ov08x40_identify_module() function up
Date: Tue, 29 Apr 2025 18:37:29 +0200
Message-ID: <20250429161121.534719345@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7a39639e448f070cbe37317ac922886b6080ff43 ]

Move the ov08x40_identify_module() function to above ov08x40_set_stream()
this is a preparation patch for adding a missing ov08x40_identify_module()
call to ov08x40_set_stream().

No functional changes, just moving code around.

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: ebf185efadb7 ("media: ov08x40: Add missing ov08x40_identify_module() call on stream-start")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov08x40.c | 52 ++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/ov08x40.c b/drivers/media/i2c/ov08x40.c
index 83b49cf114acc..580d902977b68 100644
--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -1937,6 +1937,32 @@ static int ov08x40_stop_streaming(struct ov08x40 *ov08x)
 				 OV08X40_REG_VALUE_08BIT, OV08X40_MODE_STANDBY);
 }
 
+/* Verify chip ID */
+static int ov08x40_identify_module(struct ov08x40 *ov08x)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov08x->sd);
+	int ret;
+	u32 val;
+
+	if (ov08x->identified)
+		return 0;
+
+	ret = ov08x40_read_reg(ov08x, OV08X40_REG_CHIP_ID,
+			       OV08X40_REG_VALUE_24BIT, &val);
+	if (ret)
+		return ret;
+
+	if (val != OV08X40_CHIP_ID) {
+		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
+			OV08X40_CHIP_ID, val);
+		return -ENXIO;
+	}
+
+	ov08x->identified = true;
+
+	return 0;
+}
+
 static int ov08x40_set_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct ov08x40 *ov08x = to_ov08x40(sd);
@@ -1974,32 +2000,6 @@ static int ov08x40_set_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-/* Verify chip ID */
-static int ov08x40_identify_module(struct ov08x40 *ov08x)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&ov08x->sd);
-	int ret;
-	u32 val;
-
-	if (ov08x->identified)
-		return 0;
-
-	ret = ov08x40_read_reg(ov08x, OV08X40_REG_CHIP_ID,
-			       OV08X40_REG_VALUE_24BIT, &val);
-	if (ret)
-		return ret;
-
-	if (val != OV08X40_CHIP_ID) {
-		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
-			OV08X40_CHIP_ID, val);
-		return -ENXIO;
-	}
-
-	ov08x->identified = true;
-
-	return 0;
-}
-
 static const struct v4l2_subdev_video_ops ov08x40_video_ops = {
 	.s_stream = ov08x40_set_stream,
 };
-- 
2.39.5



