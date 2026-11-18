Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035976;
	b=AzTB6wn2jHWLDv0qvhDPU4XXbAOZFsi4+Ikv2PQUe+EBEGQ59/whtwzeoorctfnYIq71
	 L2zoWHC1LGvsaXDZcEkqdPMTPS9TAY2L0ZDGMimcmYHOwmB1z/SoHFV5VAxj7yckgdlYM
	 w3HTVxXNHJabL2XhAZkCql4r5XM9VhDMFKs6y7vjuTKgCGYcAzprw+baxL9X0ymTCCC5r
	 XJopgMn8pvBl+ZkMY1JNoxEEaPQ4ozpBJtG1BOj+jInS1nOBxMGJwBERy8ktzELMb4Hsv
	 P1wQvPLzPIVbKrj1yjvlra2E1UXXOOiqEIbvQgeEXpzrUn6mjf2eIYDQ9vwYors3PHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T9UMjfq4UXlEdHP1H727Fgmrl/UIq0c9hisw322gifE=;
	b=wnFvveDdTg0htV4ORvtJm1m6xG30nG6WpKFy7vFY4EC9AUFBK71X9UypP7EjSuuOo1sX
	 TxiIzXQ4C8IOA/xzSuhQNn6hMBCmLM60CVEydQmfozzOCpdwjTrlx+xrwSYa8eM45cBDh
	 2ISTFmi/Bd8QKwjXHSVESq3x4+SQki6Z0L/HoLj7uA7Mr80eYbjrh0mFz8ue6iitBr7mn
	 UxPue+7ymL1CWEmoUHZbFEt9nimZwgQ7cv4hM9asSIJ0/KLvVAoMcTIwb1VRC/0mieVmB
	 d8p23g5BYha7dhZ7gsnh12IQOu3WuMdSsTC7DBWqD94j6rjiw/enh9GLXnOPVUH5vsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzV+N+9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C71606A335;
	Wed, 18 Nov 2026 21:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzV+N+9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C4C1F000D1;
	Wed, 18 Nov 2026 21:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035976;
	bh=T9UMjfq4UXlEdHP1H727Fgmrl/UIq0c9hisw322gifE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzV+N+9fOYcR1p3mIW8xSO4cAypc2Fd6ngN3RUnN9DizDF/v3SVarIpCGkqnZaHTx
	 Iqru0IeMi9PK1FG+NcBf4fF3lImb0cAddoA9fh5SWVaYeUqhAhxLQOFZtZttW2L/7w
	 HxfHmq7aX8yh1R0vNSlObu1/w1Hr+P9LCF3E1/eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0877/3318] ntfs3: bound index head insertions by buffer capacity
Date: Wed, 18 Nov 2026 15:24:59 +0100
Message-ID: <20261118150345.621512445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d1e45ff4a2457..632e526187048 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -596,6 +596,8 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
 
 	if (!e)
 		return NULL;
+	if (size_add(used, ins_bytes) > le32_to_cpu(hdr->total))
+		return NULL;
 
 	/* Now we just make room for the inserted entries and jam it in. */
 	to_move = used - le32_to_cpu(hdr->de_off);
@@ -1802,7 +1804,10 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	}
 
 	/* Copy root entries into new buffer. */
-	hdr_insert_head(hdr, re, to_move);
+	if (!hdr_insert_head(hdr, re, to_move)) {
+		err = -EINVAL;
+		goto out_put_n;
+	}
 
 	/* Update bitmap attribute. */
 	indx_mark_used(indx, ni, new_vbn >> indx->idx2vbn_bits);
@@ -1954,7 +1959,11 @@ indx_insert_into_buffer(struct ntfs_index *indx, struct ntfs_inode *ni,
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



