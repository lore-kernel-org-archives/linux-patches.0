Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065579;
	b=3bJNWVXYpQ9WvBdmPJXiSl/VGsuP33lDjiYxNH2vA2FVODKB5I3fPwvaaX9H1QCyGocB
	 K8Z6NekPSlL5QEWILqDA3NhYO2N82aPWtZLILJUBk7XU/7MO6e7ewFp0yZgAGkSQF3yiH
	 Q+IcwMSHPTuUHryJMFk7YPfY/SbhheKWOK2Ry99O9TNo6zOhXULmz/2Azm7A+MSewZ9IF
	 SR082+jGnI/HllZUFaQ/31Bv0kDopFUleA+zttx8HVEsZ/W6Tw8Sm7L5ejX1xTfxekmHm
	 sqhcb/EncjZJjmJ62ZCmBZ5R24a7iGaaN2ubMEnwiKyONrPHd9s9kk+4w34j4sQvvsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LM3cTyyDYrPrKJed8rDtRjBWqj5AHz72yOuuszNWd08=;
	b=3fHKoAo5xb4Gqsyhg7LywXLI+wneP97TW1i/qw4zyOSGhRwuVmPJkm46o/PDWxe60hP7
	 isphuiR+xTPfOIldaD3ISIhNE7Uyo2dt9vZxp9J5Baoxl/B2TjFZuco19ZGisNZeYZxMV
	 nsXW6/6LpHRez3TMLNAwmq1j9rTKK6mzkOOMjBfg3C2XY1hr1K/EgAC8Yyn7c0T/MmuEi
	 F9TlLn2PnnO2UIUHTe77RC0FYkpF0EYk7SkPESgPf/CFoG+D/nayUgaYVa3NbaPvEIoB0
	 9qOYt2ZfJDwKnL9Udj0TIuOAx77FZ6PVBprrJS9+osQ6S5pmiTMl9hyeWqBDO7k+RZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnFRz1CW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA334606A33A;
	Sat,  7 Nov 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnFRz1CW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523CC1F0089F;
	Sat,  7 Nov 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065578;
	bh=LM3cTyyDYrPrKJed8rDtRjBWqj5AHz72yOuuszNWd08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnFRz1CWB0A0cUAeigy9g0bwA0B9V0EffzHwRDMHOHmeiguihUWuo00oZ5VVq0Aey
	 hxzubTI5MBrzi3EUiz88ICDsnW0RBJmBr9c4Aob5QaonpZldZYLVTi5z7h155KX7KY
	 s/Lly8kuNlJvFrghXzDIXnLUa1YFg63kzXad04Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1238/1257] apparmor: check accept index + 1 is in bounds
Date: Sat,  7 Nov 2026 08:58:54 -0500
Message-ID: <20261107135013.529007242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index f1fc48e72d0e1..1ea89e9c53fff 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1489,6 +1489,15 @@ static bool verify_dfa_accept_index(const struct aa_dfa *dfa, int table_size)
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



