Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CABD569F3C;
	Wed,  9 Sep 2026 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962350; cv=none; b=R4WtcK3D+ik4gRvF3N7wzoSFbcHnfkgMYRa1hGk2alD2ps5Iq+YzgVoDs+HPmo3XmztYh26d7CKaguR1FYrpIORikSt9k2bEuPfha9hMmhyBfA4frecsFZ9dhlDJ75S99GY26gbcK2RKWyE+xZP+kcCeOCJ8y0ot6knHYeFe9D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962350; c=relaxed/simple;
	bh=9ywgXwPXibhrWi04YJJg86WOEvodqvUMpYdIXVq71XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvG550/emcozEZDunglnYLBh6x6ZjHF5sSFHfdFBj38di6WANwzOu1Sp9uMcNubz3W23pMXz1ViScRiLiC7BuuyV6gtIKKDwb7QjuWUiKQLSxRxRRF7yX55x0mUSvVPaTdrkuAAYWQlZJe8sFwXFV1m2q2H2oJV+CzKKA8Yf0P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv6jht92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv6jht92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E579C1F00A3A;
	Wed,  9 Sep 2026 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962349;
	bh=rpkea+X0dNt697SWre8SptMeEtPjmlsZ2H8mFkX5enY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pv6jht92mu9XQHjnb7PQr6ImhU2nZANhSJzLCIJ2I/QSWSdSPvEnSkElJakf5qeKu
	 7BABiFjjGMWf9gspZHGNlvVpmm3dXv4iVsmY+M+ui9UXi22krlEn97T4OCv4KkHRFR
	 nOuCjGqvMRdJOi9c9kGyMe3plSVw5jM2PyMTCJ0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 261/556] iio: adc: max14001: add missing select REGMAP to Kconfig
Date: Wed,  9 Sep 2026 15:39:01 +0200
Message-ID: <20260909134239.715143186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit b7c969d0d445c415b8e9f32627d7e8f092c7e916 upstream.

The Kconfig entry for the MAX14001 is missing a 'select REGMAP',
causing build failures.

Fixes: 59795109fa67 ("iio: adc: max14001: New driver")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1076,6 +1076,7 @@ config MAX1363
 config MAX14001
 	tristate "Analog Devices MAX14001/MAX14002 ADC driver"
 	depends on SPI
+	select REGMAP
 	help
 	  Say yes here to build support for Analog Devices MAX14001/MAX14002
 	  Configurable, Isolated 10-bit ADCs for Multi-Range Binary Inputs.


