Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FFC1DFF4;
	Mon,  1 Apr 2024 17:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991132; cv=none; b=eab3TCYCIZyOnvTb3u2QtEgFJw5/MsxxmANDSEFwMOgtgsMCOdCeARKE0lP8Nw0b1obAD8j2+t6he0UO2v+hh9IqaNk16m8jJ/S+lz15ZXYYCID1RQ+6NDauSgw3oths14yGCcex4IJV1W6GOPrjybsP+0LPjfxVnGT85cSHWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991132; c=relaxed/simple;
	bh=+6URVwDLuobUNmO16BVqfYqTTpCHaU2kH7oqsx1ndkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCQVR3QhxKrnKHKHTNh2Pmj/WP7keUOWhpbaQIhWIC6+z/f72AhCYXpPVe6BCNptB5naxcIpw81hehP4xAlp9LPdmzDuaLRYF27aWXc2HJDVum4xTLUSkIURm3c7cK5YXBpMEXihbbdRhBleriOk6BunzWG6o0ngDqnyTDLIvMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4/2ogLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4/2ogLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C15FC433F1;
	Mon,  1 Apr 2024 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991132;
	bh=+6URVwDLuobUNmO16BVqfYqTTpCHaU2kH7oqsx1ndkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4/2ogLt9ntE9mm9czhcwoeTR8lwi3Ccz/vSi7v/rxY7MUaps60F0MP35uAqHcKJ+
	 uNlOTbyODovurWPdYHJHvqlWbaEtrEY3psxYTzuZu4T9okuQBOMGxzU+EWYZ9O58OO
	 UIhXyhoy+mRf93C2oKTNLt2d4y4JkYiMaoy2KCqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 172/272] iio: accel: adxl367: fix I2C FIFO data register
Date: Mon,  1 Apr 2024 17:46:02 +0200
Message-ID: <20240401152536.130445241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cosmin Tanislav <demonsingur@gmail.com>

commit 11dadb631007324c7a8bcb2650eda88ed2b9eed0 upstream.

As specified in the datasheet, the I2C FIFO data register is
0x18, not 0x42. 0x42 was used by mistake when adapting the
ADXL372 driver.

Fix this mistake.

Fixes: cbab791c5e2a ("iio: accel: add ADXL367 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240207033657.206171-2-demonsingur@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl367_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl367_i2c.c b/drivers/iio/accel/adxl367_i2c.c
index b595fe94f3a3..62c74bdc0d77 100644
--- a/drivers/iio/accel/adxl367_i2c.c
+++ b/drivers/iio/accel/adxl367_i2c.c
@@ -11,7 +11,7 @@
 
 #include "adxl367.h"
 
-#define ADXL367_I2C_FIFO_DATA	0x42
+#define ADXL367_I2C_FIFO_DATA	0x18
 
 struct adxl367_i2c_state {
 	struct regmap *regmap;
-- 
2.44.0



