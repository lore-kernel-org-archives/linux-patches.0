Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5E91836F0;
	Wed,  3 Jul 2024 11:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006258; cv=none; b=eLCX11K9ORDKxgyqXkEqSRInmFYyzhkzsa3ayiFXWEJucljvtZQABQZYHAextMeISo7uEgxN2A3WVadYi3sn+juFA3eyLM6pGLN778Gz+TVt3/XLRJa40FdmCWZwoXp1Cb0YKoPrC5OWRrEzxSlj+XRHg+OAxuWANIFfV5Lssfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006258; c=relaxed/simple;
	bh=KUTeuM7mZxp/nxbAUAgit0TOL0Ha6cVCofDGWxzsMXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Biv7J8wln/axRTux8I9rpiTNBkzhjo3OkTPC9y+kZK9JB13poplQNtupqzCRvnGtDjznSt9NzWbK/QNMX9PWymr5yP+Rm/usUChAdkQsUh4Lt5DchvJ/+JKVUqgYz/idi8b4cK32N/8Txt/NAcH1B5MNuRx0gbNF4pVfQSP6ZQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdfRi5wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdfRi5wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42903C32781;
	Wed,  3 Jul 2024 11:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006258;
	bh=KUTeuM7mZxp/nxbAUAgit0TOL0Ha6cVCofDGWxzsMXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdfRi5wrsPMleFiFz3OVa8QahA5NT/Y1hA5kUdzgMC2d5F0p1JQZxiHuhR8bxbmrb
	 Hgjrgkl33EdyrzU8Y0KiKjSHn6My6Vdh2Kig9LCD7K5JPGPLh33o4WZBguHHtC16v3
	 tOEKlu4mCbLR7/ciN/nrEWPWO3I9NJ3vG2nnYzg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 312/356] iio: chemical: bme680: Fix pressure value output
Date: Wed,  3 Jul 2024 12:40:48 +0200
Message-ID: <20240703102924.917319969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit ae1f7b93b52095be6776d0f34957b4f35dda44d9 upstream.

The IIO standard units are measured in kPa while the driver
is using hPa.

Apart from checking the userspace value itself, it is mentioned also
in the Bosch API [1] that the pressure value is in Pascal.

[1]: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x_defs.h#L742

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-2-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -678,7 +678,7 @@ static int bme680_read_press(struct bme6
 	}
 
 	*val = bme680_compensate_press(data, adc_press);
-	*val2 = 100;
+	*val2 = 1000;
 	return IIO_VAL_FRACTIONAL;
 }
 


