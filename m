Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215077;
	b=Y393aioRd3wKt9PVnA+ZQeYmqbttHYlJXNn+D670wnvuLx7FJ+LMKmAjWJXGTQ9CCJ6f
	 4Flob94xx0OPSB6TCru6WAOsLWvOSs9i7ciI4YdCiGW/lmMiibjoEWYx8J8aRlKE1JrG+
	 3tJ5oL05fvkUZadg00GiL4BHiOycLTRyTGf1P9xHgCj0V4xwShLdpBipt4sZrw0D3uV4L
	 XY6GlKOUVccHie6mM2Fwy6Vjp0poNH1sc9cunPLBcEY3HCqF/2oOGE8aY7oDeJL+/asE7
	 VjLL1meznDVEOlHUB40tQXtxgiVq+wuqYEJ1UYm2++2fFjrx6Nf1jXxDGPcyhCwG0fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dPkCkwVLJJo16zQ5XEOI1FnW05CnCGKneTjZm+blsZU=;
	b=bEYC86JnReSqHONyQH6nQoU9P59YRnZUofr9ihXmPP9ywK7GPt3SwS69gwgCYRQBvpi6
	 IFF3+NY4xy8WyBrsJBgX1rC1/IUAp7w/aN5aaAod0dAYvLj+NzgNqkK08GoVDxYAuWEXJ
	 occDheWkwQtkx/tn4acJ0ooqS5mvG/+nKSbDwy89xW2+lWPqHd1E/SEX398DpOEQsLzpJ
	 a2Vp8lnjMrg9YYFvXejsmlzrz4h9letix3unEWwFX266SCZ+kwiV0gIkzYsoaVl2ViBu4
	 2AehIZfsIBODlQ3vRj64uFTrQneKnOtP2nmNAhe/0GGeTvl0MPlFMnodbc4D1GjeRYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlPvhDvy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19192606A31C;
	Wed, 28 Oct 2026 19:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlPvhDvy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FF91F01825;
	Wed, 28 Oct 2026 19:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215077;
	bh=dPkCkwVLJJo16zQ5XEOI1FnW05CnCGKneTjZm+blsZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlPvhDvyQ2Y6/lgltD47lvf+piFhNv+GBc9aBen8KacUZuvOzIQ6ELzG+jpWCDMZl
	 +BE+GlLmWe74kt1PhCAMs9erwPtJ5VigiCVGFg7e9t2XvlHxmb/zKZVD7t1xsiCqHM
	 Kn+JGfkOsDL7y5mSr2hjsTZdKPWwJT4F32z3iXN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c1e9aedbd913fadad617@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1082/1887] fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()
Date: Wed, 28 Oct 2026 17:52:58 +0100
Message-ID: <20261028170524.028023737@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit d7ea8495fd307b58f8867acd81a1b40075b1d3ba ]

When a compressed or sparse attribute has its clusters frame-aligned,
vcn is rounded down to the frame start using cmask, which can result
in vcn != vcn0. In this case, vcn and vcn0 may reside in different
attribute segments.

The code already handles the case where vcn is in a different segment
by loading its runs before allocation. However, it fails to load runs
for vcn0 when vcn0 resides in a different segment than vcn. This causes
run_lookup_entry() to return SPARSE_LCN for vcn0 since its segment was
never loaded into the in-memory run list, triggering the WARN_ON(1).

Fix this by adding a missing check for vcn0 after the existing vcn
segment check. If vcn0 falls outside the current segment range
[svcn, evcn1), find and load the attribute segment containing vcn0
before performing the run lookup.

The following scenario triggers the bug:
  attr_data_get_block_locked()
    vcn = vcn0 & cmask        <- vcn != vcn0 after frame alignment
    load runs for vcn segment <- vcn0 segment not loaded!
    attr_allocate_clusters()  <- allocation succeeds
    run_lookup_entry(vcn0)    <- vcn0 not in run -> SPARSE_LCN
    WARN_ON(1)                <- bug fires here!

Reported-by: syzbot+c1e9aedbd913fadad617@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c1e9aedbd913fadad617
Fixes: c380b52f6c57 ("fs/ntfs3: Change new sparse cluster processing")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index db4f2dffed950..c037f5307657a 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1048,6 +1048,22 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 			if (err)
 				goto out;
 		}
+
+		if (vcn0 < svcn || evcn1 <= vcn0) {
+			struct ATTRIB *attr2;
+			struct ATTR_LIST_ENTRY *le2 = le_b;
+			struct mft_inode *mi2;
+
+			attr2 = ni_find_attr(ni, attr_b, &le2, ATTR_DATA, NULL,
+					     0, &vcn0, &mi2);
+			if (!attr2) {
+				err = -EINVAL;
+				goto out;
+			}
+			err = attr_load_runs(attr2, ni, run, NULL);
+			if (err)
+				goto out;
+		}
 	}
 
 	if (vcn + to_alloc > asize)
-- 
2.53.0



