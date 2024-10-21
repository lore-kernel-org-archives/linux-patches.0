Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C591E6325;
	Mon, 21 Oct 2024 10:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507463; cv=none; b=KEqDUOk3FIyry5TuqQP8C1WGYSoEWxjFoC2IDYDlPClCgNQQkFKDBA0+LLVIEjZcuv9fwpazhji0oz99wBjEQ7NLfnVBkjYzTi7jLNrVM0stWCpheMdqxNy2fmsJp23S8KhdLTsg2h6EVJdoy8kL5aoM5BXbtd/pbPsm5G0Mz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507463; c=relaxed/simple;
	bh=X5CZXpPUq2DAymbS3jq/IAek8DHmOr/9tOCSoSEMrAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw70f3A6ZMGSfOjGolC/YFG6hKLbiMTF/APU++eiR6eD1jLjMOydccyRxr7zevus4Ln9iAdCeqr86mc6GBFeXD8W9qGnOgkup6/DEYz+NNg8KdFDwP0p+qNT+TVlCUATV/PKjBwfpsSq9XuYBvAJV9IhN36ygYkC4Yb5QvEb560=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idZp8DGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idZp8DGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BC4C4CEC3;
	Mon, 21 Oct 2024 10:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507463;
	bh=X5CZXpPUq2DAymbS3jq/IAek8DHmOr/9tOCSoSEMrAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idZp8DGZHLIUJynLfRNP1FD4pyLyjDiFrxQdQYe42TxHwofc407P6L7FG3++QTAut
	 gxKjJS9ubMCwD7P4CgTwMK1JGkXvpm5wA66MRPo1Fi1jL2S40sEMGTmGaU6Nvgjzah
	 chJSV0ZG1AvtGliMVqWBj24WfWr1w6D0rFW9+rlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 58/91] iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:12 +0200
Message-ID: <20241021102252.083391190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 4c4834fd8696a949d1b1f1c2c5b96e1ad2083b02 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Fixes: 2a86487786b5 ("iio: adc: ti-ads8688: add trigger and buffer support")
Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-4-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1193,6 +1193,8 @@ config TI_ADS8344
 config TI_ADS8688
 	tristate "Texas Instruments ADS8688"
 	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS8684 and
 	  and ADS8688 ADC chips


