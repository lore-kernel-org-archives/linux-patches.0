Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047336;
	b=W+QLSWu8fXLHt99Z7DlYUDWKcUaQFKPUU0nHgazPQfc0guxKKJvZj+k83JvFY/JTMBg0
	 XNOn/DJHDpzaa6sTzJ/F/j1EH5IRjwSCGy+SYzS1zDnWTQHseOYJj6HhSlmzDWcRwuSeH
	 KZst3RM3zevkNtyY2Rb/AEcwJjGeCbyLW9xiHPWn02iic0uUXXQTTvIij6zuzd0EBBuOj
	 VZWmTJbdOShRGJh85nw5hBFdbpGOkEK5Tnhh0fExWvXUwBGACCXVFwsdcAP6/cPlC/iFh
	 q0kmzfpBOVu1z34WyFQ1UZ5wio2Om/0r7VKtnd9IhECuNAUILOxmZ/eV5r0y93zblag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/TndBeld5+RdvVrZePo2ppr44fBeLBnbIv+GkkhvbKM=;
	b=f8ouWLbNTm0bDQdXK/H3Y9oq0onJ5mOnim6h+Cr3Z1CiuVJYYSv2/UzaZ7qKS96GNBtH
	 9I3nfKn/tB2hg1rpswljECwg6uTO7KvGKt2IdoayAO+smffra3jjtavJJDNGggjk8Kh+I
	 V/tbHsX32rgspsN9WlLZFO6VQcywvQPZ50HNGNRC9qM63UBYEEtzdS7MVkVh2kl6/AC9q
	 luvwdMI52yJeq+9g6X2dnJuqDzle5wmTlvyzG9VLBGgUcpc9vnGiXTc8AV5WjKuqmxMcT
	 yPr5RuqSHrnG+G2cjHwQMNR/6CHGPohC2bS+6oC6EpflMB72SYDksGG8lPqWn2w7eOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sh+MnH9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A0606A31C;
	Thu, 19 Nov 2026 00:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sh+MnH9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86201F000C4;
	Thu, 19 Nov 2026 00:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047336;
	bh=/TndBeld5+RdvVrZePo2ppr44fBeLBnbIv+GkkhvbKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sh+MnH9x8DdO+rdmRc93CxCSb3aFkMlt5hmV6Bh/dzRu3I7C4BYen1VzciXtEGinH
	 SMZ5rONEeSItEO7Thj1eaimx4FVywS4iBQdm53Ro5UbcIzX6kYqXInx3c7yeRQFFeZ
	 n9WQOv3KrsFeA8H48u61hiGqJvCIdhwR90XrfqO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1603/2857] assoc_array: dont lose objects when a shortcut is split on a word boundary
Date: Wed, 18 Nov 2026 15:43:57 +0100
Message-ID: <20261118150259.085382177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 2a62c32760a8fbf464a7388853d19bc62c5cc423 ]

When assoc_array_insert_mid_shortcut() splits a shortcut at level diff,
the new shortcut in front of the split, new_s0, gets the first
round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE) bits of the old shortcut's
index key, and the bits from diff onwards are then cleared from its
last word:

	blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
	new_s0->index_key[keylen - 1] &= ~blank;

When diff is a multiple of ASSOC_ARRAY_KEY_CHUNK_SIZE, the shift is 0,
blank is all ones, and the whole last word is cleared, although all of
it lies below diff.  A walk then compares the key it is looking for
against that zeroed word, takes the shortcut to point elsewhere, and
every object below it can no longer be found.

assoc_array_insert_into_terminal_node() trims a new shortcut's key the
same way, and only when the level is not a multiple of the chunk size.
Do the same here.

Found by a userspace build of the array with a test that inserts, in
order, string keys whose first word is their length and the rest their
bytes.  The 102nd key split a shortcut at bit 256, and 76 of the keys
already in the array could no longer be found; AddressSanitizer also
reported assoc_array_walk() reading a word past the end of a shortcut's
index key.  With this change the test passes, and AddressSanitizer and
UndefinedBehaviorSanitizer report nothing.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 65409f0d2e0e5..62e35116db19c 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -866,9 +866,11 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 		memcpy(new_s0->index_key, shortcut->index_key,
 		       flex_array_size(new_s0, index_key, keylen));
 
-		blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
-		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, diff, blank);
-		new_s0->index_key[keylen - 1] &= ~blank;
+		if (diff & ASSOC_ARRAY_KEY_CHUNK_MASK) {
+			blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
+			pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, diff, blank);
+			new_s0->index_key[keylen - 1] &= ~blank;
+		}
 	} else {
 		pr_devel("no pre-shortcut\n");
 		edit->set[0].to = assoc_array_node_to_ptr(new_n0);
-- 
2.53.0



