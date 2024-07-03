Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85AD18A93A;
	Wed,  3 Jul 2024 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003655; cv=none; b=LmrsXfJMvG4wmd3q+kvoBDVSYNVSo4TWSXGqUXWov/dGl0jTjiry4SZvkEjIXua7olmcmE+1NcjveztWKBw8uKxtDX4WqZs6r11SCLDIfaScVwb7N1s0YVsbiNNdJsbcYWm4EpybVH8XGsNerIhb7pDJSj51bLJq4IVPLrYCXNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003655; c=relaxed/simple;
	bh=fsikqbeNIdy54V6Hedz6M1Uglh62OKWHQtkT2Z6WsOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPMgSkV4lkWfxy5ZQYF9E4Ilt4Z9J9eNkM1Nn/P2ZCJHqwi5iApScp9iSR8SH8uR9wUCnpejiW8maqt1nk69AAGRAbZ/pA+Go6sFG7eHb4wUzClA+5JzLyloPkCLOx8FoFJAJJPaW97npDLYZjpxcW1xCmPpb771T4hpZiIBOiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sG8ewtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sG8ewtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4208BC32781;
	Wed,  3 Jul 2024 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003655;
	bh=fsikqbeNIdy54V6Hedz6M1Uglh62OKWHQtkT2Z6WsOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sG8ewtt0Uu63Xixd1PbSuEGN/svG6sgudrJ1FUFEIlRlu7vxs4Mph2vxN0hCvxfR
	 lyoOJ1GvM9JW/JxiIZyAHDC1rRK7O+PodjMSJ6fDRdfEvXOj8I1CGU3J4fbiXC0iPC
	 BJCCqBUxTyLR+vqF/1SUEV1eDnKel46Egu1EBQEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 119/139] iio: chemical: bme680: Fix pressure value output
Date: Wed,  3 Jul 2024 12:40:16 +0200
Message-ID: <20240703102834.932201552@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 


