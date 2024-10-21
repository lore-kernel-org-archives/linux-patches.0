Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1D71EF0B0;
	Mon, 21 Oct 2024 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506681; cv=none; b=POFmWUxNeGRTc0cHBh/QlyhUZwuinglr2fHKOV87KcC57Ndm0DBzGCdQK0wflznx09aJ2hWDultbPyUNjPe7Uljpzauwg6qMSzl9QIi6f0zd9JkVGhXZHwlEvdUYiXhSbMr5placP8uBelRLhLN+5Nitgcw5q4YUrhctLEJAvU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506681; c=relaxed/simple;
	bh=uhK1bFJGgYkqxUgOu2u0vAhKtqXXwmiu/jjMx9K80RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPIziEnarHcNxby8UNQYYfejEyv0OrMCgtaMJdo49c23QmjB6rN18IfoIpskV9PcTwr+FtxvOZCZVsrIWAssV5GVFjl6ubqaatanjY2attiX8qiVHXOvPeM0t1x3Jq/jqNQJkIMSKstWAByER8ftHsZskcwvXLIX4FUcA5IqVbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICoFOPId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICoFOPId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0FCC4CEC7;
	Mon, 21 Oct 2024 10:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506680;
	bh=uhK1bFJGgYkqxUgOu2u0vAhKtqXXwmiu/jjMx9K80RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICoFOPIdgDshPi1M5q+yN6YPxjhsx+nbwovWR+l6ue6Puj1KF+TFpe0WRjp5a13RE
	 YPSvMiUDBtko7AaQNTM4rlXVI2xR8paF5mW+zZ02JYbeq/aUvEzIJqeEd2UHSY477z
	 +b6e+rS99QaNMXRy/hYd+/WphFEhgoPmF9a2cZBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 086/135] iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:02 +0200
Message-ID: <20241021102302.689942896@linuxfoundation.org>
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

commit 75461a0b15d7c026924d0001abce0476bbc7eda8 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 16b05261537e ("mb1232.c: add distance iio sensor with i2c")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-13-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/proximity/Kconfig
+++ b/drivers/iio/proximity/Kconfig
@@ -72,6 +72,8 @@ config LIDAR_LITE_V2
 config MB1232
 	tristate "MaxSonar I2CXL family ultrasonic sensors"
 	depends on I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y to build a driver for the ultrasonic sensors I2CXL of
 	  MaxBotix which have an i2c interface. It can be used to measure


