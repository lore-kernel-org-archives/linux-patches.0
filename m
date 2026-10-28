Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213294;
	b=FdplLDM7q9xbVTno3O1L+p2baRHA+oqxDmKRYWpXESvqo2yPHGEvvel+c/BjFqK/0MHv
	 vA8NQ27hE4KhgaeL6e5ua6YkQt5vd8ZX4ub9w4AbM7L9aAfX89osxq20Xsw6BvLFe3dT2
	 /tVCjHyi6DLTFyU5IUjOREOmSaIzkPs0FK3OGvLWXviRXfAWErHvx/t4tlBFNFOchAXjp
	 IKf8gHslkTKrVSCZZKJlKX7fT+nR0Iosi6ls/ytoNyOlULwoRus6CrHVeMJLXYC8UqtH4
	 drDz8H54lg6Aq+ZvB6iQpITiHsZE/6TerEop/ccu6GlFJGWRiyUkyIygRLz9XCnXgWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/y+O7/A02l53Rpn1TLhjP8EX2uk5/JjVmq7/QhFTseE=;
	b=lcYRlLjavsFLNuSTUKES+N5Ub9vatLk6JdkzM3fsvKl6m/xMjH9MOk6opKL3X0hQcXSV
	 +kCvhqbB6W2w9rELm/YuAOIEwzoHK+vHihBb08hJiHQC5CMLvBVEDUOnv5mNCacyDqSMa
	 o7Wzwrsy0MNlIgATNeqddSiKxS/l/kM+ZAsOn+RyDBLNJ36agIYH6Qn623v35vSYVxUqG
	 Y+fMBao2nEOpzikmIPeGY5MfZR1ioskHM/++c5MdqlokuQOZGEZ4uHNC3QHXWN+NGtfvH
	 OZGtx7OmNNoeHy8yOtCDF14r0GnfzOKwUSQe7HxKOT98fZ6Mx70qB2WDDV3SDNaoZLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXsDoTQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8BE606A31C;
	Wed, 28 Oct 2026 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXsDoTQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7EC1F01825;
	Wed, 28 Oct 2026 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213294;
	bh=/y+O7/A02l53Rpn1TLhjP8EX2uk5/JjVmq7/QhFTseE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXsDoTQEPXKpXVjYAu5aOCQXzb+sbFncUUR/8bMsF3wkDSMQ7+jX0of5Up9ufUzh2
	 8dmg1h14SHUJhcYq+2Iz6wG2PBvJbx/weABKOiumcFZB/lPftN4yo7j17UYJlqQoOk
	 nnnFwuJNXcHmCXhCifKYnuYv4zFM+Iyf3jfsZqBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0455/1887] dm-crypt: reject the lmk IV mode with AEAD ciphers
Date: Wed, 28 Oct 2026 17:42:31 +0100
Message-ID: <20261028170509.586399302@linuxfoundation.org>
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

From: Ben Cressey <ben@cressey.dev>

commit 3195e0daf590683992edb4eed32269e569e04924 upstream.

A "capi:" table line that pairs an AEAD cipher with the lmk IV mode,
for example "capi:gcm(aes)-lmk" with the integrity:28:aead option,
causes an oops when it is loaded. lmk sets tfms_count to 64, but
crypt_alloc_tfms_aead only allocates one transform, so crypt_setkey
reads past the end of the tfms_aead array and calls crypto_aead_setkey
on the values it finds there.

lmk exists for compatibility with Loop-AES, which uses CBC, so refuse
it with an AEAD cipher rather than allocate 64 AEAD transforms. The
check cannot go in crypt_iv_lmk_ctr with the other lmk checks, because
the IV constructor runs after crypt_set_key.

Note that this is not a security bug because the memory corruption can
only be triggered by root.

Fixes: 33d2f09fcb35 ("dm crypt: introduce new format of cipher with "capi:" prefix")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: LLM
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2914,8 +2914,13 @@ static int crypt_ctr_cipher_new(struct d
 		}
 	}
 
-	if (*ivmode && !strcmp(*ivmode, "lmk"))
+	if (*ivmode && !strcmp(*ivmode, "lmk")) {
+		if (crypt_integrity_aead(cc)) {
+			ti->error = "AEAD transforms not supported for LMK";
+			return -EINVAL;
+		}
 		cc->tfms_count = 64;
+	}
 
 	if (*ivmode && !strcmp(*ivmode, "essiv")) {
 		if (!*ivopts) {


