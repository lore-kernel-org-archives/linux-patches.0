Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620322;
	b=daHMMq2DrxyzqudD7SSQSvEDujgvR5RRR21f7dQxfM7+L4FlSOaDq/kv7MDAjdX2rIlC
	 TAhrugInbiGY3c44NgVuFnr78E+2zO0oXj+zebqOv6UQ4j2YzvwG9xGK+oO4sUIaCiQ1w
	 D41rDpWW8B3bRGiFOgtcJOzM5Fp+zmVQXbVOXEIzSY00iwED84z4XIIWapVVxso08sSlx
	 ABUxaTlC+ofBg7o2ObUI1AwLvomm6BsrQ2KALTIXc0OtarDDl97bwa66OcuF8Rs7QxHU6
	 QggMkEL3ydhGRlnHiHGoTqc/RvhfhgxHXEmM4UoPZaxuD4N6Y3TEW59sHP71dtLwXPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lc/+2KR4DIFGu6HP+UshTDpLnFsHpUPWQZ+IlyBZsRA=;
	b=RGP0afBJjnnoQLD7jHIVMPKK32B++LaF95LSwPlb1rsFUtSjQqvXkb9Pazq3SOd0dT/n
	 HRDQ84p0x2jPwFDR/K29UxHNfSwA/oYtdHtHgafydSOy2gSs2waigPPkzhthsXAp0Y1r9
	 34TOvhQi8POQ5j8t8PvNJoA9698JpEwmVnOlMEbq7IDWZ1RF6rd2I+f4FYIpqVfX4SOOM
	 Hhjy89i/mKHkkLl2jbiNPHLwOSj2aTXUoCGyQlKnWeHoB1tivwhz3DjC82TS09euBvYQg
	 tw3N5+5eMHt3g9AIu2zU6C2TcIoDbNKpmQsgffPqgT+F0+sbb3eI7pk8lG8wtSiP41Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuJPQi8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5080B606A31E;
	Wed, 25 Nov 2026 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuJPQi8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAF81F000C0;
	Wed, 25 Nov 2026 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620321;
	bh=Lc/+2KR4DIFGu6HP+UshTDpLnFsHpUPWQZ+IlyBZsRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuJPQi8fV1SQy4O0XtmxVX9ocZP1zXXrxEtQml6oBwOOB6In8QCaBxXUDdyhBzDAD
	 8QvwYEfrkVjItg1Ds9uQXkAYp5eITZXoZsg7zw18vFW4xj7DNS4cIJ4Ox9HHF894zR
	 JrcEnKtw1PfUggAqelO90mLvnyz0ao29jBQ1ZZjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff132cb52bce4f44ecc9@syzkaller.appspotmail.com,
	xietangxin <xietangxin@h-partners.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0877/1005] dm-crypt: reject integrity_key_size with non-authenc AEAD ciphers
Date: Wed, 25 Nov 2026 15:36:55 +0100
Message-ID: <20261125143842.249416017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -2826,8 +2826,11 @@ static int crypt_ctr_auth_cipher(struct
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


