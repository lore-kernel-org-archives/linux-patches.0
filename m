Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE005A79B;
	Thu, 16 Jul 2026 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210504; cv=none; b=JV/tPj/9CRNlIgoS8bjY8xK8uCmJHqHPwJSyRn+LvrNEiieCih8FEJIlvoq77p3VNY+9PTDXRriRTx0Xf3LbpquUkTwSiYbhT1db9YeB7oraa3h/RfCSC9ljXGAC/xvO+rKLsdHKQx6MCi5nKKLRVQMBc8sHNJI/47dnDxQCFBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210504; c=relaxed/simple;
	bh=2qhJzOBX7NSHPqXCbod7zj1lSKJOfoRT/+ONfZM2ayE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snjK9/NOfbFygWE/ZAzQ8v5PMFMODait/zBs4G5Fk7yMnnyhJ3zWd38afBF9gZxlGMRMdUAWu/4OVsc4aAUd14G+RbtTSKDcjlQYr8UtyOrBUHcarrOa1pbXRzMl6BdXJKbdOmQDViAEOMk9LUhKTzGwVLVK63Jt9NdQiX/1epY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbpbSIT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbpbSIT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE241F000E9;
	Thu, 16 Jul 2026 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210503;
	bh=c5KS+WrUYV2G7HmYyj/uzvkl08Kpbo3WD/uu8vmnuiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbpbSIT5mKc+PkzceMrmss7z2b7w7n+agMq0h677YL21FblwBhNc8sRlhXkTFJH0k
	 ya6lRtI9fnmi3uY0ltkFptWqwq0KU+qbpxhvqvH4AOioSFLnXwBHBs8VK6FhgdF0Sk
	 N+tSbXEnXDgC9TRTfexefdorL3KwS8KiGduFvH2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 072/480] iio: light: al3000a: add missing REGMAP_I2C to Kconfig
Date: Thu, 16 Jul 2026 15:26:59 +0200
Message-ID: <20260716133046.269338353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit a2d30022b7c316ad845d1b696e724058b88e5a4e upstream.

The KConfig entry for the al3000a is missing a `select REGMAP_I2C`,
causing build failures.

Fixes: d531b9f78949 ("iio: light: Add support for AL3000a illuminance sensor")
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
@@ -45,6 +45,7 @@ config ADUX1020
 
 config AL3000A
 	tristate "AL3000a ambient light sensor"
+	select REGMAP_I2C
 	depends on I2C
 	help
 	  Say Y here if you want to build a driver for the Dyna Image AL3000a


