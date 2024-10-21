Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8EE1E47A6;
	Mon, 21 Oct 2024 10:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507897; cv=none; b=KmNXDSYbNcEdbTL0bfIxNoIgoh0HWwCbGd03n3Y69GNlwRcCSAL2XJiVWbZFHoiFIZIaqlZthVNJgkfkul4lAccwRf3yIKjJzB/VshLyz3dNiesjH+8ZsfHU+d8SrvHy6IpVpp8U0cm/39d3Sre7+sIMuJoGPIk1XouWQzi1Ud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507897; c=relaxed/simple;
	bh=F50Z4NPjwjX9X3qfxmMWvw8hrPSw196GuWhUaknVbyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKF/UIxqhf2+BlQHK8VUNadfAnOZ2jetvECdcn4Bkjw6tdrgGQTYAgvsXiCwiYXCMNkS+vO6BBoKdNTZHwdo6xTuFBI0Oy8lGAV7cupjh3nKUTTwUCTfXpkEetUdHBkYOTX8lpTLbiVzCMljaTITsTpFugMic9cu647HOBWdYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4ll3q+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4ll3q+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E393C4CEC3;
	Mon, 21 Oct 2024 10:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507896;
	bh=F50Z4NPjwjX9X3qfxmMWvw8hrPSw196GuWhUaknVbyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4ll3q+RNuk85bWhMDrPhynYRIjDeSqml0qKS1+69MkapCJ+CvGjV3ppKxlo5aYd5
	 AQPc5lAgVypg3+E1RS1o69Sf8FzqyTIFkLevugg3F3b3FiaDU9LzbJRfM6mnIypsRH
	 KIzcj1CEnLrCsO4b/OV8WWOiACR4YCOgI+L/Fcys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 29/52] iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:50 +0200
Message-ID: <20241021102242.766744015@linuxfoundation.org>
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
@@ -1126,6 +1126,8 @@ config TI_ADS8344
 config TI_ADS8688
 	tristate "Texas Instruments ADS8688"
 	depends on SPI && OF
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS8684 and
 	  and ADS8688 ADC chips


