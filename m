Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060659;
	b=lbfB14tHdW2zEjA3X4Q247AzI0DsTHwUd8PCpuHZFvmkMSi3NeOxwmA1x2V3b4E18ffo
	 a3Ffi/1nEDdcalz0FqRQbTIuXkoPHUnXZ3N6QTp9DtXKER9j+DFilqH7oRtiAZZjHR0Kc
	 fVoYnywVK65+6DPuN2kEio5lreh6qe+qg0WGnutcZoJRI6xraDz4VrkFFdrFU2NaxWU8x
	 WEXxkZkA1IHUk2pQD6IGaAFnI6ojQSbQqhH5rVsGCi+shfLLIkVGhG5vLhEIt8N5G22l6
	 +KZ+KX1g4C+32M/VpzEQYujhy5oJIW5WcKNVFe/VJY5PNZsZ6iGu4Es7Ngl8W+4vbOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RqM4p0KggN5fmI1Jj931AOBCAYhj7l4bDyLQvVK1mNA=;
	b=S8Yqw6fMUjB+/mvh4Qs6VnFhvb5tQklkSey46XbykbhunDCzw0zNcEVA4CrLZnTZuJQT
	 ST3R5fXQWHnn5Do0Tb5Xua2rtMJOAw+cu6xMJ5uLP0wUd9x+x0nXsjYjTpkn5gQ6a6o0L
	 9dAyYP4YyzmuXv1DAD/iNBRHzIRc/CHh1/zLlPP5Ii6mp+19eAyznaNsVnylEipCyorbm
	 +9vYVekp/73cowvv1qK37eHgBfn/icD8vK5/Biiqp1SxznpbQnaVlyubUGWVcMeeI25WL
	 WIeE9d/6Eub/2yyla3bKkDRJ2ZWpAnTZqGiEwSbsEaSdKBy5gPjwb2cTy1Ty4qnIthQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dvZmqBo/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF052606A326;
	Sat,  7 Nov 2026 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvZmqBo/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4C81F0089F;
	Sat,  7 Nov 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060658;
	bh=RqM4p0KggN5fmI1Jj931AOBCAYhj7l4bDyLQvVK1mNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvZmqBo/ZoyvWQorZtMdFwf8NFLzEhFYR3F0f7Bo9Nbt20TUUoFIic5UcqlXWC63j
	 tSUb5OndFmmLwskEYB5QJDaS7PEcRPy5u4La+YYEyZ5NIGYLLHww2C6vhv6d81jhHi
	 3gpx/rqSdvh1X4zRQD42fkaM43Avj30xkAEhXAuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0080/1536] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:34:56 -0500
Message-ID: <20261107134959.921187941@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 790a2080e0c9eabefea3561dec301172043de236 ]

The driver has a match table for the spi bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1241.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/max1241.c b/drivers/iio/adc/max1241.c
index d62c1a0116593..cab04beae7293 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -179,6 +179,7 @@ static const struct spi_device_id max1241_id[] = {
 	{ "max1241", max1241 },
 	{ }
 };
+MODULE_DEVICE_TABLE(spi, max1241_id);
 
 static const struct of_device_id max1241_dt_ids[] = {
 	{ .compatible = "maxim,max1241" },
-- 
2.53.0



