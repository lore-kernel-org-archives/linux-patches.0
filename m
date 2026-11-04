Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829430;
	b=EWvHoBLXv00cE0ad45gDV7N28C3uvDi8LWNuVRFufpxS+VQ2eTFhkU5Y4QdlTKP153ON
	 ZdpgK6ri+i+0dHpzaKqBYE1xAPMuLXqNuhrsWdbINmR200ga2NOf2wz+37y8EnEEIPf/O
	 z6drM/I0HIDwhRJU3urNhPhEMvb50ZNlZU3XMKU3hBXdk9/nZC3Zty3OOKlY7aFZ5UIIa
	 yC9XJyKMuZnWqx1OR5NEM/XhaSKb5BW6jfRAjWDeEo8sDsVmJ1dWjOQYy3kOeuoCdZCkA
	 gHbFpfC7Wm1SiSaOqt+9tCOZ4OUtdcEwlsY+EcsucgoAtX/wstIhhkGmkxHKjyFyf0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUMyaCAwkGDOpk5bIiFTTYCMZMK05vErZijbi2QVQxU=;
	b=2qJdfv+D4qnrd+uJzMXQ43EB4Ne1rmf02dr62hFCM1jmqvI2LR4g4qv0ePtC86Ny+Jfg
	 UgMCRKGo9wKpZ23Vz6lnlzq7OUeV9m0EbXr6Kx2yzxXlQLL7LbCLUeb/+1aB/svfNIDht
	 d662XS2FVW5A5KywZt0E/chHfVefW/hALo1fYSHmFpIpzr90o8ZCTyaQgI2o2cWy6QPc8
	 EMEjfBbH3BPnguyoK5k0SgVI/0zzn8oUsWxk6cW1NydzVWRFGBU7PiIV/ncZ7Y7W6JW6+
	 Gjy2wccLJ+wwJL/XtcEvAKPZhPWTIY2ao+UhPQNtlswhyBx+WdZgwFxl27M2f7m+1Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRx8epJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135C9606AE08;
	Wed,  4 Nov 2026 21:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRx8epJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B3D1F000C1;
	Wed,  4 Nov 2026 21:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829429;
	bh=nUMyaCAwkGDOpk5bIiFTTYCMZMK05vErZijbi2QVQxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRx8epJOtPeYU/tNE/AX3FLz5r6Qn8RAUkHw5YjOU5/to21/doi6b71RmWqq82mJ0
	 YH8ZxmnU7pCbqNmvobPVjWTwPn9dVLRYNTSLVbTMytqTlsCayw+NxdlZo5U7uf9U8h
	 6sTHjnlbvGpOv4aonY1eh9jgervYwWLzzN8zHdfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0094/1005] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:07 -0500
Message-ID: <20261104211046.262992541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



