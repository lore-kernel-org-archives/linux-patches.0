Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063995;
	b=eHn3b++51hPk/4Pz+7Tykim+s4oYnY8pgVKSGa1I3QT3xs3RMg2rzmTXn1uQ5ZkEzTEk
	 UJbqPT2IxeRW+QgD+F8700Ns74JlI8xsAD2DEFz7REiXU3jZf8AcBNh6TQkwQtYigLKAX
	 Xr+8i3gXjsFXlBAq2CgKeZgh0JZhNFSYeTVIVZBL9+s0sT9U+JflcGYVpqY6fk8WguokJ
	 QnlEP/UbL9s8m0mEEm6d047UTyp0ow1ZPIBe/BgtF89i7Dedh3OP6IEiT2CBvQoXQ11t1
	 h+6B4VyKslVaKP+klorQI17eLX7LGrPJfeeqMFj8mqsSI7MU4FIY/oXSuAUR21o7cuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TamXucSCCdo2SP0FhGhGDQt4kmXkAHGzeIpDx70tdiQ=;
	b=TIVuR35N3Eql3iZdnFTRopmLVRA02oATPSthKEe2ZbBozoPHtT1DLqA2izcgIjVe8Tr3
	 S6HdDkgnyvI90pRUO0pgFnSuZ2sbW6ORr+81hjz+5P+vYsmLkCjSkwJOThrzG8R3ByI36
	 HH1M3Cp/MktwM/uSz290TsnFZxgZ8gl6jx50nGbAHm1l71Brjq0NPVKaF6W8tAU0FWdWj
	 tWyvnXmFRqD/0bRyvP5D+U8Gvy/OwMevLp/y9fJ6BHXc4eq+RvXoWmRfuYsriE/pXlWUE
	 EJKsF6JBwXgQ82GBKsSaRDGqulAHyhYPVyA3hyZOsLLs92sIYPosJYYuqWspAPCYGxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sOeUFDKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C174E606A332;
	Sat,  7 Nov 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sOeUFDKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED9A1F008A1;
	Sat,  7 Nov 2026 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063994;
	bh=TamXucSCCdo2SP0FhGhGDQt4kmXkAHGzeIpDx70tdiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOeUFDKLVtd13oQRHnDMDHnI/s5D8ROZEL0yps5HjmoBQVGJYB3D67lxAPqLDI1In
	 OMvl/Z0DgqoJKyKmguU8D1hYeMpc3RikykrQIBzEKbk6tcWRQh0CbnBnAqwZ9RYasO
	 rPYzVY6aBjsxNXq0oNmGOHJetRJB5v0RyvPt65nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0177/1257] ntfs3: bound index head insertions by buffer capacity
Date: Sat,  7 Nov 2026 08:41:13 -0500
Message-ID: <20261107134944.349258692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 2f497d23652ff23da07b08cfb4b4a1c2a87f1892 ]

hdr_insert_head() shifts the existing index entries by ins_bytes without
checking that the resulting used size fits within hdr->total. A directory
index root larger than the newly allocated index buffer can therefore make
the memmove write beyond the buffer.

Reject insertions whose size would exceed the index header capacity and
make both split callers unwind the new node when that happens.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45ef5a8d661162757547
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 689712d3463d4..37e3e16b1f841 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -594,6 +594,8 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
 
 	if (!e)
 		return NULL;
+	if (size_add(used, ins_bytes) > le32_to_cpu(hdr->total))
+		return NULL;
 
 	/* Now we just make room for the inserted entries and jam it in. */
 	to_move = used - le32_to_cpu(hdr->de_off);
@@ -1801,7 +1803,10 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	}
 
 	/* Copy root entries into new buffer. */
-	hdr_insert_head(hdr, re, to_move);
+	if (!hdr_insert_head(hdr, re, to_move)) {
+		err = -EINVAL;
+		goto out_put_n;
+	}
 
 	/* Update bitmap attribute. */
 	indx_mark_used(indx, ni, new_vbn >> indx->idx2vbn_bits);
@@ -1955,7 +1960,11 @@ static int indx_insert_into_buffer(struct ntfs_index *indx,
 	/* Copy all the entries <= sp into the new buffer. */
 	de_t = hdr_first_de(hdr1);
 	to_copy = PtrOffset(de_t, sp);
-	hdr_insert_head(hdr2, de_t, to_copy);
+	if (!hdr_insert_head(hdr2, de_t, to_copy)) {
+		err = -EINVAL;
+		put_indx_node(n2);
+		goto out;
+	}
 
 	/* Remove all entries (sp including) from hdr1. */
 	used = used1 - to_copy - sp_size;
-- 
2.53.0



