Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF14933F1
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7191AC433C7;
	Sun, 16 Jul 2023 20:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540456;
	bh=FQ41aqXCriix0jCvOKjju00opULUpNoItFYwY/0in6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suk0tKrKPSfY24C83BPT7hyFKdH+R2KyZP5+crB3AGbEGmnfuft1w0KDCDNYh1fx9
	 2VjtRS5b8vJ2Q91WvNDNZyCFtNyYXXGste5kLhy3D82wncUQcLdZYbb4N6rgtzO01J
	 wkLDtOS3jGyL2DYyUZx+WZkxmPQ7qhreI7zqgvU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 369/591] iio: accel: fxls8962af: fixup buffer scan element type
Date: Sun, 16 Jul 2023 21:48:28 +0200
Message-ID: <20230716194933.465028097@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
@@ -725,8 +725,7 @@ static const struct iio_event_spec fxls8
 		.sign = 's', \
 		.realbits = 12, \
 		.storagebits = 16, \
-		.shift = 4, \
-		.endianness = IIO_BE, \
+		.endianness = IIO_LE, \
 	}, \
 	.event_spec = fxls8962af_event, \
 	.num_event_specs = ARRAY_SIZE(fxls8962af_event), \


