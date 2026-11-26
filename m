Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705737;
	b=XNo1AfnKtlh3AN7Y56Kl79cM4hQVjTw2m4cjJqfMiTNZJ25fUXVvhhNYiIl7CHaLvIYv
	 SLlVcUGNkdi8Tc6NwhDS0RXKD8QNe4QtUVzKvFtLnpemfebRS2iXN+hdR9VTlys8kZC0N
	 T3tnOeRMAfjbBPWh3tYuBT/YnvgVCkoY7L/qP/Dzx4FESPtvIaTSYz1N7Ldyvyl8r48YM
	 kmy8ZNEY9h/J50MQS8SX5+wF4NPfbmINMKhlmwM8LF3gxAuMAPvVGFgEHeBSFwkna06t0
	 pUiej/426HvxMod69dM0Coj96E0JIV1NZn3kPmIRr2p9a4Shn4XcLATaw4MndqKSOHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6T0L7ZUilb/hU0+XuYdRKMIANs3pi+CwbLbPOgNyMWY=;
	b=d4cHbUfjfyzfBoTcgj+7/TcvjxUUGToRBH6M3O+KL9eSCPmoDsJNvfAl/uC6WMLbw6b6
	 RNGGWyy3sZGFIjlcuB83b/YNnIYRZpUt0Ivqw3wuKnCNSm4Wl8Bx971aT/xd2kEnD1rsn
	 maLZeq8VOrRIpLWa+BScI98fBiW4y+p5h155DFz4YnEAeY18LY6RdGlBSHZqTX/Jdithg
	 /5AotfgdHUj+DqKMpkBjHIaqI4SkXohVetb4hdGiJxgr6xfCvThNX5geavDC4BocAYGVW
	 Pxkpz5H2Ce5zD/wPbfu4vmyoVq8kXyTXqro/FFgFxB8j8AKZEoaqWuvm6KL6lCM4ppg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYo6IKCs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3B606A331;
	Thu, 26 Nov 2026 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYo6IKCs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD60B1F000D2;
	Thu, 26 Nov 2026 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705737;
	bh=6T0L7ZUilb/hU0+XuYdRKMIANs3pi+CwbLbPOgNyMWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYo6IKCsahv+a/LwL0TdNA1LdehtrAuE18eYFaUHF3WX28kLfSJoyUSgnG0l+VbB0
	 OrAS87AE/UuSxTBzHw7BNPkTyQIxSY43KJF/61fXN/VbkcRQI/T6LaaBjChuz0Zgk3
	 /OTz1h2r7bI6GKgXGgTwEMoCbCWnP0pBbmfEKNL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Amer <and.amer@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 297/319] iio: afe: rescale: expose offset if rescaler or source has one
Date: Thu, 26 Nov 2026 15:41:05 +0100
Message-ID: <20261126144013.461989310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Amer <and.amer@gmail.com>

commit c293f0db308fe76a0a9b0f6674cd2dea149b03aa upstream.

A rescale channel advertises IIO_CHAN_INFO_OFFSET only when its own
offset is non-zero. A child rescale therefore hides a source offset,
and consumers apply raw * scale and drop it, even though
rescale_read_raw() folds the source offset in.

Expose the attribute when either the rescaler or the source channel
provides an offset.

Fixes: a29c3283653b ("iio: afe: rescale: add offset support")
Signed-off-by: Andrea Amer <and.amer@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/afe/iio-rescale.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -242,7 +242,8 @@ static int rescale_configure_channel(str
 	chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
 		BIT(IIO_CHAN_INFO_SCALE);
 
-	if (rescale->offset)
+	if (rescale->offset ||
+	    iio_channel_has_info(schan, IIO_CHAN_INFO_OFFSET))
 		chan->info_mask_separate |= BIT(IIO_CHAN_INFO_OFFSET);
 
 	/*


