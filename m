Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFE4322F
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 23:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D07C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 23:00:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Tj1uHVsb";
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pC3iclwo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649199648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hkyGk1AvLVX7ZRVfVHkCHtVHh0s6OJd2PrQtUh6w60g=;
	b=Tj1uHVsb4vuldzWK0tqqyQAFUUEtNKgum2t3Lejt3omVE8wpXT+VdN8gizFerLG/C8cdnG
	U4aAa8mosNhykpultJGlofEzcksB7MqxKdRdY8nESvS0SNMzchDPgHZXFm4ZD+KEImo74I
	2tcakOg6lFe2HRoxlHbIGJ7Hx18txXE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c6cbc3e1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Tue, 5 Apr 2022 23:00:46 +0000 (UTC)
Received: by 2002:a05:7110:404f:b0:16b:55e2:eb18 with SMTP id x15csp675048gex;
        Tue, 5 Apr 2022 15:28:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbcyyJ4VIrjYFttQCsSXno/ThGYOOTm+wrgTnjsmEV1nWv1oAFHgNr2nOB3NNxTicOuvq3
X-Received: by 2002:a81:f97:0:b0:2eb:8322:91b5 with SMTP id 145-20020a810f97000000b002eb832291b5mr4614304ywp.186.1649197706704;
        Tue, 05 Apr 2022 15:28:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649197706; cv=none;
        d=google.com; s=arc-20160816;
        b=ZwuAU6+m2tC3Xx0f2nOq/nvdlFk0DN7c+opdRyx85lJmnf0/Ou+23suraHVppfEQQ5
         /eBKFl3S4hh4m/6qZhbdywtqcJKYH+87dx3FfpFjLqwfikvYT7sxDjVPJ8mXDUmIcoR0
         ctGIBEcAVwI4My/Nv8RcCYjquYCqnKNz3Ae53jnCoWwGItsAziZbE7kKNJ5ZINAsGfz+
         csnVsbLanbR8SdGW4xDFpdvx+MqaMsrDGY9OKwqrdlh8FdZ521jL7OoZmoP0LEbgCzSh
         URpgN+fnAa9HyWsuDuzLndU0qjGP7ckgXz/9rQJRegrRG0hTWhihxfdb+btR+WFlxe7Z
         Zl2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature;
        bh=hkyGk1AvLVX7ZRVfVHkCHtVHh0s6OJd2PrQtUh6w60g=;
        b=ZxTjADSy6WYTmvRuUJ6WppBHkJUdm0Wl9gDLUhD5kG1G1dy0mnvfa8OTJbleqy1+WN
         VV0NNIcVWFZlNsob8XEdaKIbzbSQqQesWgLQ+0etSDWd5rlfp23MDVk9HeJG05pI64jZ
         WwURaP3Gq1DOxKxHcQD6HGe9eeKKCqcwj8YbxtSa37YFb8Xwf68MOmreN4hMhuRCz1CD
         Bovod3OSTFC7QHVJq9Jk4B+ry2jQSXTszA0/mvpAh1ShFmdFlR5e6BL2EcSqPEWxs/ZH
         DBkr3VIhiAVYPZIPRcyNrDZUKF0Xzy0GBASbwtp39wVSFwO4dAMX2euqJK2RGW6QUz8k
         0pog==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=pC3iclwo;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=zx2c4.com
Received: from mail.zx2c4.com (mail.zx2c4.com. [104.131.123.232])
        by mx.google.com with ESMTPS id 188-20020a2500c5000000b00633994045d2si10383863yba.572.2022.04.05.15.28.26
        for <jason.donenfeld@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:28:26 -0700 (PDT)
Received-SPF: pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) client-ip=104.131.123.232;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=pC3iclwo;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=zx2c4.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105; t=1649197703; h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references; bh=hkyGk1AvLVX7ZRVfVHkCHtVHh0s6OJd2PrQtUh6w60g=; b=pC3iclworp7SpzvFLpYNTwoovHeWrbXA+SG4WIF6BDNLXqIuRT2mIue0JzNr8y512V3VbY tMIs2AlNGPbiXziBJg4lVMilyeAmw5lfddYwnIRmwOInfXvez9/57r7Qd+mtNbHOa0e+4W R9dt7UXedOFjfHejuvBboGOuwFdAVro=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3e43e3d3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO); Tue, 5 Apr 2022 22:28:23 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v4] gcc-plugins: latent_entropy: use /dev/urandom
Date: Wed,
  6 Apr 2022 00:28:15 +0200
Message-Id: <20220405222815.21155-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9pV4SdoSyMq4kax3w3Vu1nPxjO3faCZKq8d0RDo8t731g@mail.gmail.com>
References: <CAHmME9pV4SdoSyMq4kax3w3Vu1nPxjO3faCZKq8d0RDo8t731g@mail.gmail.com>
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
case, we detect whether gcc's set_random_seed() has been called by
making a call to get_random_seed(noinit=true) in the plugin init
function, which is called after set_random_seed() is called but before
anything that calls get_random_seed(noinit=false), and seeing if it's
zero or not. If it's not zero, we're in deterministic mode, and so we
just generate numbers with a basic xorshift prng.

[Note that we don't detect if -frandom-seed is being used using the
 documented local_tick variable, because it's assigned via:
   local_tick = (unsigned) tv.tv_sec * 1000 + tv.tv_usec / 1000;
 which may well overflow and become -1 on its own, and so isn't
 reliable.]

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v2->v4:
- v4 is based on v2, not on v3, so:
  * We're keeping the version string change, since Kees is going to
    remove that anyway from everything all in one swoop, so better to
    increment it as is the custom now, and let that patch later change
    the way things are done.
  * The xorshift prng is retained, because why not. It's faster and
    produces less code.
  * The get_random_seed(noinit=true) technique is used to detect whether
    -frandom-seed is being used, rather than local_tick, because of the
    overflow bug in local_tick.
- The size of the buffer is reduced to 256 bytes, which not only is the
  size which the kernel guarantees will never fail due to signals, but
  also more closely fits the histogram of usage, according to an
  allmodconfig.
- Pipacs pointed out that gcc uses gcc_assert()/gcc_unreachable(), rather
  than abort(), so switch to using that.

 scripts/gcc-plugins/latent_entropy_plugin.c | 46 +++++++++++++--------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index 589454bce930..0639fa4d48bd 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -82,29 +82,35 @@ __visible int plugin_is_GPL_compatible;
 static GTY(()) tree latent_entropy_decl;
 
 static struct plugin_info latent_entropy_plugin_info = {
-	.version	= "201606141920vanilla",
+	.version	= "202203311920vanilla",
 	.help		= "disable\tturn off latent entropy instrumentation\n",
 };
 
-static unsigned HOST_WIDE_INT seed;
-/*
- * get_random_seed() (this is a GCC function) generates the seed.
- * This is a simple random generator without any cryptographic security because
- * the entropy doesn't come from here.
- */
+static unsigned HOST_WIDE_INT deterministic_seed;
+static unsigned HOST_WIDE_INT rnd_buf[32];
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
+	if (deterministic_seed) {
+		unsigned HOST_WIDE_INT w = deterministic_seed;
+		w ^= w << 13;
+		w ^= w >> 7;
+		w ^= w << 17;
+		deterministic_seed = w;
+		return deterministic_seed;
 	}
 
-	return ret;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		gcc_assert(urandom_fd >= 0);
+	}
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		gcc_assert(read(urandom_fd, rnd_buf, sizeof(rnd_buf)) == sizeof(rnd_buf));
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
@@ -537,8 +543,6 @@ static void latent_entropy_start_unit(void *gcc_data __unused,
 	tree type, id;
 	int quals;
 
-	seed = get_random_seed(false);
-
 	if (in_lto_p)
 		return;
 
@@ -573,6 +577,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 	const struct plugin_argument * const argv = plugin_info->argv;
 	int i;
 
+	/*
+	 * Call get_random_seed() with noinit=true, so that this returns
+	 * 0 in the case where no seed has been passed via -frandom-seed.
+	 */
+	deterministic_seed = get_random_seed(true);
+
 	static const struct ggc_root_tab gt_ggc_r_gt_latent_entropy[] = {
 		{
 			.base = &latent_entropy_decl,
-- 
2.35.1
