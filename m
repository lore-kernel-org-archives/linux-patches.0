Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214340;
	b=hIH20EH7CLOugzSPK/YxRMTO6zOrz9RlXKTtIqI/65404IzpCgRDPuaLF4LFAnLk6dQy
	 ZRcFewT6Uy5ZYr85QcgV3yujUZ2ebCdEqRBo8QCVMmaR+bUQEU4D1+SshsWs/PNe0icSs
	 bZCD72UeGuFDkZqRjb3jxYNG1jaH49s8VMjA3gK/nOKPi0EliSR6Mf+JHjfJiyDkkoIr0
	 62QhuGAmGgvNFh3I9/1+fwd38LbsgbQ0PzQ1RWf69YAtA8snHY8ZJytwIVzu1aAdmhNgE
	 D5gtHt1jVwZ2J7A8dGoQDqA9U9dupk0iHm3VYxx3/DGRdiBGCZWuVfe/1WSFgRKjtEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=soL2Noi4TY1QRegldbC/bO6QIDP82XcJPHnO1cloeH8=;
	b=iKf3O5SdPcYw/TqGzPTXhGSUv0IgsOtTxcxg+OqCxo4Bc8QAUIK/eggAfQGj2oKjGfYz
	 8jXV/j5wpwS3to4iS784RQRYaj5GfWsJYigfS8rX8PHN77ALke0SHIeW1KHuk736vmr86
	 cBFW+mnB3M4z9/n1S2MXgrzVnuinraIukco2wTh08LW0ujw6fIXiwzUzW3rQxEvg3dZbK
	 oz16JOC1lDfJ+sEkIWHBpRkF3qj2NcP9KsVT1pj9iGUI/Zj6TtPKgnYHeaVQ9GsEsKTZB
	 wXczPziwqGD3JyeLQN0KKUM2HH5WyBlskA/j8MWVTH8EoILq6pKNtgI8RK5YaID82+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+N7YMx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A899606A332;
	Wed, 28 Oct 2026 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+N7YMx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8817B1F01825;
	Wed, 28 Oct 2026 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214340;
	bh=soL2Noi4TY1QRegldbC/bO6QIDP82XcJPHnO1cloeH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+N7YMx2/k5xMtZWCuK1OSs5bVpnDTY5IirzyjhZp2HACWdKfV77ANnZHaxvTnEd4
	 JH3i7Bb4W1PiQ91EGYqTamECQJl12RGqVONcSlwACpEWsOwyyYo4H+uDtBrW3uQ9Ut
	 ggGLd15tY+4IeuTswT9YFEU5fg3+RSxcLIi8QmVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	"Theodore Tso" <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0825/1887] highmem: add memcpy_to_folio() and memcpy_from_folio()
Date: Wed, 28 Oct 2026 17:48:41 +0100
Message-ID: <20261028170518.196896112@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit b23d03ef7af567929bcd3fca7eea6f4f347387d3 ]

Patch series "More filesystem folio conversions for 6.6".

Remove the only spots in affs which actually use a struct page; there
are a few places where one is mentioned, but it's part of the interface.

The rest of this is removing the remaining calls to set_bh_page(),
and then removing the function before any new users show up.

This patch (of 7):

These are the folio equivalent of memcpy_to_page() and memcpy_from_page().

[agruenba@redhat.com: use correct chunk size in memcpy()]
  Link: https://lkml.kernel.org/r/20230802144354.1023099-1-agruenba@redhat.com
Link: https://lkml.kernel.org/r/20230713035512.4139457-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230713035512.4139457-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 736a0516a162 ("hfs: fix general protection fault in hfs_find_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/highmem.h | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 44242268f53bd..c4d6ae968dfc3 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -415,6 +415,50 @@ static inline void memzero_page(struct page *page, size_t offset, size_t len)
 	kunmap_local(addr);
 }
 
+static inline void memcpy_from_folio(char *to, struct folio *folio,
+		size_t offset, size_t len)
+{
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	do {
+		const char *from = kmap_local_folio(folio, offset);
+		size_t chunk = len;
+
+		if (folio_test_highmem(folio) &&
+		    chunk > PAGE_SIZE - offset_in_page(offset))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		memcpy(to, from, chunk);
+		kunmap_local(from);
+
+		from += chunk;
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+}
+
+static inline void memcpy_to_folio(struct folio *folio, size_t offset,
+		const char *from, size_t len)
+{
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	do {
+		char *to = kmap_local_folio(folio, offset);
+		size_t chunk = len;
+
+		if (folio_test_highmem(folio) &&
+		    chunk > PAGE_SIZE - offset_in_page(offset))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		memcpy(to, from, chunk);
+		kunmap_local(to);
+
+		from += chunk;
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+
+	flush_dcache_folio(folio);
+}
+
 /**
  * folio_zero_segments() - Zero two byte ranges in a folio.
  * @folio: The folio to write to.
-- 
2.53.0



