Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062406;
	b=SteVcDhmjl1YOiVsTtmcRtcdQB2H9OjEE7FgZhGt87AftejkaZ+FVWFms+ywdVpJoZbl
	 XX0rF7GN3170SyTKMcNOJkTEeTFO17r6BRJDhBCh1ZFaxBp7fHUlbnFA5BLwqh+zIREas
	 R9FxCOW2UC1u/xPBp9w8wGA+gbg85ge/uk3X9HTdPmWoNIIjCZEQ8bBAebXWohamRhpQp
	 RvO1EDwiuhS9r8jzoNQoNzlF25GuEUP2DXpErS6AOAA6jlSEsubQ0r73F1lZgWVq9TuIm
	 F5jbS+AjulhuCNNEOvSc8O0ZhbvEncdhJ0Whl5m1ZscloT/tXI3SNdM/CDGnAkhH9Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RSTcCdJc/4UFhwlUaXXBP60y0kaE0+2PZx53OX/ly9c=;
	b=BN5QuomdMtKY6OFW/cS3uYnTq4mcbTG5wSwLqVwONvyS/SRRlLBmm84DXBGrKSOOXjBN
	 XtVHQGw0+bENRurfmhH0iT4+6Yd2YN9dXMhg5oUXzE5HPAR3bx5JoLQTfWEJZrwJsYRte
	 mlnr7r/yv1LUrswCtOOrQ2j0K8OfmuLeH7UIQDwU8qy7JE4fQgXdSuMzRTIVrNHXtT+Qy
	 3jq4YJjMOYtU2oen+jhOHNUXoTWxtUVQTFqm4wxF6ht3kieFqAjT+sD90MS01PxVkg2ea
	 A6KgA3D7DZ/gpLn3EU6tcYFtWeDPhRaMei4F+Hid+lmcAkXkbGbePD+V+vv+yowMpBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpI2tND1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7A1606EE92;
	Sat,  7 Nov 2026 14:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpI2tND1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185771F0089F;
	Sat,  7 Nov 2026 14:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062406;
	bh=RSTcCdJc/4UFhwlUaXXBP60y0kaE0+2PZx53OX/ly9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpI2tND12IZUtffS2Yj4N5yB0zzrRBUth+1+gh5yFQv5YE5QwTyF88/624N3sYfAQ
	 Eguz4Hx4Ke6DhERwKCzwFyr+z9EJtIukePRb24CcufQ1QB/T3oq6dGBOBylsIUVCeL
	 wfA47W+L1dane14TPwkPrbAaTxfuFq+1WQlzQ/hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1284/1536] platform/x86: hp-bioscfg: fix OOB reads in hp_get_string_from_buffer()
Date: Sat,  7 Nov 2026 08:55:00 -0500
Message-ID: <20261107135033.844140375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 176b38b84ae5e075850b3ebb25f906d66f95a46d ]

The escape prescan loop uses 'size' as both its bound and its
accumulator, so each escape character found extends the loop and
reads past the end of src[].

Use the original u16 count as the loop bound. Also include the 2-byte
length prefix in the bounds check, pass the u16 count instead of the
byte count to utf16s_to_utf8s(), and advance the buffer by the bytes
actually consumed instead of the escape-inflated count.

Tested on HP EliteBook 840 G2 (Fedora 44, Linux 7.2.7).

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20261007134711.473857-2-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 26 +++++++++++---------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index 1b84dad24cb68..fda99b179734b 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -54,8 +54,8 @@ int hp_get_integer_from_buffer(u8 **buffer, u32 *buffer_size, u32 *integer)
 int hp_get_string_from_buffer(u8 **buffer, u32 *buffer_size, char *dst, u32 dst_size)
 {
 	u16 *src = (u16 *)*buffer;
+	u16 orig_size;
 	u16 src_size;
-
 	u16 size;
 	int i;
 	int conv_dst_size;
@@ -63,17 +63,21 @@ int hp_get_string_from_buffer(u8 **buffer, u32 *buffer_size, char *dst, u32 dst_
 	if (*buffer_size < sizeof(u16))
 		return -EINVAL;
 
-	src_size = *(src++);
-	/* size value in u16 chars */
-	size = src_size / sizeof(u16);
+	src_size = *src;
 
-	/* Ensure there is enough space remaining to read and convert
-	 * the string
+	/*
+	 * Ensure there is enough space remaining for the length prefix
+	 * just read plus the string data it describes.
 	 */
-	if (*buffer_size < src_size)
+	if (*buffer_size < sizeof(u16) + src_size)
 		return -EINVAL;
 
-	for (i = 0; i < size; i++)
+	src++;
+	/* size value in u16 chars */
+	orig_size = src_size / sizeof(u16);
+	size = orig_size;
+
+	for (i = 0; i < orig_size; i++)
 		if (src[i] == '\\' ||
 		    src[i] == '\r' ||
 		    src[i] == '\n' ||
@@ -91,7 +95,7 @@ int hp_get_string_from_buffer(u8 **buffer, u32 *buffer_size, char *dst, u32 dst_
 	/*
 	 * convert from UTF-16 unicode to ASCII
 	 */
-	utf16s_to_utf8s(src, src_size, UTF16_HOST_ENDIAN, dst, conv_dst_size);
+	utf16s_to_utf8s(src, orig_size, UTF16_HOST_ENDIAN, dst, conv_dst_size);
 	dst[conv_dst_size] = 0;
 
 	for (i = 0; i < conv_dst_size; i++) {
@@ -117,8 +121,8 @@ int hp_get_string_from_buffer(u8 **buffer, u32 *buffer_size, char *dst, u32 dst_
 		src++;
 	}
 
-	*buffer = (u8 *)src;
-	*buffer_size -= size * sizeof(u16);
+	*buffer += sizeof(u16) + src_size;
+	*buffer_size -= sizeof(u16) + src_size;
 
 	return size;
 }
-- 
2.53.0



