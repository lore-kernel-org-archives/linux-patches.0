Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0509A1EB9F4;
	Mon, 21 Oct 2024 10:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506669; cv=none; b=ok1kJP1Zg99yaTS+dxY21xgxfs5wfLkl8/VP+qjMy7Sx2+XZepm2ZBnp6joaWycQl0kms+2CYUeFI+pJD+BMqCzKEyhVtKQPDoFU0Q0NJbEhc8oOSB3P1jIbAXbtit9GC6moUhFSA5CU9Xn4wEsc3lhV7fY74djYZK9Mmkijld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506669; c=relaxed/simple;
	bh=jd/gggo1TfcYMUKn8nJiUq4Ow3ebp/VC82pyHE7vv0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjrVMLVRFKo5CmLwScDwtR3MOvapJQQ1S8cDkV2NLnzuCTZ4BAXhCD1vEyc9c+xZoOaobPwKHocBhWVGVRlxZ5MHxf7c16Ds9wAa8pp3/u6RbbsuQojEdnGn6TP9vRTwnNAHQOE59f9MBDOYJZLts/vKYAaK3JWUdJMCdgU5sKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC3aDs2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC3aDs2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07455C4CEF4;
	Mon, 21 Oct 2024 10:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506668;
	bh=jd/gggo1TfcYMUKn8nJiUq4Ow3ebp/VC82pyHE7vv0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DC3aDs2jspb97XrSCfHbsaZPoV5m6aJS08MtssA29Usw+GeaielWd2h3wgxFIJxkX
	 UgcAD6DZHvgSVdmRTZvRrLxvzUnKr+IeZ2de7Ue9ahIRxyWJxs17bX4Rn/EWVVmU/U
	 nq3Q1HhtxdguGkD6CPcyEVRQ1/y9EqH7kN6HGJzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 082/135] iio: magnetometer: af8133j: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:23:58 +0200
Message-ID: <20241021102302.534967955@linuxfoundation.org>
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

commit fbb913895e3da36cb42e1e7a5a3cae1c6d150cf6 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 1d8f4b04621f ("iio: magnetometer: add a driver for Voltafield AF8133J magnetometer")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-11-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/magnetometer/Kconfig b/drivers/iio/magnetometer/Kconfig
index 8eb718f5e50f..f69ac75500f9 100644
--- a/drivers/iio/magnetometer/Kconfig
+++ b/drivers/iio/magnetometer/Kconfig
@@ -11,6 +11,8 @@ config AF8133J
 	depends on I2C
 	depends on OF
 	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Voltafield AF8133J I2C-based
 	  3-axis magnetometer chip.
-- 
2.47.0



