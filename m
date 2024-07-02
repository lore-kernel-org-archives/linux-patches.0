Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67BD15B0FE;
	Tue,  2 Jul 2024 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940387; cv=none; b=UJS60JuF3G8dCnBilP3gIIWTE39buDTfyLORz7krmonqlvkkYCAgdhzFrilqYKjVOcXpzfEB0vd5Cl9lF60GBDsaGclGHtJudrlA71htO0+r3Zy11f0ekjvWtfkQvHQs3ZP3FaBG5E7apheUoFc9iCu+GjBseu2SJ5oxiaGq6HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940387; c=relaxed/simple;
	bh=seh6Ylhp1q6f7CD42YSmfZhkSEfrtyFJqR+ro4rMXgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmxNoEv/LUUJpKp1W6Hs3ZF/GDjUyCTjEpmtBjV0IaVtSzE6qJoiKEaqMnTK9nG1u+RZoomR5ZMAeRUDBsNlRVNDU9gA5wVtGjYeRDjl28Fb4VRS1s9RZb8EYAzQwz0Xl1Sd+Rc62AOcVB6ZdS8tvZr6+mfgcdussORJRdTO1b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jcd/mOm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jcd/mOm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE06C116B1;
	Tue,  2 Jul 2024 17:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940387;
	bh=seh6Ylhp1q6f7CD42YSmfZhkSEfrtyFJqR+ro4rMXgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jcd/mOm9iL42ZxHh72jc1ai5GdYElcf0pJyrY54y0lxB0vDB/wIun86rcS76xsNQx
	 0sfZ5xF9MSXg7PyfLUKK/p3iNDsCkxRkfdIPaR3IBcXPORDNfdkp2jLCMdQq9FC3p6
	 AmicT+E1RkkoqJ49OKg988P0YaNQn5RidmIdRofg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 139/222] iio: chemical: bme680: Fix pressure value output
Date: Tue,  2 Jul 2024 19:02:57 +0200
Message-ID: <20240702170249.283909449@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 


