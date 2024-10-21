Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DD81EABC0;
	Mon, 21 Oct 2024 10:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506665; cv=none; b=nChVHQR7VaWMMQoj1x/oyHD3acZqFQHxP2wLuCqTldPqRuXVZ88c0EF1ni3oUiUKPuP4poEA55NDdVDcjpisI0ZkVdLXESPw+jWaxOijDVic9TbMX/ZA5zStu8H3yImKwdsnThCH0dWKV0gNK585pEliqvTJNBHatX1p3NOt+qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506665; c=relaxed/simple;
	bh=YgaqMM842Yk6M97SHEI3qUnYb5BLK4+ffhr4WB7GC/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HszdTNEDiQDbqSdAkrJXdXemCJugVnPok7nagUa5136QhWwraxTHyK4V0JaO1lMYvQZUuAYg+fYAt12n6HAOXFwJm+MVDYAKri9ip3Eo6gjQ0B++j7bsvCRZcySAcoybk06ccZy6jItPmG77f28Hu/HNm/sW75uj+4hDIo/tMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNQkrUWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNQkrUWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5B1C4CEC3;
	Mon, 21 Oct 2024 10:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506665;
	bh=YgaqMM842Yk6M97SHEI3qUnYb5BLK4+ffhr4WB7GC/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNQkrUWx9udF6+QE1DTHpS/ehCIPnOcZZTPZ929dJotyFcz0hcpa4LCfxvGpwt7h4
	 bcjvX/35OXzlUhUzrLrd87vCKbIbKnItp5meQcn8JBHSV4AUYZJ/5SMwF+tO+E7PvE
	 EMHUJqHFuig7aH3jzrV99bwefoPxVnZkOYKUQFZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 081/135] iio: light: bu27008: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:23:57 +0200
Message-ID: <20241021102302.496741599@linuxfoundation.org>
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

commit aa99ef68eff5bc6df4959a372ae355b3b73f9930 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 41ff93d14f78 ("iio: light: ROHM BU27008 color sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-10-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -322,6 +322,8 @@ config ROHM_BU27008
 	depends on I2C
 	select REGMAP_I2C
 	select IIO_GTS_HELPER
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Enable support for the ROHM BU27008 color sensor.
 	  The ROHM BU27008 is a sensor with 5 photodiodes (red, green,


