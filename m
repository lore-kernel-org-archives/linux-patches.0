Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E73A1CD;
	Mon, 21 Oct 2024 10:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507861; cv=none; b=py93AT5eF0bo7ieFKHF4La/AG8ghnG4tX2QY9CyhLnJkp8y06bP8C3HHlZ/tGsl4wxQ5LCiBgPw+L2mPhVYcaeYFr1qy33lWzUMF5eRY9m0USP8lTjz2gMuYxySEIviks4ESXye0AV+XUuTzz+mrCa6irtg18+536UNCNF9xf9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507861; c=relaxed/simple;
	bh=SXtGcLJVELtou709sWXMuZFPkBMGUZBOZ2omttUfJRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPe+Y/Cm1RSqvkSQEGsiLvoQ6grgK40qX4v8PhRM4y6pw8UALwI6QMSDjrAtAVpFNd8E8r/qDUlTqwJoPcNQFrxrTizkIT2Nqx1KgRLXZqm10J3UGRHX3BqGULvrQN/xTdVqN++98SdCnctDX/Gjugaw4ZsbddL1Ri0JLHKv974=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sfk8Y50h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfk8Y50h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C55C4CEE5;
	Mon, 21 Oct 2024 10:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507861;
	bh=SXtGcLJVELtou709sWXMuZFPkBMGUZBOZ2omttUfJRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sfk8Y50hJ9ItA3/PtYHeN2Z3wJoYUY7Cfl2MG/mdhCYvUA93MKjbpmFBD8Vl29RDi
	 OCPm+t7PAV/N4P3GHjaNiiR5CxkOLPrH3Qa+Ht8Eb0z3IjirEzWGJ4ynLu5k4n9Xp4
	 tLTiril+Q47JkTQKdpmTwYgkeCRDnsWm2mhUNo1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 26/52] iio: dac: ad5770r: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:47 +0200
Message-ID: <20241021102242.650645938@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit bcdab6f74c91cda19714354fd4e9e3ef3c9a78b3 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-6-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -191,6 +191,7 @@ config AD5764
 config AD5770R
 	tristate "Analog Devices AD5770R IDAC driver"
 	depends on SPI_MASTER
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices AD5770R Digital to
 	  Analog Converter.


