Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5295200A7
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C17C433C9;
	Fri, 21 Jul 2023 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966270;
	bh=O1lYQPx+/r9tSAiOW6Wy1ShJrAzu+S1Eg8VEPkIQAGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf5ZF84xkFSHNOKQ68nVxAIkTe7nlHcxk3rmRhPq5qh92wc+dFzY5U7iawdbIj6dK
	 +Tm9gB6NXMTbkiH5sKYleFfJzydO2DTguQqYKvqTW+9QdD/FRQt/LGeQuQkjZ8Wo3s
	 1Tm0Fv+OsmV+0NqwGKaeGgzpegETpE3rgJ+OX1Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 256/532] iio: accel: fxls8962af: fixup buffer scan element type
Date: Fri, 21 Jul 2023 18:02:40 +0200
Message-ID: <20230721160628.229636121@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
@@ -486,8 +486,7 @@ static int fxls8962af_set_watermark(stru
 		.sign = 's', \
 		.realbits = 12, \
 		.storagebits = 16, \
-		.shift = 4, \
-		.endianness = IIO_BE, \
+		.endianness = IIO_LE, \
 	}, \
 }
 


