Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F48242D6E;
	Tue, 29 Apr 2025 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946863; cv=none; b=iPrMIn2cifI6Pkz4vPM8NIESv2Fs1geEGRrIF0HQL00f5v3Qq1HsiqqPMcPIcZb3MfVNSNGBiCKba9q9yl8HBdtP00h6a5nv6x7SueO86fHcjXoHBKBth9k86ed+5wtlsbP/H53RgnnNQBFnBHJiZpV7ZcIx9fsmO6t5HnjrKa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946863; c=relaxed/simple;
	bh=Ye6zvPFo7XPLiCVIYX8MP9OMK+1HKKUoqHkSBEogh40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sf/NdXyCYEO5w5gJ1Oe66sPTB9k9QTIIRsTIN0EodfKMLu4T4/JUh+e3ZqW0nnsCGNFN6Z61qC/MkV17lqDStKrzkrAoJdb75oZTcVxemf3m8YWyzhglUpzGlIlXjl6qTnRS0kNn3NtlawNxWcBIr7dUuRGG0N5OoDD5s3DurzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Umav8Y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Umav8Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C8AC4CEE3;
	Tue, 29 Apr 2025 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946863;
	bh=Ye6zvPFo7XPLiCVIYX8MP9OMK+1HKKUoqHkSBEogh40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Umav8Y0qAablVbgIQ1b4dL1IvWTiJNnJ1FmWaDrtZ5Ba/kqi64rgoT/ymekzW6kg
	 8qB5nJwkiYRugvq0+QHjUDjnMBzyzPBu0RbcR/H34W2jDNzlR0eGHWdDouUt9uC9RZ
	 upMe1mA5pddanE0WKgo7+rE5ObADkT1/r5vLL8dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 066/286] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Tue, 29 Apr 2025 18:39:30 +0200
Message-ID: <20250429161110.557429219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 3d391292cdd53984ec1b9a1f6182a62a62751e03 upstream.

Lift the xshutdown (enable) GPIO 1 ms after enabling the regulators, as
required by the sensor's power-up sequence.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -748,6 +748,8 @@ static int ov7251_set_power_on(struct ov
 		return ret;
 	}
 
+	usleep_range(1000, 1100);
+
 	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
 
 	/* wait at least 65536 external clock cycles */


