Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619675;
	b=MBHmEcNOP3pXn2gKIX7NiqXMymth68X9xgZQswXZk5cHZ7vmJ9uj/dJXEKJ590m2qvBx
	 9+DdSZuB3/Or9M1bMkZgoapgpgwFdwVJMp3udjuyW4QkySNtvBOyeoD09zhDxgPDG+juy
	 iRNhe8IhvsRmGBNjmfEb+nUbpntCmJufmXZ7S94U5jaLUBzfVH8hjAntGHlNDHFrUh39E
	 LgV8bqJe87z/HZNgWEt18t9zWUm1LPmVbz2wqGXOd9vhb3GZw48oeM5rl10sdJ+iUesPv
	 j/p5sqaDmwDXGpwGV3P0hZyRDmoGsn31k053++qdvL7LpnYo9oh8bx1NIZhWopWoqRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O//+f9tA+6eZzRKBRPJCT+Ps23LybXdvBlDBvkPzCZk=;
	b=cr+S+KjAlKYguyBnbLM+4cOOeFNgjLLuzCf7o0aozD5qNh9Esw5hNfGSfjSc+KPaiNe5
	 /FIF4ahBPmhnmdRvmRH8w/9dMH1OfpLpswLHXHpA2hwv7b2KXf4EvRA+DgRYrbV+YeuWV
	 D1ingd4RQo7FZsW/z7mFewHQqGXThtG/Qqdn2e2zHro+jcNxoUnfz7cxLsW4A2Nzzn6iz
	 g3MvPj8fH7jBOhENp9zjC+duhNf2HHKspKwfJDRs131Gbzm2RKoBNmQu+BVVYy6jMx+M5
	 PBTDBG9BEjQSlb0c+ogifG880gGRCEpKq1k34nlJWwXZvI9vlumqwBCVjt0b71GDCDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmeAgN2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D857606A6AA;
	Wed, 25 Nov 2026 15:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmeAgN2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688AB1F000E1;
	Wed, 25 Nov 2026 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619674;
	bh=O//+f9tA+6eZzRKBRPJCT+Ps23LybXdvBlDBvkPzCZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmeAgN2khmmIRynKcqI0Qq3Ee8hSx3bsAjN4w7j/8cxlmvBkcT/PgsO3br0s07k6a
	 GZPU9JcqHG22BTk1aOOrhgY5erRgqTU3im9KH7W/f3qZhxr9w8H8ZFjU/cOseqtfih
	 yK+n/3wsdmMwNkeDR/wbU4GZdEnPZxjHCjYK5bk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 0673/1005] ntfs: do not read an index block outside $INDEX_ALLOCATION
Date: Wed, 25 Nov 2026 15:33:31 +0100
Message-ID: <20261125143837.518522298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Wahid Khan <wahidzk0091@gmail.com>

commit 0ea30dd6eeabc09235d5c2cdb98ca4e0d593963f upstream.

A directory whose $INDEX_ROOT has a child node but whose
$INDEX_ALLOCATION is missing or damaged gets an empty index inode from
ntfs_read_locked_index_inode(): size 0 and not non-resident.
ntfs_lookup_inode_by_name() still follows the child node and reads a
folio from that inode while it holds the mft record lock of the
directory.

Since the resident iomap read started to take base_ni->mrec_lock, that
read waits for a lock the caller already holds:

  INFO: task init:1 is blocked on a mutex likely owned by task init:1.
   __mutex_lock
   __ntfs_read_iomap_begin
   ntfs_read_iomap_next
   iomap_read_folio
   ntfs_read_folio
   ntfs_lookup_inode_by_name
   ntfs_lookup

The task never returns, and neither does anything else that needs the
directory's mft record.

It takes one corrupted byte on an image from mkntfs: change the first
byte of the type of the $INDEX_ALLOCATION attribute header of a
directory with index blocks from 0xa0 to 0x00. The first lookup in that
directory hangs.

Check that the index inode is non-resident and that the vcn lies inside
it before every index block read, and fail with -EIO otherwise. This
also rejects a negative vcn, which was only checked on later descents.

Fixes: d9e00c457d4a ("ntfs: serialize resident iomap reads with mrec_lock")
Cc: stable@vger.kernel.org # v7.3+
Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/dir.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -308,6 +308,20 @@ found_it:
 	ia_mapping = ia_vi->i_mapping;
 descend_into_child_node:
 	/*
+	 * The child node has to be inside $INDEX_ALLOCATION. A directory that
+	 * lacks the attribute gets an empty index inode that is not
+	 * non-resident, and reading a folio from it locks the mft record that
+	 * is already locked here.
+	 */
+	if (!NInoNonResident(NTFS_I(ia_vi)) || vcn < 0 ||
+	    (u64)vcn >= (u64)i_size_read(ia_vi) >> dir_ni->itype.index.vcn_size_bits) {
+		ntfs_error(sb,
+			"Child node vcn %lld is outside $INDEX_ALLOCATION in directory inode 0x%llx.",
+			vcn, dir_ni->mft_no);
+		err = -EIO;
+		goto err_out;
+	}
+	/*
 	 * Convert vcn to index into the index allocation attribute in units
 	 * of PAGE_SIZE and map the page cache page, reading it from
 	 * disk if necessary.


