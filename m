Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69383F482E;
	Thu, 16 Jul 2026 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209114; cv=none; b=Fr/R4DvRjGpfllueIInfVgZI4qd5SBVmC68Ax+DaT+ICyFQjWuHj8jxPgvIUfJlXCVFFHixqSjD38f0HFYYDmSTV4B1GQCteFVMwir31gs2XzIfnXj8Qtr0bF6jQvjeeoaciymj4nc4SlI2FDE87JAMH36OOppXqrxBnYNwg4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209114; c=relaxed/simple;
	bh=45MrJh6UbuKvMXBfj2kRIiYrQiiIFbOSUvtBOBaf4kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIUji4C4Zqp8GwtMy6w/GiPfQ2Nelcgc8+2qyr8I1uT6vvDR7UzNKZi3DJ9/y8FnTn1izOLgAZp7tx7yhLrC0LW9JCFGEFfFUU7hhR7SD6nygbza18qisClzhuvoVcysVAcwC4lSJJ3DSzSITVZmXMYk5PlcyrFFm7dAsJ5I8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9kHwjAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9kHwjAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058FB1F000E9;
	Thu, 16 Jul 2026 13:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209113;
	bh=Sck3M/wTGzkTwzgt/D18hbsgLwTgrLsoa0GiCfQSFGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9kHwjAXVylb+JM83eb8fcGiZSvNgMJRLBCNLB4RMaMtzP98q5ol+93v/2brKsIUF
	 ftvMnr1/HYLfMJKJbEfn0Jmee3leyGMyZj4S6IFPyd/fCbekp69vUvUwfdwDoOk0TR
	 q3b66KBKKr9CvAHNtNH4/eEn/O0zf9stI0ZzjJ2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 061/518] iio: light: al3010: add missing REGMAP_I2C to Kconfig
Date: Thu, 16 Jul 2026 15:25:29 +0200
Message-ID: <20260716133049.118779362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

commit 84486e3bbda18a2df1ed74ca78e1e14bde9a941b upstream.

The KConfig entry for the AL3010 is missing a `select REGMAP_I2C`,
causing build failures.

Fixes: 0e5e21e23dd6 ("iio: light: al3010: Implement regmap support")
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: David Heidelberg <david@ixit.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -56,6 +56,7 @@ config AL3000A
 
 config AL3010
 	tristate "AL3010 ambient light sensor"
+	select REGMAP_I2C
 	depends on I2C
 	help
 	  Say Y here if you want to build a driver for the Dyna Image AL3010


