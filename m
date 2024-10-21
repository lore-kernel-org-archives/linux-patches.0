Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6BF1953B9;
	Mon, 21 Oct 2024 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507400; cv=none; b=JERRKiXe44cZdWxB5imCJnxIuPSNNIrlwAeHmHNBofBXZyTHLoxbW8ar04gFezI2Cz+50MQmp8AlN8kJappunFKkYNjMT9/4Tqjk5pukPG8jbjY5csY9J4jIq/zJT1kfjAo3UtcowDF/EkNFKji2hg7RQnKoIdrN14Ka5PTgtxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507400; c=relaxed/simple;
	bh=VXDUbLEezxym7njxiyf33xCRnjUvuDinXepj+WVr1vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaQ9xDnqiGEKJIVZnA4VuSDtbpabDxS9BKs3WOov8sO/yZAas6he/8A/cJH0NY/m92YJINwhQARujperhyXb0F98WJphryjJFbSfbe3q/MxJuJ4jDyeemin3gXL7YR+wgoL0QYgYJHoqDNnd0/5NlYvRyLuCyAFvmcJjy8/87zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VthM5BmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VthM5BmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA974C4CEE5;
	Mon, 21 Oct 2024 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507400;
	bh=VXDUbLEezxym7njxiyf33xCRnjUvuDinXepj+WVr1vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VthM5BmQp5UUuocpYpPx0unlBVxVdzJ6J9zxBVprQpH+y6MY4AiN53cae9hi70XMf
	 PEVL/jZp+w9NM54OU6XqShGnmDYqAyNoF/IVb8qBE38GgN0g2+LhLlUo8uOwazW15Y
	 Mfi2gqViDuNywc9lnUS3qkQtKBKxP5oqEu+D750g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 65/91] iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:19 +0200
Message-ID: <20241021102252.353335926@linuxfoundation.org>
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
@@ -60,6 +60,8 @@ config LIDAR_LITE_V2
 config MB1232
 	tristate "MaxSonar I2CXL family ultrasonic sensors"
 	depends on I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y to build a driver for the ultrasonic sensors I2CXL of
 	  MaxBotix which have an i2c interface. It can be used to measure


