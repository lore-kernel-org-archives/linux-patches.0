Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214338;
	b=VF4LWbg8APzLlcxCMNPl2h8Y5LGKwekLaXID6yi4U2RpBt964+27t8GioPuPbREDstSd
	 koE3Mp56lf2WPznpc1Y+7fSWgSc0FgM0EUTo60fA85hAMcvZiNSHsQ9yse66+jnUrn26L
	 Sjps6utEqdcbnPEBb6d/chf5n2kDLdBJlROFEA34d67SSvZ2kUsVNS5Hr/+49GmF6yaKn
	 iFRk3SedMePxG/oNOkD4fMmMFESzfzKzUfQUwV/t90XNnI6kFbihQFdNkCF5ky0MAv2nz
	 Mep7k+Jdvr2DspSmooMxc9qKDfPoyTst4HxXPqGvlEGkhjyr+M53UtWmrrrNw6OTp3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0gwhFuv36a/Bzn3Pmd+wHY3T2Tf+FOx804WA3O99DHA=;
	b=cDZ6k8aG2pCdL2f5LniPpe8CMBCq8NI9ahokqvEWxv3d/JcGFDucs9XlG3sk3qENja33
	 8Na9Lr5bqb2DyDpR1irBxme9lVpZK3EgZTFuKBDC8D+/nkIBih38R0+chit9057VpECh2
	 G3jIQAogwFPDvBzOpB3UWu9fdSiMBL1IIa1+x28paE2KtsnElc8JwKBReu8uayQc6vzXf
	 c2R7WCcT+S+8sphaqFYW+fPp1QUwN20uivj50507Ozu2fXk3Fn8CBWoSOX/uXTTgC0J9U
	 i8fm7zXVepStiExC/Sq3BYDfUu9igCeuxKbNrQ7m6FGhMMkl+xTtCpAb2qW1D93f5Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zz5J5CBH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAC8606A326;
	Wed, 28 Oct 2026 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zz5J5CBH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AA61F01825;
	Wed, 28 Oct 2026 19:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214337;
	bh=0gwhFuv36a/Bzn3Pmd+wHY3T2Tf+FOx804WA3O99DHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz5J5CBHH12ltL689BpRvQEbP7O+Oqw/m7L/jEsBcVHNZwJDRS/kxIbll78m8QooA
	 Gut5vZFEbykJBHkHvqW85CUqiPy7uBWA+ME4vyTQsiF5W7piy//5q+6rLA4fMyqJ0w
	 Gtx8vpVrf9s1Y1GVn44TxzqrjEz3btBLepiKyZ7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0824/1887] pagemap: add filemap_grab_folio()
Date: Wed, 28 Oct 2026 17:48:40 +0100
Message-ID: <20261028170518.174859546@linuxfoundation.org>
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

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit ee7a5906ff08e435ed95ec9fe7c7eed2c11015d2 ]

Patch series "Convert to filemap_get_folios_tag()", v5.

This patch series replaces find_get_pages_range_tag() with
filemap_get_folios_tag().  This also allows the removal of multiple calls
to compound_head() throughout.

It also makes a good chunk of the straightforward conversions to folios,
and takes the opportunity to introduce a function that grabs a folio from
the pagecache.

This patch (of 23):

Add function filemap_grab_folio() to grab a folio from the page cache.
This function is meant to serve as a folio replacement for
grab_cache_page, and is used to facilitate the removal of
find_get_pages_range_tag().

Link: https://lkml.kernel.org/r/20230104211448.4804-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230104211448.4804-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 736a0516a162 ("hfs: fix general protection fault in hfs_find_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pagemap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a40afc0aea3e2..a1f481f51afdb 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -610,6 +610,26 @@ static inline struct folio *filemap_lock_folio(struct address_space *mapping,
 	return __filemap_get_folio(mapping, index, FGP_LOCK, 0);
 }
 
+/**
+ * filemap_grab_folio - grab a folio from the page cache
+ * @mapping: The address space to search
+ * @index: The page index
+ *
+ * Looks up the page cache entry at @mapping & @index. If no folio is found,
+ * a new folio is created. The folio is locked, marked as accessed, and
+ * returned.
+ *
+ * Return: A found or created folio. NULL if no folio is found and failed to
+ * create a folio.
+ */
+static inline struct folio *filemap_grab_folio(struct address_space *mapping,
+					pgoff_t index)
+{
+	return __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+			mapping_gfp_mask(mapping));
+}
+
 /**
  * find_get_page - find and get a page reference
  * @mapping: the address_space to search
-- 
2.53.0



