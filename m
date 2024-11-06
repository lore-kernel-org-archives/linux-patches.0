Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2261DF738;
	Wed,  6 Nov 2024 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898837; cv=none; b=YA9WkZsBEUc//nDOR74KCWHcZQA6itLhbqRsHqINvdx6AwtYUnudbh7vIEctI7Z4PtLSTfUwJ400b6RgbTUzI8LUEdKMjMrLwjmazCvooUUu/JG0cmVnq9SaflKb1H8iHVieFttXyJZatrvUOpf3N4DIBaxNjgWFTMbGg1UaeSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898837; c=relaxed/simple;
	bh=jzUmavmKupLtkrvDcvzleD5w7Gq0NRXxmwoqF3p+a8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOkirddN1LBfGHu1taZb+8aK/rO7AKlgDrRvb6pYrQwvUJGm8G0FanRkFMJtnQU4Ef+LVqXFFkk/SPw/02LwNu1iZYZMzhGEH8WHbOL9H9DFrbDBl0pACf/J2xNTXWvDCEU5BqyP5dyFF+pKKcgp3uFdeLpeA2EXIX2pIyjkZNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Td09aG37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Td09aG37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85926C4CED5;
	Wed,  6 Nov 2024 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898836;
	bh=jzUmavmKupLtkrvDcvzleD5w7Gq0NRXxmwoqF3p+a8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Td09aG37orOePJ3j9j0LVoojm5tn3yDu0rDuyLRQ+KD+UJ2jc6TkDOviOd5yrnqS2
	 hYkHe3NFB8bTBvNCXGW9XmbTuQeKHU23u4AnDXwpl8LFJFt3DYsIqfZHCBDlg+m/TC
	 MLgUN8/y5sKCT0nloBEafRQcHEV/0H/xACDATiDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 372/462] iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Wed,  6 Nov 2024 13:04:25 +0100
Message-ID: <20241106120340.714649607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -49,6 +49,8 @@ config LIDAR_LITE_V2
 config MB1232
 	tristate "MaxSonar I2CXL family ultrasonic sensors"
 	depends on I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y to build a driver for the ultrasonic sensors I2CXL of
 	  MaxBotix which have an i2c interface. It can be used to measure


