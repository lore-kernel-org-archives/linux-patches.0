Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063018;
	b=5BJ+6RZhCiUErkdEJJVdp1HM7NG5Zn8Q5Eo97T+b0rnGJAl89qdEHYJJu9WGDY8bcAd4
	 bnwYTR9BllVxZct+O1woIn4iYCd9NXi0MIa0JXXEPTg6AGhfK42UGpZdWjOx023EVdO7v
	 1sLtDYi68enz3pcoCDugNx1cG9h42jh+a51RlYVwGXBz/SYjC2R9AWzB0ycC9rG94DFZa
	 oc+F+TJAHCTDS258KfbUBFoiLK3MJuXwxofmzdPOF2odmPOe+3F5yIjBVxq2Pz7Z3wUgm
	 at1B7Pa+pvhnbBA6SF0/dbjoKDAyLWCVd0MCT+gdyicZfd+ihrj0Ia5aY+Pa2LFaO5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rhyRnYdjCr7s4bp2JtNZc3W/SSnw/4RxAVmcX4y0hB0=;
	b=RdcQ10A47+AQdoX8DGLQ+wIQQKBb2n55tJY/X0zAeZwG4ArjKiBYRQ6YWdKoqwj51Rjt
	 LSVEIvus+LwF6xyPp7lB9zc9/gZTSgYQ1/suDHUirUOdsqOn1PDiT7o/sZ+ZsEhQtoKor
	 u4Us6A72cTtv+4uaFK5hp7j6br7sfMaNUTUn4qavkX7QoDlI64w1UCL+bI4BMkAqpj9SZ
	 i3khbal/NHURK0ZN7VqhlDALfoVXFWIz5jxX4paKxA3Lo4SAxcMTs2Zh5gi/y5px12F4f
	 DAzPuTkFmEUYaPahrKdwFVKo1Ow/zHMnF/20Fp68pjOzBN4SHnEqAnBRXnnOfZWcDjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jI+nb4sy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0D0606D801;
	Sat,  7 Nov 2026 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jI+nb4sy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB42D1F0089F;
	Sat,  7 Nov 2026 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063017;
	bh=rhyRnYdjCr7s4bp2JtNZc3W/SSnw/4RxAVmcX4y0hB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jI+nb4sy4ul9twZ7BeUO5JCzn+Z1DvN+5v8dkkcXkN+NROrdGnjBqR1EL9zO5FI6g
	 QBChWUcvTx3CIIvMOhsMsTUbEXf0ZoTTDPgAvakAmR2ub0SrZM+4Rf/1CYOJ6iNtz4
	 GdAsSXxkBAmSETqMkUArJ1o/4XBnuZZOfy+oixWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/869] iio: dac: ad5755: validate SPI match data
Date: Sat,  7 Nov 2026 08:49:09 -0500
Message-ID: <20261107134900.761950380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 85e2c8ca7ac9e39a61e7fb18728918f6e966f439 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but ad5755_probe() stores and later dereferences the result.

Validate the match data before it is used.

Fixes: 62d3fb9dcc09 ("iio: dac: ad5755: make use of of_device_id table")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5755.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/ad5755.c b/drivers/iio/dac/ad5755.c
index d0e5f35462b1b..ce188c5a9ad15 100644
--- a/drivers/iio/dac/ad5755.c
+++ b/drivers/iio/dac/ad5755.c
@@ -819,6 +819,9 @@ static int ad5755_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	st->spi = spi;
 	st->pwr_down = 0xf;
 
-- 
2.53.0



