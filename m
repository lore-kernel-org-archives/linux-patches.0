Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210338;
	b=WoXfEMwg4+RNsnG+LX0b0NOSyGtVODuQVCu017zkPnPEhzCBUldjp3dPboqTEV1CvZFQ
	 Qf03fnn2/2fr+cT/irc5gUdThBzppyS6aelxcd/xAJChd1t0MRtmrrNyTn6/0I3g7fcbm
	 JfboMRdj5L3TlhRf1aGeQnI15M5uIqhQuCd9bEZs53q/+0+0cgsuTvJwuXT+iIzyUha7U
	 TF/viv6wju23WiKtYsGfd8mn/1Gfa9Jj9bSK+lZRtSqA9HJN3iYq2BF8eFCUwTuNG1QeL
	 OEiSo0R9w6DBQZr2KwZUDDRUWP2gZvaM+fs7K+AxhW9zU2vJkoI1P32O6d4FSezVNTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vy98fDSQygXzGHHV/qCFdoyrSE7FZvWAg2Qc28IhVtU=;
	b=bvYtr3Kr12vyEVH2UAQlMHQmdXIDB71RJCsvYRTqJeF+ahbxVXFysVBjfuP9VZeRKHJJ
	 AM0pVLqUfHdWsLz2yV0HvmyoJAXVLsLGSVtKxV7QDrFpA64KC6mo1yMjllu0NQkyacFN2
	 AkyqbMuStL3nnl2zeWvt6tABPXjDDoxd9NLB+Y/YlJOzUMwRjKPuewckgfoYJn9aN8IZZ
	 DHfQ7YUsklAe74YKzpTQoL1EcfOYm5Z0ItpWlOGyq0o54iYo1Kr1p/e6tyGsuzVLNOHOV
	 ud/9jssV0PFbVY6ekSINdKuDNweZG8VnELvAex1rx036lRpUg0wnmEZSfH7gQtPLL/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xs0vnfzQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB961606A31C;
	Wed, 28 Oct 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xs0vnfzQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A861F01825;
	Wed, 28 Oct 2026 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210337;
	bh=Vy98fDSQygXzGHHV/qCFdoyrSE7FZvWAg2Qc28IhVtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xs0vnfzQoTaWZibZPBzDN5IZSIrWLCiJ8VIDNZrgFF1LZZF2HCyUQYY5w1RklCxBf
	 U2ar35BAA9SDg9k1Z5YGakLn5BI2+7aoQIW7RQHQrtv2DP7TPGwG0f9HOy5DivM2yI
	 8fHIxpdY82LzK5+9zvPmcrWTNz22osNgic0nudEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 161/168] asymmetric_keys: reject trust keys without IDs
Date: Wed, 28 Oct 2026 18:01:37 +0100
Message-ID: <20261028165946.898930029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit 9695df3b1db4ac4534274d38ee16e3b9b0bf910e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/restrict.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -236,10 +236,14 @@ static int key_or_keyring_common(struct
 			if (IS_ERR(key))
 				key = NULL;
 		} else if (trusted->type == &key_type_asymmetric) {
+			const struct asymmetric_key_ids *kids;
 			const struct asymmetric_key_id **signer_ids;
 
-			signer_ids = (const struct asymmetric_key_id **)
-				asymmetric_key_ids(trusted)->id;
+			kids = asymmetric_key_ids(trusted);
+			if (!kids)
+				return -ENOKEY;
+
+			signer_ids = (const struct asymmetric_key_id **)kids->id;
 
 			/*
 			 * The auth_ids come from the candidate key (the


