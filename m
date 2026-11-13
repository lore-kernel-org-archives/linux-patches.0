Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591578;
	b=jXvFR9IbOKr51xn0f5ugabQ3igp6is6mHxwk+dTwmE7ftY8NvYwSM3TM143qoGfbV3Uq
	 GIerVY+NDKXeldZkxxVTxH8PQDjR5lJfI/0GHWoPcU7TSj+aDOfttqUx6bmz9v1w+8dRa
	 WEae9HHJawOE1OgnyoBlF17vYDbjnZrRSQBhlJO072bPemdJihxZ690PPgT23XznN73jR
	 VXI+7VNalt27m+vFARkVzny5M+iOXykocNYilVuh1THC6Yr0YH2wEwW5FzhhQhowZGvvF
	 M8mbB4G62uraakOJzQyEEk009vy+4ZAL6lCymaKbL8eS3YOEMTvIdq4a9sa8dSdh1jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VGH6B3xl1M9V+6SOfpo+g5wKwI28bOkb5I9ytjDDKhw=;
	b=s0uu1ySnogk/z5/NkBV2t6OBBQDvUOJkPFNZUVvFOgzRpqqMrYIX+q4BvENuWYnqo6K6
	 C+7p97wd3NNNA+Ix0MXLT9j/mFk/2I9BUB2unWPJuZyU74QEAJAPmtmeLfeAgiXRxwu87
	 vG7FaxEyLuin7Er7YlP82mGxYKJtIeBIEnWnsfspk5NPdJZf+2hgx72heY2Ld7NKXxrtG
	 zA7LYgsqjsivBC5dB1Y/f/0eeiUSOOSdN4WAOjWuGdC01EDqw+8ay2LqeyiSpvUtlFS43
	 Z/6y1R6p3e+gB1f+h8djIpaGczEB0TsBRZugfVdOryWXFdwh67AA3s/aD4XpAbFy0Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vj3nFk9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44A0606E234;
	Fri, 13 Nov 2026 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vj3nFk9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604351F000C9;
	Fri, 13 Nov 2026 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591578;
	bh=VGH6B3xl1M9V+6SOfpo+g5wKwI28bOkb5I9ytjDDKhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vj3nFk9HRt3F7dBn/QqL1uLSCM4OIDhAXiNPhKByWUd2DG+zEHgjAGV2IbLydwAlP
	 Lr36JVUQkdXHLHh3bYz+SnTI4wmsxFFYufkX/n3pKPHC02Pjq0PoiwECDcSlXupi6a
	 d/d7IszlYgcWg9afi8TzTNASUWuQvhMfPblGyjPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 626/670] gpiolib: cdev: dont set GPIOD_FLAG_IS_OUT
Date: Fri, 13 Nov 2026 10:53:10 -0500
Message-ID: <20261113153833.006905022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adapted the deleted block to FLAG_IS_OUT and direct flagsp access instead of GPIOD_FLAG_IS_OUT and a local flags snapshot ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index b85ba9989b143..e7416a018a548 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1367,11 +1367,6 @@ static void gpio_v2_line_config_flags_to_desc_flags(u64 flags,
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



