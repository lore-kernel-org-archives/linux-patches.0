Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021553;
	b=5OC6gHXw3cOFzbldR+mIMJujbDqgYFDquBH+sFTx5SWEcz7MBpOqztFiEK7dj+x6lIde
	 5WJiJfUF7pYQ3VDjqftdHjYMK3leXqsO5yqmZpnoix0nZRu68pzmJ8+fv6OQWru3tKAXB
	 2rO2sqwwN6DwLnaH9N2Ypbr9XOArmFbgF5F2zBv6GUkJfwjiD1Q+8HhMN7UY1n8/Ksbf2
	 Cd1pE8lQke3tqdZ0/MtGs7jqiju0ErueDzysrpAiktIn946TAJ/WEjPIthOF7yy95rysV
	 XzZPvv2BbVSvaNmr0i/UyDGzSjEvQ4496KyStRKMi0WggSofoUq5mk0LIgjTnaCAojQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APtmEWEhIZB9y1mddNoh67ca/T10993DRV2VcOQE7aE=;
	b=l13Sa/r3ciw7vnTljCXl45jLOHJZ4/Gvid2jmJBZzCTbUniorf5pZQkJ1bggeZ9XPSRU
	 nAeDuLbK8yashdo07B3LaKkU2Lh/+gYJKMl+WFjp32oLaV+yRlRLxgC9ysvdzQfPqAC3P
	 XS0cUsHRgj9ImJtKYKq6h5CuRdRM8s4ZIaQvoWYXv5nzsD1nWidmMJaHYEYDfQEdIwxPl
	 ZZpDX4bCuNfQwKBqTkyzph4zXtRyuj5SEi+lCne2UchbUWEKalyIMumYXdYuA1Y3I5lI0
	 agwanbGlN/3ETdy/f85d6dbHfu7TZdC1IhOunqAHsARSfdIU5xdM/pDeNmrtLBmBVWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIEgZmjq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE31606A33F;
	Wed, 18 Nov 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIEgZmjq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660B01F000C6;
	Wed, 18 Nov 2026 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021552;
	bh=APtmEWEhIZB9y1mddNoh67ca/T10993DRV2VcOQE7aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIEgZmjqs3gs2Td/76jgwS4JTds406urg7FpgQv5l/boEkT+Jauu5pL74QgfQOdRh
	 N5N51mXzIIr/xj5qOnLldOVeIiK2lmvxUUnbf3EU9ywWAiFKKNfqWH4Q6QWA/JazjS
	 jt7CMHkjgQPD5XI6/QmqwtdDFbGoqoREP47i8Gps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2347/2651] gpiolib: Propagate emulated drive errors when setting arrays
Date: Wed, 18 Nov 2026 15:59:47 +0100
Message-ID: <20261118150409.562185124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 9c05d36ccd74f..90731a547ed63 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3950,9 +3950,13 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
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



