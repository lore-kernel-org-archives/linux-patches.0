Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591329;
	b=bj9X6q3l8vKWNMbsXyl4/WN9wcCzreFTo/2qJJ6gHK67I1Yf1UnINa1Zm64i9fKUq2dg
	 O4MkQnikVhgotD0dfd6akS+mqXi8v0A8RGW3R1yXN+wEmIFpr79q1mOvf503HW4zcFkZa
	 KSgd0PH7+SsNzdS/7vurdz2isrFeZFNpVXKYgqgsViC+gvdrIHE/JsdgqJ/aKb5miH+6q
	 V66RxarZ6lgdmi7plQUUyB2iwrM1ACh5bApvFWyvBGC4KvVvaO9KsXKqB4O8vFt7KZODX
	 dCn2LWP74bu+12FnrbXXnJNJEV+bdrLG4cxAV7Ot7wq2K701ax1qOB5CFZhdduPRNEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QKJANru+VsOy4QL/4ifAxt45IlNTs3p3iPjV1JrLP4=;
	b=MD1VgQNPoI9uCxuQKhWdH3U8IBUcNPYAga/BL/FMlixmOklyCkYFe7xSR4DtcOMfraXV
	 pVEaw1ebjnQxKqtPOZ2b6Sv96qvoIns1WL2N5aqM1LVWLx3SJ8hTngUSY34R1Gqyw8vfj
	 T3/y+7TyCEWqTUfoZZOYURHQc5TbGfQKMGPwwl7JMgt/OklI9+/ztQA/NFfD0z5OD8pe7
	 5LX89HVCuEvHZK5WrqaW0V2d0u5GiLZQnMxYGQuFTIte+1XFv+RjnE2mGqcuCtKOaNEOe
	 yt0FoHFFPJd3Bn70N4T0VIqDq2y3XfsEX7YEt4yiNEpljkIoxue1lhKJp/t4w367BhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GG3Bppw6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F2B60776F8;
	Fri, 13 Nov 2026 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GG3Bppw6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FA31F000C7;
	Fri, 13 Nov 2026 17:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591329;
	bh=5QKJANru+VsOy4QL/4ifAxt45IlNTs3p3iPjV1JrLP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GG3Bppw6avrp11tIhCurss8YyM0xWHes5opxJ/9TEbeaWue06Z/Myy7DTiHR7OcLc
	 PZpet/JqbHta1V5/O6ExNi7nRkRaEnKqlkSIy+dV6CP0jzbD7DB6You8oChQ8h/QC8
	 fvVN3bbs/+SwNCRQHopBbdSCFAqXt2Kw+YKaC0TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 441/670] iio: adc: ad7192: reject devices without match data
Date: Fri, 13 Nov 2026 10:50:05 -0500
Message-ID: <20261113153826.857144227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 7f7a119a370ecf6c8d4ab9e9ee0a8cdd77afedd3 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ad7192_probe() immediately dereferences the returned chip information
to initialize the IIO device, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the chip information.

Fixes: c3708c829a06 ("iio: adc: ad7192: Convert from of specific to fwnode property handling")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index 02328b9115756..ef8268ad353e0 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1394,6 +1394,9 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret == -ENODEV ? avdd_mv : ret / MILLI;
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = st->chip_info->info;
-- 
2.53.0



