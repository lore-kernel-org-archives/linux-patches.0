Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217174;
	b=16C9sW/7LMV7aVN4f5vmVDPx1MKImKr37TeNsVuiP+647hAGCtOhFt6EnYnnzoueJxxz
	 SM4udhnB5FAe4t2gq1k+BZDpyE/n53Ee4+4R6CzNbAqBrZiZ5hnzZDWdSK4+c46f+9197
	 3Qf2+ME7+QiG29Zr/3yF+VUN11aOJSjUtVp2HwcQvnfD0cqo7vqo5ZO3Qrd6MA+73mBVN
	 CS0wnfcVAlUQJ8euEbQ7u8qhqbJVB8TCmW2+/K1++QhwQStJxGiyFIUQ38p4qVkoqzrk8
	 ywPLoUVYnRwk6mQLb2ViytwL6GFb6rRCa/0bO1D4zL8k6k5JLwRzHs0QBOa/biEWAjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sMbIb4Y2Uudv8NAw+AIPHZfRaj5L+7jhenXWuW5Lb4A=;
	b=veRLUqbDWyVsTcRAicpYs9sc9sQKReRw8li8H9gvDJdOzDUFdlOzZ5LCRjKkUSOVfemR
	 bWhpbHUkgGXL0FaECIO5u8rj946VQmt9f9TiN/3VEBunWNLzPG2qcTqfln0OOCYIRorJI
	 O4GeuIv9/PZe2/4wEj27yFx8vk1vEiq5Qkdt1jt4RwlZpT8lem//B+ewBE4LpqyZJ6crF
	 RyYbHtLnppgTJMq1LdSGL5W9KOBGLzRHJW9wM9/cITdWdPxr52t2paao2/yc3g0pgFW3P
	 p6Kcxf1ju9FEEkU5HLAwb15Q2jWEFp1UqmmiOIEFLKeCd9h/tSDkFxTN0j66G1LVTbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvVgfxsU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03B606A31A;
	Wed, 28 Oct 2026 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvVgfxsU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0261F01825;
	Wed, 28 Oct 2026 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217174;
	bh=sMbIb4Y2Uudv8NAw+AIPHZfRaj5L+7jhenXWuW5Lb4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvVgfxsUDfXj9pkTX0o4jBBj3wQO+gv2ebArbdh52/gmFKR7P9q30TN5n8MczXfa8
	 EyedL/lgGQ/wwD0vv+OBc/LUfHXX5zix60BgBy6lOQ46YlXpRbv0TJIonQNuVJPgEV
	 UHdZ/TXh141QyET6h1xG5SUhCsm5mMOLzkKrDdKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 1813/1887] asymmetric_keys: reject trust keys without IDs
Date: Wed, 28 Oct 2026 18:05:09 +0100
Message-ID: <20261028170540.703958992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -152,10 +152,14 @@ static int key_or_keyring_common(struct
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


