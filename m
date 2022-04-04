Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FCB7A
	for <patches@lists.linux.dev>; Mon,  4 Apr 2022 23:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F850C2BBE4
	for <patches@lists.linux.dev>; Mon,  4 Apr 2022 23:09:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hJHv21j3";
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KFvhKuZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649113784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vGTaurbGxnmX61uTtsDVA0m4CB9YGZAV9yFAwsrZgZM=;
	b=hJHv21j3lUurpmA70u+7IbcQWKiWK6sKh6WHEsPZgl1rKTs9fm6+Gwk1N9ozwqpcWHfMZs
	Bb/cK7ir19RrzJ9PuMfRy0iWxQKhkst598+FRwsP9OO6wleTPzzCSsKFTXoPk2WJD/bE3c
	LuQ4n/F/gq+32bD82Q93/pcVvXAVNyg=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6d63291e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Mon, 4 Apr 2022 23:09:44 +0000 (UTC)
Received: by 2002:a05:7110:404f:b0:16b:55e2:eb18 with SMTP id x15csp3976007gex;
        Mon, 4 Apr 2022 16:07:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoZ+x7P7HAu+hThADKBph0JhCU+kmsN2N0MyIeRA6GVAXZhZlwTW3PI36f8g9qNdooQzr4
X-Received: by 2002:ac8:5f12:0:b0:2e0:67f8:132d with SMTP id x18-20020ac85f12000000b002e067f8132dmr613531qta.417.1649113633689;
        Mon, 04 Apr 2022 16:07:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649113633; cv=none;
        d=google.com; s=arc-20160816;
        b=f889yu5/9sCJ0KFMHBmZIU4tXLdsSe8M0mu+qTqleUy4a7N/FSXN0VIa85T84xiLaH
         umLUfLIItAmVXZcmVv5cffRIXgQML94sYLCbUtcAgn/pu7mZja/3iYb+QvhmB2B3ZBll
         eYnuUDTIU/jynRJ9/zLNAt1k1JoTNVhWkEE1U4/d50TxUo2Cv4FZtQp3xFmM/bpgvbha
         koukwoX1a7QpaH6s98wlL9sDtIHGioSl43OsuAyA9szEjboPhWkP7D3m1f217iZegxhF
         JMvKp5g3OaP1Xa2QvkZSINwpLwyHe8TCcHRDFl/7HVeCX8aRIMXAffbRfOFvGvS95sJm
         Vgqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature;
        bh=vGTaurbGxnmX61uTtsDVA0m4CB9YGZAV9yFAwsrZgZM=;
        b=tN7gZrMw7g4ZwEzolEz9MBCHa4srkByeV1RERlxdLuHJpEm2P15LzQ79Nl/JNe4J/l
         RGRZcwaYgPXmImj3S1aBNJrX78krL4DvYAuFhLqZBsmZv3I+AleAJEh1fpGJ+l9vq7Pc
         OIPdmBcqOfgaqbsJA/D+g95gFaWpXxlX7ldxV/A4K6wpf0K/wm4FG/t3TO1kcKhElQ+j
         z2JWAamGb7UOdJ2CXUJxF4hMEr1RFa89bo8Vst0FxSpZdE9BhDEsevogWlcaCoIialxv
         1Ul9PfKra8NB2AWpEGOrBJuHDgQUtUqv9HxYGC3+eo8Wr/L/Vb+sSR+MqYEb/zwv6bLt
         k9dg==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=KFvhKuZ7;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=zx2c4.com
Received: from mail.zx2c4.com (mail.zx2c4.com. [104.131.123.232])
        by mx.google.com with ESMTPS id j1-20020ac86641000000b002e1fbf3bea5si3463824qtp.150.2022.04.04.16.07.13
        for <jason.donenfeld@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:07:13 -0700 (PDT)
Received-SPF: pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) client-ip=104.131.123.232;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=KFvhKuZ7;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=zx2c4.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649113633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vGTaurbGxnmX61uTtsDVA0m4CB9YGZAV9yFAwsrZgZM=;
	b=KFvhKuZ78B+r+N8t4RyLL1HurxD33oMWR69ujLyRkOx4tws71XRwtLP6Dlrv71L1P1yVv8
	Hmh3CbbjuThGe+bNk9gCwR/l8+ZEWrZhX8EXaESZJyltxf9Hn0SSmSLYfmrfhv9/Qrn9Gv
	DVVxoBlvg2OuTxxwf3HstTQ93iWdXoA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9db78fce (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Mon, 4 Apr 2022 23:07:12 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	stable@vger.kernel.org,
	PaX Team <pageexec@freemail.hu>
Subject: [PATCH v3] gcc-plugins: latent_entropy: use /dev/urandom
Date: Tue,  5 Apr 2022 01:07:09 +0200
Message-Id: <20220404230709.124508-1-Jason@zx2c4.com>
In-Reply-To: <Ykt1cj0wPKEsHL2q@zx2c4.com>
References: <Ykt1cj0wPKEsHL2q@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the latent entropy plugin mostly doesn't derive entropy from
get_random_const() for measuring the call graph, when __latent_entropy is
applied to a constant, then it's initialized statically to output from
get_random_const(). In that case, this data is derived from a 64-bit
seed, which means a buffer of 512 bits doesn't really have that amount
of compile-time entropy.

This patch fixes that shortcoming by just buffering chunks of
/dev/urandom output and doling it out as requested.

At the same time, it's important that we don't break the use of
-frandom-seed, for people who want the runtime benefits of the latent
entropy plugin, while still having compile-time determinism. In that
case, we detect whether a seed is in use via the local_ticks variable,
which the documentation explains is, "-1u, if the user has specified a
particular random seed."

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v2->v3:
- Drop change to xorshift for deterministic thing. This can be done
  later if anybody actually finds a good reason for it.
- Drop change of plugin version. Since Kees is proposing a change in
  the versioning scheme, that can also be a separate patch.
- At Pipacs' suggestion, use local_ticks for determining if
  -frandom-seed is being used, since that's what gcc says to do.

 scripts/gcc-plugins/latent_entropy_plugin.c | 44 ++++++++++++++-------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index 589454bce930..435b956ac1bd 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -87,24 +87,40 @@ static struct plugin_info latent_entropy_plugin_info = {
 };
 
 static unsigned HOST_WIDE_INT seed;
-/*
- * get_random_seed() (this is a GCC function) generates the seed.
- * This is a simple random generator without any cryptographic security because
- * the entropy doesn't come from here.
- */
+static unsigned HOST_WIDE_INT rnd_buf[256];
+static size_t rnd_idx = ARRAY_SIZE(rnd_buf);
+static int urandom_fd = -1;
+
 static unsigned HOST_WIDE_INT get_random_const(void)
 {
-	unsigned int i;
-	unsigned HOST_WIDE_INT ret = 0;
-
-	for (i = 0; i < 8 * sizeof(ret); i++) {
-		ret = (ret << 1) | (seed & 1);
-		seed >>= 1;
-		if (ret & 1)
-			seed ^= 0xD800000000000000ULL;
+	/*
+	 * When local_tick==-1, the user has specified a seed using
+	 * -frandom-seed, which means we should do something deterministic.
+	 */
+	if (local_tick == -1U) {
+		unsigned HOST_WIDE_INT ret = 0;
+		size_t i;
+
+		for (i = 0; i < 8 * sizeof(ret); i++) {
+			ret = (ret << 1) | (seed & 1);
+			seed >>= 1;
+			if (ret & 1)
+				seed ^= 0xD800000000000000ULL;
+		}
+		return ret;
 	}
 
-	return ret;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		if (urandom_fd < 0)
+			abort();
+	}
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		if (read(urandom_fd, rnd_buf, sizeof(rnd_buf)) != sizeof(rnd_buf))
+			abort();
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
-- 
2.35.1

