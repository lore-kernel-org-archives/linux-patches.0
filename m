Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E49322F
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 22:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFA1C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 22:54:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="euf3g6KZ";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OqzFRuQw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649199284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KY5AEKEkClJXCIcB/dp2K6YipiPmN6Pkkmc24/xM1sc=;
	b=euf3g6KZfEKm/mKjZ/GZgostRaEaYGNan/9/3v3XdANUi+2M6IH/IPi0HYx7wr80kcjNHN
	PHZ6HjTPXOAK7OJjrt8MDPd042ez2wryAAqst4M8UZI7/b6oUzaFH14wKYtxfelLM/fSDt
	f2mNSAO9B/Y2/LpNYOvVbdmXh5/hE5Q=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id edb56fe2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Tue, 5 Apr 2022 22:54:44 +0000 (UTC)
Received: by 2002:a05:7110:404f:b0:16b:55e2:eb18 with SMTP id x15csp318282gex;
        Tue, 5 Apr 2022 07:10:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/oZ8prP4bo9H+6+CSDkx9QsUcmcw+YbqjBpO0/LNkyzJUWwYS2aOl5MfTM3ujPqBaPBe+
X-Received: by 2002:a25:8a0c:0:b0:63d:d026:ebaa with SMTP id g12-20020a258a0c000000b0063dd026ebaamr2430630ybl.509.1649167824988;
        Tue, 05 Apr 2022 07:10:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649167824; cv=none;
        d=google.com; s=arc-20160816;
        b=M6oWMSeiCqkFz2IRSDKWsqGJ1WrNTAEFf863PGkAIwroDAq1cFmDrSFiGqnNmK+ZDt
         2e4haMf5T18mvtsGxM9tFSc84GDuuEJ2zFiHbenLLUcSETrhDOyOKUw98s2BFCbTsyL9
         0CPcoEqs9VnJ5jrrLoI7c5ySvAkyBOJlumEcX1OzkQVGxHsKJ6htLhQVXcfqeZCXi/PC
         EQYalgAzO2NFSJGtybrAUxBcPoiNBaqtIB9p9RQEyhx2b4J4lUDC04w+hqc2H1ELugQW
         9Tz5wFbmTxlUjjjtr37xufXjCH9L/caUkf2fEc7cyMdXVHNbdgXZnNvkMRegg/GdKcY9
         JGCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature;
        bh=KY5AEKEkClJXCIcB/dp2K6YipiPmN6Pkkmc24/xM1sc=;
        b=kSGp3fbtU/dIOiMgF2UhaHO7SHvQEofE7d+13bDmSQ96HENZPlhEl1RohgotEoW7an
         LWdr1rc8Q1dOSCy/5fz2cyLLK74fOAOaybwAsJms2Dylakin+WSRJqQNVNML1436Ttpo
         HNtERegzg5/cFUe1H08cnINfUIoNCMv6LZN4uoQZuS0XWvMMCQTZXZ94i+NCUM+oBXZB
         F5V4ezKZmRQqoGi0Gid+Z1EBjvkkfIncUH5BxBI63YelT8Vh+NYLYBTVcPNfmmZhVDih
         rlpDRsLft8la+7vv+dO5GVwqfpHQUb5IqFlhT+ZRV3dR+nu2Bp4B0QhdQUd6czrmYpDG
         mSiA==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=OqzFRuQw;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=zx2c4.com
Received: from mail.zx2c4.com (mail.zx2c4.com. [104.131.123.232])
        by mx.google.com with ESMTPS id g130-20020a255288000000b0063dbbff27f7si4968195ybb.497.2022.04.05.07.10.24
        for <jason.donenfeld@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 07:10:24 -0700 (PDT)
Received-SPF: pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) client-ip=104.131.123.232;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=OqzFRuQw;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=zx2c4.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105; t=1649167820; h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding; bh=KY5AEKEkClJXCIcB/dp2K6YipiPmN6Pkkmc24/xM1sc=; b=OqzFRuQwwJQY39ID/slPUumYo6AOavy60E9Jx/PhGjvSpalfA9QaWfYovGjvouaDvLKbcc 8Y9+iNUVaOEas6EsxLIxTQa2xEvq7DfBph6PJoYhE49AnrjBdLnH+SW111QD2coIaLxXyo nuigC41yGXliUAzBh0XPKdNA1zzrexA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61798ffe (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO); Tue, 5 Apr 2022 14:10:20 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, torvalds@linux-foundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Theodore Ts'o" <tytso@mit.edu>, Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] random: opportunistically initialize on /dev/urandom reads
Date: Tue,
  5 Apr 2022 16:09:06 +0200
Message-Id: <20220405140906.222350-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 6f98a4bfee72 ("random: block in /dev/urandom"), we tried to make a
successful try_to_generate_entropy() call *required* if the RNG was not
already initialized. Unfortunately, weird architectures and old
userspaces combined in TCG test harnesses, making that change still not
realistic, so it was reverted in 0313bc278dac ("Revert "random: block in
/dev/urandom"").

However, rather than making a successful try_to_generate_entropy() call
*required*, we can instead make it *best-effort*.

If try_to_generate_entropy() fails, it fails, and nothing changes from
the current behavior. If it succeeds, then /dev/urandom becomes safe to
use for free. This way, we don't risk the regression potential that led
to us reverting the required-try_to_generate_entropy() call before.

Practically speaking, this means that at least on x86, /dev/urandom
becomes safe. Probably other architectures with working cycle counters
will also become safe. And architectures with slow or broken cycle
counters at least won't be affected at all by this change.

So it may not be the glorious "all things are unified!" change we were
hoping for initially, but practically speaking, it makes a positive
impact.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ee3ad2ba0942..388025d6d38d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1534,6 +1534,13 @@ static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
 {
 	static int maxwarn = 10;
 
+	/*
+	 * Opportunistically attempt to initialize the RNG on platforms that
+	 * have fast cycle counters, but don't (for now) require it to succeed.
+	 */
+	if (!crng_ready())
+		try_to_generate_entropy();
+
 	if (!crng_ready() && maxwarn > 0) {
 		maxwarn--;
 		if (__ratelimit(&urandom_warning))
-- 
2.35.1
