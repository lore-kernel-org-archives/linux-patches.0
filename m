Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060449;
	b=w6eis/6tU1GAjR6AmRdrB7R12A7dkXvZ3qjf5cpA1kDcrzzufT8pmaiOE668jXZ4+2xC
	 44AwOi05o5TI7JK+zusLuuSVA+fq7skaJtIRKeUwZvP4ABsTSCX7XmdQ1MCjrgcNif9ii
	 JRbQhvHfkhh1j6WzBbjbxeE4hoOmB3Tibq4dCiIuTIVqdbU63/KexVjAQfeqqBuR3DpHv
	 8pZ1x6zNLUcRS4d7oVI/6adNHzCtOJ2YLw/pNbTHrhHERBwrCwXN5ZEZVwU+eXLhG+Kiu
	 LvKVQeM4SMM+nFVpAibI5hOMje3bl//RNYVayY+11sY1HTp0ay8fpSlJasXO+2TXOGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CmsF/Eplp/F0wxS9enjGNRVqtnOaIz+yAaRFYpgAws4=;
	b=Gs81X+b5wJHnhZzgLCbk81OGUmZmOy6W+hX3pngS57CcElj+y/vgvHtSNJW1/6X+Dmbn
	 v0ttcCooYTO5jyJ2nKSIjrOoJcSxsbS2MFZgVEG05/Ogm0jYl1mbzLuORQOP1HhxLYEpZ
	 Dl4/tp3NUzqMzY2ZCtl5sHlKWRupwro0Imr5mtWUQNC8zokapJr572XnSxWqVqZxf6pTR
	 +2kwOhxEwId4hd5iQ6hEOEjdvQGE7Td8rBmLiQCJrcqflTZxXBtbzfapFwC1/90j354/W
	 +gT+gnUc8Cs6df0J/pbi1js53g3uoNeYe0Y3DbOEZEQEWmwufYmGtgNj+agiVOdzSEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGbeG5nl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBFB606A32A;
	Thu, 19 Nov 2026 03:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGbeG5nl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82421F000C4;
	Thu, 19 Nov 2026 03:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060449;
	bh=CmsF/Eplp/F0wxS9enjGNRVqtnOaIz+yAaRFYpgAws4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGbeG5nl9X7XRcK0zadCxVYx/v2v0zu+v7MMwQc8K1tcjwJjlJK+zJDCzKNrZJIRh
	 RgZaFXUHghDNzW2NLztQmG5B73mM4QZ7KKbqSM1cfKVJSsbOadBLmSxvsslqIhDtUE
	 KFUd34DpHq+vkkAe3declnhyRh3rDBuq0M+mcc/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1204/1848] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:54:02 +0100
Message-ID: <20261118150010.426022785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit a7c07602e00596a45de8a4a700af96392953ed38 ]

In adis16400_initial_setup(), the return value of spi_setup() was ignored.
If SPI configuration fails, the driver would proceed with the
initialization anyway, leading to undefined behavior or silent failures
during device setup.

Check the return value of spi_setup() and return the error code immediately
if it fails.

Fixes: cd888a17f95f ("staging:iio:adis16400: Use adis library")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16400.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index 07171e5379969..cb5685cbb5541 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -450,7 +450,10 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 	else
 		st->adis.spi->max_speed_hz = ADIS16400_SPI_FAST;
 	st->adis.spi->mode = SPI_MODE_3;
-	spi_setup(st->adis.spi);
+
+	ret = spi_setup(st->adis.spi);
+	if (ret)
+		return ret;
 
 	ret = adis_initial_startup(&st->adis);
 	if (ret)
-- 
2.53.0



