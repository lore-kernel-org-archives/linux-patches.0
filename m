Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E281726B092;
	Thu, 13 Feb 2025 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459770; cv=none; b=kSND9ZtbyDuVoN/21KMrhoZxcH9masQoqtqYdYG6m0zbbwvE8V3n3F8VelXRktG49FJsV7lpsZ+cvLIC+nbeoB1bsRQX83ZrRIotCFmE/wbz2DfVcnDf2PdXvu9ymTnMwmV0Ne1GvSXk+WWg2GpTBGHZPd+LZkr+8QhiuBOB8lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459770; c=relaxed/simple;
	bh=UhYWvwvMMYSdwO5hgMc2LOhZ4ME4fGkoWnB/T4M/X7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOK+N/3wCQSEVUx1MXZxgPvKZ/OJMWR355+DnNnjTB6/5h50vGE34wPjttlC37IOslJkrOYqbkjwQkvgozEUIDT8E3RMc+ypxsYBenHX5OYLUdlW+r6FuireHOhRLj5hh5aWpNZqobRnwvHedGDEYIqeGhfJuUnCkIqQpxHFKtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqm1JI4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqm1JI4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D425C4CED1;
	Thu, 13 Feb 2025 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459769;
	bh=UhYWvwvMMYSdwO5hgMc2LOhZ4ME4fGkoWnB/T4M/X7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqm1JI4o1Q2VbcbJHIXY2OGNwstW0hoN/HExC9uEEVux7ttlnRVcfva7v9+x8rrIU
	 4YVU0e6uZaEUI+2ktk2OVnSdJ66iQFlIwCvfGZEEh6xXb52orC4RWPZ4HW9sx2Izli
	 5VMHVGy8CbZQKd+04u8IEfv+cZ/Uzq2H1z3DigbQ=
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
Subject: [PATCH 6.13 360/443] media: imx296: Add standby delay during probe
Date: Thu, 13 Feb 2025 15:28:45 +0100
Message-ID: <20250213142454.505211418@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -954,6 +954,8 @@ static int imx296_identify_model(struct
 		return ret;
 	}
 
+	usleep_range(2000, 5000);
+
 	ret = imx296_read(sensor, IMX296_SENSOR_INFO);
 	if (ret < 0) {
 		dev_err(sensor->dev, "failed to read sensor information (%d)\n",


