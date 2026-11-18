Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052238;
	b=0NoJly6ou6vXOiUeH1NGarE6RwM/yX9F8RNoa+q28emThy831b7sD9TlQN1uRfUOfZw2
	 Pk69YjT/xM4m7IxcEtqst0jSmJLQaiuDvJr+N3mnGBD6/Am2UM990tFvmwGepq3zPDZ0X
	 r2SKtSD6ixtlHWGY6U1kBBzqii2LxwFwU+6XGrKFdDvGDAuWbu388Xjz9ppGnEzIjWa1O
	 rYF1tTWH+kt67kOB7H5k/gQ1cLqxgmYtA3f3eyEjfGnfNz9gsL3c41Jpdn8JumoXhL6xX
	 efu+y9qKsmmYUbWyQUOBFEf5j0Zh8zApImcw8HHWUOJtaPqz6I7BUQQK/Wvq+ODlcTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0rZUDpZc9NYDK4q8EBOGSuBAOal1Yb4DOSVrcD1naE4=;
	b=s1Scn4E4auDTDqaBi3Tdu7cuMbSBadHk/4r7f9Zr9A8Qw3wdir/zt7KHtaQvU+duLDs8
	 kGZxSzv/S8XMJPrue04Z0VKpZ1KX+H20NVqX43jg+atbnaTw9jK+mHXj7ZLi9TiWBdgc8
	 sZ36j+r2RsLzdni7AeN3btpxYttYvghubTRqW4OSqXaYr0XN1sQV6yPuxcXnQEE+3FsEd
	 9atnNM7GM3ByL9DO0GGU7zSf7u0BefFORJJTqHceRxo3FPu5qtKMoJJsAugLrYL+8ZcTz
	 0ZvC3bqKiDWjakOsJZNslgwNIZReNkCUKK6jjlIZEFqQfPLHxoeF4g+I8ODnheUi5eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD7p+a89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FFA606A325;
	Thu, 19 Nov 2026 01:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD7p+a89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9766A1F000C4;
	Thu, 19 Nov 2026 01:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052238;
	bh=0rZUDpZc9NYDK4q8EBOGSuBAOal1Yb4DOSVrcD1naE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD7p+a89gAMHY2RCvRTsvoDMSCwqeGA1LbGYir5NXtsR2DPXcu1lCKZ7QCi6x3f2x
	 8lkarQix4uKzysdS0NgFw2GquPmik5/tyTdPmzZiz0E/NTG7nzrBsQbpiradlHbKvd
	 M0KDDfVRNPOTO00RSk+7rOm75i4dPwMRo5dkG0QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0492/2214] ntfs3: bound index head insertions by buffer capacity
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118150030.862368480@linuxfoundation.org>
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
index 4b3b266c4bc3e..4f89ead53df29 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -595,6 +595,8 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
 
 	if (!e)
 		return NULL;
+	if (size_add(used, ins_bytes) > le32_to_cpu(hdr->total))
+		return NULL;
 
 	/* Now we just make room for the inserted entries and jam it in. */
 	to_move = used - le32_to_cpu(hdr->de_off);
@@ -1794,7 +1796,10 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	}
 
 	/* Copy root entries into new buffer. */
-	hdr_insert_head(hdr, re, to_move);
+	if (!hdr_insert_head(hdr, re, to_move)) {
+		err = -EINVAL;
+		goto out_put_n;
+	}
 
 	/* Update bitmap attribute. */
 	indx_mark_used(indx, ni, new_vbn >> indx->idx2vbn_bits);
@@ -1946,7 +1951,11 @@ indx_insert_into_buffer(struct ntfs_index *indx, struct ntfs_inode *ni,
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



