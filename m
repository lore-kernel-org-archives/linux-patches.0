Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619475;
	b=jyVA+Vz4tthBmrBrV5RNjY8hNxTVaZUNOHQRwBrdJioajUuSy82v0/byyDWkm0j0aeBX
	 s7G6bJHY3iTAnfR2L9UMW5eKkVabLFsgROTjDRNwd7Sh1o/j/p5LatDVtDa9Y89jR832W
	 szmn92f6NeyklrBJA3uvHAFM8R6grIkZ5QG/cPprfUBe8cqvD5OoCU20CZuVXXqktVk06
	 XiCzu8fpBADIJsdwpe1AkK3bRe+x7H2WAbVpxlieQW56bNLS5S0BVxEsuOWHnOtT8wnv2
	 cZ1tfTAm2kFi3RSV5JB7+30K9EjilzWDMJC4nPzvYU6C/WPNIwDSxj8E+1YfTycw0VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hoBr4UDhtGq3WNWN+1PiMEQ1B1VLu2h7xRSAkNSA7J0=;
	b=hQfDVox5Kl5+7G5UhvAyQGhlh9O6ihmqJuli/Wi/pDbtIBGANdR4iodAlRNF/bBmrPE2
	 fh3eDWRWCoLJnX1v3ciok56AzhDcAAUiTKp/XVcupak+nsEpi0p8DVtnv+jPflT19CbRE
	 85JHbGwG9PPaJWvWdcnM3gJ9Ss2nchTAG5vlW7EQ1Iwz3ggzVd8j2YjAPrS4lEN47dnVz
	 DjIG1IQmORsTnR8yqE3OPFw+LMIzs6K4GfaESXUaryz8gJv2NopuS9X5cRb2ZyThCAiOB
	 p2rFiXQ2q5+NXpB98EPXLASNCtOPEawXDTrfhLGksSMohkfwadwM9Ku/MxQd0GOSI3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMq5tTS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F70606A32A;
	Wed, 25 Nov 2026 15:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMq5tTS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B328E1F000D8;
	Wed, 25 Nov 2026 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619475;
	bh=hoBr4UDhtGq3WNWN+1PiMEQ1B1VLu2h7xRSAkNSA7J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMq5tTS2Ad8N0KlhtuRm3lcRTMEeEINpouK3QW0D+IeyYtxltSfK2IlaRkM4Z+GxT
	 U3p19cqsrsjvD1i/HYJfi16S4ebAGctbcTDT5MYIY2cVHATfl2Y63e7sAHoCFiIO3U
	 zEF9poqCaPpDUPkP3FqlqYOIe/pTaZG4ygtE2iGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0609/1005] mm/page_alloc: remove the zone_spans_pfn() check from get_pfnblock_bitmap_bitidx()
Date: Wed, 25 Nov 2026 15:32:27 +0100
Message-ID: <20261125143836.011418400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka (SUSE) <vbabka@kernel.org>

commit 2122887b04f3f2d76daa80055c2c273926032fa0 upstream.

Whenever the flags of a pageblock are read or written, a kernel with
CONFIG_DEBUG_VM makes sure that the pfn lies within the zone of the page.
Unlike bad_range(), that check reads zone->zone_start_pfn and
zone->spanned_pages without zone->span_seqlock.

Memory hotplug changes the two fields one after the other. If the lower
end of a zone moves, the zone seems to end before its last pages in
between. A page of that part which is freed at that moment, on another
CPU, ends in

  page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
  kernel BUG at mm/page_alloc.c:372!
   free_unref_folios+0x55e/0xed0
   folios_put_refs+0x2b5/0x530

An attempt has been made [1] to fix this with the span seqlock check.
But that can trigger all sorts of problems in restricted contexts, as
noted by sashiko [2].

Since this is just a sanity debug check and anything with BUG_ON is
frowned upon anyway, just remove it altogether.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Closes: https://lore.kernel.org/all/20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org/ [1]
Link: https://lore.kernel.org/all/sashiko-outbox-188081@kernel.org/ [2]
Fixes: 86051ca5eaf5 ("mm: fix usemap initialization")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261103-pgalloc-ai-hotfixes-v2-5-e0d2890ab74f@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -370,7 +370,6 @@ get_pfnblock_bitmap_bitidx(const struct
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
 	*bitidx = pfn_to_bitidx(page, pfn);


