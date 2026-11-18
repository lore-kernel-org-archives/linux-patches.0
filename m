Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023735;
	b=C77PFkZjLQfBVXvVe2olR5f2n5QdnPLes4XS2l4JZXSaSnABTqbIBz6/qmU5FoKVbPEa
	 pHFg3jUUIW7VF3BXEs62a4vPlUte7TaqlLU7uNWGan1XyCgtNWsYtzxyHxvF1sIfWd9de
	 EhryuHV1BTmI3v5rk+0nsG8csjIBP/k/YIAfjCKFiTtOqCyp8E9A1aG32/20d4+zhFZZu
	 1T9Vo+ZuUdNlf4uKngDTuCjhdJ8s6deQ+KNSJYfR5weNRUoa+uCwpqNVWpos6x29xlUyx
	 d1DE/tecj1WooXyqRREtt2CpQWKTHFok57nxyBAW59w0hTyInEVy0jAQuSNP2bSSZIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tBOZTML/ZuZi23Uib0eS1YTX4jRPixPrNO/eA8ot5AQ=;
	b=BIKxyKoDpYFLiFV871msKWkAJeEGN/Nf407oK39wjPxl6E6mwvkEcXvJCwYwUciYqnSJ
	 qBIAAa82jvR3aVlQOjl0neamrTSaC/f4DXIxaT0uOMUXpwFTQYxlw0dFANDoexIWBatgQ
	 h5tPW1HWadNBpsFWFxYp9ANjVgAyDi0EpaTW4tt+9Vh5wb2UTFUJtGV60HmIYBUJCXiVT
	 atYyTkD+heP5kE3TfvdQDKQDdE6CRWm4rZRNBoNTDhXzNmh5DNtNb/jaFlRIz4O5cDeT5
	 c88VSgUlYaPOKg2E7s26ZJejpPqAfOBE0p+Z1dQa7tIQgTXnMnDORNf8Q4Fmdpv+5qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dx2ZgOFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF74606A31C;
	Wed, 18 Nov 2026 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dx2ZgOFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504681F000C5;
	Wed, 18 Nov 2026 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023734;
	bh=tBOZTML/ZuZi23Uib0eS1YTX4jRPixPrNO/eA8ot5AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dx2ZgOFT793H5F4hDV2OcGXSQSohZKB8Oc6RHXroZjJZvxgpFwSbRwdgIeOnNgosK
	 Botqwzdvl+FqBBnsqYW0e9x5CzoiXopm6sVzJVIhnJAeWRh7rg1fbZO7ppk+XDDNcs
	 X13+zuOmw5QZzB1jzu0s8RFavdqKaC2+AYwn1fqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0434/2151] ntfs: Do not kmap page cache pages for compression
Date: Wed, 18 Nov 2026 15:36:09 +0100
Message-ID: <20261118150137.850192618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 953b79a7a124c3dae86544cea581a5bc7655aa13 ]

These pages are accessed through vmap; they are not accessed
by calling page_address(), so they do not need to be kmapped.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: a32e893a077a ("fs/ntfs3: zero frame pages on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 2d0ab6c77d13c..8269664ce2065 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2447,9 +2447,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	 * To simplify decompress algorithm do vmap for source
 	 * and target pages.
 	 */
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	frame_size = pages_per_frame << PAGE_SHIFT;
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL);
 	if (!frame_mem) {
@@ -2706,7 +2703,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		kunmap(pg);
 		SetPageUptodate(pg);
 	}
 
@@ -2794,9 +2790,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		goto out1;
 	}
 
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	/* Map in-memory frame for read-only. */
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL_RO);
 	if (!frame_mem) {
@@ -2862,11 +2855,7 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 
 out3:
 	vunmap(frame_mem);
-
 out2:
-	for (i = 0; i < pages_per_frame; i++)
-		kunmap(pages[i]);
-
 	vunmap(frame_ondisk);
 out1:
 	for (i = 0; i < pages_per_frame; i++) {
-- 
2.53.0



