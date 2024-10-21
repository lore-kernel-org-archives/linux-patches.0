Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234731EABCA;
	Mon, 21 Oct 2024 10:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507079; cv=none; b=TKx04q14DbVSRxkPake6p/0cjhH3ESJAQ0Ef4RCSXA2H4uRbQ5/RYLMkhX3FRJSJ89A+6soryP0lM3M1AWqDrBHHP2642oZtSSPREheS+V/1DjxjTUqcW74ZdmWvoSS7NrQa2KaINivho9IAgFgnuGyhP74ksUuvAX1lLdr4Q3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507079; c=relaxed/simple;
	bh=pu4hYcyh6G+SC/t4yBhQ9r4KpgUNtZ/PvNzzQGIcwiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6cNrzfcwYxXr2pjUw8Q4vBCvHlEi6Xtwk1PP0ohsdLMr6CRmhPdSS6DabPfw/81C3jAl1mrkoANSwIn0G9J72vqMCccV1W6G4EUhC7iTSQsHe3W/PL5CWCGbBHhHeuv1vUBfeZB9IZPUW4p5ws8zjC3+wcQ+t7CZfjK3NDGBNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbBOYNwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbBOYNwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97544C4CEC3;
	Mon, 21 Oct 2024 10:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507079;
	bh=pu4hYcyh6G+SC/t4yBhQ9r4KpgUNtZ/PvNzzQGIcwiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbBOYNwKzOAWOr0mqNXhALHKsA0vzESrnSnFI87+cY+jMWkqoA+oSyoDUOYfyPeUW
	 /OGIyiHLP6+KVzTsCzZqLBmR03bTT0aJoeVYBgNB3BWeGgH6vYZ6DO7MsptUgNrJp1
	 aOznToUplCy7hD1ANRHpg88kJxkCOrsvlQljVIoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 082/124] iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:46 +0200
Message-ID: <20241021102259.904311093@linuxfoundation.org>
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


