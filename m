Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620593;
	b=F3kDTSJeieHRrrFWupC7EZh+gRpReEOps4xLunlrVlSIwa5FD0tgVQx50teK6zxgTHsH
	 /mUwdjJ9yNw/qLcjcp7K56O5UteSYiFLRiDnHB/5JhQtn5XZpueu2sgYjj2KqoidcdVRy
	 v7lNLOmaIZ44BnVR5vu8555MvdV5on3zNRYn64MW3QrDVec/kiz1XxT7a1KsD2/UfIT2C
	 1930UeutKuSaJatBIPGboV8Ye8JJS9Y64rMeKUKEOlbU57qvHryIxXp3wRmtDfQppY81t
	 nOn8luyMWQhR43xkLo9IAthLlC05rpVvq/6y9LITnJDK6zqh8Eu24hsWJUWWGUR2XBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lrOC6mCI08iIrLD+7P7qakcke2Ar/h4+sgJPSFmbWMU=;
	b=1KjAzyURCaqNesxinVIA37K++fDOLzB72q/PHIT2NlzMVLsc0CkkvBXhvZHyKctb0TZu
	 nT3ARv7EuJN5LT9Wy8sMBnhX/WZLqxQfCqp6kyrc5rfRJ6hENYIRxGq3TNfAMCbZsIHF4
	 DhfjMDTD6pItmXc7Bv7hMug+Cm/O8VS9teC2tZRqlC6najfcbNPAF3N/nyGn5tVlVLKGi
	 nrZxjDdapHfVyYJen5HTu1zsVOPkQ32jPPwoj7cARCm/sFbABwMvIlBuq1Bo1TcxXrlnE
	 cd/83ao3jNr9Kg/zRQiZbCdlF1UzcPH5PdjtAr9iVomhIJ1Ua61kDW7S5PZ6nUYPqQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KViYFn9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05FA606A31E;
	Wed, 25 Nov 2026 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KViYFn9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10511F000C0;
	Wed, 25 Nov 2026 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620593;
	bh=lrOC6mCI08iIrLD+7P7qakcke2Ar/h4+sgJPSFmbWMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KViYFn9fQ2mga2jj2Dga8Sh7H0xemX/1vL2NKL4+Ufp5zW3S7oKV18InYoi/fL1y0
	 m/xPkKzJr5b1QGLR/CoNleKl+vA4ovkcwrGItBle+BY4SC+8MEL+Uok1ySwJ2Q1p3J
	 R4eJbXe3PcTbKUbY3AAH6+itaGcQxWoG0mXFTau0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Amer <and.amer@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0968/1005] iio: afe: rescale: expose offset if rescaler or source has one
Date: Wed, 25 Nov 2026 15:38:26 +0100
Message-ID: <20261125143844.342868403@linuxfoundation.org>
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
@@ -303,7 +303,8 @@ static int rescale_configure_channel(str
 	chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
 		BIT(IIO_CHAN_INFO_SCALE);
 
-	if (rescale->offset)
+	if (rescale->offset ||
+	    iio_channel_has_info(schan, IIO_CHAN_INFO_OFFSET))
 		chan->info_mask_separate |= BIT(IIO_CHAN_INFO_OFFSET);
 
 	/*


