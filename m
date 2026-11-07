Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062115;
	b=ttEj85wA/2bbiX1XyzVVDyr9afQBvfe0Tci6kx86Th9Hd/t5FkRtHLob3SEJbtd7kKu0
	 Qt0qtJaEsXv5H4E7MEAMEKC5tgNutS4KU+qSyM7M7T+xFVnlapcG6/NF+oel/00b6pOvc
	 GRgCbKCmTOSF+3CKYbT/NAruDB0DzgUmlc8ugklR4eSHYmcL9rYJT/04mA/QYzs5vu9UC
	 3mXMBt3Yu3joSmjTPEcCB6NL3piA/BKaDi02Yno41PVwiNNYbOYt2pj3LGms6VKyR2tc3
	 jZluLHHVEtmr6ssvd9JwPj2grJIag63MS/UG6hJ62CmvAE2VBIInvfTs33Vxd19SUUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7VvNy5hy1OjrB97Lv89szYebHoLCcz4qmweZ+JnSr6c=;
	b=AO0P0imbfiuE/veqX1Xda7b7g3lcurY0JMVlKD5FEjDZIXWB3+FQ72t1/fEoXOWvL79c
	 rbHxMKc8IoTVFOubZgfrhphU55MDQRZTAYFSwhLRoBRMwR17tfHsrpq7Bu08uGgDNsS37
	 6do7k4sDtXjLdaMqofp4iFAEu/vHVo9qTPcy1G8SoQEsPJk8o5kZzdVOZXvfLq1h5y0Q8
	 zNpq9t6O3WJAgxwy2T3zqvW5+sgLCBlJbppEWUWAJtx1acOyN8CDTzBJI24NQwcPPoQTP
	 9n325SJNwsZ8AbuxuOI7Jvv3+ojvVVD1OWCksmQpz3gbtpkvoIbJTo566RXvzcmofWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H45RLuoj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E421B60A5BC3;
	Sat,  7 Nov 2026 14:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H45RLuoj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495131F008A1;
	Sat,  7 Nov 2026 14:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062114;
	bh=7VvNy5hy1OjrB97Lv89szYebHoLCcz4qmweZ+JnSr6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H45RLuojIVA5860KmAFZYk5gDtueZsGq7CBN+rgjx/A14oQno0MraWJZ7F2dZcjKT
	 yvyxsRaT6llSdDUETiGRs5BKBUAMPdk9Yrsze2lD2YKaSL6xucYSTP7dxiT3gPEShz
	 xkg2/ReA83B31xmlnXdtf5DwYUbh9nl9ME6AHJss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1086/1536] iio: dac: ad5755: validate SPI match data
Date: Sat,  7 Nov 2026 08:51:42 -0500
Message-ID: <20261107135028.200464613@linuxfoundation.org>
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
index 0b24cb19ac9d1..d00a04af5d676 100644
--- a/drivers/iio/dac/ad5755.c
+++ b/drivers/iio/dac/ad5755.c
@@ -824,6 +824,9 @@ static int ad5755_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	st->spi = spi;
 	st->pwr_down = 0xf;
 
-- 
2.53.0



