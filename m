Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050965;
	b=Ww+ZjpcQ8n2Q2aYnAqUIT/H5DNl4gQNolxujxFFIUEFJZj2s1+6VZaJkNMXQJkDKMUDj
	 n7LzvhOJUZnYya2ecGHwCkVw6DwqADB25+Ws7DtMXQKoKMyNV/0SrAovdZoVZsrTl4GmZ
	 nfWH6Zh26twaRdqsx9UCHWl8RmgEdxXo99dc/fTeGeRTKWDQCgGqDkz2oPQK/nFJdIsvt
	 LM2rBEnplTlk4jGisxmo9C1q8CxPhascM1U4WVbPcyYWaaO2V2z0TU7mqEAJmPEU2SxVe
	 a4bhDhKR5FOKpTBfvwlzqZspm2OB172RuxOIMf+wrEeaqJDvaMhA5T0ShMvG1oZjPRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sn/liOrfidEwsgQLWCPcmOFM+iq+wqETMOH1DpZrw4Q=;
	b=FuTMb5Ntw6fUpQTzBJKXuQtFQldgnfr5s7Lq0ZaVWVjpvt4xtTzNrgkEIfi5GfXm8fX1
	 4N1ebuqOz/Gbp56sRuoejlbM4QP5L/Qqf702s59Zb6500NfQ41D9ozu3HxItdRYV8h/Pf
	 CvPAYltlC3qGTfzHE8CiQp4K1TX94Hd3UOT3S4UeVXrb20QYRDLl3KTDcYyIRxwZiE97z
	 cUtrqsVI/VUeyYW7qldyzlZPtyYPHfFXABEc/6kgHEmgfKtS8sqYZBFuj71vUz+lz/IP8
	 pagrqEOWZAHXtFwZeYimsmPztWiPyELakOCTe7WWJZY+89nzj5DvtKP2Z1bLfRb29+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wh4rajWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC523606A320;
	Thu, 19 Nov 2026 01:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wh4rajWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C576F1F000C4;
	Thu, 19 Nov 2026 01:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050965;
	bh=Sn/liOrfidEwsgQLWCPcmOFM+iq+wqETMOH1DpZrw4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wh4rajWLVDru3WxYyg/6K0O/mRsAJpo3xzMlSmO/LlgArmG4V5cbvOadTRekoqaNH
	 HedJ2tODXQP7grMpe5jhRJiglenf6FtF+lXWUJXy20gCYVVHy7OXasPlLRGspE9zYR
	 JesQVIUO1n73K1/DfIQ0aATLOgAPNk0BxQy68dig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0009/2214] asymmetric_keys: reject trust keys without IDs
Date: Wed, 18 Nov 2026 15:28:05 +0100
Message-ID: <20261118150010.527519547@linuxfoundation.org>
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
[ sashal: Reused the existing signer_ids structure pointer for the NULL check instead of introducing a separate kids variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/restrict.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index 84cefe3b35856..d95002812bb84 100644
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



