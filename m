Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022867;
	b=KWMgcLsOUZ7U+KTz+bounZGuk+AztkYgjUaqmdtbG4TfSgwDBVAoQc4esFI9uw5oeWeF
	 Gh2Nx1Ro6Cle+lgJmZ07DAbhUH2JbWlN8F1/eL+iJ0jOQmGKH5DK+u0/IuoxD6mbStr2p
	 sul58x7GmVwCxl4NPj7BHPRn/rH9DGVd8Bs3ff5QSUSkQicGwfRy9J/bTC5mAYIiYQ1VV
	 FsCVjsdE/MV+DLj4TUAwqPF3QqS69zUE2JBifJgnH3+1ury1fB9/0TtxIIprPq28SOwYP
	 KqL++fgqn3BT9uQY01X7vHuDbdb8Yub2+cPQj8zeIO3If0GgaEEX9UylY5CcmU/X1Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oIqVsmLA2dFiup2SHnwV86YEgC8amCeK83S9pEtjqBA=;
	b=uDI2gtLB+a6BqE8MnNVbd+ng1cIa3ws/OtPqFMcdjWjlqPpTkBw7RXaSIBGrya9mUTRN
	 BwD6ksCeOaXBbyniCzP4tjv897JaLpRsottXL/Lz8XIHdxA7bjOF+qLunAHtFYTmhak8J
	 O5R+RgGEDWv9RBL8uUWTi9vdtgj7et8yJT/UTNSnVTNet5u2o+u2bP7ERcTeqxJDAuWJ1
	 dxoIm4tfC+pDQt/vspHYTa4d9/gW/Xx5ktkKQ/3NeK4vE0i72U3Dl1wqTQuuVsE2VmGas
	 4ImMfDKEdEU03shY/SeTU1ZhB9SCQRP16rQ+0fON2caZa0QcJaebnKg6l5BTcoTC5Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5w2B1rI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5205606B5E8;
	Wed, 18 Nov 2026 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5w2B1rI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31281F000C4;
	Wed, 18 Nov 2026 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022867;
	bh=oIqVsmLA2dFiup2SHnwV86YEgC8amCeK83S9pEtjqBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5w2B1rItcYpw3zVIM5YfRB2ICN2aGqUgUp4aerV2p/+4q6nq7xRjiv3C/lveCKDx
	 WgC6SBExsGnME4DQNhRoH+8phHLYq61dK5KoCl95l1qXHmYxk/75KAow865fwEcT5j
	 Zof66aRQTDLopyOvTSXwzrRMALxJfXnYBE4IIQVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0165/2151] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:31:40 +0100
Message-ID: <20261118150127.758321454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit bfde6848c1e24fd979d0138c57c1cc28c35093c3 ]

If the malloc() for the initial read buffer fails, jit_open() jumps to
the error label which calls funlockfile(jd->in).  However, flockfile()
is called later in the function, so at this point the stream was never
locked.  Calling funlockfile() on an unlocked stream is undefined
behavior per POSIX.

Split the error path into two labels: 'error' (after flockfile) calls
funlockfile before cleanup, 'error_noflock' (before flockfile) skips
the unlock.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 8e561a0eeaa7d..8694f29d3b652 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -157,7 +157,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	buf = malloc(bsz);
 	if (!buf)
-		goto error;
+		goto error_noflock;
 
 	/*
 	 * protect from writer modifying the file while we are reading it
@@ -245,8 +245,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	return 0;
 error:
-	free(buf);
 	funlockfile(jd->in);
+error_noflock:
+	free(buf);
 	fclose(jd->in);
 	return retval;
 }
-- 
2.53.0



