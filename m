Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625491;
	b=UFc2CjnP5aZAGb5Vo+oIo4m9lu4hHwiwObtDL+HGeRnafpW41L3CUBOpArw50/gXhanA
	 cBhyIMG/NwG2hTJi5AP1x6xTGumXeoPA2oJTgloTN+SEWXjpu1hSTRguZsvp2N+kPE4uq
	 LL3XRJLM2nPKr4KxcYm7L7RQeK9PW+BFVoHRgPmwT4pJ8TfFKRSbIPQoayzFIeBwe8qRn
	 5rU5y2CGAwJ8l2j5VlnyeRLcPI3xf49qMOdlVOr1Pnbu4zVH3W44UIcxUiNHbnehIMBgT
	 nN0IjDCZeuJSDtyPZ6lp/FJL25x1k6pvmxZxlWDU+XPNGbwYxptLApBb4i4MQCo4vZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AgSyI9d6/GpaAPi2IqFZRPjjIBrkFHydYTs3/PZw0HM=;
	b=vAV3dSqCi93pZFqL2W0ihOL5qaYod9WWhp3GVcwva/zrzUMKUAOu5RXmdPt5u+VvvRMP
	 xwyvIKdYalTYga3bBP1Y1WbDdWQf/ewUTONhQvsFM371mjr1acgqS01CwR40EMu6qyP+J
	 is7cAvrS3pgzuq//iw7MrrYKOSiLIOciJuUwBUdBbBLu30cDErtNaEN4kfdDsTUUjN0Ub
	 udqZtCxA65TszZW24YeXHIhc4bpm3EPfio1y13qaoPVnAJTuqXyo7qX74cMlGP/JtRmvU
	 r8VRZLp9zCoaopP9EVmUfqt6Ds5h6w1T+JJ8+06krTOkrv1WBy6kd0LIKxkIF/cT0rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=splLCZjB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E2B606A331;
	Wed, 25 Nov 2026 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=splLCZjB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92DD1F000EC;
	Wed, 25 Nov 2026 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625491;
	bh=AgSyI9d6/GpaAPi2IqFZRPjjIBrkFHydYTs3/PZw0HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=splLCZjBDd1sP9+wJ8ASF5rDPQ/8Yx47bEVft2GtHjcnYD2VYkuXlbvJ7qIVnpKAa
	 GZsWRfiUzp+qThA4Ff8fUe2bXn3DFseDoxKj3o0lR6AyofOFVx/UhITqEd88IpmRUE
	 Fki/GuSEd31Huz1vtg360IMwIxXOXDOz3WoskTzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 534/816] gpiolib: Propagate emulated drive errors when setting arrays
Date: Wed, 25 Nov 2026 15:34:42 +0100
Message-ID: <20261125143901.551279991@linuxfoundation.org>
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

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit 15665047024e30f9c2227563d03034061c99ac2c ]

gpiod_set_array_value_complex() ignores errors from the open-drain and
open-source emulation helpers. If a direction change fails,
GPIO_V2_LINE_SET_VALUES_IOCTL still reports success, including when
updating a single line.

Return the first emulation error after freeing the temporary bitmaps.
Keep updates already made to earlier lines and stop processing the
remaining lines, as for errors from gpiochip_set_multiple().

Fixes: 8ce258f62f90 ("gpiolib: make value setters have return values")
Signed-off-by:
Link: https://patch.msgid.link/20261020172601.221861-1-pocj8ur4in@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
[ sashal: adjusted context to use the older FLAG_OPEN_DRAIN/FLAG_OPEN_SOURCE names and added the cleanup_bitmap label in this tree's function layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 28a1a184e580d..c9dae5cf4db34 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3572,9 +3572,13 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 			 * open drain and open source outputs are set individually
 			 */
 			if (test_bit(FLAG_OPEN_DRAIN, &desc->flags) && !raw) {
-				gpio_set_open_drain_value_commit(desc, value);
+				ret = gpio_set_open_drain_value_commit(desc, value);
+				if (ret)
+					goto cleanup_bitmap;
 			} else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags) && !raw) {
-				gpio_set_open_source_value_commit(desc, value);
+				ret = gpio_set_open_source_value_commit(desc, value);
+				if (ret)
+					goto cleanup_bitmap;
 			} else {
 				__set_bit(hwgpio, mask);
 				__assign_bit(hwgpio, bits, value);
@@ -3592,6 +3596,7 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		if (count != 0)
 			ret = gpiochip_set_multiple(guard.gc, mask, bits);
 
+cleanup_bitmap:
 		if (mask != fastpath_mask)
 			bitmap_free(mask);
 		if (bits != fastpath_bits)
-- 
2.53.0



