Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212155;
	b=voaQ0VAv1PQld3xG5ejweVmT9GHkmqyVpDAfAnCbKLSO9m/G42XJVibuQ+QBc2to4mp/
	 Z/JJuqqTAmWyM2JewjCyGzWuUlSIXRtI3BLAFPGJCyPKMYMJV0jgbxgH0S9UEE+VS7sJ8
	 d2xKLS/tyj7CQ10a4e9tuUuXyuDgP/s0CG8VPIa3kPwQnwlbWkteLBrOpqqrXbWIXDgxd
	 RCsr+DN6UVPs8uokmPH5HWpuk63onovu+A2N0y2rQwvRlHtXM/hAhUi80xicP2rV1ZVg7
	 brzePaC8QY35ZrUIb25jxEPNbX27Y+5/xbbzxMMc4Y1KsJI7gJhp7ds641h3oiOEqmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2ruo9dpi5neJBJhWbc5KxmHa93Wtfg6kh5ER78ckOk=;
	b=tBjnpwGmX/9kcv2jSnnE7prU/bQekkByJeM0hgnBSOS3n8SdpOJF9KbMUoSgvtp1sh60
	 UyiRFPrb2G9jiSxwC2tOgcA2Cwh219KnOo1FruNjPJZjh4VIhfsUT8Zn4nPINSsCHl90/
	 OFcByxAsp0h/GMCo4T1Qr4/Ef41Vkk3yfTUavg4vRir5kpzjDMOE+DDWjlhBon5Zql7dW
	 pzdn/B+rTi+U6ECSiJ7UqsU0V4nl3w2auw+JCwS+9aGyOsai3f7qJ0cxQyzCC92TaddXp
	 VMx7y/HaJQZk1LBtYgFFyGN1EB7iD5hw0UO0PRueGL+Bskt08KnutbNDHw135EEdU7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtqfhD89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F232606A31C;
	Wed, 28 Oct 2026 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtqfhD89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5411F01825;
	Wed, 28 Oct 2026 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212155;
	bh=R2ruo9dpi5neJBJhWbc5KxmHa93Wtfg6kh5ER78ckOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtqfhD89f3ls5BguE43E9U6qldJpw/dmh0lqfoH0w5+mFn7ouhJLC8YnJB9Zto+NV
	 SE8Sieiy+5ihNgBU2mfUQI6jVkn1ea9IPYMjV1LSlsRMVTr7vcAml8sRklmIIuONUS
	 MhGn1Zdzr1MEzJufu1kC5ArAH35mdnJ6kxE+lFdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0055/1887] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Wed, 28 Oct 2026 17:35:51 +0100
Message-ID: <20261028170500.479394561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/smb2ops.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3de0f2f385b58..07e003163d66b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1005,8 +1005,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	char *name, *value;
 	size_t buf_size = dst_size;
 	size_t name_len, value_len, user_name_len;
+	u32 next_off;
 
-	while (src_size > 0) {
+	while (src_size >= sizeof(*src)) {
 		name_len = (size_t)src->ea_name_length;
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
@@ -1061,14 +1062,21 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
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



