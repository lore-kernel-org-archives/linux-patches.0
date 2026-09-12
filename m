Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7680344DB5;
	Sat, 12 Sep 2026 08:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202983; cv=none; b=gJxbwZmoZDmb4SpRlSwb4NhweOQA7uwCClsR4+QRqYYEymIvsTT23bMfNZZbKjVmlt/O5etZQvvW6WvmCTNfq0oBBkVBRvKjSvwfWOM29OYDxaKQnrGF51NK7UIF4DpM9IXZxnTINQ/SiucCT4oYeHR40EVazud89v2B5rcySBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202983; c=relaxed/simple;
	bh=lcgG/n3k5Xz6J/UhRFneC1MnkuEo6Qq7rx+ObUVS+n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgz8UhkT0Bk50nb9iEWOc5+JuN8tx8FJeeADKfCxndnEo6raHC+lUT422IEV2xJt5hz/XPFORSLNi2/0UabL8A22eUw4H1+0QrOQldFVV0yhczIfB9VKluxsODYx9otm+iyGVpsfx4yTa5Vvo8WEK9MH1jeBMW6tkgb3QmhatZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zI8uEhdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zI8uEhdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B9B1F000FF;
	Sat, 12 Sep 2026 08:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202982;
	bh=Shz2yEfvOPLll2ivxvr7Koo8NXT3dKgFovy5svW4HSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zI8uEhdHOy1l2vPLq0mgANz+Ip39ixj9osgX4aqvfPs8WGjO+ZSjDeS6a8c0kGEss
	 PLkNKdwEWRr7pN/UbM+ZDI0jhzolzstpZ9Nz0X83W9VfGrse9mEQPpvDsk2B0sR9MP
	 6hdZhANQ/vn/57CS+ggwkH2L2MbLCEmvNFwlhjkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	surendra <kr494167@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1314/1815] hwmon: (pmbus/ltc4283) Add missing MODULE_DEVICE_TABLE for OF match table
Date: Sat, 12 Sep 2026 08:51:04 +0200
Message-ID: <20260912065719.866918110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: surendra <kr494167@gmail.com>

[ Upstream commit bd300460cee457c50a16a42654d6de4c85562785 ]

The driver registers ltc4283_of_match as the platform driver's
.of_match_table so the kernel probes the device when a DT node with
compatible "adi,ltc4283" is present, but the corresponding
MODULE_DEVICE_TABLE(of, ...) call is absent.

Without it the module alias table (modules.alias) does not contain an
"of:N*T*Cadi,ltc4283" entry, so udev / kmod cannot auto-load the
module when the DT node appears, breaking modules-based deployments
while built-in configurations happen to work by accident.

Add the missing MODULE_DEVICE_TABLE() to fix module auto-loading.

Fixes: dd63353a0b5e ("hwmon: ltc4283: Add support for the LTC4283 Swap Controller")
Signed-off-by: surendra <kr494167@gmail.com>
Link: https://lore.kernel.org/r/20260721055022.34629-1-kr494167@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4283.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ltc4283.c b/drivers/hwmon/ltc4283.c
index 9b85293ea6649..9ec409bc26482 100644
--- a/drivers/hwmon/ltc4283.c
+++ b/drivers/hwmon/ltc4283.c
@@ -1772,6 +1772,7 @@ static const struct of_device_id ltc4283_of_match[] = {
 	{ .compatible = "adi,ltc4283" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, ltc4283_of_match);
 
 static const struct i2c_device_id ltc4283_i2c_id[] = {
 	{ "ltc4283" },
-- 
2.53.0



