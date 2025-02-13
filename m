Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D4313C816;
	Thu, 13 Feb 2025 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460822; cv=none; b=iK7aWuQqLQbm13IQd3HenUEnhzHG74JsWNJZ7G8Z6oYeMBgrQbsfIX3WWkpUrSEBqAZY6+DH4wm4tKPFYkQTxXzOvUwItpvhIt2MiBpIHK7vq5qWsT/Uk4v4WQ/eOh8xkoMAdz2EyarBqKMuQYWafI5dV4LmC3XytDDweEC1aUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460822; c=relaxed/simple;
	bh=rzd3XT2mdd9fTve0SrmB3kTfnJKZ3xGe4Qlg7A6DbY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAxsIiNT5PkOAQg5G4xB6WxOYCTDPD0H8wOW6yTlPFpJsPenkJB24/D16IY0X5XdhiuCKdjwLDdUn0a14DOlJYmA0/HAli6IeHcZmdJ718ZcnclzlVrms6/l8ybOW2hW/R4D+CzQzvZr498r0cYitkzIhi/KY+bFb0yEl9/KdEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/ZqDtkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/ZqDtkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A03BC4CED1;
	Thu, 13 Feb 2025 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460822;
	bh=rzd3XT2mdd9fTve0SrmB3kTfnJKZ3xGe4Qlg7A6DbY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/ZqDtkLA1wQxmXm9CyEfLYjJU0uoYDEH6aWkInN8zQsrnPQty+UCs7gWfkEkUBJ2
	 WY1m8XR96bJU1vHifzTMkRyrOBDvNVZLwXOIWNCZ2nqpUVrZTkaTw5slFVoXw9BpuU
	 Qai6mOp93ZJvVGEJakQU0YGUxJSeGTJFmlNH+kPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <aardelean@baylibre.com>,
	Naushir Patuck <naush@raspberrypi.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 205/273] media: imx296: Add standby delay during probe
Date: Thu, 13 Feb 2025 15:29:37 +0100
Message-ID: <20250213142415.422100331@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naushir Patuck <naush@raspberrypi.com>

commit 57d10bcac67707caaa542e09dee86e13ea85defc upstream.

Add a 2-5ms delay when coming out of standby and before reading the
sensor info register durning probe, as instructed by the datasheet. This
standby delay is already present when the sensor starts streaming.

During a cold-boot, reading the IMX296_SENSOR_INFO register would often
return a value of 0x0000, if this delay is not present before.

Fixes: cb33db2b6ccf ("media: i2c: IMX296 camera sensor driver")
Cc: stable@vger.kernel.org
Tested-by: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Naushir Patuck <naush@raspberrypi.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx296.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/imx296.c
+++ b/drivers/media/i2c/imx296.c
@@ -960,6 +960,8 @@ static int imx296_identify_model(struct
 		return ret;
 	}
 
+	usleep_range(2000, 5000);
+
 	ret = imx296_read(sensor, IMX296_SENSOR_INFO);
 	if (ret < 0) {
 		dev_err(sensor->dev, "failed to read sensor information (%d)\n",


