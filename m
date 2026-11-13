Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591328;
	b=Dc9xhgYkY6TNTh7uiw8gqtSE7LfIsh7vhP3G0LLwEhaUVu3H/nbuFrepHt1UNGYobv62
	 C0/jQH1RClt1ZkRkM/7kwkLKWVygYkXXQFYNaVh9gXq0+v2J4X5JKSIu5XsHrHz/OwCpO
	 zLv9FFihZjzzx+0/1KcT+qjbS+7D1TJioZhRaPYXG/J/qhhbb/jpUkyKlpEjgHinYWCGk
	 p5yQdfYnQBMhasybBmiEU6tvfd1ivjHJItWIE3YegunMqbMSHVcM5maYIiQ5c08svkzv9
	 P5qbyMJCreH+r7gG039qCrTWJa5HXPo23NlKHbWgCapkXWn/kNfw6CBefeif7qsnbNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99igN95M7B6KBHxvwjxfmZD5h9FnAO4UvInzPlijUys=;
	b=Rz4CeaiH8e5yOlqnl7+23LQAnqPcEb/ErJT/6r+VRPgWVNEU3pfGK0/Wx5BDg/IlIwKu
	 nDxH+seX42sPp9/DBXedPWW5GfY8Fx/PDabDTBJFhiKWHNzNbGDsvxzrM7MNNvzfmhfx6
	 GxG50oRUhEjYffI0n1fg5nudtX6ewD4/GMTaOcGGGs/2j16OvZ97K1p2qU3if77886ufX
	 O2tXf52Llu2er+A1yI5bdOI1QDcJlrr7Mzfngq/5UXXl2L9lAsrDljxplvAiyb0ir7iPC
	 8Uwk/x28W5VKDMLYxi7puB4m4orZFiTj0Huo37g65PSprtChY+0Y4rJ+wY8aY6xgXig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OjGeSN/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0D4606B212;
	Fri, 13 Nov 2026 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjGeSN/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAE81F000C4;
	Fri, 13 Nov 2026 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591328;
	bh=99igN95M7B6KBHxvwjxfmZD5h9FnAO4UvInzPlijUys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjGeSN/NxkBCiU5q43KRq/Q+PGIxrAnWYTf7gGMiwCwdRLHTa3GPYdE9cSISd7Z/S
	 jBdjgrUQPzeh0uf/YHBQS/zWn/wLz/ITWYWUOqLw0AAwuP4MH6bJiiYVgFKc5k5voF
	 doIutV0stNSGn0b/nsWlsY1AqUJN7H9R0Y26ArbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 440/670] iio: adc: ad7192: Revert "properly check spi_get_device_match_data()"
Date: Fri, 13 Nov 2026 10:50:04 -0500
Message-ID: <20261113153826.805690693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0309e66abea141f3ec339b064b8f8b8003d2a634 ]

This reverts commit b7f99fa1b64af2f696b13cec581cb4cd7d3982b8.

The added code is currently a dead code. Moreover, the driver is not
designed to have any defaults effectively making driver data a mandatory
information to work with. Taking all together, revert unneeded change.

Discussion at #1 concluded in agreeing a new policy on this for IIO.

Link: https://lore.kernel.org/linux-iio/20260217080514.1288115-1-andriy.shevchenko@linux.intel.com/ #1
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7f7a119a370e ("iio: adc: ad7192: reject devices without match data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index 6fe32f866765b..02328b9115756 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1394,9 +1394,6 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret == -ENODEV ? avdd_mv : ret / MILLI;
 
 	st->chip_info = spi_get_device_match_data(spi);
-	if (!st->chip_info)
-		return -ENODEV;
-
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = st->chip_info->info;
-- 
2.53.0



