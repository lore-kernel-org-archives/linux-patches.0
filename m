Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054186;
	b=VN/FeYQ9aVeDoMQ5NWYDUXneJbUugP27ZwhEU+fcdyFTUcgyNouNNJg6gEzLZM7bIVk4
	 YGXAYdvDtePAYLZylM373ZmJWJY5QhuNJ9ZgIfwbJjlfRWgAbD3N6CgRjgTADaiWmPf9c
	 vks+WFhcbtYIUerCDEiUNvJkcL+56/M4dmRCb3hIpg7018gywtlev61GiSrgZ8c7ZQMHs
	 WQPfG976GzOJDYRZFy/cp4pSLG11h0Phckqr2z0ZYGGo58a2QfqY8wD6LLmPlkv304ERX
	 nDc8fQ4lgBevSvBrMXh49/n6HCgil/v8rH6flN/gJ7+0nl/ZK5YFL4NPudLzyFonqDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S3oMlQt0vO1V+yY0Olat33UsaN6ZIt3JjZ104xQ+gE4=;
	b=WUyB9DJVNerJNyvllpE/H5hJF9dm+fau4EsEMHYIfXDGtVksjbTaCxWLW7CtpJdaEBRP
	 QRpHW4ZVG9J8GhXPB94SXpKJbks+QklcykRGwsBIekMI5oGkilU+ixSKSSzeF43CvNPVJ
	 L53FRWmUO8DnKN7j3MhcZ/NhfBcG7zPHV5MN36xxLBD3S6VRkFjCMqiF4xMbPQuL5DpEB
	 TI9ww8DfHgDF4EJrdkdjqGUwcq2JyBXkAVxZkT0pbrGU2w5D1eZbOS2yWX3XqzeW/TqFt
	 UC+peokbCbNw4FbsmdHO9ph0Ey5SjJ1gbTx7c3iUR2xzR8Yq2Pi+YoQL0ZHM6T8JbXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOlU2NlH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6047D606A320;
	Thu, 19 Nov 2026 02:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOlU2NlH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B722F1F000C4;
	Thu, 19 Nov 2026 02:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054186;
	bh=S3oMlQt0vO1V+yY0Olat33UsaN6ZIt3JjZ104xQ+gE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOlU2NlHaPpXotlZPGQQfqn9BK5RiOWPZryh9cuYg//YA9cJvDK2qk3oOUdjoCzcG
	 V8FTFFc8GvsdGyJHxGndb0FvzW+bAMC6ZRmBAw2jfjM8axYoXJGCND6RUqTZGNkk3r
	 +jae4KUhFNa6UUqnQw0ApSJgFuHJeRKjxsT3MkEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1158/2214] gpiolib: cdev: dont set GPIOD_FLAG_IS_OUT
Date: Wed, 18 Nov 2026 15:47:14 +0100
Message-ID: <20261118150058.346771967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Adrian Ambrozewicz <aambrozewicz@nvidia.com>

[ Upstream commit 974d2712cb15014019595799b3ed68fef5fe9695 ]

When a line is requested or reconfigured through the v2 uAPI,
gpio_v2_line_config_flags_to_desc_flags() copies the requested
configuration into the descriptor flags, GPIOD_FLAG_IS_OUT included,
before gpiod_direction_input_nonotify() or
gpiod_direction_output_nonotify() asks the driver for the direction.
If the driver refuses, for instance with -EOPNOTSUPP from
.direction_input() for a line that can only be an output, the ioctl
fails but the flag keeps the refused direction. gpiod_free_commit()
does not touch GPIOD_FLAG_IS_OUT, so this outlives the failed request,
and GPIO_V2_GET_LINEINFO_IOCTL reports the line as an input while the
hardware still drives it, until a request without direction flags
makes gpiod_request_commit() read the direction back from the driver:

  GPIO_V2_GET_LINE_IOCTL, line 0, input:         -EOPNOTSUPP
  GPIO_V2_GET_LINEINFO_IOCTL, line 0:            input
  GPIO_V2_GET_LINE_IOCTL, line 0, no direction:  ok
  GPIO_V2_GET_LINEINFO_IOCTL, line 0:            output

GPIO_V2_LINE_SET_CONFIG_IOCTL updates the flags in the same order.
There the line stays requested, and since commit 92ac7de3175e
("gpiolib: don't allow setting values on input lines")
GPIO_V2_LINE_SET_VALUES_IOCTL on it then fails with -EPERM, though the
line is still an output. A line whose driver refuses to make it an
output is likewise reported as one.

gpiod_direction_input_nonotify() and gpiod_direction_output_nonotify()
set or clear GPIOD_FLAG_IS_OUT themselves once the driver has accepted
the direction, emulated open drain and open source included, and
nothing between the copy and those calls reads the flag. Leave it to
them, as the v1 uAPI already does.

The other flags that the helper copies stay as they are. Active low,
drive and bias are what gpiod_direction_*() applies, drive and bias
possibly before the driver refuses the direction; edges and event
clock are the character device's own. None of them is read back from
the driver, so there is no earlier state that is more accurate to go
back to. A failed request releases the line, which clears them, and a
failed reconfiguration leaves the line, like the lines before it, with
what was applied up to the failure.

Reproduced under QEMU with a test GPIO chip whose line 0 refuses input
and line 1 refuses output: both refused requests and both refused
reconfigurations leave the line info with the refused direction, and
setting the value of the reconfigured output fails with -EPERM. With
this change the line info shows the direction of the hardware in all
four cases and setting the value works. First seen on real hardware
with v6.12.

Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Adrian Ambrozewicz <aambrozewicz@nvidia.com>
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Link: https://patch.msgid.link/20261016-gpiolib-cdev-direction-v2-1-aambrozewicz@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
[ sashal: Adapted flag handling to FLAG_* names and direct descriptor access through flagsp. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index b1e4571401c9a..8894206de3dca 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1054,11 +1054,6 @@ static void gpio_v2_line_config_flags_to_desc_flags(u64 flags,
 	assign_bit(FLAG_ACTIVE_LOW, flagsp,
 		   flags & GPIO_V2_LINE_FLAG_ACTIVE_LOW);
 
-	if (flags & GPIO_V2_LINE_FLAG_OUTPUT)
-		set_bit(FLAG_IS_OUT, flagsp);
-	else if (flags & GPIO_V2_LINE_FLAG_INPUT)
-		clear_bit(FLAG_IS_OUT, flagsp);
-
 	assign_bit(FLAG_EDGE_RISING, flagsp,
 		   flags & GPIO_V2_LINE_FLAG_EDGE_RISING);
 	assign_bit(FLAG_EDGE_FALLING, flagsp,
-- 
2.53.0



