Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036564;
	b=OeHl3tOFno6Lk6KFQWKQMVj794jE9CL+m5OcT/nnRfIW3g9QeullNV7ffgt6aVm5RxRH
	 whFLq/Y1lM+vg3pD3Ym418dAnsgOOHffzTcea13QVRbia1JPSs7kMnhseK17Dn9imthqO
	 ZN+DQXiUMoDkf0aB2j2tnAUKbLhd21d54expKZCGNIiF+I+Hs72m+slJeYqqBZC9QO+XX
	 hfz1sCyEvK+S3jzZDk2y2bV8NNh2ZQ29KEdMok27D1B3p9OajSh6BmgR0wFvkGFDq0Qse
	 eBctB4OWtfJeb2OdmhzLQR3NlLqcjoIA25ipfBxAPHFMmWsuP7DGiAgGwEKvnD6fQpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/rBKJaq5jT1rZQXt0ClWgKI/iNOp6cT9TEjCyoCf3fg=;
	b=pa1M9CuRC0/aMllDsbam5r0C/gDLPGyhziclQ8slGfeCmzDj8LijQd0jDbMkmUsQOWC+
	 EmPnNQsgSdBkp6tdXEjcSRVPsMoATfCJJFbxFclPqBANtdtlflpd3r/jXEuNEbzZPEiq4
	 nbaw5Yk0nHd2gw73lEUFhA3quy4Ys0qVp/UxIIIvuMYqGIcd0NizRBwgIJp8CdnjLMZTC
	 maoGxUGhQ752T6UKQpnJ9u8LL0jVif9LsLChBCcG9GIu7Nmk5y3cuAwNMCNLZ5NwZNEfg
	 MQgZVh/hy/n/1PWcEs/mkDPRO3zZ798Rg6zU8Gd7Cr+5OlShvoRhkiahPRDskJFVOng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKQZalgi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D52D606A33B;
	Wed, 18 Nov 2026 21:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKQZalgi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4A11F000C4;
	Wed, 18 Nov 2026 21:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036564;
	bh=/rBKJaq5jT1rZQXt0ClWgKI/iNOp6cT9TEjCyoCf3fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKQZalgieJNV5Ieadpoq22J/AUwASfgDJavHKBjcnwiDLwAvLYEEVVD+PVamiI7Kz
	 NoVzrgelY91S0XHsSdn+g1LUKJQ6oCy2BrtqqQxCi9t4PtLmyZStQ2V9m6F7j9KNQt
	 rwpnRAy+xsT0ZlUsTR3VrBswKp6V5sVrv/wjrL2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1103/3318] platform/x86: hp-bioscfg: fix OOB reads in hp_get_string_from_buffer()
Date: Wed, 18 Nov 2026 15:28:45 +0100
Message-ID: <20261118150353.077804408@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 32425ca5f5b5b..786d3cb8ad23e 100644
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



