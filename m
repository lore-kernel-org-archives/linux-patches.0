Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207357;
	b=ZkNP7bTXYLkgrdbHEmQBf5WGtpxKA9Gw7vA4vcqk/xgTsKD0z6M0gi509ZNqfVOP6m4g
	 RyiazSzvfoRK4dh2RC6478izfRfwaWVL9VmKcc/AaqPCOV9A+h4MPamLWwXhHfM292Xh0
	 Yi7M6iDRmLSbWmS2fb0MMkBPuvQ07bXb2h7l6imTJ44RlJdkre3e80VOW+ZGK290wUyKo
	 AmcBa3N/VL+fK4XmvE+NCHBdxZ7YYEVLVRJVXpTDMgCZTRBpXKeIRdt6QKHZ6OToJtCzg
	 QfasRv+M1QeJxecwGbu89IktwDngANYpysU0h2DCqQyqGqLq04M/gZ6A3rDWhxWx5xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RO1SeMmZPm/uK9jwyO8wWGKguci0W1WLDslbyJ/oxIY=;
	b=acyGLFQoeqyLlnastAx4OrvVymSzdG7KCWI9oKGyTnak4dT30okOSpgSs7OrhGyX6zYz
	 gH4PCTWbZbBgdSqZDyX621PsdpLoOHPi7lOk4xqbIax8YkOKvJOmj+6bbbKM4B3XTgw1M
	 nf1MQNstn+9jhg9tducZ6P4BBoALuA97srpyqg/IcWhe4J8xR0eY7t/X9CbLHgsubxI4W
	 +YThmsejj4R0IF4pDk2dzEF4TMmKZ7OwR/fcwekfiy3Sa4LGW1lcBdfGnXeZmt9Ci3+KZ
	 qEII+WZ9grUicwKofTKa5YN7ao8KZyoGyTW+le4QuoBVr81JM5KjkQ7/4myBeA6tCqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMoWGezA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C9A606A31A;
	Wed, 28 Oct 2026 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMoWGezA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A141F01825;
	Wed, 28 Oct 2026 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207357;
	bh=RO1SeMmZPm/uK9jwyO8wWGKguci0W1WLDslbyJ/oxIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMoWGezAeynw3/qT/vqAoSzf0DFTVV73KyQ5imQhJFW6eYt4bAX+K3v9MoJ0wbT4G
	 o3IxD8Z+KMZ+DDyN1gLTJcPNX//NsmIhz0UmUMaH9rFRCV66xlxYAyGvWCXkzmf4rD
	 Wi/v8iShSS17q8GVoxwySi+Sb7IJRb+RYxFkaU/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 78/88] asymmetric_keys: reject trust keys without IDs
Date: Wed, 28 Oct 2026 18:00:26 +0100
Message-ID: <20261028165943.950834603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,10 +243,14 @@ static int key_or_keyring_common(struct
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


