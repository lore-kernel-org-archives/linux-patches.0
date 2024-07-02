Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F4D63D;
	Tue,  2 Jul 2024 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941487; cv=none; b=uZLQQYrC4YyaEPcC90PUkLr7CUoquHNFuxOX7wnlJFAAcib/c3vVNHS3LX2Nvza6+qU9gHOcDYdfoVPUfVEL6BGHIGribyMi7shU58IZrbk1oIYIGNC0iUOu2kRY5sLt8tZXqPU7DzuyDDDt1RVpasjT95GApyDeQy59b64lQ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941487; c=relaxed/simple;
	bh=pdTN0Nm/+Aw1fHaKa2aZFg1IU6sBE6IN/tzusQnXkpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERvNO+EJx/vEaHqgQkp1Z8wSLZ3EgL5t1gAA+cIFq+L4iqrBSb4o8IEsEX4rBln7NrL5HU9cj6EhhGxvrsQ8T+7HALrBu0HZgReRtL1gYVr76jJSjqk06Ab9nba0YAYKejJdRHNJ76j71ypieo3Bfu3Oppli7DxTbybwwL47LVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cg6Jxk4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cg6Jxk4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F031C116B1;
	Tue,  2 Jul 2024 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941487;
	bh=pdTN0Nm/+Aw1fHaKa2aZFg1IU6sBE6IN/tzusQnXkpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cg6Jxk4qpcttZzmSh2GGby6ZGM5r8OlqplEHzOoUhKvppYFTJAdVjxaMo5Enqaa25
	 MSWnhfnjJmr7qa+FuZIVJx5uXDsIi099o7p1hGWyi46zo0Ri1cJc5CBHyA1qh4y9qY
	 VkXLG4NF/Z8dXwUQMQ7uzMeTzVoHp3vURoBtx1vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 079/128] iio: chemical: bme680: Fix calibration data variable
Date: Tue,  2 Jul 2024 19:04:40 +0200
Message-ID: <20240702170229.215497456@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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


