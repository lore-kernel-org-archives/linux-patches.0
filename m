Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039255;
	b=v6NRBh3nSoy/Qvnr7DiBmYMC/JdPbvVkUyFmXxcV/NJ6Fav43SG2sP5uaQberrqh3LtZ
	 DqfPxaSubk6Rqa1tL+ygjzjaoLcjpAIVcCgVHRMjfnFB/GTUZw5g5jkDZFdjNTQirhi6B
	 /L3QVYU6Ru5xuSzpNlrWcInQgDI7X2wzbwjAI23UkL+P7itzWvHhg69cPq5F4xKkuq5Rs
	 gl9ZvKulZQTlYsHDdvwqFPt0UHb/l9l/k05yqw9tC9aJAadySFfm35ad/fW/MFG3IvrP9
	 vLULukj5VNpRbHzwzz+yTPYRePnJKRoJT16rLYXdo28V1JIHY/5Y/0dMPgXRzCwjyLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2jMK2gZBFJd210aX1QgHKvnqI1ipUUn2K6PIO+GkUDc=;
	b=Sze1KX3GKcNBjme9xmCDRlr7+QyCYc99T8bFxHRj0MA9UyF/0EJ+NFpw9OOgMC8W740F
	 3fMKCv8ZD9LK6EO95SU2VQNgpgXDPX10zrmJ4w6J/xOx4yiLHwPSxdhl+M5tMIPGYJQxf
	 GOEo2McbJkglTO2elfFVZzUuboYtZrmUf2W5vGWHUkw/4xel7DcYgkdpsQkND2Yqd77YB
	 oGH4IBJyQwzAHNpHCfwgicB15vXSxqHPoqB4j1DSKnG8Nb2HxH1ukQGOGl/+tJ39+KoT2
	 faUOfcRlF5zsozh6V/s22LG/GExSdEg6k8/6uhsIlnX2KE/d4EfhFwwU44p48guuUEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNCdovR7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C52606A31C;
	Wed, 18 Nov 2026 22:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNCdovR7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ACF1F000C4;
	Wed, 18 Nov 2026 22:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039255;
	bh=2jMK2gZBFJd210aX1QgHKvnqI1ipUUn2K6PIO+GkUDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNCdovR7Pp0IZn3YHgA9miew854qdAHUxH+bGKlGHtHmpljD70fjc6Hy3zHW/vbe1
	 sDPfgIpoSh52ct8ltorgsTLXYF0LLlbcYK/BCyflBQQMhWXqZAIHb+1B49Ds7bIKAW
	 ipVSyMbq0KYn0I0g0E0/sX/p61tYMpPSE8dkQNBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2008/3318] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118150422.289251937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 37aa6729ab0f2..f35b68d796bab 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -156,7 +156,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	buf = malloc(bsz);
 	if (!buf)
-		goto error;
+		goto error_noflock;
 
 	/*
 	 * protect from writer modifying the file while we are reading it
@@ -244,8 +244,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
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



