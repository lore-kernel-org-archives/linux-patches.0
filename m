Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211559;
	b=FtU5dNtpRMecEzVqg7S6IsIs7GTqhStU1vh/7T9WH79swNqSr+ShRmMRjQ8z8INcqiI+
	 a9ykSdsLZgUKiiKntRQOZMGy1fci+yneLSuGsKDQN5xZSiDpb1kryjIJUVQaV/GB8DO2b
	 l5bbeac5FZLH6KcFvDpwJi1yAYq+mBVg6An7+YrpbnPlnKvZ3B9WqY7cVQEqVBs6GCZYV
	 cOKiIj37BQ2in0BbYZLFLOhETHZfMLgPaoiE4TmOFQsN6oo4MOCZdf2Iom+o6Q1HHNDDg
	 gmkXfRh6OtzcG5YA2uTWm4RVomfBMthZCahfaRPf2QQwWHNXV54wFKsgI395MM2ZggQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2BWgl+lEYyt49/YD4Gqu7p20x5KYtf6NXtzuwZc/+UM=;
	b=5hNMz4MH3g4MNs6Nyc9cCeNdkko0roRM78AT2yMzE8lz1F8FHazZsHcviSQ5vhrc3oxT
	 A8g2CyvYsCeejOuag9gdIfRxKD9iGLpjsYQyHGoIxB1Owr2DqKCLhMf6WWMKkin0bu35G
	 OdOTplQNe6uPUZtSvxMN9wqeiLP9A/nnNi2+xILW3QgI9aQ89kBn2UDpcKjslREEI+cn0
	 HIcJjV2PokgkmJpRcr725s9c1Q8xiCcsmfGGY5sPgBZ1ytnqYex13MAushd/lIkcPVJ6t
	 1rz5+HrlseOTF+uS3CMW1WABgg9EYaisTsMS5qT+TRTNSXRYgL5FD5o4M9MhR3zbO+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/gEuUW3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE97D606A31C;
	Wed, 28 Oct 2026 18:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/gEuUW3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0081F01825;
	Wed, 28 Oct 2026 18:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211558;
	bh=2BWgl+lEYyt49/YD4Gqu7p20x5KYtf6NXtzuwZc/+UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/gEuUW3ZORAcIoEeKxCl5QuI92jhpxfzageprTdxICmWAuLKXwodsn0ZFRf0jxc5
	 Mb3MlstWIKegZkVhF62ZQgxE21UONJDEb5XtJCoRQQTc2THA0tRvovL5mWOeK/OSaV
	 1+OhOrPnlJS59rYnlLJ/uWJPgGV/rlAUv2c4eHbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 365/571] dm-crypt: reject the lmk IV mode with AEAD ciphers
Date: Wed, 28 Oct 2026 17:58:32 +0100
Message-ID: <20261028170016.676226249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -2854,8 +2854,13 @@ static int crypt_ctr_cipher_new(struct d
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


