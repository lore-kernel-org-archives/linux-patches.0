Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620500;
	b=JgIAMd4HiOj1cPM5xEKnD1yuufRkB4/YEwy2QPqQyNoAaSpeJ/QMMWRQCShUlivEchNZ
	 MERMXg7MLU7KqQCJPZctSnnNs7eiX6c55QMROXWV3zZLBRdfOBcY9nbJyeUZu4VoBsFU2
	 g4z0GvhZb2ps6PF/GtJb/BiBqMfK5akbKV7kcox/fqjXuHGs/EoBn5QZYJpiwj6VmDG5n
	 IB6T5JROXEpFVZ2yVpJntUWmADOU8gfOzc02uPh6upIfSByM4e1xQ3EuqXNZe2ifiwB92
	 rrs+dQsaDJrt8U8Mn4LOEAMRWPjQOC7qwYxulbcNtZtccFoOaU4xudt6+nlkB4H/pCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=slFymNWmLGL5m4FwsGEoESjbjrIV9PpvBmPcHN7TJIU=;
	b=j2Y/XvCYinuo6eZJpx99PqjhQAbsWkwTrxxsNqUFURfLKnpyvnPLgNOcly5W7anNxP2L
	 aKBhUe6Snnei7eigD59dj2BWBEwneh9ILW8F1m9e6rgYdnT9u+pPi1Ig0bnl7qnpxmuvQ
	 w1eiQbf7wHUH+Onv0Aqe8wYwXO29kGO+lpR3SfeUn6qO+1S7kt6qcJKamCQWEQH3HqKBK
	 QzGZz3QMQfGUV9VUuwA4MoPila0UbEsfIa/BREGgivVnuRtNlD59adA79J9oeziatCXf7
	 B4jHCeuZFd0zVLsc956Xz3cbi40myGaHxbIXkU2RsXu6/uk1mZRr1lnNaSFlm9T7dpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXRkjz4v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C2C606A321;
	Wed, 25 Nov 2026 15:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXRkjz4v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9035A1F000C0;
	Wed, 25 Nov 2026 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620500;
	bh=slFymNWmLGL5m4FwsGEoESjbjrIV9PpvBmPcHN7TJIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXRkjz4vQSxaHBRWb0BrParUmTIol84QY2NmY+e6YtpN52XXlJtly/01d1CDXhZwh
	 viuLXp3klNh0JHo9mItQDDB+lMcubCHZ2YDCou8qmiXexfJn9hJruB5nWpNNvULdUj
	 +S9aOv2DetCdIZgMvUIelJD6QV5tjy5bguJ/aS6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0893/1005] iio: adc: ad7923: add the AD7927 to the SPI ID table
Date: Wed, 25 Nov 2026 15:37:11 +0100
Message-ID: <20261125143842.614192443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 594157b4f3f64db5833dee679194c33a5968f92e upstream.

The binding describes the AD7927 as

  compatible = "adi,ad7927", "adi,ad7928";

The OF match takes the second string. The modalias of the SPI device is
made from the first one, "ad7927", which is not in the spi_device_id table:
spi_get_device_id() returns NULL and ad7923_probe() dereferences it for
the chip information. The module is not loaded automatically either, as the
uevent of an SPI device says "spi:ad7927".

Add the name, with the data of the AD7928.

Fixes: 1140f96cd4af ("dt-bindings: iio: adc: ad7923: adjust documentation")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7923.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -366,6 +366,7 @@ static const struct spi_device_id ad7923
 	{ .name = "ad7924", .driver_data = AD7924 },
 	{ .name = "ad7908", .driver_data = AD7908 },
 	{ .name = "ad7918", .driver_data = AD7918 },
+	{ .name = "ad7927", .driver_data = AD7928 },
 	{ .name = "ad7928", .driver_data = AD7928 },
 	{ }
 };


