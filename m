Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B94F319601;
	Thu, 16 Jul 2026 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210517; cv=none; b=IrJ5IkaoVTPUQMdCF1Pwct8khWTz9GO3ri869aB2B+xjmJq6mJ6pvJ6pQ2tqooVux2FO1Jx3mXIyWIvv+4iRIs8vUSCxRy40LnnVY6m3+c+MJ7DuixrBOWh3k9tE0lNXgLSF8SjguVe4ENC32bdP0ZDA3P3bCqPZcA4KyxwCqVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210517; c=relaxed/simple;
	bh=sX9OOqQnE57KZpZppv3lmEWlRkoT2IoxYekZTv7A5PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoLuH0yp+16ajU1v6MjL2aStJjURUy+33t4QRBRDy6NN99VHAquJzB1mrSjNcd9nhbX74Bcj1uDi1UbI/exg0fdJV8RcRlgkvttF2e2ZIma84dQsRbj+NO3lvamSZ2VkQ1pqGc4dNPnW8zbDDdoW5HyTEmn2jfDfGq60Y6WvK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHSztkeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHSztkeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A142E1F00A3A;
	Thu, 16 Jul 2026 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210516;
	bh=M1+pEa4qAHBOU18rTLgIkG5viQoCht7CxpZukldNzpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHSztkeo6X9DM9iNXTSs/lgUFdfllyy50lgnCakBfLsBMqwaFVy7SECrsUV4kipQe
	 55B3xfZWwguAY8gxGs2AY+ytD2KFys553zgmbd49/X/I/atwoS5EOeQF5QKxxo6SnC
	 4ixnFD6JfJHuHnlxCohe05Y4DPBdmAR4xdHYtiNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 076/480] iio: light: al3320a: add missing REGMAP_I2C to Kconfig
Date: Thu, 16 Jul 2026 15:27:03 +0200
Message-ID: <20260716133046.356545422@linuxfoundation.org>
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

commit 9efcc9ba9b2e940cc01e63d132ae741e4c5d09c7 upstream.

The Kconfig entry for the al3320a is missing a `select REGMAP_I2C`,
causing build failures.

Fixes: 1850e6ae7f91 ("iio: light: al3320a: Implement regmap support")
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
@@ -67,6 +67,7 @@ config AL3010
 
 config AL3320A
 	tristate "AL3320A ambient light sensor"
+	select REGMAP_I2C
 	depends on I2C
 	help
 	  Say Y here if you want to build a driver for the Dyna Image AL3320A


