Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78841849D3;
	Wed,  3 Jul 2024 11:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005069; cv=none; b=AEIZXsCGaIIFRbvpqCqFDSCNLn/gT9kRXDqkNUsA4NH+YhvVXH/M6dtuv5I45G75/6YRjk+T8mlZeTX5q4yRAPBpwOfk/ix5Rr+8z42a+6H0d6o92LIkY3w1jxavMNpidskyBnG1TpzYuErlIz0uU+CmWAunj2nvT45+rVr1CkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005069; c=relaxed/simple;
	bh=mSTE8iyCN7Zn7PH0It7wKR2I4lisODdP17AYmTH1P9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7YbXrt1QFLBBvksIL14fcYcIDeT1N5y7qMHJht88j/ZZhLOSXgWAQGRI9zQA+fXPc4OSdAt7O3p7WPJTLtnFD9fBQDBSCj1jo5kJmN4Z0M+ty1u74+Nj8EKbrAB07tsGGzIlZy7IJaNfunEbVWwBS4VoIgDsy+b+ngYGBW6jEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTZSjvR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTZSjvR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35300C2BD10;
	Wed,  3 Jul 2024 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005069;
	bh=mSTE8iyCN7Zn7PH0It7wKR2I4lisODdP17AYmTH1P9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTZSjvR0slC5mxWPKwhpuSiH/fss4WWoEBsrcDXms/f0LGirBYo6lv64e1lDwuMGg
	 H6Jth+nTlG5RallNr34EY1kG5clC8i21kvW+Nz0Pm0v0PIAtPp0bIltOPv76BMtuCT
	 UMcjhQAhLI9Wp/5v2eT9B7s4m6N4aVd0LKOoZNwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 250/290] iio: chemical: bme680: Fix calibration data variable
Date: Wed,  3 Jul 2024 12:40:31 +0200
Message-ID: <20240703102913.593470830@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


