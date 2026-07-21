Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748944CADF;
	Tue, 21 Jul 2026 20:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664277; cv=none; b=mmTnitHVFLe2GNpL4d8TZB5DPpH30Ppy4Xp8HAqw3jRbbSViKwkpBcR7aGnQPJcFIjk6+XorEiyvbfkp2LEgRI8dfbUPV1ayMPYdF+zkEnkoVPzMJLTkoedQZXX8bUZUxx8Ac+fJ/lzcQ81c86cpidajAvTdZgxfjRXH7yhAWqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664277; c=relaxed/simple;
	bh=go78DfxQYFBO65Z4iIGxwFHGq0Qd/R+Gl0z4VZqaL8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kcjsUuW/FFOne8SNsp7Tz1i5nwomTFjlNhvoi/HOyAcKfRp7dHWK/9Pk8ArioCReZCuWlhmjr5JhaW7myoU6FJe03o4nEVtJvsdz4cZ8bsRD4jBqsPFFxXZ/5Es5C3l2o4OICyXufP7n1ToMCNgi4u9tfUA73+qJmWINInqKYWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg/1d87Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg/1d87Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936241F000E9;
	Tue, 21 Jul 2026 20:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664276;
	bh=2ya+iPOjoZZ1Q/+Ib10xPskOuc+xJvRqXG1CsJ56wKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tg/1d87QzgRmiXPhfthBC2GoPueHDdALC0OR06owLUrcB+C+6tQfpVRzN+9AlQsu7
	 mMxT+FTgZqwdaIFWChu5ZyYCLXMALw/6FZ5SXNxcR/ZMjw/dv/Ub5EbiGqGhg11vEr
	 lD4IDB8JB2pYgvB2yalEsSW/6S4TE9yosbaDV6Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1138/1276] iio: adc: ad7380: select REGMAP
Date: Tue, 21 Jul 2026 17:26:21 +0200
Message-ID: <20260721152511.470308560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <samuel.moelius@trailofbits.com>

[ Upstream commit 6697091b386a4e2830bdd38512c87a4befff2b32 ]

The AD7380 driver uses generic regmap types and APIs. However, its
Kconfig entry does not select REGMAP.

As a result, AD7380 can be enabled from an allnoconfig-derived config
with SPI_MASTER=y while REGMAP remains unset, causing ad7380.o to fail
to build.

Fixes: b095217c104b ("iio: adc: ad7380: new driver for AD7380 ADCs")
Signed-off-by: Samuel Moelius <samuel.moelius@trailofbits.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -188,6 +188,7 @@ config AD7298
 config AD7380
 	tristate "Analog Devices AD7380 ADC driver"
 	depends on SPI_MASTER
+	select REGMAP
 	select IIO_BUFFER
 	select IIO_TRIGGER
 	select IIO_TRIGGERED_BUFFER


