Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623481;
	b=s87aCv7ZOjAgN+5Y1igK6WHiQOpLYH+uTMXwDMpX1vr3wZJ9KkLtTan/B0yOUWMu6rfP
	 zHMDKDFIlRb+Ce4FGe62Y0PxU0cameZKMD21VVUSqWuixKjSw45//9egI9zLtIoyG2QJV
	 pTj2GXWe7fGMmF55FyMzdr43PrjEt04yAGeVX4k92J4KRlx1EEgs94H7E7XS2B3f5wAdD
	 tq+VcJCLpDHTSF2Nh9OC44O3iWsMsjCA/qE7f8DxkuRo9DaaLAXAinmNitbMYLYuV3gJT
	 N6kOkxWvhfA5vwBrdWF65uH35V2PaVjLpTDNoGNbZOrIeleno3lYxkT4+FCzpNuZUwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxeSDlzD3lVh/3o11mbnh4liJDhBoaONMTUWGQeMcK0=;
	b=O5Ojk4K8aAxgjhB9f/NRIhZiar1/PahWFNFlfHGiZlYTOMNNxzHZgfHk0SUfK46SoV79
	 g6YdXabPfte35vXB4AcEIR8hSV5E6AmZOaO4mNSZrMeui54jPRumdjvKptt5DLwmJH8p4
	 tciWn9b353Ak/cPQoix5uaf98AzCRQAGVRlTKIimuPQiSKHzI43QfZ+/ALRM7rKaA4IrG
	 k5sdueMF1FLCcs2NQjAdFoWyPLka5VlDK8WMkuXprhOLV/AO6TjGi489cdbnwyDxS8JWU
	 FjAeEvymiwFLRzNtJoPGqeC8KjlDPcImb9/ho7watrcijA0pXWbI/ulINSofwkKMM5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOjcvmbT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F44606A31E;
	Wed, 25 Nov 2026 16:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOjcvmbT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6471F000C0;
	Wed, 25 Nov 2026 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623481;
	bh=rxeSDlzD3lVh/3o11mbnh4liJDhBoaONMTUWGQeMcK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOjcvmbT8n1zrsqpnufypkSHUJwrdnS3nXFMCgr0CPoB1CwtIaji+pCHBXR4WVGZo
	 oA72OrHF919VE9OhOwXSnFTYGEGOdMxTfA7s17m5Mn4hibExnZZi8ohl6eD/ACC26O
	 mjE1VTP6da3W61bpNa93Lf++Bhsr/x0+edtUf3mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff132cb52bce4f44ecc9@syzkaller.appspotmail.com,
	xietangxin <xietangxin@h-partners.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 872/990] dm-crypt: reject integrity_key_size with non-authenc AEAD ciphers
Date: Wed, 25 Nov 2026 15:37:19 +0100
Message-ID: <20261125143842.446242222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: xietangxin <xietangxin@h-partners.com>

commit bd93c4e59c5132282c01f142806e307c7380e7ea upstream.

When integrity_key_size parameter is paired with a pure AEAD cipher that
is not an authenc composite, crypt_ctr_auth_cipher() returns 0 early
without allocating cc->authenc_key, but cc->key_mac_size remains
non-zero because CRYPT_KEY_MAC_SIZE_SET was set during option parsing.
As a result crypt_copy_authenckey() dereferences NULL crashes the kernel.

Reject the contradictory configuration explicitly instead of silently
returning 0, so userspace gets a clear -EINVAL.

Fixes: 4441686b24a1 ("dm-crypt: Allow to specify the integrity key size as option")
Cc: stable@vger.kernel.org
Reported-by: syzbot+ff132cb52bce4f44ecc9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff132cb52bce4f44ecc9
Assisted-by: LLM
Signed-off-by: xietangxin <xietangxin@h-partners.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2905,8 +2905,11 @@ static int crypt_ctr_auth_cipher(struct
 	char *start, *end, *mac_alg = NULL;
 	struct crypto_ahash *mac;
 
-	if (!strstarts(cipher_api, "authenc("))
+	if (!strstarts(cipher_api, "authenc(")) {
+		if (test_bit(CRYPT_KEY_MAC_SIZE_SET, &cc->cipher_flags))
+			return -EINVAL;
 		return 0;
+	}
 
 	start = strchr(cipher_api, '(');
 	end = strchr(cipher_api, ',');


