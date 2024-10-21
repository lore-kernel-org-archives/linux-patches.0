Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C301E6DE1;
	Mon, 21 Oct 2024 10:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506704; cv=none; b=fWxy54rMArpHNue+hltMOeRRq70/yKbvlA8b6eUIgh/Tlll+PhWMksMCgprJdWIV9wZUo6dmL/2PxXMvWydkAJGYyEtXi91Yvgq2e79V6cSqJqNsDh4riIC24SLkHogoTDIgVLxrEdaD3ZxCiMXz0OhkpUFe3RKNc3V67+OagHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506704; c=relaxed/simple;
	bh=s+DQVT3hQXtexPELBsD6voDItiuCk7iiABeov+sbm0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+4SjINPa3g5yd87gVVF5gKiUzemGDuiSBzD51fKsfh5gZxQGYDVgJAq7j+OwIttY4qMMOiLUVy7ipWLNSnnOuo5dvVOJqkK/2IU8dzWDmdM2wsc642MX94deFcu+jaW/7rYYpc/G/OAvthH/HrMqbY5xpuY2sTPDOlSyTEuzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ7890tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ7890tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3824FC4CEC3;
	Mon, 21 Oct 2024 10:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506704;
	bh=s+DQVT3hQXtexPELBsD6voDItiuCk7iiABeov+sbm0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ7890tuQUb3qonXiDe3ZXhEy6wredu67UwPVRwKE0zfKF8uIEgV6UOMbUk3o38a/
	 m52aezlUYxKeRJ2C+S4QKCHQTib35xwGu+vt2lEkq21q7O7uuEgba1+Ap4s2l3AUWr
	 SwO19Kd0MGHtaTEakOTDHMKKEfvOQm9q1+DScOg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 093/135] iio: accel: kx022a: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:09 +0200
Message-ID: <20241021102302.963251068@linuxfoundation.org>
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

commit 96666f05d11acf0370cedca17a4c3ab6f9554b35 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-1-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -420,6 +420,8 @@ config IIO_ST_ACCEL_SPI_3AXIS
 
 config IIO_KX022A
 	tristate
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 
 config IIO_KX022A_SPI
 	tristate "Kionix KX022A tri-axis digital accelerometer SPI interface"


