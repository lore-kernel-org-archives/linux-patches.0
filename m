Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225F1E630C;
	Mon, 21 Oct 2024 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506698; cv=none; b=G5pNyOXhhXiUfsF8ciFwmijLMC/5nyxKwdDOg3wedEi/AUcXcwiaRxLfuiAgVkadmSPPzMYCb09X4tDQ2yqPkq/Ti2pf4q0DhBQsuW6stvhsIlpN4IoAlwycFRgR2K/43wv3X/e15XREe5InOBJDUghmWbc8YTl92YhiEPWa7pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506698; c=relaxed/simple;
	bh=zIkk77nntBx17Ii2jyDsCfpBi57hBmlzLtxpu52j7fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H43cIwKVKyhp/hKgK6R95VJ3cq6RnSh1Xq7Sy60zb2gV/lRC/WXCOBzCzPCPVExNGvTRmye8Lj2UAoXh8COieYS8sFX1lG2Y4lhFP8nwuZoXPtQUuApwQQDaD7bFlg3a6L1V4cbCgGgZd2IkwCygxMMu0TQNj4/1f2R627KF34I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJLhZpeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJLhZpeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4761CC4CEC3;
	Mon, 21 Oct 2024 10:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506698;
	bh=zIkk77nntBx17Ii2jyDsCfpBi57hBmlzLtxpu52j7fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJLhZpePVtfwEDF+4E6bP9ClQQ2zeHpVWu8G05WMUDQAE0HSOZPFx3PP8u0uxuyhx
	 QSFY8v0T0SG4XM3zg0lo0QSnUXMT6ItedI7JZKV1/NxPtaMfR0OQqiw8a1h2cdUMLc
	 B2ZwEdF8igzZD7nMsglcQ3p0Tnntl3MU2/iOz8fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 091/135] iio: resolver: ad2s1210: add missing select (TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:07 +0200
Message-ID: <20241021102302.884966639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 2caa67b6251c802e0c2257920b225c765e86bf4a upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 128b9389db0e ("staging: iio: resolver: ad2s1210: add triggered buffer support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-2-4019453f8c33@gmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/resolver/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/resolver/Kconfig b/drivers/iio/resolver/Kconfig
index 640aef3e5c94..de2dee3832a1 100644
--- a/drivers/iio/resolver/Kconfig
+++ b/drivers/iio/resolver/Kconfig
@@ -32,6 +32,8 @@ config AD2S1210
 	depends on COMMON_CLK
 	depends on GPIOLIB || COMPILE_TEST
 	select REGMAP
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices spi resolver
 	  to digital converters, ad2s1210, provides direct access via sysfs.
-- 
2.47.0



