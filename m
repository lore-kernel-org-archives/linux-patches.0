Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17D91C285
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HXcXvvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7790AC433C7;
	Mon, 16 Oct 2023 09:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446840;
	bh=b8h75ZluMTsXUdXieMAXoFOaQRmk27ZQyzbfbL3gq30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HXcXvvGjZiOGDdfGYqlDYsIQJZyghBjTl/WNsI8/sKK6CCLyFozzy4QpuEkn3hlV
	 qBd027E7CIy8bQtLt/oZGFxv4rIQAa5LsxVWacMbIF6drSSEl7MLgfTZMMmBFrC3k6
	 +l74fNpWHH1eTdqBEVTOCWsNqe5NNEUK1zxY/klM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrea Merello <andrea.merello@iit.it>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 081/131] iio: imu: bno055: Fix missing Kconfig dependencies
Date: Mon, 16 Oct 2023 10:41:04 +0200
Message-ID: <20231016084002.072652205@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit c9b9cfe7d342683f624a89c3b617be18aff879e8 upstream.

This driver uses IIO triggered buffers so it needs to select them in
Kconfig.

on riscv-32bit:

/opt/crosstool/gcc-13.2.0-nolibc/riscv32-linux/bin/riscv32-linux-ld: drivers/iio/imu/bno055/bno055.o: in function `.L367':
bno055.c:(.text+0x2c96): undefined reference to `devm_iio_triggered_buffer_setup_ext'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/linux-next/40566b4b-3950-81fe-ff14-871d8c447627@infradead.org/
Fixes: 4aefe1c2bd0c ("iio: imu: add Bosch Sensortec BNO055 core driver")
Cc: Andrea Merello <andrea.merello@iit.it>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20230903113052.846298-1-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bno055/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/imu/bno055/Kconfig b/drivers/iio/imu/bno055/Kconfig
index fa79b1ac4f85..83e53acfbe88 100644
--- a/drivers/iio/imu/bno055/Kconfig
+++ b/drivers/iio/imu/bno055/Kconfig
@@ -2,6 +2,8 @@
 
 config BOSCH_BNO055
 	tristate
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 
 config BOSCH_BNO055_SERIAL
 	tristate "Bosch BNO055 attached via UART"
-- 
2.42.0



