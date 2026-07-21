Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD553FE67B;
	Tue, 21 Jul 2026 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655104; cv=none; b=s8xo9zCrPsC7YKsgcKcqGL7rCkTmsEz0Q20vYsnTOCBMK3EWEh8Qozoqqs8eNkxYRh3DrcRupqjwgnd4mkqrch4R4FsskFDZsYxJR0NXyiIqpITI0EX6E0f8WmE7BXSN5CXq8ibXrMvg0mUipl8wDpwQiw6ozrWx5k5xaeLJGXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655104; c=relaxed/simple;
	bh=WofCAD3ejaic+uh/2976CCY+9ioddaxWTJodrPo325g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbPhckwW15xq9kZgqdycYtX01cs3iE569LM1GZnzIs36aavFyRsdHsOghCc6oPNWUPkKgcx4Y5d8+GZ7ha554SdU5uLEbnWvRYiV+3zK/38Vi9h01vstGB8ISFhCoBnN7cB/cdl4Iqg0RR6blVvJ4W1AESgwY/cw/f8ff/JK6HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGh+7Ebd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGh+7Ebd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1C41F000E9;
	Tue, 21 Jul 2026 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655103;
	bh=ej0zxtmUZPeYkcXLJS0vffRaxH9IAeNy4F4DdiogWhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGh+7EbduLetVEoizUX+Qpy4dGE01N5JE4kDqG21AqoruXw51t98SNPkblrEu4/iB
	 RpWmlAr0YnyGPN/kqMqaGlxB5W/e5JrlqZuPVeenILbegvSZQ6fdvDC2W+hFRzTkCD
	 IydxbAqm8aO9i5ToGYuCrW8hXzyMsoGDjYETbIg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 1957/2077] hwmon: (max1619) add missing select REGMAP to Kconfig
Date: Tue, 21 Jul 2026 17:27:10 +0200
Message-ID: <20260721152638.869003712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 943a749bdffdd2132fab9240db890e07d93e1fcf upstream.

The Kconfig entry for the MAX1619 sensor doesn't contain a
`select REGMAP` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: f8016132ce49 ("hwmon: (max1619) Convert to use regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-1-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1215,6 +1215,7 @@ config SENSORS_MAX16065
 config SENSORS_MAX1619
 	tristate "Maxim MAX1619 sensor chip"
 	depends on I2C
+	select REGMAP
 	help
 	  If you say yes here you get support for MAX1619 sensor chip.
 


