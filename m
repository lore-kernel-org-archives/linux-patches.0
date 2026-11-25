Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620655;
	b=KupAyhflqc0Bp3+FXcNczx8mSCId8jX6hYtqaQLWwQ6Q1MV1o01vb7iKeO9RS44w26HG
	 7eAA2zi1cl/pHxzq0kBp0+JiJEhPXdNOy7VF4LQ8oC8bFm/F+1/pwRY0PKKtA6FdC8bC5
	 SlPeUEUYP0RMLne2qwFkc61quOrtXRTAJxOsmqr2wpizxG/a5w0KilrQt20Qpar0Sh9X1
	 qWCsLTFhVw3BNwByhQBir9xJXZrcWKmZszSCbFul1jshl5dSCxb4RfpZrLFhduRhWbwj9
	 GYIG2yKRtVsZVuu//AHOXfkE001WrlSjyKopQ+BtJbVi0aIkOyobK0oZkMF6qk612UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ko1GN/Ro/i9t170+hken9k4UhQXB1FJ8T7gtPPxliIM=;
	b=mZETUh/0Fm6tq0H2M+MaEtGact7fc1ilRcq8NJhBp82f94WUvCtFmGsC5IrOakqpxP1/
	 rYzlVBEuLYF31Puy5vETY+WQASZ33dW19NUDPxV/yJIrvCxaOZOv6tnm2d3e9kVV60VfH
	 ia9k2PXS13tD/ni6peq5bcbcYDe1PX58JDv8TTch4alPxTXir9NszBUxe5v1e8MKywkQR
	 pe+Hu+RNF408dAlbbjqidZ67UL6ic8quQu54sHTteNd1UkRYczi3DImIUxnNmf4vjKX1k
	 WoPKg+tk0yaysF8UCE6NZHdonHI69yAz9ulzuagrgS2QeznzhauAsRBtPGA20MSvPlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=If2HUTKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DC8606A31E;
	Wed, 25 Nov 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=If2HUTKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ED41F000C0;
	Wed, 25 Nov 2026 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620655;
	bh=ko1GN/Ro/i9t170+hken9k4UhQXB1FJ8T7gtPPxliIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=If2HUTKya3rFvCS1q71zKeIiTMUAkPo06S9YRDbsAUhzmGEv42EPTeAvqmzuxqM7x
	 zk2YXwUMjpoqGaYJ17cdDnBvuVEAoDtYZ5p0231WcpvWqBJUfDsFOsx+vou08DHIhy
	 GUi9e/LsGUC8EIfZymobW1JmZCVlVXgKkFhwQBVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0991/1005] iio: proximity: sx9500: ignore event config writes that dont change state
Date: Wed, 25 Nov 2026 15:38:49 +0100
Message-ID: <20261125143844.869921509@linuxfoundation.org>
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

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit b8ed9165906597b69a46fabf39ab41690721ebe8 upstream.

sx9500_write_event_config() adjusts the channel and close/far user
counts on every write, even when the event is already in the requested
state. Writing 0 to a disabled event and then 1 leaves the counts at 0,
so the channel and its interrupts stay off while the event reads as
enabled. As channel_users[] is shared with raw reads, those can then
wait forever for a conversion. Writing 1 twice and then 0 has the
opposite effect.

Return early when the state doesn't change, as
sx_common_write_event_config() does.

Fixes: 4193c0f1d863 ("iio: driver for Semtech SX9500 proximity solution")
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9500.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/proximity/sx9500.c
+++ b/drivers/iio/proximity/sx9500.c
@@ -548,6 +548,12 @@ static int sx9500_write_event_config(str
 
 	mutex_lock(&data->mutex);
 
+	/* The user counts must only change when the state does. */
+	if (data->event_enabled[chan->channel] == state) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	if (state) {
 		ret = sx9500_inc_chan_users(data, chan->channel);
 		if (ret < 0)


