Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827179;
	b=KYvM2l3uN0/0zA72JrWNngukVMY2Ebi8E94SnPbTYjOFKz+u2V9p6+GZ7+zU0vmnV9UJ
	 rbhjm1buPSP0nN/SutuLn5T84EAlL4kVwjvcYnHlSvjIgpVVEwYCv4j318L13tvxJKEgO
	 HioQKedN/p7q5gBGdcB/WjKROwWCijR35WCQ56hgc6ZOJXFHIBHLILMWbu3NaDlXIiOcC
	 G4h8PnrilHC2yOMMCrVGVwJjHuJG3Zjg5iTtArv/4oaXvfb7EqkbUKJNl8Oisy5r+8+VE
	 ODymk4k52UkN23YQwJzsJ6d/VPMXwb45XjzTI0lLlD9syo5Weto7vHi3UqLlecto8Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IgpIb25Kf3xQ5fCC4an+44AO5Um1+kvzNpbOYL9Sp5w=;
	b=ZUhSjQjf7EvkZwoiO1C3aNBETWKh2eFJT6fmZi4kG0eMlzmUInm6k8hg2fsgeqFZy7km
	 q5MTzjG91smwGMKOkFMDXJ6iUpqXxIXnDjsSB4KrjwevoW/QsBKB9WA5bvccCDQLTclxB
	 87wkWuOu8i0140aVsYNKOYD0V5fif6KNLKBPkI5HU3dXvlbNoTWEFBtKJ+bLjwRlbP8ya
	 k6m8pUe+E+E16RJWjAqUXJV9MijLJtMLpxsMRv/TF53ZioKavXyZO8sxcF6XtZiCfPXOl
	 ehkDLuJGg8kpiFJwi/qrX66r8MKGXgpqHnUEyxXJx0Pmbwkaf5prtyoWtq1I4rk4rYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEddZR0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD60F606EEB7;
	Wed,  4 Nov 2026 21:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEddZR0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA051F00919;
	Wed,  4 Nov 2026 21:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827178;
	bh=IgpIb25Kf3xQ5fCC4an+44AO5Um1+kvzNpbOYL9Sp5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEddZR0TSuRZU4Lfco+8DG5roI7cIUE5sUVyXqvQZDoploBcKLX4aQdcnR/wrjb5Y
	 papKeVcw0tSv1zuNanzkM8fwuwfZJa8wp6u9IXdplpDWCidThQJ4tuTjKt8BHKIRx8
	 +7JZiV6fsZhfzyZMB8/wKECoeDp50eYdeSDgnQvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.3 241/547] mtd: virt-concat: unlink concat node before freeing it
Date: Wed,  4 Nov 2026 16:07:05 -0500
Message-ID: <20261104211045.016622540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 532caaa2f445b22b74b88b4023a810426772db54 upstream.

mtd_virt_concat_create_item() links each new mtd_virt_concat_node to
concat_node_list. mtd_virt_concat_destroy() later frees the node after
destroying its concatenated MTD device, but fails to unlink it. A later
list traversal dereferences the freed node, causing a use-after-free.

Remove the node from concat_node_list before freeing it.

Fixes: 43db6366fc2d ("mtd: Add driver for concatenating devices")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6, smatch
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtd_virt_concat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtd_virt_concat.c b/drivers/mtd/mtd_virt_concat.c
index da4277ced4d6..4fad0967a96e 100644
--- a/drivers/mtd/mtd_virt_concat.c
+++ b/drivers/mtd/mtd_virt_concat.c
@@ -130,6 +130,7 @@ int mtd_virt_concat_destroy(struct mtd_info *mtd)
 			mtd_concat_destroy(&concat->mtd);
 		}
 
+		list_del(&item->head);
 		for (idx = 0; idx < item->count; idx++)
 			of_node_put(item->nodes[idx]);
 
-- 
2.56.0



