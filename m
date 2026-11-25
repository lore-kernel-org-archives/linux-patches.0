Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620596;
	b=O9KIaA/xO63Dvujn5OOPp88IxoS/ctAMXkNTHs2+CUEbNVpbTPpEiZqoPXByaU4Hhamj
	 OJ2nErU/iq03VcJWJxoFGFqQ9izdk0Nd+ZkhAENceC4Ixd+BVtVMpqGcDtlZQFzvD2rob
	 aHVpsEsyJpyT7E/ZeQ1VvsTAyeE1y0aiM8cCwwg+lP2HtsiXM4vYuIF7KgVcW6NNbcvpc
	 d70r1v1H5fKpvs8goSYXWlsyNQrr30ANkH9pu8DEWljhX5AIqAf5kHBx+KGtXhO73H/AB
	 9O0J0zOTcgOceqsyHJKwXluOKwKcLfbLDwGKswcHvckh/XIehsChgD5Y560+4HBCKtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8js41t1tybSMGMEhYb3wOJatfGrtXdxl8HUZX1tMFVU=;
	b=CUXqtSyxzlq+m8rIvlfbyMEvoffQw0rc9UdenwFPQFg2dN6OJNL0oLlGQlpAJL3E9or6
	 EghSYxmOj7biwqK5OMah0dDhYQkN+n6rMSXwOpsjm4TXFDd0YXnPh999AHtpsx4GqV1L2
	 8KNVfknKuw0avPnLsoXwk2jHtEz7+BQ/cQPTyD7wFTaizuJ/SLIcQ6hiASnOwHgLS+2AL
	 7LwDfFbxNq2QZey5p1NgXVAIYgsFuH6c4sXwuXvtLtJxFSRrloM6iSxtV3xIycme9AGdO
	 JaUKHpLdgdVxPx96qumabyasIun6Ky6zJ47KBI5gSSsv1SQMGAyjcqe+CHmCxCsbFsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arPfybNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A839E606A31E;
	Wed, 25 Nov 2026 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arPfybNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EA61F000C6;
	Wed, 25 Nov 2026 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620596;
	bh=8js41t1tybSMGMEhYb3wOJatfGrtXdxl8HUZX1tMFVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arPfybNmnhNE2VcqX5xBGXjWD9qhr+gq2v5kwCGGU2eqVT24FJJGaYbARRhru98IP
	 kOavyRRg0fG5+u1NW/zhlPbhCJCFmC8OVB9lgB73lWV+qyCdzSToheSuU6oSowKOZ2
	 DXuisoaaq9p5ySp2zUrqfhHXBWcjwrUnPiBog0zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Matt Ranostay <matt@ranostay.sg>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0969/1005] iio: atlas-ezo: Fix humidity channel read support
Date: Wed, 25 Nov 2026 15:38:27 +0100
Message-ID: <20261125143844.365999719@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,9 +116,6 @@ static int atlas_ezo_read_raw(struct iio
 	struct atlas_ezo_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
 
-	if (chan->type != IIO_CONCENTRATION)
-		return -EINVAL;
-
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW: {
 		int ret;


