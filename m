Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924B21E5736;
	Mon, 21 Oct 2024 10:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506656; cv=none; b=bonX02NbEwRuyFrTe8rbRwRGuVVNjUvXOMB8qnuQO9OIKQi2JOwIY7DEsudwNUzT1l22BN2Ybq9d7OfpSnfgcOppU3JekGd0ypFWJP/3pdzeX4LU1KejT1N30Z+sldOun7kXzsnrCo6ydv44iE9F8lZmUIH8/ysEYmQAtulvRj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506656; c=relaxed/simple;
	bh=sFsWWqKWmZjsYpi+f9HiVHMbFSzZgZ05DAc2u/O5F9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4EEwnWOuWrglMSBgE3gt6WW8FUqpXEn6UePlcpzZ8EuQuNp4cIHDov12JPpr/3Kr9nXXxKcWTlxStivhO+svzrMSmoptiG7640s7YjOcggceyLYYf6mtcEGeeW3vPuzFCRGUVPZx9qfUT8QTrsi7gsA8uo9p0764Yn71H5IJ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRexrruX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRexrruX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36BFC4CEE8;
	Mon, 21 Oct 2024 10:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506656;
	bh=sFsWWqKWmZjsYpi+f9HiVHMbFSzZgZ05DAc2u/O5F9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRexrruXUX+19pRA+HBO+PbPKOHCgjKhYeGLSWtooY2Ynp3hBhxmtFOFD2I5GQQEm
	 GSUp4otiq8AivIgHVT8cSgBPyY2yvcoqy04sistSDcvvTaJM3Flu+dHqCqjLcRZWnO
	 85h64oQuZ45Yn6xyUHzZJTTgxidT+3g2w3nSRTHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 078/135] iio: amplifiers: ada4250: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:23:54 +0200
Message-ID: <20241021102302.380441652@linuxfoundation.org>
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

commit b7983033a10baa0d98784bb411b2679bfb207d9a upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: 28b4c30bfa5f ("iio: amplifiers: ada4250: add support for ADA4250")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-5-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/amplifiers/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/amplifiers/Kconfig
+++ b/drivers/iio/amplifiers/Kconfig
@@ -27,6 +27,7 @@ config AD8366
 config ADA4250
 	tristate "Analog Devices ADA4250 Instrumentation Amplifier"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices ADA4250
 	  SPI Amplifier's support. The driver provides direct access via


