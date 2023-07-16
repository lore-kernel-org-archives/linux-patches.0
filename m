Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C238748C
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CABBC433C8;
	Sun, 16 Jul 2023 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537194;
	bh=5R3QcsaKEDHCRAWjA6wncRV4wlqc2Bh9h1cCn+8bRCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMAycVmaSTC5DjmV1H2luuJ84YzO2866k3c5uwKesfz7qEI1zpe/VqllRTFf+z+Qm
	 uT6/YU4Ea8ZCjbNtV2ZNK3rpuuNzkgKe2NBTeM4tnWk98X1HphxE4yWCrg0eUnaPY8
	 rtu8RQwM7ekaOLz0FZUv+3A17ioLQSMfd3uEKvb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 010/800] iio: accel: fxls8962af: errata bug only applicable for FXLS8962AF
Date: Sun, 16 Jul 2023 21:37:43 +0200
Message-ID: <20230716194949.345658205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Nyekjaer <sean@geanix.com>

commit b410a9307bc3a7cdee3c930c98f6fc9cf1d2c484 upstream.

Remove special errata handling if FXLS8964AF is used.

Fixes: af959b7b96b8 ("iio: accel: fxls8962af: fix errata bug E3 - I2C burst reads")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230605103223.1400980-2-sean@geanix.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -904,9 +904,10 @@ static int fxls8962af_fifo_transfer(stru
 	int total_length = samples * sample_length;
 	int ret;
 
-	if (i2c_verify_client(dev))
+	if (i2c_verify_client(dev) &&
+	    data->chip_info->chip_id == FXLS8962AF_DEVICE_ID)
 		/*
-		 * Due to errata bug:
+		 * Due to errata bug (only applicable on fxls8962af):
 		 * E3: FIFO burst read operation error using I2C interface
 		 * We have to avoid burst reads on I2C..
 		 */


