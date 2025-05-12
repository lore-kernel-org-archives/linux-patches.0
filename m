Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B330296D09;
	Mon, 12 May 2025 17:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072419; cv=none; b=AL/93yXctPGhi7CckJH9x0bwz4VjA0mtIoP88+xWwTGSrA9jz6wvL7waV7BAMZjvkWiGLKlQoE/jOvT/x/LthGSEDuCQvlPZZKOeBfn17AwNC3KGXgGidbxRzlSFZkFHeu3tl/LUNjTJHMNtYF1MDscSrbPL7o7eXcga+zRYZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072419; c=relaxed/simple;
	bh=aIVZQU4kgk7t0WPQpHAs4bkwRaewjq52CK79836XSX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC2zkKonIXUDw0m0gMR5PiUzKEiFqcB+ip6sQ8xXjVRJzJsj8CRXa7Y1Z8x4ZhZm8AKrY3CdzPKuMkbNmBJhFmsxXWxhInN8iQzV4LdfuHHtojFqiFW1orQn+eO5n9vFhyE8ZtGaP+LvggpstYQUFDpJ88vaD/gN/r7eb0xMPfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsewFNO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsewFNO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43085C4CEE7;
	Mon, 12 May 2025 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072418;
	bh=aIVZQU4kgk7t0WPQpHAs4bkwRaewjq52CK79836XSX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsewFNO0hqS4zYmS7iJS2cNLeh2v/pRJc9Bm0y0TOKHOzw2fSKKqCxPANY0AokEJO
	 cjPfVavAaEFn6HRshbDnmP4DCqnq8h/V5vKw4B519WqN+1maBQJ1DowUmNLlXtguTh
	 IPWf+QTK5MKB6eXspGvDSy54wMKC7S7S+PTjCRr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 35/92] iio: adis16201: Correct inclinometer channel resolution
Date: Mon, 12 May 2025 19:45:10 +0200
Message-ID: <20250512172024.559282087@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 609bc31eca06c7408e6860d8b46311ebe45c1fef upstream.

The inclinometer channels were previously defined with 14 realbits.
However, the ADIS16201 datasheet states the resolution for these output
channels is 12 bits (Page 14, text description; Page 15, table 7).

Correct the realbits value to 12 to accurately reflect the hardware.

Fixes: f7fe1d1dd5a5 ("staging: iio: new adis16201 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://patch.msgid.link/20250421131539.912966-1-gshahrouzi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adis16201.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -211,9 +211,9 @@ static const struct iio_chan_spec adis16
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
-			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
+			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
-			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
+			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	IIO_CHAN_SOFT_TIMESTAMP(7)
 };
 


