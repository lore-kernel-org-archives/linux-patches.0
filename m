Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062408;
	b=3VozeiLX798YuPIdhYAkJpG8u6phumVNAgcwd4RBXMZqk0wPNULJISi5+H/bNsetn//p
	 YGXD1Z7foDF1zujLmKLn4Z+0cAVsQ/2/tPmSqtmEl2rvCR4kS43q4yNKMT/Cb30RjDwov
	 J3Ycbqt5Y8DULTvQ7U82xHOc01gJXZMciPkDygNrIUWF43rInsBCSYFxa1o0mSwehGT8D
	 HaThNn67LVew3MRNNPm8yi5VeX1vr6bkWK0Nttg0WmGGo0lWY00kwl/rD4reWVzG9DAgl
	 isidHk9u22BiOtHugLEBgPPpVP53ff6k6jHe/hJsplPCy+A4QE6F3e1TmqN12q+yy/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TjpKFUR6wthCOByRppiw2E4Oq8RaevV5rPvmQiOjUXE=;
	b=tkx9r3z/doQg4qh7EMLbDEGLGUm9ivsBqSGwHqHg3vuI9BacPRKAVhVD6PkbWI5pJrZC
	 ItWpOLSDrFbeaBFv2nurwurUkN/S2tD5IsBjP1aEsXwuuONFIs9Fv3ixRfeo9GkCWL7TJ
	 EmmIG91dfJxEgptEjbGCpXNnfBphhpURVST9Dk5Pf9hIwkPSCHuWjQ4IG6X3EgEUaszAI
	 jaeUFv4jvA4UZTcyu+SpQXEyTG1GKpjS9p+Jli8ybP+LLuu/gMMZjePfEmAqPqAGJpIHn
	 tGdD5CVF5ARaIrmn9XymOdMIzUxRdhSc/VX4iROYwDaOJEQAd+V7TPMIOm1KN+hx7IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8aLOyrG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642E606EE89;
	Sat,  7 Nov 2026 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8aLOyrG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5441D1F008A2;
	Sat,  7 Nov 2026 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062407;
	bh=TjpKFUR6wthCOByRppiw2E4Oq8RaevV5rPvmQiOjUXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8aLOyrGbZd4rfQO8N4mF+sFP5fhRcbkG9gK5/1a6OvB5usmLYpjgnGnFea1YNl6m
	 QrR/PGbhXJlbv5DV5mf9IAX3XqQBfABb4AcV6p9KDyuFAqLqyd/hALb60LdvPsAk+G
	 wUZFhSEz0qcefFmgl1xXKkG0PcEUBLC9henng3XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1285/1536] platform/x86: hp-bioscfg: fix non-ASCII truncation in hp_get_string_from_buffer()
Date: Sat,  7 Nov 2026 08:55:01 -0500
Message-ID: <20261107135033.874293670@linuxfoundation.org>
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

[ Upstream commit 6b8d2374b32c35efa2a431b3cd2fe346f8917dcc ]

utf16s_to_utf8s() writes into dst, but the loop that follows
overwrites dst from the raw UTF-16 code units with truncating casts,
so any character above U+007F is mangled. For example, U+00E9 is
stored as 0xe9 instead of 0xc3 0xa9.

Convert into a scratch buffer first, then escape '\\', '\r', '\n' and
'\t' into dst with string_escape_mem(). Quotes are not escaped, so the
existing strreplace() still handles them.

Tested on HP EliteBook 840 G2 (Fedora 44, Linux 7.2.7).

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Cc: stable@vger.kernel.org
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-3-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 62 +++++---------------
 1 file changed, 14 insertions(+), 48 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index fda99b179734b..fe336e7440065 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/printk.h>
-#include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/wmi.h>
 #include "bioscfg.h"
 #include "../../firmware_attributes_class.h"
@@ -53,12 +53,12 @@ int hp_get_integer_from_buffer(u8 **buffer, u32 *buffer_size, u32 *integer)
 
 int hp_get_string_from_buffer(u8 **buffer, u32 *buffer_size, char *dst, u32 dst_size)
 {
+	char utf8_buf[MAX_BUFF_SIZE];
 	u16 *src = (u16 *)*buffer;
+	int escaped_len;
 	u16 orig_size;
 	u16 src_size;
-	u16 size;
-	int i;
-	int conv_dst_size;
+	int utf8_len;
 
 	if (*buffer_size < sizeof(u16))
 		return -EINVAL;
@@ -75,56 +75,22 @@ int hp_get_string_from_buffer(u8 **buffer, u32 *buffer_size, char *dst, u32 dst_
 	src++;
 	/* size value in u16 chars */
 	orig_size = src_size / sizeof(u16);
-	size = orig_size;
-
-	for (i = 0; i < orig_size; i++)
-		if (src[i] == '\\' ||
-		    src[i] == '\r' ||
-		    src[i] == '\n' ||
-		    src[i] == '\t')
-			size++;
 
-	/*
-	 * Conversion is limited to destination string max number of
-	 * bytes.
-	 */
-	conv_dst_size = size;
-	if (size >= dst_size)
-		conv_dst_size = dst_size - 1;
+	utf8_len = utf16s_to_utf8s(src, orig_size, UTF16_HOST_ENDIAN,
+				   utf8_buf, sizeof(utf8_buf));
 
-	/*
-	 * convert from UTF-16 unicode to ASCII
-	 */
-	utf16s_to_utf8s(src, orig_size, UTF16_HOST_ENDIAN, dst, conv_dst_size);
-	dst[conv_dst_size] = 0;
-
-	for (i = 0; i < conv_dst_size; i++) {
-		if (*src == '\\' ||
-		    *src == '\r' ||
-		    *src == '\n' ||
-		    *src == '\t') {
-			dst[i++] = '\\';
-			if (i == conv_dst_size)
-				break;
-		}
-
-		if (*src == '\r')
-			dst[i] = 'r';
-		else if (*src == '\n')
-			dst[i] = 'n';
-		else if (*src == '\t')
-			dst[i] = 't';
-		else if (*src == '"')
-			dst[i] = '\'';
-		else
-			dst[i] = *src;
-		src++;
-	}
+	escaped_len = string_escape_mem(utf8_buf, utf8_len, dst, dst_size - 1,
+					ESCAPE_SPACE | ESCAPE_SPECIAL,
+					"\\\r\n\t");
+	if (escaped_len > dst_size - 1)
+		escaped_len = dst_size - 1;
+	dst[escaped_len] = '\0';
+	strreplace(dst, '"', '\'');
 
 	*buffer += sizeof(u16) + src_size;
 	*buffer_size -= sizeof(u16) + src_size;
 
-	return size;
+	return escaped_len;
 }
 
 int hp_get_common_data_from_buffer(u8 **buffer_ptr, u32 *buffer_size,
-- 
2.53.0



