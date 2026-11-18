Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054281;
	b=tdMMKk4d3UH6oMAne0wCLsuEXAtpYAhvXLwIKrlyp0emYRjOMgM++mrIOwuebLfVfB79
	 LJcBxuPf5n5p9zCrA5H/4HehXM1gg81KTpBfvMSls4S64jrrkbIZ/TUmk83Hu63vG0HnU
	 N3ywGnGCod+vX2RKNoo0/qXVg7R8hpsIW5nTAkxIH5WsCFvYIAJlhTgRLeot23rXmLKCb
	 e3oqLN2jLPkaVhSLpELyIl+VYITEtr6Qr+qqxd37kMxVSolkjGBZnKLRtWuYAWgYDOoIS
	 pc4eDSL/M4XUZTEqZEhKYX5sRyH0x7NuJRgO4jI594m6KSzypDBJ1e9pFos0bvEcbaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kXslL8kKWKPuXNTfXPevCu3FpgkRcxZWu7nFUWXenSg=;
	b=RHbLU3vlPyrQfoC7RzMS5lDzr5QQ9ZIggu5c2t2SamsRH7LrB3qJ+3kEbZKAVn5dQLTC
	 emYa6ej46hEWCRbtp3yn/cdfUZ1oA3iVDzIZHfMwgBHPCzbJKpqMWwoMuJfAf9sxpiqk4
	 t8ZgeOxMH2omrMoFjBbec9PLbeKUPNT9dibznRviZWAjKpafQDeVO0pX0WmB+OgU9jCtm
	 6lnR5AVnNg1yOLf2uMU/k4fWYBT4+xeT0RJtbQYwMzCcrCNnDLuC08g3d0JQNohPMG2KR
	 EVOw6qhGwh67rZhSEgHhSGCZgYCKD3XhOK3YMbZbaVdLc++C+1H01H2UuSBulAPVe8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbqieP0y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038F3606A325;
	Thu, 19 Nov 2026 02:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbqieP0y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A771F000C4;
	Thu, 19 Nov 2026 02:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054280;
	bh=kXslL8kKWKPuXNTfXPevCu3FpgkRcxZWu7nFUWXenSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbqieP0yh0ok+epKSUG2Ciw7U/X1UYEmHg9I/TqG3SeYTQ283CDq+pDsKPAX0qoS3
	 2i6CKVJyIJG5nullFjDWIYLJmh1OEOcHQrZURo3MWfM0FED7gCc4cgTt+u79z9IGFP
	 Ia2OZbIritxVqDGpJ4cst13/odIPhXImZJCapH7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1202/2214] assoc_array: dont lose objects when a shortcut is split on a word boundary
Date: Wed, 18 Nov 2026 15:47:58 +0100
Message-ID: <20261118150059.946261722@linuxfoundation.org>
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



