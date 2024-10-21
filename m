Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A496B1E6DD5;
	Mon, 21 Oct 2024 10:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507490; cv=none; b=RobJ9FAwUwLT8N2R8u5/dHDjBBNoAJMSmL+zZSwtlhgZ0Q6dzpI0BVRwbFYuZJaQCmb4a54ZyLV2bD3Dh3NWVfdJ4AniCap6bBJS1L3qkP+nI3Vk18O3X2gpVY2BmWv6+YIMDkPjsJ0pgtd0FjTElH2XLqCZMfw4JdS3pmzNslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507490; c=relaxed/simple;
	bh=4zQowDBt7mPOgqpVoAeIfD/OfhWAydQL4Ap0z3Xn8u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYV7TvNm6kdjQAnX4buMJzcJc4gzSEd6B5g2LiPIlNc+E4AJ6YDwIcp0Mmf315blBSNLBMrPjtCfH56jR+Mnegly0hBh9vxOI2/3zn/6XEpn9mWM+vTZ9ZdSORGvt0K0wO3J7IC7TB3nNrEcyxwUOPIkcYpYFGe883JI48qyPdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1pIl0/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1pIl0/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF55C4CEC3;
	Mon, 21 Oct 2024 10:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507490;
	bh=4zQowDBt7mPOgqpVoAeIfD/OfhWAydQL4Ap0z3Xn8u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1pIl0/VADuBDU3Wp7TTtVHC8XDSHeiOSlbuwITg0b7rGaJ7mT3JAbmL2KmfwH7Mr
	 F5vWUQNiUolphNv7p9cLUyIYIGB5Pq4KZ36+l7fccrHGT2tWTkH3C9qEy9jJFc7X6O
	 rHhIItMVDjXw9XqZTuQzKZ6vz8B4fK/XGQtgpIy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 63/91] iio: amplifiers: ada4250: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:17 +0200
Message-ID: <20241021102252.275826381@linuxfoundation.org>
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
@@ -26,6 +26,7 @@ config AD8366
 config ADA4250
 	tristate "Analog Devices ADA4250 Instrumentation Amplifier"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices ADA4250
 	  SPI Amplifier's support. The driver provides direct access via


