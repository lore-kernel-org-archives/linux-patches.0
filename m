Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213807;
	b=vYFvnQ23GBjZcdtEm4ujgJBJZZvHoxYbmjNsoL07jQDOpyZ5QbZ6+Odnj4sq0ZAa2ykR
	 rUFY5cPgst0x2TF0ZvYBUTdYj6baEVCy9SoyyjoBN86btcUQQ3YhnQeASmotkXXd6C8rv
	 FgqEQND9K5f2U82aydssAB7Dj2sV9RFt/29Xd3RDQ3fFgymXUts5eKG0wObS45jQmCtBN
	 K0E+MuP94hGELJQrHrEhXnGHKsap5ZfhLOAwQxQIXEOrhgfm68FKHrxUh+vLNtdUnBZMD
	 m+wO2exJhXIip5/QdZMPz+EhVyUJ72UKbGAlkBBuj/yZd1k5TLqj+gK4ktZEkqLi3XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7U/+plyWe9wtKYLZrW7wcExZBZu5N3bFDKuqeOtXOGg=;
	b=P6iW4+es4ULMz7UU0EHbY9hBs/vejv7+UFGLALUBS2zRrJRz9gL8nAB1qfWAhDSnD6+g
	 eGHNXSUgLg2p+p72paq2A/jTkps44C6soSNZ2wrMpqd6Wd54tJ2WUamv5LkvpzXrXmls9
	 z9F6ZQp+ntMfHcD7wW0Ob0qUEQZarVILPLUBRImSEeKW1lzBIC8mYlhBKlXdxGFQlmIUl
	 ftNdU0nUdp4jLooVvTfyDw/M0XLMVm/3J6VdEqPi3rdpVZV+U6eEXp/20vxAAuoUvK6XA
	 krw7BqxUvsD5euUyM3And6Uro6tn4D5Wd2YHZJ2wVlSU0U8XaC+7A9JgvRmCAWOBwSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLeTX6O7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525D4606A31A;
	Wed, 28 Oct 2026 18:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLeTX6O7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B511F01825;
	Wed, 28 Oct 2026 18:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213807;
	bh=7U/+plyWe9wtKYLZrW7wcExZBZu5N3bFDKuqeOtXOGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLeTX6O7cKq57QtyWzUhvkykIQwFoDFteb/zh8r54zZRTNg4OCP0V2WNf33V+7wq8
	 xKd2ijZIAtMG9Bw2rOKj9lD4Ica90LN5YNFEc7+ImFtdNTh870ijlXvAQp6SUP2+W5
	 cK8T92tlaeuDOicwEEhqUOp5V2767JbHW+VQSDKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0637/1887] filemap: add helper mapping_max_folio_size()
Date: Wed, 28 Oct 2026 17:45:33 +0100
Message-ID: <20261028170513.906087952@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 79c137454815ba5554caa8eeb4ad5c94e96e45ce ]

Add mapping_max_folio_size() to get the maximum folio size for this
pagecache mapping.

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240521114939.2541461-1-xu.yang_2@nxp.com
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 099d90642a71 ("mm/filemap: make MAX_PAGECACHE_ORDER acceptable to xarray")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pagemap.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index dfaa099018671..a307e63cdf737 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -325,6 +325,19 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 	m->gfp_mask = mask;
 }
 
+/*
+ * There are some parts of the kernel which assume that PMD entries
+ * are exactly HPAGE_PMD_ORDER.  Those should be fixed, but until then,
+ * limit the maximum allocation order to PMD size.  I'm not aware of any
+ * assumptions about maximum order if THP are disabled, but 8 seems like
+ * a good order (that's 1MB if you're using 4kB pages)
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
+#else
+#define MAX_PAGECACHE_ORDER	8
+#endif
+
 /**
  * mapping_set_large_folios() - Indicate the file supports large folios.
  * @mapping: The file.
@@ -351,6 +364,14 @@ static inline bool mapping_large_folio_support(struct address_space *mapping)
 		test_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
 }
 
+/* Return the maximum folio size for this pagecache mapping, in bytes. */
+static inline size_t mapping_max_folio_size(struct address_space *mapping)
+{
+	if (mapping_large_folio_support(mapping))
+		return PAGE_SIZE << MAX_PAGECACHE_ORDER;
+	return PAGE_SIZE;
+}
+
 static inline int filemap_nr_thps(struct address_space *mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
-- 
2.53.0



