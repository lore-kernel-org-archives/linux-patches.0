Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015927;
	b=qziJnl96+FdmudxdeEvE5E250+E0xfcCSZ6Y18jH6V+MtJ9HwbqbcXZQB1S0UCCOvprz
	 Zw8e/NiLYDljalttG0p7cWaYFNjDJIY+KjGxZRojzbDXX8H+F4RgnuC0GoUCHeKgJYS68
	 IFV4fdkOjFd6ZUufaTROW9O2iZMBXwGymiCUECtk7+IofOBuWZdTAY6yEDkARcw9lraJ8
	 dMAoZSDyKNN0z0+vsj6jODyzhMyVRH2vxvTo3/2C/s52gvNMuTkx/SW0i1l+QMkv/83pn
	 MCDmrA+SF75vQfttpwp0bQUXJ3lIOb+bGaJW0wj3oIwDKnE/6mqY+5kvLDZN4WOjnBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wz9+vxvkriGQMWe6kQXEMGJhQUIBGKVrBEcHoVMxcqY=;
	b=H3sH8QMzg6APrnY4M1gJDl+RNvuws8UX9B1k7T+bBz1AEy3FUtD2skFLawtHWtlj6er2
	 noiluLnRJauGGShAs4wm4vPYW0hKyPtpXvDIGM8ZPM/Hv/VaK7dc2LTJEaHiypT4I+JeR
	 fLQvlw7LAThkoSZQvoAdeK1CkJwF0SzakThmrrJo2jwu1shqJ5LXLeeltCBSde5Urc1sv
	 qbw1TMIrTWFW9WfRD0I37iiW1qA4zoB5uCmpB0IjvAELXybpTydiXSrwLwrQ0kWNnrfu+
	 plgo1K/gaMNaGli6wCmseVxUDdZU3TKWIDhq0jjFsaIhRgDaOVL8c77xReQL7DPtEZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boHZCb9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83898606A31C;
	Wed, 18 Nov 2026 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boHZCb9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FAD1F000C4;
	Wed, 18 Nov 2026 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015927;
	bh=wz9+vxvkriGQMWe6kQXEMGJhQUIBGKVrBEcHoVMxcqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boHZCb9nfc7wXewoa6+fWHnewj/k79fJie6oVaPt+MPZ2hxPoqn1v59nfda9etDaT
	 74TQ9rJEpeJATHGUYfPldzlR/6LDuILSlN9XdO0D6iRoAyctkm4GpcqlbmPtPuQmtw
	 tqmfzLOrXt2xetKw7l2yngGhFjsp1IUQJDS5rtXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0348/2651] iio: imu: adis16400: Check return value of spi_setup()
Date: Wed, 18 Nov 2026 15:26:28 +0100
Message-ID: <20261118150300.366450215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 512a8da63cdcb..79f2974d37771 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -420,7 +420,10 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 	else
 		st->adis.spi->max_speed_hz = ADIS16400_SPI_FAST;
 	st->adis.spi->mode = SPI_MODE_3;
-	spi_setup(st->adis.spi);
+
+	ret = spi_setup(st->adis.spi);
+	if (ret)
+		return ret;
 
 	ret = __adis_initial_startup(&st->adis);
 	if (ret)
-- 
2.53.0



