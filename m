Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063366;
	b=mwjZ481+YUsY3W8clzBY5HXFghIWlreEEe+1R0gW3FEYG4e5rcmWR5h7SJqDB4CpwbkN
	 SDpPCx2GUSthkISyMD9E8pMaPHQss+9+DUNQr+WZ4FkI+jlSA6VuH3FaWbRJX1BeFwDvh
	 RM8ZDZqgIJYrkiQYDCvVZwEveEKCuUAarq2zrBSGQIcBX7saYS/Tf1U/x7SvJ2X34AsAQ
	 nDl3enPaBfMRfU+LtJBkwRIsq5gr2t8IKNlIy3yvZy2AfL+qi3O4pf4i9pF2UO0UkwU3d
	 INWcqTHkRE3hTAvU/Uwyus1ePygTPskPelOf9V0eCK+XtMDjuXlUI8uOCfmDndSFOiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TWfwmuqiJc5F/k3/cyZ+Gf/tKhTJaAx3+rzK8oYUUK0=;
	b=HrW/l3nEsBqnf+SXYG5G5xFl55ulBEAS+2vAWCxS9a33oyxQPk1O0NOvDG1nEt/7UPW6
	 nna9iWLn2+bKQdJdOvUerQ/hFtbe/PMAA7XSEWvLuOXME64YII0r9nyj44qiDB+Sw6OJG
	 Kf0GeyoJS2AeNavc4PGHVMOfLS4ctrMcLvh6/LzEmOB0gtGuY9/ypfxDh9voMZN1eK78F
	 uGqm+U1UFqaCkxc0cjjCVUo/hvE0qv3s5GhnYPw20brQINVAlmfS18DMOscfaknP8qq3l
	 ygk3b7kQf9r1s7YIlOjcFy2guoqgH3SLcf05/9F4eyAF+Ge0smYUR08xdkTnCOkIAeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC0mRvWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A4B606A330;
	Sat,  7 Nov 2026 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC0mRvWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61941F0089F;
	Sat,  7 Nov 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063366;
	bh=TWfwmuqiJc5F/k3/cyZ+Gf/tKhTJaAx3+rzK8oYUUK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wC0mRvWqDUwC2Bq/5dbNdbrCVlNMXV4EdfLZh6peYMuAVLEnCe8JAKRdewOAyuqXe
	 L3aD13qbPbmFOj5J+jixUKbPT960kAkuVAvJi2jNucsSThmQdtEyFEf4lwrmfGmJi5
	 RywTtw2A3jg24fSkiiy9EbR1EDEEYJNlphIaN3G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 543/869] platform/x86: hp-bioscfg: fix non-ASCII truncation in hp_get_string_from_buffer()
Date: Sat,  7 Nov 2026 08:53:45 -0500
Message-ID: <20261107134911.819450345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 288f7ac01dacc..0dac3a853dfe2 100644
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



