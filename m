Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F246F3D3314;
	Thu, 16 Jul 2026 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209112; cv=none; b=bcZnjlSBtAToL3NTaqCtkDfEAZORhUr68VVQJxgAEVsUWkAeErQONXwegkdX2HgicibsYgVlKwzPQD3EuWG3uyPixV0bdJALkjGvWipbNgOWnzfGRXwQUZSFpogyEIHFhWVRdVDEJb+dK8B56+dSlQBBF5IHU0jTzgAxmrKCF7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209112; c=relaxed/simple;
	bh=xeLiw+mCw4ndK02hqnqmmJfF0PFVE+ixZp9aQarHCV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSm8ouGYcDIuEfaQjhsMrB1BE4407w7FHS3IC/ioWsuEdFxSanq3FHsdqt/7gONkhccRG2dn3ohpWrAMPNXN/+8s0VEmuTQvpdDSsoTe3cvnukODh9KoNi+qos5vN2GFv7gaGjlbcv7pEO3piWRrGQxSikR8EABMipLBYHPGQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKjXrJdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKjXrJdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627531F000E9;
	Thu, 16 Jul 2026 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209110;
	bh=ScQqw7lW3zgvuP0wPp52b6G00Ev+vS4HC/4TpLQP0oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKjXrJdAm5yDaKJ44t5j6WpKujy//Y85E6Wm8RfDfhfPVW2oBhaOWZbqmbwKmAxjU
	 8m2VJsJx4O/sx9I+1W3jmQM3YOsprB1yRsrvq25hTiXJoFPuDbUxK+nax7wy4kCjdx
	 WpZg2eK4+AAilJhos6ZtdNIz0htVnnDSZXU1oqAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 060/518] iio: light: al3000a: add missing REGMAP_I2C to Kconfig
Date: Thu, 16 Jul 2026 15:25:28 +0200
Message-ID: <20260716133049.097518572@linuxfoundation.org>
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


