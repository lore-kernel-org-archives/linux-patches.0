Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038615;
	b=ATQotScqa4KbvP+51nzAT8FeeCBran/Z9ogtKllxsxYlqmGwoxfFwG49D+Z8Y/jE7DJX
	 VZ/746co26TuPV2NBMLWGrNvQ0Ivk4rTNKmtn0LFMf3K9TO5DJuy1pA1NyMoNQOynfZe4
	 DDAqXXcwnk6ZTZR8LTvZWT6um+1IEU6e/HTbdRjCVBsW7CFf/Km0Wmu8O1TI6eNP6Iqm4
	 2nz7I/n1AimdsLlCzv4zjgepd4OriVz2P4AtYL1evaFmQXpn4BGE7iwCs8hL5uu1Xd3IV
	 CdNmYILMznz+EXSsCanS3Pp3qDAVcE0gDmw8dSAHm+cPaZL7x4sSZVLplQgsDVDV4ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vLSssprjLIBb8W9p6YoI7y924AYh3Gk7Mw50sEvdmec=;
	b=QaPMLGiqs/MfrGNa+412dqEYU5JtLDAhoieth2E2nasUhWOJwWa6F4p7SPA4MkMc/z6j
	 0dw/Nc1qW0DaOy5DBxp36aeGZVx2GvKK9ie3BEvHChFdknAf3xgG0p5hvW9kijAKbcVte
	 tXL5dNReXuwW4tZQmgVFbBprYnGguclAyePyop1gQ+nf1Adr1Q5rGYhAQ6qDRnDiDh9Pg
	 VXm5mmu4hDtDihu/9Eu/HDYCjj4rIf0DKt/KsDUlnigY7LgAk+fbtp+Qp6tmMN/Qa0x6m
	 5h3oOuJsWOrqDSTUmSNUuz0KvjBlw5fzAh/siFSrXhDaH6ht64EN96GqoOI6Ve0+PLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOhFDwte;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59FF606A31C;
	Wed, 18 Nov 2026 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOhFDwte
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD7A1F000C4;
	Wed, 18 Nov 2026 21:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038615;
	bh=vLSssprjLIBb8W9p6YoI7y924AYh3Gk7Mw50sEvdmec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOhFDwteHyVuTStccVo6ZTE+ARShnIo4TnDZoefkImxm90MRKWLTSQqberdJB1Yv8
	 EiYxqgk4kERQ9Dx1Eb1Y02ZGbNbVgLcuTWX3bzDKFRKKeVGWNTTFtVcaQqiyRFBWj8
	 k+IRsLW5q+b3S6FNrURejqfDNvJu8ekRY72p26AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1806/3318] gpiolib: cdev: dont set GPIOD_FLAG_IS_OUT
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118150416.035261191@linuxfoundation.org>
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
[ sashal: adapted GPIOD_FLAG_IS_OUT access to FLAG_IS_OUT through flagsp instead of &flags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index c6689f66a2d29..f8e8e418d05c2 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1417,11 +1417,6 @@ static void gpio_v2_line_config_flags_to_desc_flags(u64 flags,
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



