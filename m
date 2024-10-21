Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FC51E906A;
	Mon, 21 Oct 2024 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506659; cv=none; b=WC/d45BSy/0zQ4WlJYC4WRSRNd8JX2cOcJ6O405aJ9Vz20vOEJRcHbkcMzyldOrimr7xWzXr6Sv29JVdhd20dKDuGEVSrDucuPP7tY7Wf+mw8Wd2Jo61ZTl4ExeVgDbeAfArA551DszseamkVLI1sxPmhKk22YR5N43anjr03TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506659; c=relaxed/simple;
	bh=0P7/rV3u1KkD0ZclGWSyvUhsnOJtybbZjFhRW2s1Yno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tkryrujet35HB8HzwhYV5+gZoshYYeR6+9drhpAKti10VNFw6bqjce0bI68cVIy1hQyBFEsDbcoXJRMETUzePE6hBWbA97KLZ9zqL/nu+Hc7J03VFv9M3pzrpaceAbBlQsGvIUYWltkJ+OqgjOJ+uMyIjH7cVhEBGoCE2HWtlf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/43X6EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/43X6EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C72C4CEE9;
	Mon, 21 Oct 2024 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506659;
	bh=0P7/rV3u1KkD0ZclGWSyvUhsnOJtybbZjFhRW2s1Yno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/43X6EM1K3ZFuIVkRFg/t/aCe4kqZVvbh0sFbGJ4+XV9L6Lsn6sSTp4w9IrJI8R7
	 qhAp9dDCJI5SyNXHgyyvAnvixqMDMDYKkog0ORu7YvmMvXuvT7mHtnJsAFxcJaPDiW
	 GaBr+Jdp75IMm0/bpLOX1G3SxpMRSnP1tLQVWCL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 079/135] iio: frequency: adf4377: add missing select REMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:23:55 +0200
Message-ID: <20241021102302.418195182@linuxfoundation.org>
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

commit c64643ed4eaa5dfd0b3bab7ef1c50b84f3dbaba4 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: eda549e2e524 ("iio: frequency: adf4377: add support for ADF4377")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-3-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/frequency/Kconfig
+++ b/drivers/iio/frequency/Kconfig
@@ -53,6 +53,7 @@ config ADF4371
 config ADF4377
 	tristate "Analog Devices ADF4377 Microwave Wideband Synthesizer"
 	depends on SPI && COMMON_CLK
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices ADF4377 Microwave
 	  Wideband Synthesizer.


