Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060637;
	b=O5OF8xlTeThNFlG9ZhYEfQF+oKHxDk0aYiuVtuitEt3Gyf4kEplskF+xL8sSOcgRpyij
	 RO08TmSfn0nvc0Ejs/E4Bo3rCEXAYhT/M0XP4bqESPBgOAl+i7/S99qzEYCMgq9KQqgpt
	 uvRNgn2PSMTHve9PpC5X20Y3P+k4/gRNuwMUwGv5/gCM7rfiv/nk/5jk3OqATrmScAts9
	 /J8BW6Hg1FReOMC6BZ/DwkybMA+npDGoMSSM38vTecQRVmXDqsmxP+cEXOdSAl6aYlSGr
	 qMJsERilYt4oTschqxoDEFhZkERRX1qdBkRsTEzZ2BmfMW7PXHCR1JVOlBneTsCz0uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+C13jJZOMJZMjb0Y6bR6KF/1Ns+ff0DjZe4mX6VveM=;
	b=wr4QcMohn1i8VJ1v2OQIeDsL5cAh43UmIGjQrWXFKe3g/bl/PIGlIo6LDRPctygTerVl
	 YDHO2BXxkGZqHco1wDcqBMN1u9oahbXH1/kEdW7PnSpTEwn1esS1I1NPZW9MK9/C+qsVQ
	 DsDkUAm2fMgFPtfTOOzChI66siH+RT88e3dCmOrjbTUEUHELWf5hXSFJe7V2kYt260y/w
	 XbSCngBnMkmr4UXEWl4+p4jVlno51H8F0QW4Nh3MreuNoY0GmdhfeWY20jP3tNVOfMaA8
	 0MI472MnX/gNxsEIfqfIxptNLnlkUe7Yt+386E6aNbHF20D7IS3SjzYCNiqZOaHBhHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N7/2HR2J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EBF606A326;
	Sat,  7 Nov 2026 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7/2HR2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B451F0089F;
	Sat,  7 Nov 2026 14:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060636;
	bh=1+C13jJZOMJZMjb0Y6bR6KF/1Ns+ff0DjZe4mX6VveM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7/2HR2JqS5qCHVzBfGXvZCMkO5qDf+iHm64aY44z1Sowt3FemYsiUj0y6tp/RNks
	 J4/7X/9yUwzyJXYsUCrmoc754EPnzi1JOxcaedRmZQ76RxY2Q7wnL1Km3UDXdsOnE5
	 aIe/XQws0mrcwar6/jJwREaqg6tLngvK6wacIEYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0041/1536] iio: accel: fxls8962af: clamp the device-reported FIFO sample count
Date: Sat,  7 Nov 2026 08:34:17 -0500
Message-ID: <20261107134958.814181332@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 2f8225b91eb478ca2e9aec8aaef4d229765bcebe ]

fxls8962af_fifo_flush() transfers the sample count the device reports in
BUF_STATUS into an on-stack buffer sized for FXLS8962AF_FIFO_LENGTH (32)
samples, but the count is a 6-bit field (0..63) that is only checked for
zero. A device, or an attacker on the I2C/SPI bus, reporting 33..63
overflows the buffer by up to 186 bytes: a stack out-of-bounds write.

Clamp the count to FXLS8962AF_FIFO_LENGTH before the transfer, mirroring
the clamp already applied in fxls8962af_set_watermark(). Conforming
hardware reports at most that many samples and is unaffected.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/fxls8962af-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index a4e4e7964a1aa..80a611f43d50b 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -959,6 +959,8 @@ static int fxls8962af_fifo_flush(struct iio_dev *indio_dev)
 	if (!count)
 		return 0;
 
+	count = min(count, FXLS8962AF_FIFO_LENGTH);
+
 	data->old_timestamp = data->timestamp;
 	data->timestamp = iio_get_time_ns(indio_dev);
 
-- 
2.53.0



