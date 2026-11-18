Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054311;
	b=DLwX0wRUh/nlIOZTdtOyCoKOjUQQRGPFckP5JlTbx8qsKD7BjgNLvgnLaM/9omaeyfCy
	 wCCTwf0HWJSawvnM2hVJ+tQQEyxmDUQX+jJhpVFp/4RIwIIbMB2J5y4CZYKSSG2M7ZXZu
	 1AjzT8I3hST33ZcmLIjSaK84hC2nK09hT+NFTtFeOlFFjoYUxLtjNfz4Gt3ydWmVjU0JG
	 jr85vZuqRXvmVnghDCtOfo+QTag+1jyUoYJMc5vP51KRAWvU3Zru3ZA016WuFn+N1xj94
	 cc+3xccjsLg10i0NUDlNGcW9/J5Pl1sD6L+d3iGfx4pBAzDRuoPbM+xCSiiJUWNKe4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PS8kevWysaMtY5Dv+Nmh+XsqhO+Ya52lFyFJN2pPJvk=;
	b=1W4FdgGTD78cRGJhip78R6/yBQ5umRx71UVhp8gyrJK94D5QQOFgcIUgxVeLu6hi3Qm3
	 AAUmhAGsP1dK+DnwgE2cD1lQjbefHKmRvrcPX76dLZhu7cVXEFAkF5NK1eb3Qz4x6Uqa1
	 hY52CgKCFkEPZbaKbhKGe0Q6VTVnQ9wZXCF/+2oRR8A14teWsoIgWKGTXV4LyVfO87oZV
	 bi7Xoc9iU1Ii63rn3NT6V7lHaPyJrz7aycREME7BE6lAD3n4BmW8ZeL3EslPYF7WHJVrA
	 Gh0UJGDHcRtrb5hmAJGTU9oNlbD+dgyccuvl3avSL+dW5lyAenw5m7SRs4M5yUrx0UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXL17ZzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD3606A31C;
	Thu, 19 Nov 2026 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXL17ZzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50211F000C5;
	Thu, 19 Nov 2026 02:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054311;
	bh=PS8kevWysaMtY5Dv+Nmh+XsqhO+Ya52lFyFJN2pPJvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXL17ZzRmNRTg7x/xvj4bRufRaycCAretp4V/nzlifiM1lMluWZcVcsajYp1jSoDj
	 3toAtKZzmc+htXmwySm+XK7SY4wecQqcFdmreOks/sZN+YctICM0wnknBHrHIwrIRR
	 q5CPs98iVPhHWzuKeAJ61VzM7OZ7c6NHLNWETciI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1203/2214] assoc_array: dont lose objects when a root shortcut is split at level 4
Date: Wed, 18 Nov 2026 15:47:59 +0100
Message-ID: <20261118150059.981284678@linuxfoundation.org>
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

[ Upstream commit 20b436c1ae8d37032f888c725915729830dc52f2 ]

assoc_array_insert_mid_shortcut() takes level, the level of the node
holding the shortcut as assoc_array_walk() reports it, and adds
ASSOC_ARRAY_LEVEL_STEP to get the level of a node in that shortcut's
place.  If the new key first differs from the shortcut no further in
than that, no shortcut is made in front of the split, and new_n0 takes
the old shortcut's place directly.

A shortcut at the root is held by no node.  assoc_array_walk() reports
level 0 for it, and whatever takes its place is the root, which is read
at level 0.  So when the new key first differs from a root shortcut in
bits 4-7, diff is 4, no shortcut is made in front, and new_n0, whose
slots are indexed by bits 4-7, becomes the root and is indexed by bits
0-3.  Objects already in the array can no longer be found, and the new
one lands in a slot its key does not select.

Eighteen keys are enough: seventeen that agree on bits 0-7 make the root
a shortcut, and one that agrees with them on bits 0-3 only splits it.
Three of the eighteen objects can then not be found, and inserting one
of those keys again adds a second object instead of replacing it.

Only add the step for a shortcut that hangs from a node.  A root
shortcut split at level 4 then gets a shortcut in front of the split
that ends at level 4, as assoc_array_insert_into_terminal_node() already
makes when the leaves of a full root node first differ there.

Found by a userspace test that builds a shortcut ending at every level
and splits it at every level inside it, from the root and from a node:
every split of a root shortcut at level 4 failed, and nothing else did.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 62e35116db19c..e7c9a2f513114 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -843,7 +843,8 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 	 * zero length - otherwise we just connect the new node directly to the
 	 * parent.
 	 */
-	level += ASSOC_ARRAY_LEVEL_STEP;
+	if (shortcut->back_pointer)
+		level += ASSOC_ARRAY_LEVEL_STEP;
 	if (diff > level) {
 		pr_devel("pre-shortcut %d...%d\n", level, diff);
 		keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
-- 
2.53.0



