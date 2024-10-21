Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EE11EB9E1;
	Mon, 21 Oct 2024 10:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507067; cv=none; b=guubuNqUCf9bjUedahbog8L+WdTuVzZ2u8pFwh4y1uudIW/WkLds3FIH+y78JGRBY63PONq8GloDXV7pPxsHrafmJWI/ftNSCTgoFJ0QZHHux69ofy9tmMlXynglVR0us6hzGUeFopXExZzXtVoNxHqky4jyGkHAu1czbtldfBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507067; c=relaxed/simple;
	bh=e7nMwLj5gYdkoniuVQpyA+g3naqrrNH2w5jn3nnvvRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2Ox8SjpDoqH7zx/+j1SZoqVItVOxaIenxE2PG+ZP7haRvOA6grP6kNPtlht4wum/ZQdJ2MZaPr1+Cn17eCWzD+bnOAyoe6PdYJo/lhtIHEEjy5Jiv0vYLvy/Pi5HEia4As1V96zcow01Djjj1XpqRouR83X97S6QbhogLmw0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBQApgQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBQApgQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC0CC4CEC3;
	Mon, 21 Oct 2024 10:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507067;
	bh=e7nMwLj5gYdkoniuVQpyA+g3naqrrNH2w5jn3nnvvRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBQApgQLWg8nxYGRZ+XQzaD0zOECi9jR/uynsrNMhkhVw0EzuNjYYuoaAlq5TcSsa
	 JIV71gRfwskzGRckyG6CiAIKd9o2OeFJXvo01C3PSV5m/m090P8G1wPXeTszGi2NoW
	 MHEOZDi4vxk93U1+YXbU7AH2rV6VkxgpomCzXmVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 078/124] iio: amplifiers: ada4250: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:24:42 +0200
Message-ID: <20241021102259.749675961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


