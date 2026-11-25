Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619465;
	b=nqmb1vO2Yl/KLpn68v2lqb/Wjm09l3UaZNkM+wJiHpiIh10WyZOLPWmQjPuIOGr2/8Ac
	 Ui8Yg6wUHvmLXphpduhyn9wWqfYj6MJa3KTz1jbuskuxjrP+ulatkIx4DD1fnJANwT3+G
	 TQg6pWtu+bKyad+ZLml0pgyOSwvteKzTcDT04B6X1NJxCbMuS9R8az5Q2+2uTuofJCWJO
	 26LWB2XpOjFf8DBQhTdNMAaX2hRlZTKsijp1wVJE37NPJnpJlSk0v0Mu1EW5giYeWoT5P
	 vLJi6BV5lxubkrrS4n8sIocvzQ9w4Z8e2tZJAnw6Eb55dGsewTjhSDtKEygjWxzpoqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wau0WtpN0WYBUSc8CT1vfozR27/pSEakNHAjFqyBFtM=;
	b=ILRX/ZSpeHR3L/OFIXxKl8g7RfNkZjTeVVxqY08TiXuqrpTMUEploFBAMufifjjeAg/c
	 m4/gVyAnmOHVsYPVcc3EfvTgeBI505L9JMdzTGtSn3jtzxgirCzGfWz10ht2nPyMFahkY
	 8KpL9nx4bNT3EkNraTpP2tFukMZ9ySYLCbw2imO2rCTKY4jGR4hQOoA7ORwf422eROlFB
	 +f6HnLY10cEFH9M+d4NxloXPt0Gh2d4GT0BUibXLJSfjmGibOzYK7qtEyqfEb7WJw4dst
	 K+hU1NMjQjejmDAm9Vo9L8PRnVpVjf/ibeooFl8ANEPxj73rde3Ec8RRgLGEScrMRug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz55sIPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5347606A32D;
	Wed, 25 Nov 2026 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cz55sIPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BD11F00A03;
	Wed, 25 Nov 2026 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619465;
	bh=Wau0WtpN0WYBUSc8CT1vfozR27/pSEakNHAjFqyBFtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cz55sIPA9BU2/CWhiP4T2xLG7t5VBnheFo0ZSR7DnCPAwk7dZnfZMS5CL4SMGG9Hh
	 KLElORnonA3m7fZCCG8SbaGNefxkfnybnkZB5ll0qDsobc8I6pbWNE3C3+5lYCZcWu
	 cY9tJxA/Hn9Y8dnh4yOyXD9+c8dZXwvjlVT7zGyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 7.3 0606/1005] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Wed, 25 Nov 2026 15:32:24 +0100
Message-ID: <20261125143835.941235978@linuxfoundation.org>
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

From: Gregory Price (Meta) <gourry@gourry.net>

commit e5db040c3d09c5d85dda70f736d4d1a6714b741e upstream.

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Cc: stable@vger.kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-5-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4427,7 +4427,7 @@ static DEFINE_SEQLOCK(zonelist_update_se
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4435,7 +4435,7 @@ static unsigned int zonelist_iter_begin(
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;


