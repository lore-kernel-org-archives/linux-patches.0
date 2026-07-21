Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C5046D56A;
	Tue, 21 Jul 2026 18:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658982; cv=none; b=efNJHjXdGsn+qPf7x4hVmzYsSfciM1xpusG3WBWMKzky+tGtEaRyeZ/Z3p1/tYGmm8aObX1pUSHrEuDbQItsjuPPsrU+wL+lsI5pYxNt4a1xRHGJYWmYMGq/WeDIflU1TLTJkN62M5ozj8ikQsX6DEP/ftWVcsu6i1xqVXD9+Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658982; c=relaxed/simple;
	bh=K82PdBK1CaxeofuhL+lku49wlWeeuIP1USSbHrAoRAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufWi60B+JOy9aUNN8h0C5yTnNNdBoKTNxsMF/ES+wVSHEIYv0+WRwHVLqLTdaQQf1pCXxlm3whKPFjJioxfAsdpZmg9p/ZYDc+aqCG85rq+8FqQmUUOxB4FrwyhtvQjQMOY6GqN7DZsmYd91p1MxV9eRfD5tJGw5BU+T/4P6rYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rO55dTpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rO55dTpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FF81F000E9;
	Tue, 21 Jul 2026 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658981;
	bh=8cqGbcv6EPqrBoQT2WbQcdwf59axuHyZ/bH3a5lwB/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rO55dTpTMCcmPzcutpqnI5CF3KFbfz/MRel30EqVCvSOG/5VYIbpDfYa0nkxmgO+J
	 OoWjD2gqqudF46TYpVfoPAW1cleReWIqfc5ChXJhxSBU2zAVJ0ltGFyaUIpoDHmKIt
	 2rRYSdaBcpMjPQUz+6HUaIqANIm35e8pyYYIxFDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1306/1611] hwmon: (max6697) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:23:42 +0200
Message-ID: <20260721152544.826673125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit ed576f2f4eef8cbe2c110da503825a8dc4717030 upstream.

The Kconfig entry for the MAX6697 sensor doesn't contain a
`select REGMAP_I2C` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: 3a2a8cc3fe24 ("hwmon: (max6697) Convert to use regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-3-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1331,6 +1331,7 @@ config SENSORS_MAX6650
 config SENSORS_MAX6697
 	tristate "Maxim MAX6697 and compatibles"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for MAX6581, MAX6602, MAX6622,
 	  MAX6636, MAX6689, MAX6693, MAX6694, MAX6697, MAX6698, and MAX6699


