Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064190;
	b=jRUYAjowTNX0JtzsHpBavz8aHRSuroiIx3rPiJXztERdtRtSZNyJGV7+RdfBxFm14Yta
	 tCFj5l4Svo1JKyQqfhjVBpsLwRSWaEZV++5uotCJwFiXaxzrjgLLlF8xA3vmGXl70ijjM
	 Qrp1+HEJGWAqQBZFLLEglBoYQbSQViDrJ9EHUUSewck9M3sznxT/77QCt0gt2pK8qtSyl
	 ww7E4OD/HKVcaUhbd/xpjkpp2UJB26b3Dr3UbmsVSfNRQJUKl8NpGkj6b6luyNs9jh3E0
	 bV8IfnksybJAUQgYz+iwQo7kcu9Wg98zLK4Y2M/TzkQN1TBIy70aL9xKLS27pNmJp5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bcOqYsa3LuMZY/GKXCzePtgO31NEaYl2OWYrQ+9pi/g=;
	b=md9DIssFLqNZCe/u3Xr6wqY9S0G4oP+PGBtS1rEVrY+VO8Gbep7lOsNKb2SALGcDmGP/
	 Nxi4y20lA+DdR+1jLm5RFKX9LZLBHP8FNxbfJi12fTzudsIrtNAhP+9MeA5lls+oPQrD/
	 sLtpxkIz82Os0p31A28DPCHXBMfVzM0jNqqRkeh8Z1I9ONobOQot46p4z1frK/GV4Ws5c
	 lujsN4G6gSBf5I85kPLjWdytvUtyS/FrN/uWXL/X/m2DTwuQna0mmDIU01byZ47qyvc9h
	 SqIwZPcD1WemeOfJ+BBG9emBPWn/ompN6v01z/jlo1/dnhWsW1Uqi5i8i/TmX4Xixfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOp5TQpO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5ED606E8EF;
	Sat,  7 Nov 2026 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOp5TQpO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C3F1F0089F;
	Sat,  7 Nov 2026 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064190;
	bh=bcOqYsa3LuMZY/GKXCzePtgO31NEaYl2OWYrQ+9pi/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOp5TQpOXSvS74NJvHIKORaHMc0BvRNXjkXwpJw/eG2Bpi5/gQgpTBW6rZLh4ezkW
	 2tOyMKqr/v+DfDOq6dV5r7EwyzbHnmGhhzx+5V1l43qkPH+KhBfhsN6o2LohsFdevH
	 MicnJWwbZKlgJgSwMYf/dhTVkNbeSTDB/PMTSEYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0331/1257] iio: dac: ad5755: validate SPI match data
Date: Sat,  7 Nov 2026 08:43:47 -0500
Message-ID: <20261107134948.560102457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0828b99090990..730289dd8ef69 100644
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



