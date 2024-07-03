Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9BE180A8A;
	Wed,  3 Jul 2024 11:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006161; cv=none; b=Ojx6kR1x4OmYQOB0Zbncu9QoeeDAIfXbsxfHXTYwVAmVgZN4y7hV3W1xHP7iG1qUMN8mekbqTbmILSPcoIsxDPOrqntay4/N3sNjq00K2V4/ZIbN6pyyNmbbJ8cmT2Ys08da5INg6ZJFQU4VwIoaKo8l43L0D9lHvL70G4c3/bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006161; c=relaxed/simple;
	bh=nuK8weqUxYTo3zFg16N0p144Y3awmflVBXOXCkk8JLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jx9sjfZKN52NzmOZNzaktjxm9o76TFa8JdBo7yd0neH63+ce/9+92GCOpfRvwYI9L+B18xBajeK0fq/m+hIFbMlMcX68tJ/maCpaSGMholU6IicpYUBQnfeJ2gk2RlPFosf3ieVQUSgceTW4OeZqbYx6XSxSIsEJ6oYMOZE3308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MvABRRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MvABRRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9640FC2BD10;
	Wed,  3 Jul 2024 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006161;
	bh=nuK8weqUxYTo3zFg16N0p144Y3awmflVBXOXCkk8JLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MvABRRZuAipT6axMW+kJmowSFynyJM4Gc69zjJPEIk6oN/5P+zeKJ85h5oBDCrjS
	 POUXjMMx4FQKakPOqKW0lU7WGcE2o3Luu5KXx5xr3Zq9dNac8hjfccjhdiGT13aGz0
	 AE+3/w7qcPGSJCyQDQhvvdeeCYtzx2NhfUnOA8TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 313/356] iio: chemical: bme680: Fix calibration data variable
Date: Wed,  3 Jul 2024 12:40:49 +0200
Message-ID: <20240703102924.956449892@linuxfoundation.org>
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


