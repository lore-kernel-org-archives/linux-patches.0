Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705356;
	b=d1uTdrZHoEYSbsJ4DcsAVJmVmpqtqtZg4Jl25Jh3yNxPCriFSW68LueQezTwt0MILtKp
	 yhYJ3HmXzwe69T8XQXG996NhFsYnUFb33GbRbB2P9YeGggWxN/t8hGvzeoYM6ggEu4zE/
	 Mpdw2DJ4R1LcYtKHPIl7q4EfXfQqotpNhBDhkxbdDI21Y7JzW3oOjAK8Q9nOvPT4d/oVd
	 H8krjQL2xIW77CwGyYoJFqqA12kB/K9lUmyY+JYhp6YiCpZicVZRdzPB6tYRVZD1ITAVV
	 TmXvxcN896oETlTBoS7aDdIwY/cwTk2VwibGy0Y0A5WCjslUylUBW1lftsGAXXNji5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F9NLMb08mV0yJvVcDhySjfPM4nUkXG+id0RqtrtyQYs=;
	b=zlK0GuF7mjpYKaxAwEtStjsjq4+T0qhnHeEIN7d1ZBI5+s7419LZxJgSATp3yevIAwgh
	 AeFEuUasy1TGZBx6g6yM8qXdcI7AM7K6+SXQ6s3jPDfBrDbOvmWPsEDIsne+Wpwjs4eMU
	 HLF0gSh1Vn7YVGC5a/TaFvk3Qxh7SEJzP5YDgcD/kGOqTIrdSNbmA4xOYUg3diCMT7iKu
	 gexydLb3mtA84nmZHAJOxNseqpTnWkT3+ZHnWeCQtR7yJ3fDnYFeGrTmZwC4e7WPuYUFn
	 M3bwBPPh/TWXFUmHQ2G3NnAVMgfWriynHfxLxq6JN+PolZTGF32nLaJRXBvHAS1ENoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMDUAon6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78971606A330;
	Thu, 26 Nov 2026 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMDUAon6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C9D1F000C0;
	Thu, 26 Nov 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705355;
	bh=F9NLMb08mV0yJvVcDhySjfPM4nUkXG+id0RqtrtyQYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMDUAon6Hfa+Z9aeRkZQHn7D/wVSWFhyGe8XW9vG4/ZpL6kLu+QQOkJi87Jm7cCOA
	 vzx5BgY2wPUvP6pjc94FrsoGebouPGfqpPo0jb6mltSEgJ6zX5E8qEv+4N3OTctFTc
	 b5STPqjMNBPwAL7eP2Q73k/+VUO+gMnXIzN1+CYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 168/319] KEYS: Reject descriptions larger than KEY_MAX_DESC_SIZE
Date: Thu, 26 Nov 2026 15:38:56 +0100
Message-ID: <20261126144010.538722034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 094c53d2994975e36d4cab7cf5d9f34c1b0f1916 upstream.

KEY_MAX_DESC_SIZE includes the trailing NULL character. Descriptions
generated from payloads and in-kernel paths bypass the userspace limit.

Reject descriptions at or above KEY_MAX_DESC_SIZE with -EINVAL at the
following sites:

- key_alloc(): before quota calculation
- __key_create_or_update(): before key_set_index_key()
- keyring_search(): before match_preparse
- request_key_and_link(): before match_preparse
- request_key_rcu(): before check_cached_key()

Cc: stable@vger.kernel.org
Fixes: f771fde82051 ("keys: Simplify key description management")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-3-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/key.h         |    3 +++
 security/keys/key.c         |   10 +++++++++-
 security/keys/keyctl.c      |    2 --
 security/keys/keyring.c     |    7 ++++++-
 security/keys/request_key.c |   14 ++++++++++++--
 5 files changed, 30 insertions(+), 6 deletions(-)

--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -37,6 +37,9 @@ struct net;
 
 #undef KEY_DEBUGGING
 
+/* Maximum length of a key description, including the trailing NUL */
+#define KEY_MAX_DESC_SIZE 4096
+
 #define KEY_POS_VIEW	0x01000000	/* possessor can view a key's attributes */
 #define KEY_POS_READ	0x02000000	/* possessor can read key payload / view keyring */
 #define KEY_POS_WRITE	0x04000000	/* possessor can update key payload / add link to keyring */
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -245,6 +245,8 @@ struct key *key_alloc(struct key_type *t
 	}
 
 	desclen = strlen(desc);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		goto error;
 	quotalen = desclen + 1 + type->def_datalen;
 
 	/* get hold of the key tracking for this user */
@@ -834,6 +836,7 @@ key_ref_t key_create_or_update(key_ref_t
 	key_ref_t key_ref;
 	int ret;
 	struct key_restriction *restrict_link = NULL;
+	size_t desclen;
 
 	/* look up the key type to see if it's one of the registered kernel
 	 * types */
@@ -874,7 +877,12 @@ key_ref_t key_create_or_update(key_ref_t
 		if (!index_key.description)
 			goto error_free_prep;
 	}
-	index_key.desc_len = strlen(index_key.description);
+	desclen = strlen(index_key.description);
+	if (desclen >= KEY_MAX_DESC_SIZE) {
+		key_ref = ERR_PTR(-EINVAL);
+		goto error_free_prep;
+	}
+	index_key.desc_len = desclen;
 	key_set_index_key(&index_key);
 
 	ret = __key_link_lock(keyring, &index_key);
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -24,8 +24,6 @@
 #include <keys/request_key_auth-type.h>
 #include "internal.h"
 
-#define KEY_MAX_DESC_SIZE 4096
-
 static const unsigned char keyrings_capabilities[2] = {
 	[0] = (KEYCTL_CAPS0_CAPABILITIES |
 	       (IS_ENABLED(CONFIG_PERSISTENT_KEYRINGS)	? KEYCTL_CAPS0_PERSISTENT_KEYRINGS : 0) |
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -957,7 +957,6 @@ key_ref_t keyring_search(key_ref_t keyri
 	struct keyring_search_context ctx = {
 		.index_key.type		= type,
 		.index_key.description	= description,
-		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
 		.match_data.cmp		= key_default_cmp,
 		.match_data.raw_data	= description,
@@ -965,8 +964,14 @@ key_ref_t keyring_search(key_ref_t keyri
 		.flags			= KEYRING_SEARCH_DO_STATE_CHECK,
 	};
 	key_ref_t key;
+	size_t desclen;
 	int ret;
 
+	desclen = strlen(description);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		return ERR_PTR(-EINVAL);
+	ctx.index_key.desc_len = desclen;
+
 	if (recurse)
 		ctx.flags |= KEYRING_SEARCH_RECURSE;
 	if (type->match_preparse) {
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -584,7 +584,6 @@ struct key *request_key_and_link(struct
 		.index_key.type		= type,
 		.index_key.domain_tag	= domain_tag,
 		.index_key.description	= description,
-		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
 		.match_data.cmp		= key_default_cmp,
 		.match_data.raw_data	= description,
@@ -595,8 +594,14 @@ struct key *request_key_and_link(struct
 	};
 	struct key *key;
 	key_ref_t key_ref;
+	size_t desclen;
 	int ret;
 
+	desclen = strlen(description);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		return ERR_PTR(-EINVAL);
+	ctx.index_key.desc_len = desclen;
+
 	kenter("%s,%s,%p,%zu,%p,%p,%lx",
 	       ctx.index_key.type->name, ctx.index_key.description,
 	       callout_info, callout_len, aux, dest_keyring, flags);
@@ -787,7 +792,6 @@ struct key *request_key_rcu(struct key_t
 		.index_key.type		= type,
 		.index_key.domain_tag	= domain_tag,
 		.index_key.description	= description,
-		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
 		.match_data.cmp		= key_default_cmp,
 		.match_data.raw_data	= description,
@@ -797,6 +801,12 @@ struct key *request_key_rcu(struct key_t
 	};
 	struct key *key;
 	key_ref_t key_ref;
+	size_t desclen;
+
+	desclen = strlen(description);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		return ERR_PTR(-EINVAL);
+	ctx.index_key.desc_len = desclen;
 
 	kenter("%s,%s", type->name, description);
 


