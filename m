Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057214;
	b=W+j6lHCUD1EbaKlDGiA7zNiT24mckfA/LsUaVRCPWKbwGWxjbBVc4bcm2n71wmvRLGu9
	 +vu8Po3KtnYR2OlrdZdBZZrgYTFJ84/WamYBl+4ZH97tPCX47kPNeWYZlLj/GnD87SHgS
	 3SrkQwk6cf8E4yYfmK3Jp63HlhBmhStq0UPXGC6iyucPjcguhJiy3M9VlI5HIo1uIdWO3
	 2O7ZVvba8XUMJJrjmCo7OOMuchI8Q0+7jxQezJjp5LReaQj7k4yjwFqrMtU/hE8Qoo5B5
	 n6Knz60aOdolyzszzyHYHyjRn353bNFv1RAoqM8lMwthB1j1AqBetpoOQJn0NRjISaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PdK/8ikoWl6BiHFk0iq/gcBxeUJywmDpqU/CWQmN7zo=;
	b=2Iwt2PKJX/4OSv0zw3dwRXYS/stFTvyC3Lh4tVlE5RybYAemki2Png9s26Cvwnge149J
	 LtSGPNDxwBU7tQHxP/HY/1D/9dhfon7dTq20ybuI2pjsQxUdPuSQoZLnR4Pup/L7p479g
	 IKpHKj2A6v1sJ5MBrI1apoH0occarp9ZFC/sDFtKMx/5q2mChf6vnLwwyrXuiwJ2qK1mb
	 7+4918+eUCq+Jfb8uoT/do4sc4A2lubPTtB2cahYlZg9XERA7cHa4rLi6dufD1d9FMG5P
	 MLXzAyvp7PfatJMwIOsMh44HaSR7GVkE218jX6ClTK+vCm77Y4oPGTfQXOeP7dv40LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjuomomd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A4F60A2606;
	Thu, 19 Nov 2026 03:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjuomomd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5F71F000C4;
	Thu, 19 Nov 2026 03:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057214;
	bh=PdK/8ikoWl6BiHFk0iq/gcBxeUJywmDpqU/CWQmN7zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjuomomdSLvRGr/fSH2BOzQd/7SzWV0CjHIhTCVD0S7cy56/SYXwXPCPoj+ha1xuM
	 DgIopIQy1Mc8wh3PMdsOVBxbWu6KDKRyEBs7b1phnnVj2Zt3plnjiJGWLnXQLqMFCw
	 hpn7iwZVsll4NgMpkStsRC+AjHa+a4YI13iKSDA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0009/1848] asymmetric_keys: reject trust keys without IDs
Date: Wed, 18 Nov 2026 15:34:07 +0100
Message-ID: <20261118145911.596141088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 9695df3b1db4ac4534274d38ee16e3b9b0bf910e ]

The PKCS#8 parser deliberately leaves the asym_key_ids payload slot
empty. key_or_keyring_common() unconditionally dereferences that slot
when a PKCS#8 key is supplied to a key_or_keyring restriction. Both the
plain and :chain forms reach this branch, allowing an unprivileged caller
to trigger a NULL pointer dereference through KEYCTL_RESTRICT_KEYRING
followed by add_key().

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:205 crypto/asymmetric_keys/restrict.c:279)
 Call Trace:
  <TASK>
  __key_create_or_update (security/keys/key.c:884)
  key_create_or_update (security/keys/key.c:1021)
  __do_sys_add_key (security/keys/keyctl.c:134)
  do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>
 Kernel panic - not syncing: Fatal exception

Reject an asymmetric restriction key without key IDs. A PKCS#8 private
key cannot identify the signer of a candidate certificate and is not a
valid trust anchor.

Fixes: 3c58b2362ba8 ("KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/r/20260429181629.110802-2-bestswngs@gmail.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: Adapted the null check to the existing signer_ids structure pointer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/restrict.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index 77ebebada29c4..45b7fe05d84ef 100644
--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -154,6 +154,8 @@ static int key_or_keyring_common(struct key *dest_keyring,
 			const struct asymmetric_key_ids *signer_ids;
 
 			signer_ids = asymmetric_key_ids(trusted);
+			if (!signer_ids)
+				return -ENOKEY;
 
 			/*
 			 * The auth_ids come from the candidate key (the
-- 
2.53.0



