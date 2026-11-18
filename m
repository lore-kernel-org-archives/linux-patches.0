Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034736;
	b=wmu7y+ZiP8AX4sbtgWsSOfqARYjkJr17+G9DpwO1nNlFo+kwqaIjcoEb1w1uq52Sjzuz
	 LT8KEN8iacJA61FGgfLvlxglG6l/q0noicYT77KFktg/7Qyj7O6w58Md/aIZDPCuiqjwA
	 7pqyNS6MJ726KaCHXNheLwhQ21UU7bTTQgJADfXlHGh/50KkrmxrsEGRn6Y3iixQCuhZT
	 n8bbkPMr6gTm5Ckz8al3S+TT0T+5AXw8N8HBxUQH+Rk8Fdjs+IMYhO04Jng+ZgoOwqwlq
	 vXkB9hhfWkqbtFEaAHYVgGuPHtwLITId30Us5uCHYouUDWWoEQK6yCuT8iIuSCekNjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RQL6xaFv03DTPZKGNOvBRe4q5foc/hXhYaaBZRu9gNo=;
	b=FG58tK++zEKBdYZ+vnPxGkI70w8fAV6ZiHMOd7GzmnT6MOEE8/jVHumCBPvJPnfmpCLS
	 sAKS7NvnRRD9efUTTba3i1HYWR/TMaxTgMM5P5bxF7yNLh+2FZNfG8Pm7fjyf8HEpPjnm
	 Ib6HCMEZL/N0oD5aQnXpg+pIgcPj30s95IwQPF4BYdFAOXUHfQJaW11qyZf7B7YN0A9rZ
	 93mE3/IFrXSXvaqS6+WBUTzP4rY+sbYg4MzNQWkrGRjgVZ8SNWZujnD6kZysJiMnOMNYg
	 Lp4nRI1OPbyolvNApI5Gj6sErwfvpxrx0Yrq29knopiRIHRJN4QvyEdEHT2XO10858A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ix9qzN4/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32541606A31C;
	Wed, 18 Nov 2026 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ix9qzN4/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC0F1F000C4;
	Wed, 18 Nov 2026 20:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034735;
	bh=RQL6xaFv03DTPZKGNOvBRe4q5foc/hXhYaaBZRu9gNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ix9qzN4/V1+7ZhVGSHU7tq0e4W9a/8pEW0UL8ig5rsAl+K6jG0dWdHkm6sJT4a3yN
	 Sf2WwipEUSiyXCYd31mAKJe7ex7zCehEIXAnpFtiB+JGADRKvRNk7Q0/JA48tSfKdj
	 kl1V9Bvf0QQJqj1fVesoqhI4rewzLt/LOL03lKkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <cenzhang@linux.microsoft.com>,
	Francis Perron <francis@akrites.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0473/3318] KEYS: encrypted: fix integer overflow of datablob_len
Date: Wed, 18 Nov 2026 15:18:15 +0100
Message-ID: <20261118150331.098897838@linuxfoundation.org>
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

From: Cen Zhang <cenzhang@linux.microsoft.com>

[ Upstream commit 8697c431e297eb0d0ab13dda6bc172b48a34f05c ]

encrypted_key_alloc() stores datablob_len in a u16. It is computed from
multiple string and payload lengths. If the result exceeds U16_MAX, the
assignment truncates the allocation size. KASAN reports a 32760-byte
slab-out-of-bounds write when __ekey_init() copies the master key
description into the undersized buffer.

The total payload length stored in key->datalen is also a u16. Use
check_add_overflow() to reject values that do not fit either destination,
and use kzalloc_flex() for the flexible-array allocation.

Fixes: 7e70cb497850 ("keys: add new key-type encrypted")
Cc: stable@vger.kernel.org
Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Cen Zhang <cenzhang@linux.microsoft.com>
Signed-off-by: Francis Perron <francis@akrites.dev>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Link: https://lore.kernel.org/r/20260909153433.83117-1-cenzhang@linux.microsoft.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
[ sashal: replaced the unavailable kzalloc_flex() call with kzalloc(struct_size(...)), which computes the same allocation size. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/encrypted-keys/encrypted.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 1e313982af02a..b39bf082d5a29 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -18,6 +18,7 @@
 #include <linux/parser.h>
 #include <linux/string.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
@@ -606,6 +607,7 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 {
 	struct encrypted_key_payload *epayload = NULL;
 	unsigned short datablob_len;
+	unsigned short payload_totallen;
 	unsigned short decrypted_datalen;
 	unsigned short payload_datalen;
 	unsigned int encrypted_datalen;
@@ -659,16 +661,22 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 
 	encrypted_datalen = roundup(decrypted_datalen, blksize);
 
-	datablob_len = format_len + 1 + strlen(master_desc) + 1
-	    + strlen(datalen) + 1 + ivsize + 1 + encrypted_datalen;
+	if (check_add_overflow(format_len + 1 + strlen(master_desc) + 1
+			       + strlen(datalen) + 1 + ivsize + 1,
+			       encrypted_datalen, &datablob_len))
+		return ERR_PTR(-EINVAL);
+
+	if (check_add_overflow(datablob_len,
+			       payload_datalen + HASH_SIZE + 1,
+			       &payload_totallen))
+		return ERR_PTR(-EINVAL);
 
-	ret = key_payload_reserve(key, payload_datalen + datablob_len
-				  + HASH_SIZE + 1);
+	ret = key_payload_reserve(key, payload_totallen);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	epayload = kzalloc(sizeof(*epayload) + payload_datalen +
-			   datablob_len + HASH_SIZE + 1, GFP_KERNEL);
+	epayload = kzalloc(struct_size(epayload, payload_data, payload_totallen),
+			   GFP_KERNEL);
 	if (!epayload)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.53.0



