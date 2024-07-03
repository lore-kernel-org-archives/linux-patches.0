Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78E819D8A7;
	Wed,  3 Jul 2024 10:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004306; cv=none; b=bx0jLwJEhZANjj8eX1Onhuf5qKHVEsq2Tg8M+X1uVMpafy/az3kahjBr/XX4NrEt6bA4BAL7zQ5wYvfrcMW6wskgyRTdx4cYPsVwvLUbreSrRaeLkwhBCg7hfasDVWmx1+DCz8lVlx5caXNABZIhrLG17lx5cV+tl3sylXA7Ko0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004306; c=relaxed/simple;
	bh=Tj4P4PHWq1UiCZW13NbFhT1Nc4355B9h0yu68b7005Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNDH5xR5nsyDdK8BzjKA6FBprGQh9T5k7oH3nY0oJGg4hva42DmWXPqJiu/uMojelpbEKz4a13iGPAKGkShExjRBBsS3M6M0kF2k52np70pjZIDuH/S0U5MTfKKpET0BtM39I9XbmotZjwfxqZOiPpDtbO4JdOLmKgPqnRA7NcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wD5aKq1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wD5aKq1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CECCC2BD10;
	Wed,  3 Jul 2024 10:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004306;
	bh=Tj4P4PHWq1UiCZW13NbFhT1Nc4355B9h0yu68b7005Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD5aKq1C7eaA0+z4HR8g9OT26TyuVM36gPLdpH7OxkZQR957yU2U1hC5G75gE5GPS
	 9QgcjaZJSemMGDMSomDrdEG+yU9vPU++ovdozF8rwe/jCgaZUsRHIEStVI72kaOB/X
	 5jReVJztIPNRvaFG5lpYqVELwLSSvFgGiruqVeGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 161/189] iio: chemical: bme680: Fix pressure value output
Date: Wed,  3 Jul 2024 12:40:22 +0200
Message-ID: <20240703102847.545183664@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -670,7 +670,7 @@ static int bme680_read_press(struct bme6
 	}
 
 	*val = bme680_compensate_press(data, adc_press);
-	*val2 = 100;
+	*val2 = 1000;
 	return IIO_VAL_FRACTIONAL;
 }
 


