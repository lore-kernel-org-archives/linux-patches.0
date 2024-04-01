Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5C71CA8F;
	Mon,  1 Apr 2024 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988772; cv=none; b=ATv+qTjP9Gen+AdNu42SkiwslW6JMe6p1bQNuLPEn5h1gMBkpG7WVhBCyZ00NFeU8r3WsD+uNRyZv78vdBaYhuwEfiCiZSQjCLgWsAdxyRZXJybTayCUsLnb6OWFLOU5qtI3QP7wfROnoGdZVt0IiLSzY9tv+gN/EBTe1V9SDJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988772; c=relaxed/simple;
	bh=buMy+Nwo9PsuHF2h4vVSjgGcuqKxRCJ2xcfvB2HtIUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpKVKnAhcDWbUWAKdAZFO4Vj6sdc3/1JfmSiwNszoEjsY5jX0INM/tZJCDUX5XNB4uJJfsTZxLFClS0pG/IQg+el0T+hGXbTqNd110uHaR4mtNoFuP6adO81GNZp/659pQiPF2/j0vn8K06pzxmUDKpCwtvDwGdQDcAGVkPA7Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFGKaAqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFGKaAqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F353C433C7;
	Mon,  1 Apr 2024 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988772;
	bh=buMy+Nwo9PsuHF2h4vVSjgGcuqKxRCJ2xcfvB2HtIUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFGKaAqO6I8woeC4WRpCLS/HnCNa5RlWFAa8lER5CHZAbLIfFk8Vzc4QIqoIX/tfg
	 8z4vwxFBfCdFPSeuFrDq5XXPGyJyxc81iOPLmjHSNBGDg1qaXd72jh0oOwY8AiME4e
	 YUEqcDUuStZiqoym+5OmMeukRu3vlmZLZZUb//B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 283/432] iio: accel: adxl367: fix I2C FIFO data register
Date: Mon,  1 Apr 2024 17:44:30 +0200
Message-ID: <20240401152601.614457284@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iio/accel/adxl367_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/adxl367_i2c.c
+++ b/drivers/iio/accel/adxl367_i2c.c
@@ -11,7 +11,7 @@
 
 #include "adxl367.h"
 
-#define ADXL367_I2C_FIFO_DATA	0x42
+#define ADXL367_I2C_FIFO_DATA	0x18
 
 struct adxl367_i2c_state {
 	struct regmap *regmap;


