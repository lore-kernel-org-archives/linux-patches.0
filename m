Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208209;
	b=24OWB51ZXCIJM25PHLUWLXLe5GBES9QDfZR6qRJK8fSF7sNxdiy6kxnc8uTvYRpbOfk1
	 cyPZbRaw7dshPjS5D0/I6xuzV9DTOQOArJOJ0VpVcX+EhKwc7z8PUXCWyRmJYLM8SMPMn
	 gezCd7C70U8DKRaLrc2y54wvYB+vyAHSejyTm2IdnE3SN1y6dTjnfdqjJp0Lmzwo1d7S7
	 x9zqzp4SYawi5IWtQrTqgG9hrmTo5dfFMEf5TWVVmYmNyD/WJ6qCqg3f9AKSiccq3JM2W
	 j2lj9aKcYXwFag57eTQv6UQ4BOIic/3SkPvn+emTZmUBjjiD5y7i1xZEd9FNfgYNeyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vh0/taQnOepJSi7BBvHBgT9Lso+1dY6fFEUhbXKmDpY=;
	b=aPREKgBhRgvK+9X0O9W9y7Qbx20GR/akBi9hO/ohlSTVZAURBWIGGzTI9eZue9GbBxkO
	 Byd+UALugvdeVsl5d7eA/0SDKK7MJ9uBVHkw7xYMxq9e0xkG5NhdUTtsjR0vFEcThx8hl
	 bFnWnZQlGemQMB1D1YZc+VI2vC7bglSl2CwsMOhjgaDKk0ChFiezmDpXcytROo3TtRt2/
	 YGN0hj/PMKTsHHwAtNfmDBtnqYsL+N1Y8PfKim7yc5kq01l6YCzbe7Inic6dm2XZlHZGJ
	 fGhHIt1/XwuLUPDFl0nBUwRMF7hsFL+maWfX59iQSPp/t/eTqf+hnsSXoHJwf9tyGgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQTMkxTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C0606A31C;
	Wed, 28 Oct 2026 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQTMkxTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5F71F01825;
	Wed, 28 Oct 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208209;
	bh=vh0/taQnOepJSi7BBvHBgT9Lso+1dY6fFEUhbXKmDpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQTMkxTRzIhZfXT8AoFMtUf3UC7TUgOreZsP74mCA3YAyeV2pBehNp2i3v9ozehO7
	 bxxdfknhiNipAXEq/wUR7MPcMumddOasGNlEx00neTOXjWNZF6Z1ojklfaDaHH7v5g
	 IwphcacQjiLYVjR518SjLInlbMDCemVHPAV3APpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/516] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Wed, 28 Oct 2026 17:53:10 +0100
Message-ID: <20261028170004.431319718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1113d0904b630..65a85f7388eef 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1012,8 +1012,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	char *name, *value;
 	size_t buf_size = dst_size;
 	size_t name_len, value_len, user_name_len;
+	u32 next_off;
 
-	while (src_size > 0) {
+	while (src_size >= sizeof(*src)) {
 		name_len = (size_t)src->ea_name_length;
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
@@ -1068,14 +1069,21 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
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



