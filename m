Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061989;
	b=Zj06ukvvc5kdKUPRzBbTk11x/tgBAkQ2Hz3ZZhOb0nk1spMOTWDfEnFArOu9+NspuV9+
	 iQflla4VI87p38266ITcldi5KQyangqo9v7rutP4s0udIvYNrKn4CpKTIB9YCmFRRZTVc
	 Bc4byiiyp76baoGw1LrKBLYumAHmjsX6p/t3Q0rX70qycqdhYG7yBOYHpW/nMPvNjQ50M
	 6KBvB0rBITzAp1R08880909L5P7gAYfbYfypxjZA29aoL4jK4VnG+SXAz0CcO7kKSRRxl
	 VlVoSKXmqkdWPRlQ9GeMZ0/VNS9HbZMnkYVlFSlx/92/bhyo8iF8plOrazrSjToRgYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jeKOaFELNvDG3E5v7QKPZIqQMsNiYz4swCAgcxG9nrk=;
	b=26FQk5VIErK37BnqUOqWfhojRQKCNb1X0DZcqWdrdYKREBCOzeHd9RGQ+89QfyQaNZw2
	 X6qbs/0XZrl8KUJLqMYx9iQOl9qYBZ94/MJWIfqZHcnJTTrA5xBplhi62iFRpEs/llFtH
	 TEcRtdC1Dfb5H7/C7Ka/99GFMZkWE7BJHF4TY/zHxJ92In+ZNBEESKDz+8gfcPxca3nVG
	 WD2MvPZeAzi+94wkRv5p4Ds7k2JIw1f62NJhOJiscWu2NCu0kgjt5DNJ876gzh/dLAZuk
	 FoKayp4jnTDgnOuFcfpkwZEWlNIpUCgwAQrsP/HETZIMcmOMtZwG8Ps7Com9RdZJYVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvZ8jXF9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C283606A332;
	Sat,  7 Nov 2026 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvZ8jXF9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEA31F0089F;
	Sat,  7 Nov 2026 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061989;
	bh=jeKOaFELNvDG3E5v7QKPZIqQMsNiYz4swCAgcxG9nrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvZ8jXF9yLug+h2Cn6bNyqCJ5VGclyj0FWM5/2GWqmRaZAHTmNn0oHgOL6p2MmZk2
	 t3A3M1meRnhv6FK5vLDx4ddf+hsLPjUXWEnXkODmEqccd6vblEm3xYmTUs2LBmfanb
	 KAVWEYvbZIH9esm8pbdbUscqUuxU1nDPnGREbmv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0980/1536] dm vdo indexer: prevent delta list overflow on load
Date: Sat,  7 Nov 2026 08:49:56 -0500
Message-ID: <20261107135025.175534096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit 936293c9f3f4f2a0d1b80df9332e96c552ac3b37 ]

Check for corrupted delta lists sizes that overflow the
memory available for the delta_lists. An overflow can
cause the delta list data to be written outside the
reserved delta memory space.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/delta-index.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 0ac2443f0df36..a42de1af4b693 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -803,7 +803,7 @@ static void compute_new_list_offsets(struct delta_zone *delta_zone, u32 growing_
 		(delta_zone->size * BITS_PER_BYTE - delta_lists[tail_guard_index].size);
 }
 
-static void rebalance_lists(struct delta_zone *delta_zone)
+static int rebalance_lists(struct delta_zone *delta_zone)
 {
 	struct delta_list *delta_lists;
 	u32 i;
@@ -814,9 +814,17 @@ static void rebalance_lists(struct delta_zone *delta_zone)
 	for (i = 0; i <= delta_zone->list_count + 1; i++)
 		used_space += get_delta_list_byte_size(&delta_lists[i]);
 
+	if (delta_zone->size < used_space) {
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
+						"delta zone lists overflow zone size %zu",
+						delta_zone->size);
+	}
+
 	compute_new_list_offsets(delta_zone, 0, 0, used_space);
 	for (i = 1; i <= delta_zone->list_count + 1; i++)
 		delta_lists[i].start = delta_zone->new_offsets[i];
+
+	return UDS_SUCCESS;
 }
 
 /* Start restoring a delta index from multiple input streams. */
@@ -944,8 +952,11 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 	}
 
 	/* Prepare each zone to start receiving the delta list data. */
-	for (z = 0; z < delta_index->zone_count; z++)
-		rebalance_lists(&delta_index->delta_zones[z]);
+	for (z = 0; z < delta_index->zone_count; z++) {
+		result = rebalance_lists(&delta_index->delta_zones[z]);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
 
 	return UDS_SUCCESS;
 }
-- 
2.53.0



