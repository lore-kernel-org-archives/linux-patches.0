Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620137;
	b=Rd1jH/O24j+LqYbNqVgf68hxyfr0U834SWcue0uqL6I6KV0MgFESUTB034k6/MzrzjpI
	 ZhBI3Iwj4Oo3yWvaj0gYL5HEXhNaT9S+tcCZyTUP1Awr0TpQyuXLvftbtSBFanW5G93f+
	 c3xu6QKoCGr+XRgzhgy/yC9W3cxc0iVSBaYYw8+YLwQ9mVQ+lwn/LxR9Q5v047iyNpTn/
	 tDDBUma6pQn0DRCjEXFqZOZDlYHGKyKTS/SKnNjuRyWNvi9xREY19aVOB13236tacviqR
	 J9vYS9705zdO2HQlOX9R5bsOxqn/GZwV2PcummorPxMD/yuPdr+tldGdD2zkLH7PFQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VCvryZyuXbDvDD3wBK+dK4JMp3Hs3FQ47vJpYDUlwAc=;
	b=UWdQmOfrgKfOSY8TX9n5boljnxTEttF44zIBHVHR6pJOYu+2ZuzHqUfe2wMrUFJ239lq
	 kEH9IqYJWKfOlln4Bhd29uYZ2AQqiWI0Qrz/Z1mxBmuSUWEdAmy3iT5IvjMPiscIoX2u/
	 UH2+TKQlpjXIHp+m+GS7j3DXPFWWqh1cB8wl7i4vq6LDbkdXT8A1G7MIwJpI6AWYiO/Zw
	 vEfCjNfPaTOhLngaL6ctGIkoBatbgs37q8ijypXl7kksWRxOnqKNKDPy80UPsZqmSNSj1
	 ap2duiLgYoH97BmiiXTf4O3ohOUxhp2wjsRIr5CzfsGuU/3Yuz80igoH/1FRwWnSetg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndtm24Ce;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33AC606A32A;
	Wed, 25 Nov 2026 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndtm24Ce
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626A11F000C4;
	Wed, 25 Nov 2026 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620136;
	bh=VCvryZyuXbDvDD3wBK+dK4JMp3Hs3FQ47vJpYDUlwAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndtm24Cea+xjS8t3Zx9c1WJA7nYk7P2dmcsCfQFOYDaz5q85/BDTmxN6HBf+JjEd+
	 QYBs+T93UkSSN2vGOiS3GnDlkTFudimIuKRx4C9nQvfSsFAyhC4PU2xinsLCPiQylu
	 Svmt+V7O2LfdTuKR/lpe8DS5euuAjDb2HPJI9ph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0820/1005] gpiolib: fix stack out-of-bounds access in gpiochip_add_hog()
Date: Wed, 25 Nov 2026 15:35:58 +0100
Message-ID: <20261125143840.935491044@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit f8a4fdf57cedb9cb3f47d94269ff27fea8e819e8 upstream.

In gpiochip_add_hog(), parsing a device tree with an excessively large
"#gpio-cells" property causes a stack out-of-bounds write when populating
the GPIO specification.

The value read from #gpio-cells is used to copy the values into right
places in struct fwnode_reference_args but that struct's args field is
an array of size NR_FWNODE_REFERENCE_ARGS so a value larger than it will
make the loop write past the end of that array.

If #gpio-cells is 0, we can trigger a divide-by-zero later when
calculating the actual number of hogs.

If #gpio-cells is 1, we can also perform an out-of-bounds read of
the "gpios" array.

Reject #gpio-cells larger than NR_FWNODE_REFERENCE_ARGS, lower than 1
and make sure #gpio-cells is larger than 1 before checking the
active-low flag.

Cc: stable@vger.kernel.org
Fixes: 802c51a83e9a ("gpiolib: fix hogs with multiple lines")
Closes: https://sashiko.dev/#/bug/linux-fdec1c0e-c6e3-4eb6-8746-d68a3f951374
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261110-gpiolib-hog-stack-corruption-v2-1-c5b28cb8dc8e@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -986,6 +986,8 @@ int gpiochip_add_hog(struct gpio_chip *g
 	ret = fwnode_property_read_u32(gc_node, "#gpio-cells", &cells);
 	if (ret && is_of_node(fwnode))
 		return ret;
+	if (cells < 1 || cells > NR_FWNODE_REFERENCE_ARGS)
+		return -EINVAL;
 	if (argc % cells)
 		return -EINVAL;
 
@@ -1041,9 +1043,10 @@ int gpiochip_add_hog(struct gpio_chip *g
 		} else {
 			/*
 			 * GPIO_ACTIVE_LOW is currently the only lookup flag
-			 * supported for non-OF firmware nodes.
+			 * supported for non-OF firmware nodes and it must live
+			 * in the second cell.
 			 */
-			if (gpios[i * cells + 1])
+			if (cells > 1 && gpios[i * cells + 1])
 				lflags |= GPIO_ACTIVE_LOW;
 		}
 


