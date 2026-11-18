Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035149;
	b=BZclCkZlAAmi9XIqeyioILi4zP0fBk3fSEoj3297f4emYMd0GIr9nVg+TQp/ZKdkD3g2
	 bIhKqxLqyO6ZXdj9OsjIUWj45/J+RPPN+cTymoZy+FbcXrfHdPVGlrVvsbDoPvaK3oEoI
	 QqMvfvl75J2roE2I29YXHiW7Xsi0OCDbE62HTvlS3Pr4AFKNIfaS12QaEqGAWcz5chDDG
	 YeI1frNXA+Wo10uKyBmO9aoiwa1ORRKq5VqDB07q5hBdje4VXk18puUZhf9OnP5gA5ma1
	 QQK8BYTkbripD2xbWHX51MffYYdZEKoYSCPOZp+cCSJS36zhnrIrNEiaJ0f0D0xcziA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOaXSeIRxkLGBfetR8eZ7fmEOdVKSIr2N3v+gTHbtKQ=;
	b=l7bfkX363aV0YkrgBURf6wxlqsr7v4RYNAATs3Q41ICgANEJaL7syUOAkMdWsKN2G9SC
	 nqRJh9MFkJy2+Kop6UVerA5qZCa0tDt/LzXmBN2HLAOs0AlrV0mfyxv2XHyGeiXavOsXB
	 h0f4J+vmVvQYeCmP+uvJ9c8SxByLL3IYcv1KKt//mfHZF3AMAa8/KQodXx6AEubpTmY50
	 DPbCmoPgM13gRn6wuZ1K6kpCeRE4U41iOMuM3JgWg+/J88c+n4dTz8YMzARPF+BkZ1sUi
	 RPo9Y8RoPtfGRseibleHL8BWkmUYqrNbKQLh6S0eI7DP7Y8ZxVUElFDR1jjmXy8d+6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Al3S6oBX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50661606A320;
	Wed, 18 Nov 2026 20:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Al3S6oBX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6881A1F000C7;
	Wed, 18 Nov 2026 20:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035148;
	bh=VOaXSeIRxkLGBfetR8eZ7fmEOdVKSIr2N3v+gTHbtKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al3S6oBXGtiRrWjbU1zjT/RmDtSGwkOdaUwByU3r7mXTz7KyoI5pd4xgBsixJkblB
	 X9h+l43uVy8z0uD62frfkacrjDUnOEwRbFgo5X7a2+zEdb/JWE8SBMlMPqBbrgrDLS
	 xiqu2qzJ3kuDEaMkla7WNu/GWyymC+NSA9rY0uck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0622/3318] media: microchip-csi2dc: fix async notifier leak on probe error path
Date: Wed, 18 Nov 2026 15:20:44 +0100
Message-ID: <20261118150336.500028888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit c7528789244ce7329ca883170fb9315d739ae985 upstream.

csi2dc_of_parse() ends up calling csi2dc_prepare_notifier(), which
registers the V4L2 async notifier with v4l2_async_nf_register(). The
probe error label csi2dc_probe_cleanup_notifier is reached after
csi2dc_of_parse() has already succeeded (e.g. when media entity init,
csi2dc_power() or v4l2_async_register_subdev() fail), but it calls only
v4l2_async_nf_cleanup() and never v4l2_async_nf_unregister().

The notifier therefore stays chained in the global notifier_list while
the enclosing struct csi2dc_device is freed, leading to list corruption
and a use-after-free when the list is next walked.

Unregister the notifier before cleaning it up on the error path,
matching the teardown already done in csi2dc_remove().

Fixes: 2de0b3c0f678 ("media: atmel: introduce microchip csi2dc driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/microchip/microchip-csi2dc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/microchip/microchip-csi2dc.c
+++ b/drivers/media/platform/microchip/microchip-csi2dc.c
@@ -733,6 +733,7 @@ static int csi2dc_probe(struct platform_
 	return 0;
 
 csi2dc_probe_cleanup_notifier:
+	v4l2_async_nf_unregister(&csi2dc->notifier);
 	v4l2_async_nf_cleanup(&csi2dc->notifier);
 csi2dc_probe_cleanup_entity:
 	media_entity_cleanup(&csi2dc->csi2dc_sd.entity);


