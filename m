Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE5748C
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F9CC433C8;
	Sun, 16 Jul 2023 19:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537197;
	bh=/SJTzf6cJ5rmORfMkdeRaBuuug8P0SJVYHhP41EdMjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eC3uLN15iYKK7CoYNix4htPLIgMW+Q8XU3WdH0zUOioCRmXidDel51yhmRDHP+AXn
	 8ZUSXVoHmh/C5nsg5U3/dH9RkRzi2vo66twtx1CMutSLuZb1+xAwZoTAztpCWH4ctr
	 4dTXKhE57oFAOdFwiQgMM/kSJO+Pjz7guJu4GylM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 011/800] iio: accel: fxls8962af: fixup buffer scan element type
Date: Sun, 16 Jul 2023 21:37:44 +0200
Message-ID: <20230716194949.368554167@linuxfoundation.org>
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

commit d1cfbd52ede5e5fabc09992894c5733b4057f159 upstream.

Scan elements for x,y,z channels is little endian and requires no bit shifts.
LE vs. BE is controlled in register SENS_CONFIG2 and bit LE_BE, default
value is LE.

Fixes: a3e0b51884ee ("iio: accel: add support for FXLS8962AF/FXLS8964AF accelerometers")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230605103223.1400980-1-sean@geanix.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -724,8 +724,7 @@ static const struct iio_event_spec fxls8
 		.sign = 's', \
 		.realbits = 12, \
 		.storagebits = 16, \
-		.shift = 4, \
-		.endianness = IIO_BE, \
+		.endianness = IIO_LE, \
 	}, \
 	.event_spec = fxls8962af_event, \
 	.num_event_specs = ARRAY_SIZE(fxls8962af_event), \


