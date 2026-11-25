Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626171;
	b=riqkHVw4Ks4F0khgPaYn8Z3AClKBVFSjkONmZYKqQw/1odHC54yD0OT3YtVonw0sYyjr
	 q7pBcZNHBo4J7A37ZiCoRZn6Ms/5HSIcI2zUsoL3pt1kwzLArTig81mlMALkP2ZROeTZ9
	 opAVtxdTWCsxMKlJl4TzrsOypImWqQI9rSL51XToqDAmjHc4RIImdt0l+BokRt8XEjMRq
	 m0F9PGN54UL3CUAA1JlAJaCMd2FZJ2KLWN4KpjWRksWKl6GNaWulqhbpadlbCLD/uQhs5
	 0M5XRri/josXCZiFU0ULYJya4oM8jh+d6+g+jNP5KC/1Rhi5HaTuFcHdjBMnAU/9TvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ifNI3p7WBRDN50asvwHqGfVq6PnMnqz4BD7RWFREaYU=;
	b=Lz229KviF1BAzAc6IsWQwF3aehns8fCVj+AsEHMch9O2SCqsSyzKYG0z9CD5VFna/8wC
	 c1C8dptu+rwU6M4rjdAt4J1K+cfpGza4jxJn/gwq3AFc2wUQ3yVzGv7ec7So2tWExCk9P
	 r4W2g1rkcjFre3HNgIG27Qy/B3/2eSpaHTrO0em5Rp5sLTHigCsG3DovmNd0G8EuciDPD
	 fGO2r/NrRQT5dLAp2tqzSdEOWimJdDgj7FGDPqSNpH4LqFIodLUrY9wgAlRuT7CvgkqxM
	 r38sq0w2c9Q48/4md2wloEpIl0oJitZd5CtTWWDZYlb6qyMurx7Q7ThpB4n+mJEIFcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbJff3s7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526CA606A329;
	Wed, 25 Nov 2026 17:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbJff3s7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59231F000C4;
	Wed, 25 Nov 2026 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626171;
	bh=ifNI3p7WBRDN50asvwHqGfVq6PnMnqz4BD7RWFREaYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbJff3s7y3SORddoMqynlYWdVFfjEBv+u0Fa1bJn1iiNlmPT1dPngQ3UXODPU0s4y
	 U6lpLUa5TEkeTZEpYYnZF7PO6htRde/dYSKBcOGaCOsTs2h5cf3vzI7+of1OdtH18L
	 MkyhZtq6RHsjXZNgqkDZdHnuZ1pNUaoZNcH32hp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff132cb52bce4f44ecc9@syzkaller.appspotmail.com,
	xietangxin <xietangxin@h-partners.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 711/816] dm-crypt: reject integrity_key_size with non-authenc AEAD ciphers
Date: Wed, 25 Nov 2026 15:37:39 +0100
Message-ID: <20261125143905.634992986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2926,8 +2926,11 @@ static int crypt_ctr_auth_cipher(struct
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


