Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767BF1EE02C;
	Mon, 21 Oct 2024 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507831; cv=none; b=sMiJSlSKu7mI1o1j4oEJz8g3asR9pXfukuwBRNqLsAkt+7fp4lGxBU0Eymyo5oQ/oPB/uW4eTDL+aq7ZJtDwI5gssTHiWHrrzrFHSqPVCBqf+tPayGBOWUqvjvJlEQZIZn9dGc1QUndC+9A4bnPCVDY8z6N5S6oX/H9YEgEcNaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507831; c=relaxed/simple;
	bh=YRJHjgsN/Sx+Cle5/IGC8B4viAYtL2JPDFvQVWjxuRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuUHxU0PdwGiq41yBoxrbQrlglIA0y8b4M9O1jmT/vKmDeGrNQ0P5xbsigejSW4b1BocDTzOOC2wLlcPdCkcQKrv2YCVL+Pyqc+L6nwur9jZHFxDhfGNl65tLOon4cAd2GbiZ6SJ6XAUm9kNxxz4MIb6pNeF6Gdtevpsiah8Vcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2q14hYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2q14hYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7C5C4CEC7;
	Mon, 21 Oct 2024 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507831;
	bh=YRJHjgsN/Sx+Cle5/IGC8B4viAYtL2JPDFvQVWjxuRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2q14hYgN2nqOZZQx7xciBBsKSCdNnK4lWOJFTscsSfINUOR/QQdEElEzBbt2EvD6
	 0MXFmi4vfFS4ADqNjAZbjGsVbvKVlfPJK2rdHQcE9EmRdxi4OkaSnTg+El4YEB/Aqy
	 bCNrlZOOka8JK69Q0oFOQj0Us41iL5xu8vJkdBho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 34/52] iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:55 +0200
Message-ID: <20241021102242.962472352@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


