Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023952;
	b=Z3yCNU+R2sRb4lEvTMULNGueYrChdAVLSHG8fElvDtedBnzVZqqN6ER0VJhXn2V9HTRB
	 pGRO+bjB8cDLhAe5aZqk0PkZnjYvSvbgT1PFUhq/z+USENeyjLnsmYXA/cTxhiJVktNmV
	 TfJ7SUdDyhfVp1wcSxCjyv/N6hcuMq0f65SJyHJRfaSVI0+OoQP76EArf1ts2n8lgHsjJ
	 up3ocwhEIrW3vkOVdN7oqkeS7o70tWVGX1WAUdusEzknAPul0NwGOxUBjgFn3Mk3/ZGUV
	 tJjO/zRYqxmvIYLQWNqaM0rgjl572cEMJYsV/FU6JiYxce63HKfF/Y3vCQCw/2iTvUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aLSqTKm+2DUXbaR2RcX2xiECuFJf8QNbBgYSXM6XWVQ=;
	b=rle/wt8Q3HHhhQlkKPgNHPL8YfUCGqZdUZpkqkiCKlvOhwQPXHFgMruKeKOamYl5xu4E
	 tsi5CtyKVQF/fMBBlvsMyEmFLv9kcy7NmISCX2U4PAOnXpYwARXI8pLuTYLdeWXa//0Lp
	 zfq0pt+ThxiUUPuhcf4d29HMS39jUXav5i4004v9b5nrnlGvYHnv62GftifCH8cxRTS+w
	 KWGRuxnP+tjl18j+mqZ8QwOID6/3joPuj4Qxm5vMGeONr5xQNnuczNhVt2R0OvC36mPGd
	 1jb2Udq1b0yr+cGKaEGfGIAVSGxad13LEhvKXQeirEg4/GP+9fw+E+H8dPmeHdgGM7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UG2h/tcj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D766606A325;
	Wed, 18 Nov 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UG2h/tcj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D191F000C4;
	Wed, 18 Nov 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023952;
	bh=aLSqTKm+2DUXbaR2RcX2xiECuFJf8QNbBgYSXM6XWVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UG2h/tcjmZCGrIwQB1uopn0oP557/CNm1jPMD/y9ZXSsjm7agTKCrwBB3aajJvacn
	 QHuN7nNjNK2QIhYeb8RQ3rlKNPmt/mNMzDYPKObA89weQqsBR+mCiF1TafLi6xL4Uo
	 xzfWArssNpe0E9eUoRGGtOOvj89uUrUQPCeOB4g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0551/2151] fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
Date: Wed, 18 Nov 2026 15:38:06 +0100
Message-ID: <20261118150142.035246867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit a1972501ffb15313f7ae598989bb2cd32829e625 ]

At the end of attr_allocate_frame() the on-disk valid_size is meant to be
updated to the value passed in via @new_valid:

	valid_size = le64_to_cpu(attr_b->nres.valid_size);
	if (new_valid != valid_size) {
		attr_b->nres.valid_size = cpu_to_le64(valid_size);
		mi_b->dirty = true;
	}

but it writes back the old valid_size that was just read instead of
new_valid, so the field is never actually changed even though the record
is marked dirty -- the intended update is a no-op.

ni_update_parent() spells the same read-compare-write out correctly a few
hundred lines away, storing the newly derived value:

	valid_le = cpu_to_le64(new_valid);
	if (valid_le != attr->nres.valid_size) {
		attr->nres.valid_size = valid_le;

In practice that path, reached from ni_write_inode(), re-derives
nres.valid_size from ni->i_valid on inode write-back, which normally masks
this, so the visible impact is limited.  The assignment here is still
wrong though; store @new_valid as intended.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index e500f7be8cc38..4e348c0f813e1 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1868,7 +1868,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 		valid_size = le64_to_cpu(attr_b->nres.valid_size);
 		if (new_valid != valid_size) {
-			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			attr_b->nres.valid_size = cpu_to_le64(new_valid);
 			mi_b->dirty = true;
 		}
 	}
-- 
2.53.0



