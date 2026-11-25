Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619563;
	b=r09fbiBpQqamJA4AsPmci8ksfiWpKxeDQxAOJ+RYatpYS8YNIH4NcwNvrhYqx6XbyOVA
	 N/suMARrrJNWpFkE+j0r/GZzEwvySBbJY9FDX0xlsE+3WSkSSLpVJnO3FdY1y6xYn1eUy
	 KScOIcRFI+sMof3LUL2trx32AQMCuftz1Rdqc2ffV6iMYmSCmyB5Jz5OX2YHwaKQGVRxc
	 7NwJLCrx3Uz3nzm047P0wXFpvml/MPfsDywa+ee1zPD1aOsgxf9ecxlsE4vBQR+yfvyEV
	 opfBUKIkauHbT9Ij51nGmuBTzLSTz6uJET6/OcQlemDGmwIxxOyf2pjeEZE07ghzHtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6aaiQEWVj6nVwVlM1TrY6eVKVDCmmaSE5EjCQWnw1h4=;
	b=FfvdPOqAfXJUOQi37Yhr3cHHv8VH/QmVTSF4RK3xKpsMIRuQekNswfxDGE2qsKpyWlpL
	 /tYlYEEnU5Nb7i+Jy1eDn4ljw2W82LX6GfweldSR4iTx43vixh0FX8wJzXspFhVnLozkj
	 paV1/QD6wFpXI4qz6qaEtb4z4tiak5xRlPCEFXoCpp5j0sFBacCXrI2LWSy3CEdu2EcGr
	 gTWFtVHiDsjMhcZB0IQYHjzzvBp81X+adafcLUiGLWtT9AVYng1j3FUsUOS9zbrjlHqLA
	 zLo+v9dNm943D001cxX6DwKpVwccvsldL+1Yp3U3ZYX8+mH/4zs5QD9YguAuvMTzCBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opyRMBVy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C20B606A321;
	Wed, 25 Nov 2026 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opyRMBVy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685941F000C0;
	Wed, 25 Nov 2026 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619562;
	bh=6aaiQEWVj6nVwVlM1TrY6eVKVDCmmaSE5EjCQWnw1h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opyRMBVyx6h3E3UNZd/PU7JQM1GJJHX80d1MIG2DaTz/RGRzSUHsSdviCdlZrdHZJ
	 GLC9h8Yp+YhsxOeiDl4NB4+cc1ZtSDUsyiFiBzPSCD8B6kNaW+f1tPcKwdw+6rNJ9+
	 GY+Td808wAB5EkCjFhmL5wDzWZfU8MdAnPtdMQSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 7.3 0600/1005] mm/mmzone: read each zoneref slot once when filtering by nodemask
Date: Wed, 25 Nov 2026 15:32:18 +0100
Message-ID: <20261125143835.800228481@linuxfoundation.org>
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

commit e55119ab611a0e47595db7e1d2ac1e69f7a73ff0 upstream.

__next_zones_zonelist() tests a slot's zone for NULL, then reads the
slot again to look up the zone's node. Offlining a zone's last block
rebuilds the zonelists in place, so the second read can return the
terminator:

  CPU 0                             CPU 1
  __next_zones_zonelist(nodemask)
    zonelist_zone(slot 1) = NORMAL
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE, NORMAL, NULL]
                                        -> [NORMAL, NULL]
    zref_in_nodemask(slot 1)
      zone_to_nid(NULL)

Current GCC and clang merge the two reads, but nothing requires it.
With mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a
nodemask allocation between the reads while the node's last movable
block goes offline oopses every time:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:zone_to_nid+0x0/0x10
  Call Trace:
   zref_in_nodemask+0x9/0x20
   __next_zones_zonelist+0x23/0x70
   prepare_alloc_pages.constprop.0+0x16c/0x190
   __alloc_frozen_pages_noprof+0xaf/0x330

Read the slot once and test that zone. A NULL zone still ends the walk.
To achieve that, rename zref_in_nodemask() to zone_in_nodemask() and
pass a zone instead of zoneref pointer.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://patch.msgid.link/20261101021340.2251928-8-gourry@gourry.net
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmzone.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -43,13 +43,14 @@ struct zone *next_zone(struct zone *zone
 	return zone;
 }
 
-static inline int zref_in_nodemask(struct zoneref *zref,
-				   const nodemask_t *nodes)
+/* A NULL zone terminates the zonelist, so it ends the search. */
+static inline bool zone_in_nodemask(const struct zone *zone,
+				    const nodemask_t *nodes)
 {
 #ifdef CONFIG_NUMA
-	return node_isset(zonelist_node_idx(zref), *nodes);
+	return !zone || node_isset(zone_to_nid(zone), *nodes);
 #else
-	return 1;
+	return true;
 #endif /* CONFIG_NUMA */
 }
 
@@ -67,7 +68,7 @@ struct zoneref *__next_zones_zonelist(st
 			z++;
 	else
 		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(zonelist_zone(z) && !zref_in_nodemask(z, nodes)))
+		       !zone_in_nodemask(zonelist_zone(z), nodes))
 			z++;
 
 	return z;


