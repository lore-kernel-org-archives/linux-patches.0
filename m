Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035243;
	b=x+VzDVSSfxPAsKAb6MmMcmll7MLWzTnhtXwkeDQdMqwkytZJ3NCHPe+MG99NpvIn/7fW
	 IFmnLF5V4FyPXn23mc/M+fdihWt6xawUQlEOv9WsXU07PJhxmMAXsjDfwEAZpYxQ6rDHY
	 0M36XoX9Zxf/8+PfFvn+/zuMVY3Na93QoqHJ5NFMuhWefYBsoL/Q2ze2/JZWTdtJUMmW3
	 O6FQft5YLBFYra1OtI9qctGlhhsTgAdd1UqbXZrCt0N9dqyJOWo6Ak340PCQ0wzP1tYPh
	 u6fuX/9B59pMCULOYH+Kk4gPsIP6osUYu/7S4eNdeHYXh6QOvkQ393tJ1JqXoD0Obww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LuyLIFu7lpk2BgxQpZr4eIAjxCQOsZ/uyQH8DcXpNzc=;
	b=oxO52gsJ1uZXIZHC39uVs31towkBNOawIQ2FOFjbdETW6+/uEgKceJgqZpgYh6QJ6zIJ
	 LhYFwml1i+SqeJUQEjlIws9E/X2biFDJmP6tANuClwnZ3bFJt21qQzzRFCjsMVTTzfnIJ
	 yMnntjh7RA5dmwFUwxYcMfDTECgJI9mGCyy+ryq01kilnzqAkyrsGGOm27YL3h8GS0nBJ
	 rwGsGe+vadJtyjVg0COBlYcHolHXsf+plUIJBx7YlGOlzjLjxl8KPYa0hZvKNhyw7VIxd
	 EhctUfiQ9JusyxkErLYrDwQ2xHOodFsE1pl+88pduI5cXIZB/IR+7FKSLAwoq5+09pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loJ9W7hx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BAF606A32F;
	Wed, 18 Nov 2026 20:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loJ9W7hx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CAC1F000C4;
	Wed, 18 Nov 2026 20:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035243;
	bh=LuyLIFu7lpk2BgxQpZr4eIAjxCQOsZ/uyQH8DcXpNzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loJ9W7hxj29V/wYl8dtVstNuenP6ANu7r3H7iAJ8wwiT5/Hl38pU4aQd8YFRE1Zpf
	 oXEkBapA42PM9hmZ3T05i94afBSvRx2Jn6leKHg8Xj2kWX/2CM0eA9Ant33L8oI9Sj
	 jGqDH+1NZuatS5x7q9E/oq7bHQyBzrM/AAlpfkTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0657/3318] xfs: mark overfull dabtree node blocks as corrupt
Date: Wed, 18 Nov 2026 15:21:19 +0100
Message-ID: <20261118150337.756291283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f61c91a2e5994fa81141d6c06dadae1fed206018 upstream.

LOLLM observes that we need to range-check the dabtree node record count
before using it to index an array.  Fix that.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -434,6 +434,10 @@ xchk_da_btree_block(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
 		btree = nodehdr.btree;
+		if (nodehdr.count > dargs->geo->node_ents) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		*pmaxrecs = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {


