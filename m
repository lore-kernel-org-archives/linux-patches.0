Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031475;
	b=Eq5xpLPeCffcaRTneAx6+hThUE1Wr6XD2L4Mi3W9utOBHDw3RuQZ2f1ehZPrh39LDgM4
	 KrBmEOwhSDco6Kq+6p/Qxq2C//CgnrC8wI7yN0fQ3YKlZZbxN04qJ6tvNOwOwTfSnymMZ
	 /8NY3ToCp4NoVoejoj+S68q2L19m88vy6KN20pNpcxOrVlup7mdHQ8LsaGi/k7ysbhG1W
	 f+5HlvPgUlekzHhe6dmEArfRRXnQNvPtkLoV0gq4okjcDYsQPQrGLhyq2BOCcTk4fzWPr
	 Svq+IVFzRLCB+emBXa30JowkFkYJQYWwHhwiJoYCpg0m7+wYQ8mii6b+b6UZxEq21xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1jtJUe6f1hsbZSv26I4XfZ9pmCvad1PRNhDWPdmODM=;
	b=fu6xBkJUB17DdGk1mEaw6Z++5X/A9Fbpj1Fea3o/vtNo/qgiLLPLBfmsvghbAUbSZzok
	 QtP0Cd0JbWz55CMr0BkS+OxaiSAWgoF/TBPRcwgFKdFKLBsaw8LIQaVwKB1zEUVrVjdQw
	 gpHpQhQVylwxX4xbwK5zRCEbXUPE+lYZzN0jqOCqK/6+bIf5O5cYQzSbxhECfzUN2Sj7t
	 whPHinJxnN2wVpCbxmU7Qxu7Y480FKIYWt66cqlnE08r8Vwzl7CCiQv1ty914EJxNTigq
	 zghB6nYjKm1EQ24wCjjeCXMHP66kTvQxa58PbrK1yYkMR9hIyTMaFaHCo0r2j1fo1Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r35K2I1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D36606A31C;
	Wed, 18 Nov 2026 19:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r35K2I1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90BC1F000C4;
	Wed, 18 Nov 2026 19:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031475;
	bh=u1jtJUe6f1hsbZSv26I4XfZ9pmCvad1PRNhDWPdmODM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r35K2I1yNfHg2pWXSLulNi8RP6xxzVpwhacSxCvwOEBB1qd9urPlv3ZNJYx6oaQw3
	 DdVDP5448sO029oiC0bwNzlg+0vH89LT9YnaxHgT3fD1ETKk+IX5TT+IC6evE/T/fy
	 BLQJB3+UsznSAZ2+zg3vTbr//SgnNemkhx5I061w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1073/1756] btrfs: accessors: use type sizeof constants directly
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150052.955995853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 378c95c477b4bdc3a8283ebdf3754e308bf65891 ]

Now unit_size is used only once, so use it directly in 'part'
calculation. Don't cache sizeof(type) in a variable. While this is a
compile-time constant, forcing the type 'int' generates worse code as it
leads to additional conversion from 32 to 64 bit type on x86_64.

The sizeof() is used only a few times and it does not make the code that
harder to read, so use it directly and let the compiler utilize the
immediate constants in the context it needs. The .ko code size slightly
increases (+50) but further patches will reduce that again.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 08f750d9f893 ("btrfs: fix off-by-one end offset check in report_setget_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index b54c8abe467a0..2e90b9b14e73f 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -52,19 +52,17 @@ u##bits btrfs_get_##bits(const struct extent_buffer *eb,		\
 	const unsigned long idx = get_eb_folio_index(eb, member_offset);\
 	const unsigned long oil = get_eb_offset_in_folio(eb,		\
 							 member_offset);\
-	const int unit_size = eb->folio_size;				\
 	char *kaddr = folio_address(eb->folios[idx]);			\
-	const int size = sizeof(u##bits);				\
-	const int part = unit_size - oil;				\
+	const int part = eb->folio_size - oil;				\
 	u8 lebytes[sizeof(u##bits)];					\
 									\
-	ASSERT(check_setget_bounds(eb, ptr, off, size));		\
+	ASSERT(check_setget_bounds(eb, ptr, off, sizeof(u##bits)));	\
 	if (INLINE_EXTENT_BUFFER_PAGES == 1 || likely(sizeof(u##bits) <= part))	\
 		return get_unaligned_le##bits(kaddr + oil);		\
 									\
 	memcpy(lebytes, kaddr + oil, part);				\
 	kaddr = folio_address(eb->folios[idx + 1]);			\
-	memcpy(lebytes + part, kaddr, size - part);			\
+	memcpy(lebytes + part, kaddr, sizeof(u##bits) - part);		\
 	return get_unaligned_le##bits(lebytes);				\
 }									\
 void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
@@ -74,13 +72,11 @@ void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
 	const unsigned long idx = get_eb_folio_index(eb, member_offset);\
 	const unsigned long oil = get_eb_offset_in_folio(eb,		\
 							 member_offset);\
-	const int unit_size = eb->folio_size;				\
 	char *kaddr = folio_address(eb->folios[idx]);			\
-	const int size = sizeof(u##bits);				\
-	const int part = unit_size - oil;				\
+	const int part = eb->folio_size - oil;				\
 	u8 lebytes[sizeof(u##bits)];					\
 									\
-	ASSERT(check_setget_bounds(eb, ptr, off, size));		\
+	ASSERT(check_setget_bounds(eb, ptr, off, sizeof(u##bits)));	\
 	if (INLINE_EXTENT_BUFFER_PAGES == 1 ||				\
 	    likely(sizeof(u##bits) <= part)) {				\
 		put_unaligned_le##bits(val, kaddr + oil);		\
@@ -90,7 +86,7 @@ void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
 	put_unaligned_le##bits(val, lebytes);				\
 	memcpy(kaddr + oil, lebytes, part);				\
 	kaddr = folio_address(eb->folios[idx + 1]);			\
-	memcpy(kaddr, lebytes + part, size - part);			\
+	memcpy(kaddr, lebytes + part, sizeof(u##bits) - part);		\
 }
 
 DEFINE_BTRFS_SETGET_BITS(8)
-- 
2.53.0



