Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623448;
	b=kpu/s1WbjS2dmn0JWRtC88+JBJ3cCDC4tco9eVjTpNElq5Hlr1BITZ3E4o5O07oyNKpt
	 Cb0igX8nF8SngBgakdxY71kJi+BpvDUvEmXqF0EKB8I96DynriTYCPQ979y6dhbexLOYM
	 HJhaf4QAT1xUzColdusi/sBaMhe5ZoOvl9Q+m4T4ebNpREN6o5EKfwvX0hA9Vef4EWGlH
	 vsjVQNI1efVQVuqLy2/9JU9X50x5iSVdOmV0Saim167fskeQRgborDc+wVPWXD0Yv4dZR
	 pFPeXV2Bo+6Lw3M8g+tzC4nXOQttaED7m2K2kJq/mk32ca7G4aQdcR1YznkPmOhFlqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QOgLlnZRbxtgoD5L2cXJ+qHeaf3vgfuxY5MeijOYiew=;
	b=cDuuEXCRyqffZFRtkii7ukH4m6CFVWjDf/xYbdqt8mBVgY73+ta9dJagCuWWLdWvhIsK
	 Wh8YVJ+APScfAStFGATM2bn9HyEOLe35fFSV3M3PBod6pgdiYjXuVGWQ9oNK8aAv1zQ2b
	 l7j/wl8IKna4PbL1R6xa+bGiEDcAcjbS9wllP4SuuXQrUkYS/8c0Mz3GJDyU4pnzpajJH
	 RozHj8AGXn9snZrs5f8jd/um9Com5nPtcrpixA29iMiAnjw3YbBEWzS0DWwT3pngI9U6g
	 REH/LSGqwePP2z/enS8rGJOi8w/9HiFxfJwDLW07PuA7B8PiRmVn2JXs493WGzhGZWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5z4sP10;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72E7606A321;
	Wed, 25 Nov 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5z4sP10
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4343B1F000C6;
	Wed, 25 Nov 2026 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623447;
	bh=QOgLlnZRbxtgoD5L2cXJ+qHeaf3vgfuxY5MeijOYiew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5z4sP10HQS7y3ENqBKK3QDiwAGQcs/rbW2F83cG92daysE+7MMq6AE3OrFENYcY8
	 y7XpTgNQyoHrd2Cd0pNX2Iv1hTOIyt5MeFOQjvorhDrUDsfxQ1mQPLxzzYUvvERKDI
	 FvqDd88kAYOVvPT9YLZ4KOfywkYAWKpzQt3noUJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 862/990] dm persistent data: test return value of node_copy
Date: Wed, 25 Nov 2026 15:37:09 +0100
Message-ID: <20261125143842.217805352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 624d146d97c5fbe7200ef4b2dd5350ecf57d6b79 upstream.

There were 3 places where the return value of node_copy was not tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: c671ffa55d8b ("dm btree remove: change a bunch of BUG_ON() calls to proper errors")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree-remove.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -253,7 +253,9 @@ static int __rebalance2(struct dm_btree_
 		/*
 		 * Merge
 		 */
-		node_copy(left, right, -nr_right);
+		ret = node_copy(left, right, -nr_right);
+		if (unlikely(ret))
+			return ret;
 		left->header.nr_entries = cpu_to_le32(nr_left + nr_right);
 		delete_at(parent, r->index);
 
@@ -315,13 +317,16 @@ static int delete_center_node(struct dm_
 {
 	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
 	unsigned int shift = min(max_entries - nr_left, nr_center);
+	int ret;
 
 	if (nr_left + shift > max_entries) {
 		DMERR("node shift out of bounds");
 		return -EINVAL;
 	}
 
-	node_copy(left, center, -shift);
+	ret = node_copy(left, center, -shift);
+	if (unlikely(ret))
+		return ret;
 	left->header.nr_entries = cpu_to_le32(nr_left + shift);
 
 	if (shift != nr_center) {
@@ -333,7 +338,9 @@ static int delete_center_node(struct dm_
 		}
 
 		node_shift(right, shift);
-		node_copy(center, right, shift);
+		ret = node_copy(center, right, shift);
+		if (unlikely(ret))
+			return ret;
 		right->header.nr_entries = cpu_to_le32(nr_right + shift);
 	}
 	*key_ptr(parent, r->index) = right->keys[0];


