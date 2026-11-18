Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016329;
	b=3auFrJOVwQwi6lpsZSI6hPH59yGYQBbMVz+a9k2hGaAzi0NMIMESSkwPzUj/o2krYzJ4
	 B0R9FOJGBizMyN91zJFa+0YGwdSXeUvpop7BNRDtknNPlM+ELcx6+6ol8C1txV2kHaJFV
	 oJIc5ZjqUtUvP7ItSQpEBVNjHCLy5gFyWfjurIKXQLhKiUGTnKuL9cdFx649NjFium/E7
	 R1gd0bMn0PhlhUgMO7PS4sX3rLAjF/zM8P5qYS3FpYNKuuh5zsPukCLKDg7+Mzk2uSOu9
	 RTdlAmPaDPO5pJXRxTp4XBLF9zT4fNf8V/omxWWRxFm72Jv5VXaYqYmSKm9rICjiTGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A3Q7y6FAAEMHnwVlnZHkSFTVeV5NrEberMihnghmnZs=;
	b=MCGKEq7Q8FyzFu32V+43eWMhf6bY9qtTEmBXKDrvKhKiH7gB5NazhAXkOji6sSz1bKTl
	 yLTD5JxhhxpgESoQSzyXZk0KPAh1tXKQA3f16rUqCahaLw9FxtxpqCYMxkrmnqVTkUYA1
	 ccU+gGd7iQ391ppfxHagpXH0jTVV97pNxwAq3rGfcBlP1vOaARFTCQovWAg5dJWqhFvWa
	 2li0xshYWUmiEq+eGM+EOXnEPrkyXrnTyKkF+myEmnimncDqxX1SCcFA/Az4UMA6aBZMw
	 muCzuGzuEUikeyRLZLnyxu4g2WUEKG4++yvQ3KSnBh3nhC9hGEAwtm8ORBnm7ePuY5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HJY/IzrR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CB60A260A;
	Wed, 18 Nov 2026 15:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJY/IzrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2341F000C4;
	Wed, 18 Nov 2026 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016328;
	bh=A3Q7y6FAAEMHnwVlnZHkSFTVeV5NrEberMihnghmnZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJY/IzrRnCGIsUC/nwdZgF5nvaImiF51/+1PDpS2nY28eBzdyEItzStCojLQ5rbOu
	 3fwtoGg3nJTKfNCyUE6yqRNO/zQQ4lMENLMhwncNZyXU0P72cwIy/6YaqwPh54F3rj
	 ESVFeRr783iUO9e6jteSFwsKLYSZmom2o83uI8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0490/2651] ntfs3: fix out-of-bounds read in ntfs_read_mft()
Date: Wed, 18 Nov 2026 15:28:50 +0100
Message-ID: <20261118150305.418155261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index fd844f9c556a8..d86c8fffbe817 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -213,6 +213,11 @@ static int ntfs_read_mft(struct inode *inode, const struct cpu_str *name,
 
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



