Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210610;
	b=aSRpKD0AtgD+7LpH58doMI0sQx6bS64pY/yZhVuBJk9MCdP0eDnj+7a5SFeEOvLblykT
	 SuC3KvPQJtdWUWWFvreokVMPFEwTDPFgIA7rXipJ2ie2uSnlE09C9WMpVwulmvYN0b+Mt
	 HNsiIl0OyKRYGMQ80loyWwJ2nnv7JulPoxOwX2Zol/tAX2dbjiYEGD2I5NnSn8McZ8baz
	 TwYomFWvOjGlZdOooM0e1mOgRHZ6EVhO2RaU2g9s9oH6CcnBTZ4BHJpKlobF52AwU1vq+
	 cF/5WYy8OjkRi0Bz0uscMTBNpjgyxAe2oN9kF3j+p/pK997o28+rq+VuDY6j1P6/4EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EI1/bb1J23jxdP11QG6CD0OkWR9/CPNTLmpqEd99XvM=;
	b=1KiJzIlABoeEveqCdObYIeO08BDE9BCtvzDrz8s9g6LxSXHwM0xPTQX5ogELxUV7TwPF
	 jnJkYKyHbtAFurXkTNLiciXPTfO6jFmPNGQ+rzVx/ubYbJuZWaYkEaO6ygvgWN4SVG4lJ
	 n8YMtpio4AYf8LrgWjpCdyX9pEfaJfUx1k9kHRh+lvozXgJzeuukXw/BYkjAjO7v/SNfm
	 iCiWPjH96c1AOuHHK1mJNHjsQ2UE02Lctej4kCHWar/Lj2DxS47T5gQnuV37zBzeAnXK3
	 KT/zfhWw7vsbnu+d8pdRVm4GAD7Qp0HHWbqe/vZ5827Fwb057RAMn6i1M86AL0wmGqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+gIXZYO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D981F606A31C;
	Wed, 28 Oct 2026 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+gIXZYO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17EF1F01825;
	Wed, 28 Oct 2026 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210609;
	bh=EI1/bb1J23jxdP11QG6CD0OkWR9/CPNTLmpqEd99XvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+gIXZYOmmi2rdSXIk08cnyeEKJvCFNJmz1fq2Iu/szKv/7+4nLGtMe2b1UC2cU49
	 IH7FTQ7Acd9Cf/2aE0AG8NFFtNUgGde2YcUOLFaYWrhui5T8Y/JoAS6DM+eS/k9CDb
	 RHtMK1wKz4OcPuYQa39z6mQ44n3JXbyJaUQEsM0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/571] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Wed, 28 Oct 2026 17:53:08 +0100
Message-ID: <20261028170009.002011531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit eeb5ef6083e1cefa2ef75041b5597ff228b8d7bb ]

In move_smb2_ea_to_cifs(), the while (src_size > 0) loop condition is
insufficient. It allows iteration to continue even if the remaining
src_size is too small to contain a complete smb2_ea_info structure.
Consequently, reads of ea_name_length and ea_value_length can occur
out-of-bounds.

Fix this by ensuring src_size >= sizeof(*src) before attempting to read
any structure fields. Additionally, reject any next_entry_offset that is
smaller than sizeof(*src) or that would advance the pointer beyond the
available buffer.

Note that for calls where the server returns a malformed EA list, the
error returned to userspace changes from -ENODATA (getxattr) or
-ERANGE (listxattr) to -EIO. This correctly signals a server protocol
error rather than misleadingly indicating "attribute not present" or
"output buffer too small".

Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Replaced unavailable smb_EIO2() tracing calls with -EIO. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0b65d8ad66261..b33662f7b4148 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1115,8 +1115,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	char *name, *value;
 	size_t buf_size = dst_size;
 	size_t name_len, value_len, user_name_len;
+	u32 next_off;
 
-	while (src_size > 0) {
+	while (src_size >= sizeof(*src)) {
 		name_len = (size_t)src->ea_name_length;
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
@@ -1171,14 +1172,21 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 		if (!src->next_entry_offset)
 			break;
 
-		if (src_size < le32_to_cpu(src->next_entry_offset)) {
-			/* stop before overrun buffer */
-			rc = -ERANGE;
-			break;
+		next_off = le32_to_cpu(src->next_entry_offset);
+		if (next_off < sizeof(*src) || src_size < next_off) {
+			cifs_dbg(FYI, "EA next_entry_offset %u out of range [%zu, %zu]\n",
+				 next_off, sizeof(*src), src_size);
+			rc = -EIO;
+			goto out;
+		}
+		src_size -= next_off;
+		src = (void *)((char *)src + next_off);
+		if (src_size > 0 && src_size < sizeof(*src)) {
+			cifs_dbg(FYI, "EA next_entry_offset %u left truncated entry (%zu bytes)\n",
+				 next_off, src_size);
+			rc = -EIO;
+			goto out;
 		}
-		src_size -= le32_to_cpu(src->next_entry_offset);
-		src = (void *)((char *)src +
-			       le32_to_cpu(src->next_entry_offset));
 	}
 
 	/* didn't find the named attribute */
-- 
2.53.0



