Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591146;
	b=UhUBR8dDDagNaWt01741GuMfk8J0zY/fTvU1FbPQ25Hod0dwLTxoyeHAKH5b2iz+K76Z
	 VtQU38vqTEWkJv9j4cyKkYquQn3EsXxWYKtuXt3RbPUwRpOfyAUt/55JGZ4UG0+WjO9wg
	 ztKpLu6rwqAu/98954bXxljuZrqXjjhK7m5WHyH8xAmOHN6z7r/Au0YfchFdWFo1GCQDE
	 7UsTwxjye36PaP/df7A0lA5rQr8diZm3zz2kTwrJmy4lFsHlQfIMkmKsgbPmS6nBXutDZ
	 6t5QM+zEVVdvY0diKe/Ii8xFyccpMDjFaQSUz25+5veqagr8M6J+oWObb3Qg/rHOn9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+SUPuG44bfFr66vThoYzy1Ogbu4xg5s2MT1IBIKiIA=;
	b=GsS2ALxx2SBXzIy8/kWdrsprVrkIpbm7dqdJ7vn+hJkmFJo49fnJyQANcus7Nm1AvIOE
	 ImPlJMJADuaUSpdJZEqzfh9gLqHEKILWMiA6putY71dmHYQawl4cvhcLryVnW8RAr1b/R
	 pjzQCq8jITLR2shjDGQmJvca+bCBEuFQHfcsDAXGbmA/WJ6gEhDB3sX4S9cmjKRmx+DP2
	 cBaGefjlMu+CTie78/b5ZQEOUR/OY6YtFkqtU4IBCzp4bHhlYhJJtsBPIRXJbrLZ46bCY
	 ZHSN9VVtEDWUF2AVEcVdkJutav2EhncaIDSf3B2fVfo7Ytfr4hCMPWFU0TB5nxW4WtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UsBosX55;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C7F6073FCA;
	Fri, 13 Nov 2026 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UsBosX55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084621F000C4;
	Fri, 13 Nov 2026 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591146;
	bh=w+SUPuG44bfFr66vThoYzy1Ogbu4xg5s2MT1IBIKiIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsBosX55sHyzrsPdvV6Vl2Tv3D/oWlzwsm4RcUEeGujSP5h73CypCZ09NiNt9SyFn
	 k/4pmsRQPgZCa/g/u4P4EQvl7NFZnW5UGKoPogqc9VhsYxSa4ylZJhg2mpiKdCmI33
	 A07vBhH5ilHhD3r5qS+tvej4RXlp5zavL79gAAhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/670] ocfs2: do not read the entry array of an empty xattr block
Date: Fri, 13 Nov 2026 10:47:33 -0500
Message-ID: <20261113153821.665781236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit cd7c3563a98fe8c984463d83772e518cb7e68356 ]

ocfs2_cp_xattr_block_to_bucket() sizes the name and value area it has to
carry over from the block's last entry, so an empty block makes it read
xh_entries[-1].  That lands on the header, where xe_name_offset overlaps
xh_name_value_len, and block storage never maintains that field, so it
reads as 0 and the copy runs from the header to the end of the block.

The bucket that comes out has xh_count 0 but a name_value_len of
blocksize less the header, and a matching xh_free_start that claims
those bytes are in use -- nearly the whole bucket with the common 4K
block size -- while the last block of the bucket holds a copy of the old
block's bytes.  Nothing but a trace event reads xh_name_value_len, the
copied bytes came from the same inode and were wiped before the entry
was removed, and ocfs2_defrag_xattr_bucket() recomputes xh_free_start,
so this corrupts the header rather than leaking anything.

Leave the bucket empty instead, carrying over the hash the block was
keyed by, since ocfs2_add_new_xattr_bucket() and
ocfs2_xattr_bucket_find() both read xh_entries[0] of an empty bucket.
That read is the exception ocfs2_xa_remove_entry() documents rather than
a new out of bounds access.

A block reaches the conversion empty when truncating an external value
back fails partway through: the "reusing" and "overwriting" callers of
ocfs2_xa_cleanup_value_truncate() remove the entry without setting
ctxt->set_abort, so ocfs2_xattr_block_set() sees a plain -ENOSPC and
converts.  The "growing" caller does set it, and the block form makes a
single attempt with no defragment and retry in between, so that is the
only route here.

Link: https://lore.kernel.org/20261024151012.1059683-7-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4704d96bce053..037ae2200c83d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4511,6 +4511,21 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
 	for (i = 0; i < blks; i++)
 		memset(bucket_block(bucket, i), 0, blocksize);
 
+	/*
+	 * An empty block has no names or values to carry over, and the
+	 * xh_entries[count - 1] below would be xh_entries[-1].  Leave the
+	 * bucket empty, but carry over the hash ocfs2_xa_remove_entry() left
+	 * in the block's xh_entries[0] so that the bucket still holds the key
+	 * it is looked up by.
+	 */
+	if (!count) {
+		xh->xh_num_buckets = cpu_to_le16(1);
+		xh->xh_free_start = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
+		xh->xh_entries[0].xe_name_hash =
+			xb_xh->xh_entries[0].xe_name_hash;
+		return;
+	}
+
 	/*
 	 * Since the xe_name_offset is based on ocfs2_xattr_header,
 	 * there is a offset change corresponding to the change of
-- 
2.53.0



