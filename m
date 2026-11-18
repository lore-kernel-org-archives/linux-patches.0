Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027747;
	b=JJR7BWfVAfzGzPizoQG9Qprub1wvCKokIAsWBFI8jd4UkgAmgYEn1Y/qE+7y/pjmr9Fx
	 YrEFg3aPsY+SipQmWVEQUxDO8iQqf0GvKtRUv/qVk6l07CSRcGMfRKUvVqiC2lJ/Kp6W5
	 Gc1UXVGeF/X8ZlB8XPmGn7U1keY5bBtYr9L0Ur+umu2lRt3tMt3+WZi4TIIraLIZcwMXJ
	 QPAOigAIOktbCuHR7lof3tzbTvseWBeksv/59Uwygl/UnTtvVqkpDiZKqN8D5W4n+STKi
	 7SdfM+9fO2nZIbSzAbQUvMO8B52hg0+0Wp8Q13nNNvkwIhjKDEB6cYOCQZjSXFRW58A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAMP0LIGw4ysIbbBnWztSyjucfXn8YTBiyClYM6OX60=;
	b=icgoD9hyGHTmhOt7DZm6lxCy4lcAZr6eXj9Oujlv3TWnCoUqov5zELxmw5bfrESbsd+i
	 Bm+e1xPw0e3kz3UqO66z9hG65kmJ2roViCzsnrsEnR08qUHfPz2zLfKQR5CHSwA0aSjmH
	 TfgKmX+PuonxwGCiXM2RVEhdh/nZvdBvFFKxs7UKI3XVLbNWc6dKZAo8zVhcrN4daDsko
	 cBi8G9yfzksO3Cnatst0wJyLf0ZIBeeHjrErN8pDfcZGQB65SU316ptuggCDoxIDlhOLs
	 l4cED1szgRpMOubYPzCpoqLh2+r1uuoJT6JMBL8u2qKa9gE5mfjmtAhS12UdOevik+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gRmwcrU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82042606A31C;
	Wed, 18 Nov 2026 18:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gRmwcrU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88DF1F000C5;
	Wed, 18 Nov 2026 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027747;
	bh=sAMP0LIGw4ysIbbBnWztSyjucfXn8YTBiyClYM6OX60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gRmwcrUJsLmu4U0vp6pcdo3VllStqqQeL214tsCMFkNUqz0JOCQ8HVnUnwfLkIXL
	 GWshME5QLynKjuiGQObnBTIfIwzps4bL/qtTwiwOjlllw7HBc7bPcw/sTS+J/9OzWL
	 zvtlFHd7T6AdznnR9ZwFoNH8SMvj4SkTkFooXfJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1898/2151] gpiolib: Propagate emulated drive errors when setting arrays
Date: Wed, 18 Nov 2026 16:00:33 +0100
Message-ID: <20261118150230.936466035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3fb738f61bf79..fa2ab0f90dbda 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3794,9 +3794,13 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 			 * open drain and open source outputs are set individually
 			 */
 			if (test_bit(GPIOD_FLAG_OPEN_DRAIN, &desc->flags) && !raw) {
-				gpio_set_open_drain_value_commit(desc, value);
+				ret = gpio_set_open_drain_value_commit(desc, value);
+				if (ret)
+					goto cleanup_bitmap;
 			} else if (test_bit(GPIOD_FLAG_OPEN_SOURCE, &desc->flags) && !raw) {
-				gpio_set_open_source_value_commit(desc, value);
+				ret = gpio_set_open_source_value_commit(desc, value);
+				if (ret)
+					goto cleanup_bitmap;
 			} else {
 				__set_bit(hwgpio, mask);
 				__assign_bit(hwgpio, bits, value);
-- 
2.53.0



