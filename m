Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051780;
	b=acejnKR2zV7QvPkztyerG/PbVYOJyYQQpi0gFQADGPBA46WlXVbd/DmdQATcRsVYdBpr
	 CP6wFyfYo681H8Ih9ylJbsGO19HYhLt1FgNuwvTQGaJIQbl9p+TfNZKi3CrfXsUorwQPo
	 Unci7lJnoDetND/qz6kY5GEbCw9Wm18E6uU0bKh6eIklebujz5MG8lZbRyd9JYDrmOJ4U
	 8BPs1WXkyekyoujPL7+VPzNNGCguMFNAHcLY8Jl1m3RTmvM2pV6NvsD1r2ucGC/d6S5nr
	 1kfRIl7iJ9xDpvXbjooEw+WWE6gLkGjjxKC0lEMfe+dK9eVR5tNP3D2iZkajuxFyh2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xe52lq8C3FaG2fQMJW5aONq41ZAkbxdZy+eNykw+Igc=;
	b=T3XhNX3BazarI+Gq+zanqs16AcPhc2T1vy45bSNDldkXmQL+23LS3V7YKFpfOMZM9f8r
	 cnpDEstjrhXH410s+75HWZpEkOqIJhrVKg+tYXffS/B0YOcj0hQ0IAqnIYOUuJZqW6r5H
	 7xIsTc+Q+86Jj7XCxtfuQrL/9F9nvNrakr7sNtjbbMrB6qi7HJHoasVmCFfh3hVD5ByC+
	 HWAWL3JQN93gDWcKHo3yN8bxZXaowlpAudzp3It/HIvYHrBHhGSMe7pnAxAJ6wrN8aHRY
	 DKu1hK7YNy9D1T0QM03LpitgE2/hz3Ckb7H15k/QqY1vNT75iJ94vQnmfrNge8eYNqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eg5yUs9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9C4606A31C;
	Thu, 19 Nov 2026 01:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eg5yUs9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E121F000C4;
	Thu, 19 Nov 2026 01:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051780;
	bh=xe52lq8C3FaG2fQMJW5aONq41ZAkbxdZy+eNykw+Igc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eg5yUs9coEV93eOqTPsAakTet8ymMZkLN09qW24CsYUnHIReZJFguoDght7X2CMhL
	 08AVsB5whd4pG92chOLPhy6WRogQfPBGwCh0bOOHC1B4+2eOLKun6iT4hbuVA0ZPg0
	 i6yNCdAv2K0Z/xmBeGoElVq6K9tvjd1A0P+Cy1UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0330/2214] xfs: mark overfull dabtree node blocks as corrupt
Date: Wed, 18 Nov 2026 15:33:26 +0100
Message-ID: <20261118150023.540803648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,6 +433,10 @@ xchk_da_btree_block(
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


