Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C60D2FFDEA;
	Tue, 17 Mar 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766954; cv=none; b=PdynyAIjp9kYwfel3hq9ikmxrAY6BzTjqz9J1MnmLqZ03tLNOachkzg2IfOJND4Sdf+0UUiqsicHAeR+pdffGNsPhxg587WHRZ/9BB5qe2ZgU2cNB+JnSLbSYj/DHfwbB7QgmHXOSV1hc3IU0UpBjo/AKyMvE7SHCfcTurTF4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766954; c=relaxed/simple;
	bh=D/Z/2vAoOddETP/k7RNxxuUiPmHQOHcJAJRS07plUHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOqTsYDkTQCcy7Hj+GxgrXosckwDXxG4wfOPCgA6tTuP/lTMCBS64AMh0cw2b8WFQakaEjEOvkriWDkyqOrOOg+3fwPP61rDxIzUGBNyXvm26pRFdLpaznN7do6d4RJvIHbyhzjlfneLBUZO6G5m5tIQmcN8laT7/r3V6E9qWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNNAAilP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNNAAilP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA37C4CEF7;
	Tue, 17 Mar 2026 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766954;
	bh=D/Z/2vAoOddETP/k7RNxxuUiPmHQOHcJAJRS07plUHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNNAAilPg6ZFfQrsWBZzJWRHvflAgRUDBMp/Nrr/SWeP+1IwxVjlB/9XGXoPVj6Y5
	 g63c/V+B1aH3ybpgPjnvmwubLEjdGbuwjQqwgC+6eQ4lqXHnWlnTLF5jXx/J1Q3oNu
	 pKUFQGNNmsfWYoCbqLYd7Wy452HfWssjUkOI93ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Andy Shevchenko <andy@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 359/378] iio: imu: inv_icm45600: fix INT1 drive bit inverted
Date: Tue, 17 Mar 2026 17:35:16 +0100
Message-ID: <20260317163020.188553715@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 7ef74d961d1ad6ec72b50887ca119d7f98f07717 upstream.

Drive bit must be set for open-drain mode and be cleared for push-pull
mode.

Referring to datasheet DS-000576_ICM-45605.pdf section 17.23
INT1_CONFIG2.

Fixes: 06674a72cf7a ("iio: imu: inv_icm45600: add buffer support in iio devices")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm45600/inv_icm45600.h      |    2 +-
 drivers/iio/imu/inv_icm45600/inv_icm45600_core.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/inv_icm45600/inv_icm45600.h
+++ b/drivers/iio/imu/inv_icm45600/inv_icm45600.h
@@ -205,7 +205,7 @@ struct inv_icm45600_sensor_state {
 #define INV_ICM45600_SPI_SLEW_RATE_38NS			0
 
 #define INV_ICM45600_REG_INT1_CONFIG2			0x0018
-#define INV_ICM45600_INT1_CONFIG2_PUSH_PULL		BIT(2)
+#define INV_ICM45600_INT1_CONFIG2_OPEN_DRAIN		BIT(2)
 #define INV_ICM45600_INT1_CONFIG2_LATCHED		BIT(1)
 #define INV_ICM45600_INT1_CONFIG2_ACTIVE_HIGH		BIT(0)
 #define INV_ICM45600_INT1_CONFIG2_ACTIVE_LOW		0x00
--- a/drivers/iio/imu/inv_icm45600/inv_icm45600_core.c
+++ b/drivers/iio/imu/inv_icm45600/inv_icm45600_core.c
@@ -637,8 +637,8 @@ static int inv_icm45600_irq_init(struct
 		break;
 	}
 
-	if (!open_drain)
-		val |= INV_ICM45600_INT1_CONFIG2_PUSH_PULL;
+	if (open_drain)
+		val |= INV_ICM45600_INT1_CONFIG2_OPEN_DRAIN;
 
 	ret = regmap_write(st->map, INV_ICM45600_REG_INT1_CONFIG2, val);
 	if (ret)


