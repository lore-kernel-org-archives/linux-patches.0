Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062854;
	b=KE3bhkdASx6xSnNgO+L0Z36jDfq/L7URj5g7Q/AhXtiXQJNevLNoOYh8RYuexamgHuPD
	 C/Mes2xUxLdAfVJjBlDkCj3Re8mSQii87yC/VWOmif6s/Ld80JJml1hECBi2uLfuoXQpd
	 Jes7e9xHRO4UE/jcipBgozY0GjjgcU0ImbNMxoovBIMtjBXrU9V6VPnWuxJQHkE42PXc+
	 A0N+PpTz76F4mPE0qxmAt/FYwceK+5qdMAOO3S72f34OtZbsRwK4ZHD8/ZHadjKqISY1O
	 k5g3qRpqCCXR+DVK+AD66tctJ+a5gxjDIo1PXRI5QWd3np6AFspa5Auyl3Gm6V15eBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Z/9Y4Oz1mMzGcjbcFlD4sBB5tgPHJyRs9OVLa+os2M=;
	b=Ei5jT3CwUD2pELsgPdZ59MEXXeS0nsUWrYvHKRaYOM+ZNhDQy7PEF+42vRAr7pkK6sjW
	 yRPMC5hQWODNiQTUU59ggrWOVd2NuK3ds0XiZJs4kXMmAKiNSjTn4BPC/2+ydSlnTH7LB
	 pal4aN/Qi0gGT65e9iQyuibv6DqJcmt49IznXje+YMe1I0RryTD64l/pTCwrQjfNHVGE5
	 OmT70YhGp2csLZp+Wgc34OS0il+l8n50I1wCK9RqQyUlYeEuCJEkbE1MXoPvIcr9PDwQ8
	 L3xiNjnKW+oBCIuWca0OgqUYLXhErQZlpejN00WzAPU+T6owGiQ079iAu6c/Dh2Pcvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJwNXCux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7901606A339;
	Sat,  7 Nov 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJwNXCux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762421F0089F;
	Sat,  7 Nov 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062853;
	bh=2Z/9Y4Oz1mMzGcjbcFlD4sBB5tgPHJyRs9OVLa+os2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJwNXCuxWSj/w5qtr/VrKNPyJM+qT9GM5pyQZQDTqh66io36k/fYCvyCkP/Vgbkxb
	 dsN2/Ob9Mi4GU4HDYHlEFdblbHehQwYS9Cv5Fn4EJw6V0wMP5b8gG/q3P3RfJWn0K+
	 KcOyQ7MtKzRtWhILIiHFVENgZ11jVPZyaUBjC9l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/869] ntfs3: bound index head insertions by buffer capacity
Date: Sat,  7 Nov 2026 08:47:06 -0500
Message-ID: <20261107134857.260513378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 03ae5a817c1b4..97cbe176a83e5 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -596,6 +596,8 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
 
 	if (!e)
 		return NULL;
+	if (size_add(used, ins_bytes) > le32_to_cpu(hdr->total))
+		return NULL;
 
 	/* Now we just make room for the inserted entries and jam it in. */
 	to_move = used - le32_to_cpu(hdr->de_off);
@@ -1800,7 +1802,10 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	}
 
 	/* Copy root entries into new buffer. */
-	hdr_insert_head(hdr, re, to_move);
+	if (!hdr_insert_head(hdr, re, to_move)) {
+		err = -EINVAL;
+		goto out_put_n;
+	}
 
 	/* Update bitmap attribute. */
 	indx_mark_used(indx, ni, new_vbn >> indx->idx2vbn_bits);
@@ -1952,7 +1957,11 @@ indx_insert_into_buffer(struct ntfs_index *indx, struct ntfs_inode *ni,
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



