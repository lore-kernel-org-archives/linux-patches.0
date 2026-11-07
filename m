Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062117;
	b=YnkDFGdezieUywsDuG0mjMiL69zxh7j4b37lZepb+Uru1eB++vzFbNpJWfEI71MhwUo7
	 dzV2r/jA0OV/mg/et5xXKHOrrqniTzBXo/yPMjiv0M1Y/GbdukPHYVHConB1nqQoLu60g
	 hE+vqQbkJUHCsyyD84ItzhIZdvExUIOU9vMj59oKI0YK4Fa7JNiP6YikBIzzZhzVIf50r
	 JNB3I6ffunXCsAYhB8sO7w03ylQ1fZt+Tri12yxupboR5SU4ISf2Mi+nFRwoIcoFjJ0ru
	 epni8UKCPwaECPjOufuogSWuaUtDn9ccXYLZszSKu2blVMwGAvPu3dhwJWiOqusMAJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y0zeAe53Xwn0zObPsupRoAF2cROcy5tHohvq68XgfpU=;
	b=etmK3FhU5hiMLle+3MQYgPEoXoAhklqmYXTD8A2z45xDYaaHKeBT+Ab4fme3R7+nOe92
	 HFxl97sPYWmjTckfzhMLr9SEJYA/bj39HW0paYS4hkpm+l0mTAMzPSlQQZJ+KapGFCqPJ
	 x/jDoz8Swn7Bs4wlR0LBzhsTG2A406Gm7tBN3welNkNSLKT/e1AbfznulKIAlaepGT3OB
	 RrkNty+R/wxhwS6Sbz3IlQpwF+Id4ANetqT9u6TSWq4T26ggPj7rl+bTCrJxJWfz+LqVP
	 jEB6GCUndV8SRPXZvcekutNMjhCU08SJCN0dBXhAo3rqG8Sq+VDhxuKMrR5DhwciVWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoUW1kCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C19606D804;
	Sat,  7 Nov 2026 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoUW1kCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1551F008A1;
	Sat,  7 Nov 2026 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062116;
	bh=Y0zeAe53Xwn0zObPsupRoAF2cROcy5tHohvq68XgfpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoUW1kCL62KJzpk/ED3WwrskXsXeDsw/rpXqxSe0pRQhk+k2ZDa9lkyKawGYvAUI6
	 HS+tUouW7gHjIgN6nnzasGN3bIXK2f8C15fAsuIYH+/DWUlrPBjvQn6DqEeG65UOuo
	 5DpJdWleRkTjuW2aDYW7TIqjrQRc3Ws/15ygUviA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1088/1536] iio: potentiometer: x9250: reject devices without match data
Date: Sat,  7 Nov 2026 08:51:44 -0500
Message-ID: <20261107135028.256792723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit d13716e3defd5b8cec3ee2c27f4d9b7e01314067 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but x9250_probe() later dereferences the result while naming the IIO
device.

Reject devices without match data before enabling the regulators.

Fixes: 66bfc528a6fd ("iio: potentiometer: Add support for the Renesas X9250 potentiometers")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/x9250.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/potentiometer/x9250.c b/drivers/iio/potentiometer/x9250.c
index 7353484926997..1c9e22459058b 100644
--- a/drivers/iio/potentiometer/x9250.c
+++ b/drivers/iio/potentiometer/x9250.c
@@ -155,10 +155,15 @@ static const char *const x9250_regulator_names[] = {
 
 static int x9250_probe(struct spi_device *spi)
 {
+	const struct x9250_cfg *cfg;
 	struct iio_dev *indio_dev;
 	struct x9250 *x9250;
 	int ret;
 
+	cfg = spi_get_device_match_data(spi);
+	if (!cfg)
+		return -ENODATA;
+
 	ret = devm_regulator_bulk_get_enable(&spi->dev, ARRAY_SIZE(x9250_regulator_names),
 					     x9250_regulator_names);
 	if (ret)
@@ -176,7 +181,7 @@ static int x9250_probe(struct spi_device *spi)
 
 	x9250 = iio_priv(indio_dev);
 	x9250->spi = spi;
-	x9250->cfg = spi_get_device_match_data(spi);
+	x9250->cfg = cfg;
 	x9250->wp_gpio = devm_gpiod_get_optional(&spi->dev, "wp", GPIOD_OUT_LOW);
 	if (IS_ERR(x9250->wp_gpio))
 		return dev_err_probe(&spi->dev, PTR_ERR(x9250->wp_gpio),
-- 
2.53.0



