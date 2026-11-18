Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023693;
	b=Q3GU2MB85x+x4icmCbHTdNCut1SCLhvyOoSBbmcV1o1VvB3dsAcUpG5QxfYarsL+D3so
	 xjpbJm9kmUqib+hK8w974Ej6BfVooxZJps7nwEKDudAoVb/VB3XuF2PdDoDe+MZZEz4IM
	 Nbk7kDJB1OkLG2qUx81vtSAvB6z4iteyNQc6FMG4tTpvQnJAp7PRodGdFAwn1RoPfFyPj
	 gECdRo8KRpUT/g8iKN2LHSTf3Ur6rqOzraWNhKiscUvbHkbLNkNxaZPSJEjbyF/AHXwx3
	 MHtHs4tygKHBd85X764j+BsxFIS+grQuKCy9pZPtrOIx+lSgPH3s3PtSTZ+SZ/uaCag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ErodMqTQogDpnRO67WxPagMW+OaYcO69cB/NUPJNWTg=;
	b=AhCPtOLgfqyEjC8c6R254l9O9l4Az48V3VKR2Ff+5XdNlBr07I7Z7IbEvMcrxNB4P1+X
	 TWXhGedhtX/J3q4u3KyS26TRG+TqzZZHRKbmVEhoKiDPoEBxYP1HJgl02UfTof7CMS4/Z
	 GUHDwyvbBcFIIDkZAfA+eGF4gc5XByPpug3bztj5F68mNhm0lE7jcpWf2cws6T0JyqiLE
	 8F1Cox/s6UYhgbU/b3lXoJ+GSGXMvQw7yGa/zkY0TItCDLsHQMZcyzHgTbGsI1XjP36IO
	 gl9VTFZFaDBMkQCyBhA0d2v/1EYh8m9fD56f8UbMf1fLnFRXjItw7YZe+r4SBeMw4ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSQa7gon;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B25606A325;
	Wed, 18 Nov 2026 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSQa7gon
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443771F000C4;
	Wed, 18 Nov 2026 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023692;
	bh=ErodMqTQogDpnRO67WxPagMW+OaYcO69cB/NUPJNWTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSQa7gonEKfYKggO5t4TSPRo9zpo3v+2JzLdHfyyGIf8orrFJZzMagh4JdQcFrYBZ
	 L18D7YkcovVgVQdiERxL08gkUnh+ebgUWTXa32CAfFXPmWv21Wv+HDQsSRwIxdz1Rq
	 /nUlqB1cmNiMTL5rmHZhYPwWoKBSsZnl1e2IVJMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0459/2151] ntfs3: fix out-of-bounds read in ntfs_read_mft()
Date: Wed, 18 Nov 2026 15:36:34 +0100
Message-ID: <20261118150138.745897197@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 7a374d9be8267834dc534e55f01e5e01765cab4c ]

ntfs_read_mft() walks the attributes of an MFT record and, for each
FILE_NAME attribute, compares the resident on-disk name with the name
being looked up.  The only size check before the compare is
rsize >= SIZEOF_ATTRIBUTE_FILENAME, which covers the fixed header up to
and including name_len, but not the variable-length name that follows it.

name_len comes straight from disk and is not validated against the
resident data_size.  A crafted image can set name_len large while keeping
data_size at the header size, so ntfs_cmp_names_cpu() reads name_len
le16 characters past the end of the MFT record buffer:

  BUG: KASAN: slab-out-of-bounds in ntfs_cmp_names_cpu (fs/ntfs3/upcase.c:84)
  Read of size 2 at addr ffff888031879c00 by task a.out
   ntfs_cmp_names_cpu (fs/ntfs3/upcase.c:84)
   ntfs_iget5 (fs/ntfs3/inode.c:209)
   dir_search_u (fs/ntfs3/dir.c:265)
   ntfs_lookup (fs/ntfs3/namei.c:85)
   __lookup_slow (fs/namei.c:1915)
   lookup_slow (fs/namei.c:1932)
   path_lookupat (fs/namei.c:2278)
   vfs_statx (fs/stat.c)
   vfs_fstatat (fs/stat.c)
   __do_sys_newfstatat (fs/stat.c)

  Allocated by task:
   mi_init (fs/ntfs3/record.c)
   ntfs_iget5 (fs/ntfs3/inode.c)
   dir_search_u (fs/ntfs3/dir.c)
   ntfs_lookup (fs/ntfs3/namei.c)

Check that the name fits in the resident data before using it.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 99fdba7b403cb..e9ac5c5c7239d 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -208,6 +208,11 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 		names += 1;
 		fname = Add2Ptr(attr, roff);
+
+		/* Make sure the full name fits in the resident data. */
+		if (rsize < fname_full_size(fname))
+			goto out;
+
 		if (fname->type == FILE_NAME_DOS)
 			goto next_attr;
 
-- 
2.53.0



