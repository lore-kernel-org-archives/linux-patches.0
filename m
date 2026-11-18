Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021558;
	b=rdMyeP6c09O90XYvufZ00GijcTo9Z2VJsXGzd9JuJeK6Ut64p9vPQW8fiTa8Zq0wxa9i
	 o8uBUMrq7+RrTM6Zmn/nxk9Qj8rPozKCCVn+qC11ZH14oraQVGIz3/ELpgvlid/XwO9YD
	 EV4iaViagq/A5FcSRixYiEjRUfVDmFFNVMdCUhC/Sm5rlfc6YuvbCv+On8Y/t4Sr+8ZpD
	 M3zzr5JRqEG48FagLwpQSSQRkHJigk8a+OBTOJ/3pLBfY6+heoWSTlaaQubmIv2MWtOPd
	 bDAL4tJwTMfNNPMfJ+5IjdZ9kLYNTgiNm0SHW2//05i5x5CSwVFdV0xukSK47hl/qJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2oQBDprIMwvtXzxEK2Jy//Oa6FxM+/UznOMOaO6JqE=;
	b=XK+AC7rRn2pOmu/js677Pvi45vIZd8woUskjk0O+eExfCeXaaikUxiDQHMIrXdhTsfAM
	 UnZ2sC4XYzsc8TJiqo9YL19PmeIQnjelFO+M+kvfvW1WL5DQZD7BB2V/YnW3a5IAHoiwW
	 5uzOI1o9Rr+78oVPCDd/DP05KAkUt72IOTv+gvocZx5YZPOZhA3oOwKxTcZMEFLrDBNYY
	 uC6UNzSlTt7xh/RgsguHiqhQpZB7+yRZsbkn+qncXAcmNMA0aOf6SWMFCq63mKvMSPX0C
	 KBwzF6NbTl/P/KlrVyqmOoareljR4qQEzh0FO8APhhhvfcPNoKSgZh+Dy8RIRETI4KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8zNE1Ul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0E6606A31C;
	Wed, 18 Nov 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8zNE1Ul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4531F000C5;
	Wed, 18 Nov 2026 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021558;
	bh=F2oQBDprIMwvtXzxEK2Jy//Oa6FxM+/UznOMOaO6JqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8zNE1UlkzBCkdkLiJWKBiDEp2zRufr4ddF4gUkkmFau1qmLyCrH0zTzHfyymSnW9
	 PHep6C2PeZBOyXYeX0PEX4ZVCWDdmbVp2S9pXL9+xPHPB2+bkiF1zSMGjnJ+CeRXqX
	 UbQqakQllyq/FrHPOdZMPvqZaa2ROWHJ3zXG5uxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2349/2651] ntfs: reject index blocks with a too small entries offset
Date: Wed, 18 Nov 2026 15:59:49 +0100
Message-ID: <20261118150409.626048786@linuxfoundation.org>
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

From: Hang Nan <2122295973@qq.com>

[ Upstream commit 20e14268ef410cbabff54a79405813a8b9ce8e89 ]

Index blocks read from the volume are checked for a plausible header, but
nothing keeps a block from placing its entries closer to the header than
ntfs_ib_alloc() does when it creates one.  The allocation adds the update
sequence array, one entry per 512-byte sector plus the terminator, to the
index header and aligns the result to 8 bytes, so the first entry of a
4096-byte block starts at offset 40, while a corrupt block may declare 16.

ntfs_ib_copy_tail() then copies the entries that follow the median entry
from the source block into a freshly allocated destination.  The tail is
sized as index_length minus entries_offset and the median entry, both from
the source, while the destination only has allocated_size minus the
canonical offset of room.  With the values above the tail is 4040 bytes
and the destination holds 4032, so the last 8 bytes are written past the
end of the new allocation, with contents taken from the mounted image.

Reject such a block when it is read: entries_offset must not be smaller
than the canonical offset for the block size.  Derive it from block_size
rather than from the block's own usa_count, which post_read_mst_fixup()
treats as "not protected" when it does not match the block size, and use
the same helper in ntfs_ib_alloc() so both stay in sync.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Signed-off-by: Hang Nan <2122295973@qq.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/index.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
index 03de4c97c1620..9a23d0786959b 100644
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -489,6 +489,14 @@ static struct index_entry *ntfs_ie_dup_novcn(struct index_entry *ie)
 	return dup;
 }
 
+/* Offset of the first entry in an index block created by ntfs_ib_alloc(). */
+static u32 ntfs_ib_canonical_entries_offset(u32 block_size)
+{
+	u32 usa_count = block_size / NTFS_BLOCK_SIZE + 1;
+
+	return (sizeof(struct index_header) + usa_count * 2 + 7) & ~7;
+}
+
 /*
  * Check the consistency of an index block
  *
@@ -548,6 +556,16 @@ int ntfs_index_block_inconsistent(struct ntfs_volume *vol,
 					   offsetof(struct index_block, index),
 					   inum))
 		return -EIO;
+
+	if (le32_to_cpu(ib->index.entries_offset) <
+	    ntfs_ib_canonical_entries_offset(block_size)) {
+		ntfs_error(sb,
+			   "Index block: entries offset %u is below the minimum for a %u-byte block: vcn %lld inode %llu\n",
+			   le32_to_cpu(ib->index.entries_offset), block_size,
+			   vcn, inum);
+		return -EIO;
+	}
+
 	if (ntfs_index_entries_inconsistent(vol, &ib->index, cr, inum))
 		return -EIO;
 	return 0;
@@ -960,8 +978,8 @@ static struct index_block *ntfs_ib_alloc(s64 ib_vcn, u32 ib_size,
 	*(__le16 *)((char *)ib + le16_to_cpu(ib->usa_ofs)) = cpu_to_le16(1);
 	ib->lsn = 0;
 	ib->index_block_vcn = cpu_to_le64(ib_vcn);
-	ib->index.entries_offset = cpu_to_le32((ih_size +
-				le16_to_cpu(ib->usa_count) * 2 + 7) & ~7);
+	ib->index.entries_offset =
+		cpu_to_le32(ntfs_ib_canonical_entries_offset(ib_size));
 	ib->index.index_length = 0;
 	ib->index.allocated_size = cpu_to_le32(ib_size -
 			(sizeof(struct index_block) - ih_size));
-- 
2.53.0



