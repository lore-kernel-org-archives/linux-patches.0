Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625579;
	b=bzgzJBcnL6ZS2ZPOGvYyOwTIrF7cUGNDjr7UWmwJbwLMn++CeZCCHc/s4mC60vzRK3n0
	 batyLTnzq23dP78TAH1a0jGKwMKy3/pUUU43KVtgtb8znwty7T3eBOLgBf4LitjvCn9Nk
	 ttTeKNFGITTq9517E9ugzGG+qlxjbTeYtPcJaw8TrEri4jE3EjkEwianT1YQLRnbLBiXp
	 G09W1W0i49yvMai67ex6o5oz1t4NqC9MdrzeCKtA5LNqN9W0YUAKPQn8ZBU1xckKsszJ+
	 i3a1CdlnPIUEdsmGncQpTt2S08x/f8bpPf1AfQJGBv4VEykQf0HwWmgGVKGDcInY8zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8XIIBoWLLh2GkZL1rhoMfl36I8n/4GDHfkqNzgo5i5k=;
	b=PtOqXcua66pbRImQ0jjZWcpoHkiY9fAhfcZQxJbNqM2PysPlYqYGE0m2tnSVmnBvaoQz
	 gVvBzE0I6OOwjtKEZIVzle3YjJWS+HjXjDEYj8AxkkpC8tHhDKHxjltdgBuLMeskTwWvA
	 C24HX3O7fVb632ZzKKod/WWaIDfTyGKyPzYVp3ifeR2s1I1re7jI9WIGdqL4/Cr2yTAp0
	 jX3BCoD5L3GKkPcyAa2N3dDP7si70RWUb/czmp+FSDM76cICDjm1bvUxveioxr+2TwtBT
	 Q32A9VA0/XjxQCSUh9J/BV3l5Fw4IqHlqlreEwDSenza1OGq5YzxxZrtc5+uF8OqpNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ajNu9k90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10771606A32D;
	Wed, 25 Nov 2026 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ajNu9k90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514A41F000D1;
	Wed, 25 Nov 2026 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625578;
	bh=8XIIBoWLLh2GkZL1rhoMfl36I8n/4GDHfkqNzgo5i5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajNu9k90qAQ59LcuTgxYb8WOVEoR36VKDA4I4/+Z8GC2PmqMb5wbwHGE4xP88hAzf
	 oEk8W5tiMQhug9POkD7zuKrvVXFLK7NWeUevyAP2fNW9eRpSTYO4mQK3dlw05yUCgy
	 KfjVjZEu9A35GL0QVDdvKAoKhntKjGMiTioDSFmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/816] gpiolib: clear the event clock flags when a line is released
Date: Wed, 25 Nov 2026 15:34:26 +0100
Message-ID: <20261125143901.177050857@linuxfoundation.org>
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

From: Adrian Ambrozewicz <aambrozewicz@nvidia.com>

[ Upstream commit d35f61581ee67f8d4d58c325bac813cea528b6b9 ]

gpiod_free_commit() clears the flags that a request sets on a line, but
not GPIOD_FLAG_EVENT_CLOCK_REALTIME and GPIOD_FLAG_EVENT_CLOCK_HTE,
which gpio_v2_line_config_flags_to_desc_flags() sets from the uAPI v2
line config. Once a line requested with
GPIO_V2_LINE_FLAG_EVENT_CLOCK_REALTIME or
GPIO_V2_LINE_FLAG_EVENT_CLOCK_HTE is released, GPIO_V2_GET_LINEINFO_IOCTL
and the line info changed events, the "released" one included, keep
reporting that event clock for the free line:

  GPIO_V2_GET_LINE_IOCTL, line 1, input, event clock realtime:  ok
  close()
  GPIO_V2_GET_LINEINFO_IOCTL, line 1:  input, event clock realtime

The flags are set before edge detection is set up, so a request that
fails in hte_ts_get(), for instance because no HTE provider handles the
line, leaves GPIOD_FLAG_EVENT_CLOCK_HTE behind as well. The next uAPI v2
request rewrites both flags, but requests through uAPI v1, sysfs exports
and in-kernel consumers do not, and the line info then shows the event
clock of an earlier user for them too.

Clear both flags together with the other flags of the request.

Reproduced under QEMU with a test GPIO chip: after a released request
with the realtime event clock, and on a kernel with CONFIG_HTE=y but no
HTE provider after a failed request with the HTE event clock, the line
info of the free line still reports that event clock. With this change
it reports none.

Fixes: 26d060e47e25 ("gpiolib: cdev: allow edge event timestamps to be configured as REALTIME")
Fixes: 2068339a6c35 ("gpiolib: cdev: Add hardware timestamp clock type")
Signed-off-by: Adrian Ambrozewicz <aambrozewicz@nvidia.com>
Link: https://patch.msgid.link/20261012-gpiolib-event-clock-v1-1-aambrozewicz@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
[ sashal: Replaced upstream's GPIOD_FLAG_EVENT_CLOCK_REALTIME/HTE names with the older unprefixed FLAG_EVENT_CLOCK_REALTIME/HTE names used in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 02a322f8330c2..28a1a184e580d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2436,6 +2436,8 @@ static void gpiod_free_commit(struct gpio_desc *desc)
 		clear_bit(FLAG_BIAS_DISABLE, &flags);
 		clear_bit(FLAG_EDGE_RISING, &flags);
 		clear_bit(FLAG_EDGE_FALLING, &flags);
+		clear_bit(FLAG_EVENT_CLOCK_REALTIME, &flags);
+		clear_bit(FLAG_EVENT_CLOCK_HTE, &flags);
 		clear_bit(FLAG_IS_HOGGED, &flags);
 #ifdef CONFIG_OF_DYNAMIC
 		WRITE_ONCE(desc->hog, NULL);
-- 
2.53.0



