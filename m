Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063762;
	b=qQ9Bl/vIw4WbV53EqUJR5Z40dc85YkJVtZM21Y9yFQZsJhlEIStyT8GmyapmIbcDGAVb
	 jxkwYNdKiEpv89Hq4BR3zm48+c2lGKWiLo9zoxepYJdQFZymS6YdiAO1ZqbLK22m8TGBi
	 fvaBGHisTCzoriYoHCKBqnVgPVVCipxM9plVZmh81/fyksvKXvBBdy9ZCTEavAATjbNaM
	 s+Vw60pN5i6yKcQRQD62ALGzXqtSLs4DobthEp6ygx0CIUM1ixnS/jxSh5FP7ZfnddnR0
	 BL0Xtm0eJraolKWiT0hbWtOioIuU20IoZV5Vmk11Ypv7RglULzwIX7Ekx6k4iMkMMVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fDuBYK1zbIdOlCw8X2Y/vZ/8dG36WrZNJSZleCddeYk=;
	b=P4IkcHtkAUIP5SBXOXfnmenHTafR21pYEIPTQAvqD7qKcs9WMnctDa5dR8JrPJJVqd4d
	 WW9RZgneeQ1igQ3ANzuBdvPoea2+Ts/QE8/84uAjVQ4kWP7x+8qzQwqnXxNtDjxMyvO8e
	 Y71WkW38YKlc7EUL0oHtMlArrl7TKvYXlq7zlyPdhzsu+ZP3FYZh3SeXcfpTFtq3hHi1r
	 Om1CTPHN0ELL/HzJ/ZvgORCL7byQPRscu/9y5RnTK1FVw+ydaBglSmhuXt+XKxab44OnJ
	 87+Wj9A9QqhhD3AjG2+bkx9lCwE5hs4+TBXP5MIOYAgJdQFXEqgsqA5b8xXhbdkwdyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnNIoUVD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6F6083629;
	Sat,  7 Nov 2026 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnNIoUVD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE981F008A1;
	Sat,  7 Nov 2026 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063762;
	bh=fDuBYK1zbIdOlCw8X2Y/vZ/8dG36WrZNJSZleCddeYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnNIoUVDjhpyBQWz+0MIEl83MlbLgM4BgarRtX6Zk/hNbzKMgycRPu1Aw70PL+El3
	 RCDvB+SB0qP6w+nu/H8nhe7jJIIu9LeSwnc9D77r95uXgwL3VDG35vj2VX/rU/MNf3
	 6cuuFhSjlXbQksWrabhWVUBKLpdm2hPx+0rEu3Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 855/869] apparmor: check accept index + 1 is in bounds
Date: Sat,  7 Nov 2026 08:58:57 -0500
Message-ID: <20261107134921.755827297@linuxfoundation.org>
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

From: Guanglei Zhu <zhugl3@xiaopeng.com>

[ Upstream commit afe5d5a747393cb3d00795db31d7fce5108a766a ]

aa_lookup_condperms() returns perms[index + 1] when an accept entry has
ACCEPT_FLAG_OWNER set and the subject uid does not match the file uid,
so such an entry consumes two slots in the perms table.  But
verify_dfa_accept_index() only checks that index is within the perms
table, so a policy that sets the owner flag on the last entry is
accepted, and the runtime lookup then reads perms[index + 1] one entry
past the end of the table.

The perms table is allocated by unpack_perms_table() with a u16 size
read from the policy blob, so a crafted policy can place the owner flag
at index size - 1 to reach the out-of-bounds read.

Check that index + 1 is also in bounds when the owner flag is set.

Fixes: 6f442d42c0d89 ("apparmor: fix profile verification and enable it")
Cc: stable@vger.kernel.org
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 1e1792d3ff5a4..391665c27ede1 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1244,6 +1244,15 @@ static bool verify_dfa_accept_index(struct aa_dfa *dfa, int table_size)
 	for (i = 0; i < dfa->tables[YYTD_ID_ACCEPT]->td_lolen; i++) {
 		if (ACCEPT_TABLE(dfa)[i] >= table_size)
 			return false;
+		/*
+		 * Accept indexes for owner-conditional permissions come in
+		 * pairs, so the non-owner entry at index + 1 must also be
+		 * in bounds.
+		 */
+		if (dfa->tables[YYTD_ID_ACCEPT2] &&
+		    (ACCEPT_TABLE2(dfa)[i] & ACCEPT_FLAG_OWNER) &&
+		    ACCEPT_TABLE(dfa)[i] + 1 >= table_size)
+			return false;
 	}
 	return true;
 }
-- 
2.53.0



