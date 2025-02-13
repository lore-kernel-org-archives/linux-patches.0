Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4065114A605;
	Thu, 13 Feb 2025 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458177; cv=none; b=a4+p08uc7kGdX2hBjrh5AsFojMIZQCzew0P25V0DoGRuIDmPm6jASZ0zvTgffIgb+JvzvwStI/37EGLjmd+Z2AxjyxN7BCRxcyY6Ra/H+v1pf4a2GvlcLvyPxV3SQujm5Zq3q9mok7qSoTteZO9hlq5m5Hi6KCLHd0+Cb01qxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458177; c=relaxed/simple;
	bh=9eNLhlrxKG7UbMAmOlS+YNS8dYaNojFpJqx6XDUMxi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jj95wvNN8TNJWVeCP+KO7te1dhtLMIOxHA82qaJ+WKWCJtlkXwDr278s4baxIwOo/dgvW5i3kHCXv6x+E41HHvGoKADjUTklOnLkBTgvvcV8Z/XG89c01lFn/qidTS2QM042g0KNilzt9y4dLtBJMtNC5gcND6pzgZZA/jGWXcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2incijDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2incijDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E39C4CEE5;
	Thu, 13 Feb 2025 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458176;
	bh=9eNLhlrxKG7UbMAmOlS+YNS8dYaNojFpJqx6XDUMxi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2incijDxZR5YZP27q8RervhT1rDAdRIKVuumD5bEBpxwarH/iV6qKFj2MU8r2IXJS
	 Jp9krpn2YBLoUsyudphOR+gVUpMmG0VFhiKSivieGYHT88jzJfErhDju5WljDjszJk
	 WeKpE9N7WwwFtCJplEfrCvva1sev31KXXhIis7Uc=
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
Subject: [PATCH 6.12 324/422] media: imx296: Add standby delay during probe
Date: Thu, 13 Feb 2025 15:27:53 +0100
Message-ID: <20250213142449.053961851@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


