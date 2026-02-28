Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF154BC03C;
	Sat, 28 Feb 2026 17:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301364; cv=none; b=TvSDyzkstSCwvNGeEW0BtMP4gKPgnSzKqmAY4FUb3QoCq1hvB+eDzJpVMeb/UEfldJCzbDXatSQauUcasnG6x8yRQ/2fUHcWy6ReVJrFT7vc1+5Dx/1P/iPCrceni1ASGJ5vNgrtrK7tiKo9/UFjtpWtO5Qhe+g11b8MBRnDiFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301364; c=relaxed/simple;
	bh=s3yDxUuIIIvd2yaG41DZabKKL38dVe+r2GKckN3hqmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=claRPxeEzR05mZyTjXAELcLDgZ5oOzXb7wxaUc++ayAFeQnT/6JdjzKGfrx6UfDvMQvLh4rWXKT7Le3MQPkm7xVQXERRfs3FALTj+JGQ6yMrlbuApbgiZRzqva86AsTX9xQR9/n2esgADtrDoEcxpGWGEkYhU+OoipS0kL3FjFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+hZmSHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+hZmSHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C607C2BCB0;
	Sat, 28 Feb 2026 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301363;
	bh=s3yDxUuIIIvd2yaG41DZabKKL38dVe+r2GKckN3hqmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+hZmSHjY21xBivhv73oRN7VuySEj6Ovz5Eg5q/NtI+AgAxjS972ceXwAN2tKb4xU
	 gxwPy2696zIXCVjE+XTO0Tz88oGVRiyvmob3VaiqZfPwvkPfq/Eb2U5Q9wmyIpTyjz
	 2NqW5JQ0IIPi0u7imI8Y90y6ROMWqk8SdiF3GuaGw45/v43gDycY4eJCPpGHDiz7Oo
	 7EIrWMUFhqT6PZeJWcEpZ43X9zGLmBRXxmtNj8rJmeBrPpE+sRyNLsnfPM46hI+RhB
	 7LEcp8vjXRKE34Dhzg2KjO8fzI5+jhG2Q5v1415jyjSwwKwIDGc6Ydgi9UQo3WTY2E
	 N8GwQ5+GxI0TA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mehdi Djait <mehdi.djait@linux.intel.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 552/752] media: i2c: ov01a10: Fix digital gain range
Date: Sat, 28 Feb 2026 12:44:23 -0500
Message-ID: <20260228174750.1542406-552-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mehdi Djait <mehdi.djait@linux.intel.com>

[ Upstream commit 91848c99ed6a98daf77f4cb7d44cf3f13bc6998f ]

Digital gain wraps-around at the maximum of 16838 / 0x3fff.
Fix the maximum digital gain by setting it to 0x3fff.

Signed-off-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index 3ad516e4d3698..c1a7373a6311c 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -57,7 +57,7 @@
 #define OV01A10_REG_DIGITAL_GAIN_GR	0x3513
 #define OV01A10_REG_DIGITAL_GAIN_R	0x3516
 #define OV01A10_DGTL_GAIN_MIN		0
-#define OV01A10_DGTL_GAIN_MAX		0x3ffff
+#define OV01A10_DGTL_GAIN_MAX		0x3fff
 #define OV01A10_DGTL_GAIN_STEP		1
 #define OV01A10_DGTL_GAIN_DEFAULT	1024
 
-- 
2.51.0

