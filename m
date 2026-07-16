Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DAC23395D;
	Thu, 16 Jul 2026 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210509; cv=none; b=WqQDxlKMBeH2kQvFQssTRX2/6BJuFYGoY1Aw1MN/odDiOOyzk4hoXr9AW3fQHGpHV7bziO+6P6BXcp7gHPDBRLEuD8rqieDaSmP4bS0pnTgYL14qr7/V5+D9F3S13SQO+F1agrn8nwRUXJqzvmmnQhqidJ0CsOvE22qr1fYKD2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210509; c=relaxed/simple;
	bh=gTnQSPuehJ86mgkAc30oyKNA5rFuwWntifmR57FzTXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azu705286oc7LRvtLOCTyBtp7spmROXrfxyTihHqi4hYTaBsZ/m533BpW7j6Gt9+HNIqP02BRRYzbBbtTBa8jbriSIHFC4RE73W/sN5vadX57P/nSiH0BzLuyE1GEo2mBEHkTffTPqD/92KeFsuHceohGTCwsMle2qvxxn/wicI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcBSiYNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcBSiYNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD81F000E9;
	Thu, 16 Jul 2026 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210508;
	bh=oxZ7ype9hrAwl68T/iVpuuUlPCQc5u7Bfi5EQs0OoxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcBSiYNVuGK/fYv0J5dHCwBkN01gxzxKzLVBM1GlL+CxkOCsES8yK/UNBqx9kXLx/
	 u5GfgmcvvDbvhkZqbXONF5R2ezHRK0IRuKyXGKnybbE2DL5HYFwYcL9ll1dJPNqGQk
	 XCRkvc9Qm3dUv0BUf9ly93JBvJ31omECN/XJt1cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 073/480] iio: light: al3010: add missing REGMAP_I2C to Kconfig
Date: Thu, 16 Jul 2026 15:27:00 +0200
Message-ID: <20260716133046.291472945@linuxfoundation.org>
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


