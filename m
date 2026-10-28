Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209162;
	b=5RGsgMCLuR0YPTVCruACBnxu+Uz7DGPzBNZMMDhBQHdkrh58BVop4WhQy9ZMomjAZ4sW
	 GfeyXx7HprYa58mvy8qhERfd3YgDH+offNRxKfWd1m4PU+RHTqwG0zjqhxv/jiUhaJ/7b
	 7D5dBNZ58KjTUhlsPt3XuoMYsfCW/RdSA7Cr8V7E79iEviWXFWDBZ1C8eU1gGoeLrDFRn
	 VK78G3yCaHY0OcD6q0cG8pZL1O5BRD8q0OWfgW25ULbbEulSq3ewps8tw/yv18T0KKZTN
	 SGgcSydbGItxMdEk88hRQ4bvj2wqbgfTfAgatArGrgcQrgoWNMq+2qYLFNdThDEIZoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6qNN7kEoIcxfrsqf0ZHYLWEmIJtnKC7ZFdkegf2Yxk=;
	b=4nkU3PUY2NpYSUHT7sYHqKJrAxj+7m5bptsJTrmxQu2UtlOPwK9p2VPJHf37H/s+Hf/d
	 KKuhD3WZ2DTNSI2ODS037BgWSWXi3sg93pW/M3tjROF/GhfWFioJ3OHKu6cyfUEDvGc+n
	 QKHiz7l1UwEnjFvT0xCyYXIGADvaSn+sbCOc6IJJpgHsmqqV8ygcjS8wG2pgRns5IR5vf
	 5oYk81BAxQNJCat8WwWS8N1MrHpu0JG9YPxvyco+jLK6SAKkw91qxVkoXkES++5LvP6Hd
	 llYiCCrVgmC0t+0661xZANEEByjtT02m9Gb4maKLZanrgwP8v0wXJ1flkPHO7oxtsSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQA2LUHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA8606A31A;
	Wed, 28 Oct 2026 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQA2LUHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9261F01825;
	Wed, 28 Oct 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209162;
	bh=O6qNN7kEoIcxfrsqf0ZHYLWEmIJtnKC7ZFdkegf2Yxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQA2LUHIAuGHo2mCLF8bBpn7UnZclTSuLaBPsuHMEroQWUoQYu7QKji+iFvbGzVH5
	 DOyTOaWJv55E5qOFB6yoBHcbgqoi/mPO9xS5B8KW8BVZ2OGkBQBkjKkV7zXFb4KloA
	 uAgVfEaYcdHOtg2oVjDbWubGg2nkcR/sHgFLbt+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 331/516] dm-crypt: reject the lmk IV mode with AEAD ciphers
Date: Wed, 28 Oct 2026 17:58:03 +0100
Message-ID: <20261028170011.329726259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2869,8 +2869,13 @@ static int crypt_ctr_cipher_new(struct d
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


