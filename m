Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0628F18E74A;
	Wed,  3 Jul 2024 10:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003659; cv=none; b=BMmFzwG5FYj+YI/0u14In24BiFuCcXlTm+5GWnXY0Q1Oako5LD+RWdcN6c1RkF6R4D0bGx1t770mvURhgdbUFFGXWeGAuIfEuwsCMVbmxFkSQ/vZI5cgPe/H3HU+gynUYvwdtm0TUWBRROs3N2nOjSlsrED8ZAdr0itKAgQMOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003659; c=relaxed/simple;
	bh=CQ16StQHviM463rNhWBSD1xRPyzLlgeb2mvt+OmN/1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxXA3v7JLNVHAdRW1pQcH/gbPn/z8y16ULz082WiC4gmq4Q4YB8OsnCV/nXUvEwBXygMTMGRGNsxTzltTmcc0YDa3Jt8pXX4E/r/mo+H1js7IGxnPE+1BP1w4LDRlEgSuTGkNZ8ZObyvfNVljF6lKIe7/Ym5Z0DaZvU09qlNWMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUjAAMlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUjAAMlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1B5C4AF0A;
	Wed,  3 Jul 2024 10:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003658;
	bh=CQ16StQHviM463rNhWBSD1xRPyzLlgeb2mvt+OmN/1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUjAAMlZGVSL0+9oNghlAL9+h8PVrOz/iR2C0kmvSKZXV01H4X1INdsogi89eMPZh
	 j+E2E68X5T+UF+nTs94qoLa4DNpD3Ca22YNBxzEKBj1lbzdAKL4bit7AwBLlfoWKrN
	 6Mc2Uiymf8yXuQFyUAv64MSrPhFlkF7GImuIwfGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 120/139] iio: chemical: bme680: Fix calibration data variable
Date: Wed,  3 Jul 2024 12:40:17 +0200
Message-ID: <20240703102834.969196290@linuxfoundation.org>
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

commit b47c0fee73a810c4503c4a94ea34858a1d865bba upstream.

According to the BME68x Sensor API [1], the h6 calibration
data variable should be an unsigned integer of size 8.

[1]: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x_defs.h#L789

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-3-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -38,7 +38,7 @@ struct bme680_calib {
 	s8  par_h3;
 	s8  par_h4;
 	s8  par_h5;
-	s8  par_h6;
+	u8  par_h6;
 	s8  par_h7;
 	s8  par_gh1;
 	s16 par_gh2;


