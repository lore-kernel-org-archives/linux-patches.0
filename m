Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1B81E6311;
	Mon, 21 Oct 2024 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507496; cv=none; b=BlLLKmckL2rtYcjxJio06WdApmgijuh2b1BLA4O4ww8ki0PYfhpZCC2lFF7SNtSJ2lz/vStKCWR/5VAcf1/fws7cmVDeoB1Eeh9fN2TBvcmCoOwX+OsKaC4U6E4/mFttGovyJEvjNX+Vhvf3QWWkMA24jMmS9qo4vAHF+RrQXXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507496; c=relaxed/simple;
	bh=2NBXfGTMe8lHWI8E/jsv3BQRyMbNXYcITptxm4/0Rnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAqozHq18r/G0TQZ5mhTj0NDzsXZvRAw9hPxvpBI9ZgbVywFQ510F6Q2bjn3Hiri8EbaSBf816oWBbvPYtsVLEqZ9gKUfRoH5zDoW000Dp4R4nQEsxE9awLJutP5vFYhDLM6MqBN0rOStv4Ermu283O+Igu84282/+UQAb503Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQT8wdwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQT8wdwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B2BC4CEC3;
	Mon, 21 Oct 2024 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507496;
	bh=2NBXfGTMe8lHWI8E/jsv3BQRyMbNXYcITptxm4/0Rnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQT8wdwFIfztzunD/Dhmc2NPXB7oe6zgD4gpzduC8EXFciYeGS9XfapM+QRKqEEKX
	 OA9OLtGEI7sRb+z3ydKIzq5pH3Benxvh4gm8QVLHRVm+Cb5R51v8TOfMSGXVqoZP8P
	 J1IKd1NDTKBJCAYDw1Rh5Obd5dWEBgrCpEULHpBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 55/91] iio: dac: ad5770r: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:09 +0200
Message-ID: <20241021102251.967323632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -224,6 +224,7 @@ config AD5766
 config AD5770R
 	tristate "Analog Devices AD5770R IDAC driver"
 	depends on SPI_MASTER
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices AD5770R Digital to
 	  Analog Converter.


