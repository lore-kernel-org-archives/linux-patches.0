Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213192;
	b=pr9ZQ0rcIPJffHFxpl0iCfc/Okaoswkiq06UlLdVIMExpZxgXnGGwL1exVqJl9QOy7Jf
	 yqqzVIJ6TOTl0oJdzjTFB0czxhyNCJrGXYqfRc4RA6TeaOPIy39VNuCKEb9ByQNpL+m3l
	 PItcPe/RJxkc+0rt3qgLzBl4OE1bWbmAJZoTMcVJGqCz6AEj1shTIE2tX/sXUtaPIZAO1
	 Hrjv6FMgxAQJWc9SthbM2UWXS4YuyqgsmBB8KTaoVkxjx+59brdZy2yAHmlwMn6xVTR3P
	 0HyuCHRfSrkMRfFfLduQmpihZKzJdFNLhvXVVP2oxsuz13+irdsCiD7pw3tE3E6Z+xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Hu7714SRhbyt3IAKVyz/kRRbYPu1uerVJXt+zfaqeY=;
	b=uvWCxDOkwb2I6D1dWgnaGHFBI6Z4riq7JfMNEhcoJTUm7vKIKndaUasQl5YP7CVlt2ee
	 qOqNjioB0fVKvuAtvspXBKmnLMY4q/n84nO/wv5nn1PsochTJJKcPvyQWh3PrKZR9EFp7
	 y/DtyZXUzzRdGQ7EkSEud2u1TWcIWtM8gpjYwiJZOtlOlGndHuKyfaTX8/4Zy7jbVEpW+
	 56KSuiENYukT8Z3HgM6RKnEmgSQ0c8VVzITZ63+6xN4hfX5KaMjM6OCIHPX9bqgUAdWry
	 Wbs3SbkaNnURmZ0O5SKhLFUcvmlD5PNyC17KFhliL1ZyChPC1rCA8XuZZA1qWn+bI5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOyE+EwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348F606A31A;
	Wed, 28 Oct 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOyE+EwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EC41F01828;
	Wed, 28 Oct 2026 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213192;
	bh=3Hu7714SRhbyt3IAKVyz/kRRbYPu1uerVJXt+zfaqeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOyE+EwGxNyZurMNMJC9UQy1uCT3Dz9jxpTHMX/cAAlcbLDNWN1WhTtb73arTHIoa
	 ERPiEfoDj37ta8fXn0LUaBWBPbjLL8sb+Rc1qE2ROm9Ln8FNCrr9oycJZ+aF1G1R+C
	 abIieMpIbr6ZoCsdoXEMgPu7HQJh2HKPPe3ydM0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Nikita Nagornyi <nagornyi@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0418/1887] fs/ntfs3: Add more checks in mi_enum_attr (part 2)
Date: Wed, 28 Oct 2026 17:41:54 +0100
Message-ID: <20261028170508.747906112@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a8f659ce14f8f734894227ba2c5ca78c8451501e ]

Add offset check before access to attr->non_res field as mentioned in [1].

[1] https://lore.kernel.org/ntfs3/20241010110005.42792-1-llfamsec@gmail.com/

Suggested-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Nikita Nagornyi <nagornyi@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index bfb1f4c2f271b..d8d43f6a96fd0 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -206,7 +206,7 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 			return NULL;
 
 		if (off >= used || off < MFTRECORD_FIXUP_OFFSET_1 ||
-		    !IS_ALIGNED(off, 4)) {
+		    !IS_ALIGNED(off, 8)) {
 			return NULL;
 		}
 
@@ -230,8 +230,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		off += asize;
 	}
 
-	/* Can we use the first field (attr->type). */
-	/* NOTE: this code also checks attr->size availability. */
+	/*
+	 * Can we use the first fields:
+	 * attr->type,
+	 * attr->size
+	 */
 	if (off + 8 > used) {
 		static_assert(ALIGN(sizeof(enum ATTR_TYPE), 8) == 8);
 		return NULL;
@@ -253,10 +256,17 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 
 	asize = le32_to_cpu(attr->size);
 
+	if (!IS_ALIGNED(asize, 8))
+		return NULL;
+
 	/* Check overflow and boundary. */
 	if (off + asize < off || off + asize > used)
 		return NULL;
 
+	/* Can we use the field attr->non_res. */
+	if (off + 9 > used)
+		return NULL;
+
 	/* Check size of attribute. */
 	if (!attr->non_res) {
 		/* Check resident fields. */
-- 
2.53.0



