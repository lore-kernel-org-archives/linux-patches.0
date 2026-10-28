Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208915;
	b=0OFXgritgsZT0XbhflKlakSaYlf40b2y8rkZIW5el4AEOcLs7fBD4fV0hX/K4uwfp3ni
	 qtaKOZsClb3ZfIudCwMIE4gPpu+JW0J+DjNTfWB2mqcnptPSwP2LZUEiGO8tKGPyJwd8E
	 v4k5msc4l+65EGETn9I6NF2JWFkMfpxJF+NIcABKqwBaY/7tKd1dWbdvjGfypMILHoRRV
	 in2+WJaoNCnlFTmop5/jveZIM1QifNqNDFaiiV6YRxvV8WU/FfK1QdHmq7F3XoHXVIs3M
	 fhAMnG87nZoFgI2dpy59qLEx03QAR/INCe4aZ3MHd+XxQr6H3GVqEPbOuOOJKypBhoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C20W7cytGwjqK3/q6BQJehK89oU0ycOoEP97Aw8+TkA=;
	b=oUpaIY5e1h2XYGAdJl1j6kpAirDNBnmIKXWTUXtECaZwEKvi7vX9bnmWWn/4PpqlDiVK
	 XUC+YyKuebUWWldlOlXooKRD4waysQHupm0m4EZh5trSZ2GAkIU3b0gh3fNx/CxHex21C
	 yl3ULXoQnwL41uMYKPgZb73oR0bo0ewLIM706A/Y3v3wIuHWbB2YTeiiXYytC4AYhbDsU
	 vxNf6CKf+JxflLMRIBLQ3nG1TnumTVQHxrGyfWx1RNopXPSu6WWIbWRBaSZ6w9ZOBbjNn
	 mry9xI+YSZ/TuWcxTaj6GjXJC3cK9GtXIn7kCEQxqANNZQmdenjQhOPDQYshK7K3Hmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UcihPEm/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA1606A31A;
	Wed, 28 Oct 2026 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcihPEm/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB61F01828;
	Wed, 28 Oct 2026 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208914;
	bh=C20W7cytGwjqK3/q6BQJehK89oU0ycOoEP97Aw8+TkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcihPEm/I5aXj0r3kJiQ4vXZj9V3zZM56E8sxJwfGLS3OH8wsBlHDI2QcLOPJW/cy
	 3zzLwMoYgW0pnDnlT2OwvyA6xaLkLVzWnuQGhyyBG0G4U72zIngSThMFcMdVM7GLns
	 rMxHUGbVc82y2d3J9wjCZU7x1cNwXYYcsttOQIVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 234/516] iio: accel: sca3000: fix frequency divider condition check
Date: Wed, 28 Oct 2026 17:56:26 +0100
Message-ID: <20261028170009.047225774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit d380bf5f94a892e546d9a94e8557ad866b043a2a upstream.

When setting the sampling frequency, the check for `base_freq / 2` is
followed by an independent `if` statement for `base_freq / 4`. If `val`
equals `base_freq / 2`, the second check fails and falls through to the
`else if (val != base_freq)` branch, returning `-EINVAL` erroneously.

Fix this by chaining the checks with `else if`.

Fixes: e0f3fc9b47e6 ("iio: accel: sca3000_core: implemented IIO_CHAN_INFO_SAMP_FREQ")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -645,7 +645,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


