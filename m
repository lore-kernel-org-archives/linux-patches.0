Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A5F23BCEE;
	Mon, 17 Aug 2026 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976483; cv=none; b=OtaBy+L5OOxIGGEARJvlJrTd1diOKtUruCerCymJZVbWGU337ct4AWMTHAO1RE1CP1xlT5VxYcDAimt2wUF+JA+AOgTI4RuZMpjCEOv2QVp7Vh+cIT17e3lHu63l+FOQj4AhnP5bTU0Ql9BGFTaHcrrtHGVP307XybtP9SpK76A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976483; c=relaxed/simple;
	bh=i9UKRDfMgR4DufPni8JQ9vuYAJWHbxxpKLWJtSEYCao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6ZRrtERux69yQmf9uALy8Yx+oCTC+1EWt185Lqw/feOBBWxZ0bgF7Y0ZYtbZWpnv/kv0aCUtnfdQZ4US38sll2p98SzyL/3hBpFK/1kntgssfIynLpMUUUJyitTCZgF6VUlZA5u/4xu7uiwyhcSHsd6xXn5/Yms+yb5Dslb9BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5lO/VkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5lO/VkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C167E1F00A3F;
	Mon, 17 Aug 2026 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976482;
	bh=cOgREUmT5Lx0MeITSW0k3vMHq3CCZIzhyCpD5Yi6iPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5lO/VkMq0eU3h4PXoAJh++DY0kRZHF3L3mfXLHK+fHj0zeO4Yiqg4F6lHt0hUr9U
	 i5Npo0dRC6dODuvw0CrOX13mwyUtHEsRPijCtaAUDg0EFQ6Fmnd4tSvmR25q2ON5GP
	 gRDDZ7vnISserdtjvXbz3VMTG02/d2QY/y86kJZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 388/389] hwmon: (adt7470) Add missing dependency on REGMAP_I2C
Date: Mon, 17 Aug 2026 15:33:47 +0200
Message-ID: <20260817132553.787763239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit b6abcc19566509ab4812bd5ae5df46515d0c1d70 upstream.

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-2-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -239,6 +239,7 @@ config SENSORS_ADT7462
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.


