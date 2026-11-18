Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029066;
	b=2C56U7C7E42fILdu4E8TULDKy8Cw5igmhpY4Dib7MZNOCkVPBd8PozrUV6M3fvalFRE+
	 x/ln7hItpTtVrwBZVv/xsyNA9djS2nARr/ttohN6gEfcgqdAKS5H0gvakHYL5g4tYYpcg
	 R39itGTl7LfYkY8kVnzsiy3spvC9K2PL/zBWs12kYq2DrJyeCTMhmiFhrxMjQtF+VmSEd
	 d6NOTBWHJkj3Mw4tSaEQ6Oxx7FhzgjrlLcRq14kb3maJxvbTKQ1nm12BG6jOSPlmy4wlO
	 z5HXKEC6yTqWz5cTQqXDKnXoZcs1sw/ezsT8iPQ+jeVtRPqzQQUnjPUBE6kK+aTM0OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZVh1TUHKbD2ZF/Q0Hz1vtniD9R1dAnMsuas8H0T5Qrc=;
	b=h0c2AFeLxguNyEnZw3i0qfcTAKSiQWEfZEJzyOaWAkagwh35JV/0nLt+02oV/YQbOBkU
	 Fk09ymANf/Bix2Cr6L9/0KSNUxv89FDFxsWbQZi4IUHb8T4r8lQJZAO4pG31lJSUWd8on
	 ItGOq00uwZq37x2LVIX5RScDDa0lsceC9Q9tQZq2biLyGh70TXeWgx9WjS9taxPOPgwI6
	 jBKxY9qUsKxMLX1Ntk8vGec0HBFtmsPqzzOGhUQ91dxFc12ZriAfRrQoD9nYUOFQuu+tX
	 4DCHC8Vfu9D5nWIe1SxNZwACwMF8SqvdCc8LsgAVFnyR9nVwNUr5DaAe0FGH9xAnxmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mhNq/IBO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A84606A320;
	Wed, 18 Nov 2026 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhNq/IBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963F01F000C5;
	Wed, 18 Nov 2026 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029066;
	bh=ZVh1TUHKbD2ZF/Q0Hz1vtniD9R1dAnMsuas8H0T5Qrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhNq/IBOJ+tFPcb6z4wQ3bQjBIS1BIwXAYTeIDBs9qF0C3mhpV8gwwEkX8EM4Kr5D
	 bxgrs+xF52lHLMo5NxGwQ373sN6V+BXSYGJBFvQLGgY6voziQCW4SO2VsZRhrgkVpS
	 8wJMK4ysHcQWukL5cvu9XsqzlMuc8ADJER9RSh10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0168/1756] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:38:15 +0100
Message-ID: <20261118150015.032571339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 128f9dad78987..4b329536c0c0c 100644
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



