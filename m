Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626261;
	b=xQD8o9MXg3MPQTXiMIpO1/eiM8w10PseNrXZIQ2QHX1LHNWZdFaPpVCzl/uGVOy2CF9m
	 Sbv4WVSMQnBfjK0oQ/ZJy+iXMkchEjxlMpcLf++gzoHuW+yHPmWeWg84ohN4JCqOpzvH/
	 R0GGQoNz8bdOAL1vE51FiHVSHu2mJuQmnSAg8VrIK1kH3PX4kcG7lUsQthRgy+9KIoKFK
	 oDvEE4g3PA7MVUcvIDKbVSrrjGtY+uOW2KXe0dE2gHnhAyNv+oXPrpyFQxIBZlvoPJxF6
	 +66qZaLFbK8kIbZl0LumUHqjnsdeQ8yQlh19EM2rxtNqJm/LpybGvefbyi9ZMtAU/eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W/TY/o5L6FL82HbkR1QG0Xw9yZZ2k6m7Wi2hS4YR928=;
	b=qhm3D27IlR8s8y8GwxS4/KZovno7UPYMV+oDBlQxWJs5m2wQqoxJhNl9SgvHiYzvX+eD
	 k4Fvq0Se/SwLYqgqL6v+T9B5ezaPKWF4tPuu4mztlRGV7SLRcNSqFt8KiIHJ/NWwoVzcL
	 euWUtra0peWpuzN1H64qgY/aKBk5FTFOqg9X7ndHl3IPWdbm9nyU3lTKOL2Fj1J8/a+7y
	 R1dFU/eU4cssE3d/nOR6WBIcQ6tRYlPZGVtbXpkOBIWnswNFDcJfL1SS4Mpckq0pkGdPy
	 PCfTW4lDZKVHdJSyup6EZjDF2AqjmaPAphNTZwgCJEHtM5uhL8KsS/Ap3nr8OQRNuig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WOlH1Vk/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB18606A31E;
	Wed, 25 Nov 2026 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOlH1Vk/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050421F000C6;
	Wed, 25 Nov 2026 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626260;
	bh=W/TY/o5L6FL82HbkR1QG0Xw9yZZ2k6m7Wi2hS4YR928=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOlH1Vk/orA3I4XlfRvEDB2ZKRIJANqK6YDQXnREtJWfltKIFI5TuflfIp90pk3OK
	 2k6LcC7ckcXAPUyajCVFIoZvozpu1JagCe6RWTtBRDSXGNWWnSIQxY1LKm6xSxFwls
	 +EDGZa2oxQlSrrv45HU10rUmyeXzaX+B8S2Ecxoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Matt Ranostay <matt@ranostay.sg>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 784/816] iio: atlas-ezo: Fix humidity channel read support
Date: Wed, 25 Nov 2026 15:38:52 +0100
Message-ID: <20261125143907.320776769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit 0cb3fc8987038a26ac0f581bfa26b16daf6ca6a7 upstream.

The atlas_ezo_read_raw() function rejects channels that are not of
type IIO_CONCENTRATION, preventing the relative humidity channel
from reading raw and scale values.

Remove the early channel type check to allow both concentration
and relative humidity channels to reach the mask-specific handling.

Fixes: dc3ebfcaa51f ("iio: chemical: atlas-ezo-sensor: add humidity sensor support")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Matt Ranostay <matt@ranostay.sg>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/atlas-ezo-sensor.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/iio/chemical/atlas-ezo-sensor.c
+++ b/drivers/iio/chemical/atlas-ezo-sensor.c
@@ -117,9 +117,6 @@ static int atlas_ezo_read_raw(struct iio
 	struct atlas_ezo_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
 
-	if (chan->type != IIO_CONCENTRATION)
-		return -EINVAL;
-
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW: {
 		int ret;


