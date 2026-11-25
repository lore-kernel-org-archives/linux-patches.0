Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626014;
	b=DSwrVrfktNBv5PtNYOgR0msCTMfSR83hk5LNl6z8NRBMPYncQ6MlrmhIzsyrMNz/ULrv
	 2ivOYUw/yUgG8VlYV/s4bQ3s9FQwtSEXp6nai20llGURKIGcgLkPj50SRkYOCK5oJeG6F
	 jhiVSR8FpQCHnXITpDwJPoKqWdz33wZntMbRqdYuD/W/8lcxmgi0vg6yGyZMJyIFjgpLE
	 NLdfk4UZwddUYHOYJbjDuaBdpJoMYU+FfQxVw8VmjXe+rAcvWegdO+fAPn1lcT+dQEVkh
	 HTzE74h3ANKqihHAUvJfoacKOKYC/p1GErDD/AyURMt+L19KZKpUybWHW2dMlzMGxBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hofIljlqqleeCititXt+RZVTJAmADjYRRhpAz6sqdWM=;
	b=n7sLSlJHJrmddVaXaJNOp9+sU/73VsQGSV4R/D2PuvSZ0wHIhab/Lkbgg9NkhoTIUx9u
	 wF0AjUg1nUxRZ6Wbhtuma1+b+BqCBHMlJgxhvDblvQZdHMmDKwInH9bKrOSqPNiCSOj67
	 Wkg5/4563kxWe1jj1gSWyKiLwt+mAuYCFj38wYOOc+JEdGUls7Px2Nhv8mKdTHk8iBz1y
	 bZZ9CYzerY8PAjX9a+zDeMWa3PwmmhBnmmXjJcQH90n4BR45qe1jSWRQ3XZ76sLyBzjPP
	 g3CruLsgAVWGsX8nyu8dGUfyDi9lDY2CoWQQwcH7yirjAIBIdXVSWPCtdSdR6bFqj9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IeDNOUkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2721606A327;
	Wed, 25 Nov 2026 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IeDNOUkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198FD1F000C6;
	Wed, 25 Nov 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626014;
	bh=hofIljlqqleeCititXt+RZVTJAmADjYRRhpAz6sqdWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeDNOUkg2W4qFWJ4wNCFSBxyezdxvwTcgEYkUDzMbaD0oBNrPfjQxPkNn2OvC+0eg
	 l1daGkdD/ATisaGTLUhIZxNzS+jTf6vqRU9ztbr+je+j+d0zBDZt74B2ySWNDkyya7
	 VzKYqquOwXDn/9d4+wyhqjq+yZ0YV6MFydPlUGe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 701/816] dm persistent data: test return value of node_copy
Date: Wed, 25 Nov 2026 15:37:29 +0100
Message-ID: <20261125143905.408506332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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


