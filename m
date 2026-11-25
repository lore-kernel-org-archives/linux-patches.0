Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623717;
	b=mSCC4WzJ9f7vA9fPILVptK3huTTdpFjAfjuWWU4/XQU2PcjPNTd2nVskvMDIZTlYaIHa
	 K2o725BJG9agtA0J6ntZWrGObAQXwk6D7xwuIgmCSDr2v0AAqzU6X/lsOFj4GEB6Uqb+a
	 dzooR9Np2N6hYDc4DhpawmpHUH0hYmgiVZCjNNHguvhhcnr2qL+t//QwgnNvAxbh3vMyz
	 YCNKMrkYJVrs5CPuE5onAoBRX8KVE0FUnM4HRdnBXiGjZlNlSY8PDziRR9JA8qfiohfh2
	 y1DoZYl7czluaeHO2QAIo6HjBDSaXjWlUYPVe8YZEQQGe7lrg9isJiV3K7rJ081GOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=naOL54KgRwAC+0gSyH13uxJu/Zk8a3WXI8iPHLq/TUA=;
	b=FErs7JZKOfyFxiivQNlt3sP9pxjr6uaifuFtxzrrtmjmtz8HcbSP/L/73ZTyL4B94oma
	 nTL37WSNWO5KziqOuIfTBUl1Em+cu/+j3rBb7DHT0OvwnRpH5lBox8ufnCnuSLTKENbnF
	 rRoE+hhEo2n+6ruV4h2CrzccSMJ8JJd+5pX04zR6A48nb1GXHhQ2JAZa/+jOkyIZTg2LY
	 SQXI0VoqyL4pTZT46PWD4kl+e96npfXllzm3AXWLH5CdU1w/czqkJGuhmmQQE0X3oRTZ1
	 ceYCFG/D6Vi3upZEdBc13ZkCP1tL+UEl9vZJNfRB+SZvQvPEBCrdm+WqmBV9qadon6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=je8apJIF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0DB606A326;
	Wed, 25 Nov 2026 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=je8apJIF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7320B1F000D0;
	Wed, 25 Nov 2026 16:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623717;
	bh=naOL54KgRwAC+0gSyH13uxJu/Zk8a3WXI8iPHLq/TUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=je8apJIFMahxAp1iSR0pR65VMrnD0bSlf65W3l8ytN5Ixe+xebKXSs+I7GHHXxTbd
	 3TGrvXi5QwH4eTkgn29lTngrIVRFqO2LrnYHp0H59OrOIelXurlyYwtJ32UoApnwSt
	 Z6Pkk4eADsrctsZ7TE+r9M4x1LdMndd6eE7NQ4Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Matt Ranostay <matt@ranostay.sg>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 948/990] iio: atlas-ezo: Fix humidity channel read support
Date: Wed, 25 Nov 2026 15:38:35 +0100
Message-ID: <20261125143844.197321756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


