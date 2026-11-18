Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048941;
	b=1RY1cZUxX47rO8fsmR0GKK3qzbCc9AHSxL8C9phgus64wh0jpDaa/4RemozF9hPvsF4X
	 Km5E21kaHP4Yn9snmIeZsXbxvhUF17wF4cKM3CspSZsuhQ+qAo1l0sGGKS0Wgjw3iKRS8
	 ix11eYA5QvBaMoQoCOXDx+Z8X2WwIA4CJZhQGs2gDQVqbWALAXvgnRiwbfB9p0ncnzTo+
	 UYM0ajbjlqwCzWEfA7L4hE0ncob2iEQagmTVPu3YVSDwDdwIN8/nKhS59Wkgwma2EI/4d
	 007U7WTQjnQzw+VNkDWb11LYoJyaMvy5L76sWoINYpS4nsZ4Hsf6YQhij/F1Z//zjCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XqShPtt5f34k7CK6gxRUQ37k7aZ9Cf1KkwiKpEOK9H4=;
	b=O+BFz/L4cPQKK6fLpYruZs1qPzH2zdTCnNnkVU6LIXnN4B/I/Dv3erQe3NDNn710Mw/C
	 PxXkxrjMiWCOMu3rE62SYSphXbszDj062UjUfny69CB7hsgEw7SlFWBX/gmUpIVm7LWkf
	 ytEjsrgyF93KB81Nu/twNQs/nrlFW6oSegMK2wPM2zBL15zitAWqNMguGcJwEr3i19ojj
	 Cf8K2ICRf0gOtPOFTdzz3KwH/sIAFmrWnMJTCWSUAWxvFRDY+1utQjL+EsFi0UWz+SFLW
	 6/tWjjS/PyfnlqZPfK448NwTDCmBF0MkTrWSKxmlCQGu2pYWlobIs/s/Sl1Pi3hWlcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wX/xT+YT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78859606A31C;
	Thu, 19 Nov 2026 00:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX/xT+YT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC361F000C4;
	Thu, 19 Nov 2026 00:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048941;
	bh=XqShPtt5f34k7CK6gxRUQ37k7aZ9Cf1KkwiKpEOK9H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wX/xT+YT85s5e5rp0EA1Nz/FHiy1fTlE5KUaXOA7rLiBdpAc7g28n4UPOTcOw1MrD
	 L9GcifeuUJcmHJm8ir/JMs7NE3iUISfq4icwQCdwmOQPtN+Ew26w081qjkQriqShC2
	 Iy4Wz1fB3aIXJfzBRH+VWP9MFd456rY53YmocqrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2175/2857] crypto: tcrypt - Drop leading newlines from prints
Date: Wed, 18 Nov 2026 15:53:29 +0100
Message-ID: <20261118150319.717163145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 3513828cb8f6db714ee48b1559e6253a57ecf1f6 ]

The top level print banners have a leading newline. It's not entirely
clear why this exists, but it makes it harder to parse tcrypt test output
using a script. Drop said newlines.

tcrypt output before this patch:

[...]
      testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)

tcrypt output with this patch:

[...] testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3a31a4baad67 ("crypto: tcrypt - Avoid reading req->base after submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a1807652d1325..bca44bdc8a9ee 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -324,7 +324,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					  crypto_req_done, &data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	i = 0;
@@ -575,7 +575,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+	pr_info("testing speed of %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
@@ -877,7 +877,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s)\n", algo,
+	pr_info("testing speed of async %s (%s)\n", algo,
 		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
@@ -1108,7 +1108,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 		crypto_init_wait(&data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_skcipher, tfm), e);
 
 	i = 0;
@@ -1315,7 +1315,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+	pr_info("testing speed of %s %s (%s) %s\n", async ? "async" : "sync",
 		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-- 
2.53.0



