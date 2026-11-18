Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015271;
	b=FED01a2EcjpDtnL2HXbiJtjThwLwk4Svdt2XC84gGTykPIh/uYu0Z8D/fp1p9EJ+zt/t
	 4JPCFPPwDbaLgJSYsPW68tb2TaZ0rvRap36sU1aOFXmguDqpBoz4IGhttvTFqQkpokh//
	 VK1NtvKeoy9iCernuQnsK9gNQJhTYPvT5zQytHRoIEqjQWLNqq2L91NsS5Aj7LUy8PZDn
	 Q3LtfX1Lx9OEPLmGS11vDYZdbwwTYefPCR7orgfupHYc2a6e6QdbiWJMW+kAb0umYXjcq
	 faFokSp8NyNVgP1WT5acAKXysG5MJJUBbzoUOqutbH5gJDQrc488fA00K21FKUKb/fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DeHwzQh/WQCnSpbas4x17K6MNfATCbfzGCTo6FaZ+fQ=;
	b=izT5Ioh4WYHUJnKZaIm8I9jnr7GXkpL/Ck4tfdLJZ9Gi9I4uxmXVGKWclISsX2nPRd3N
	 cRjjX7cKzFsKkHFbscFk9JYDq7ZdWWGz1ty9njfMvwsvBh3HSQukyBghwU/J6g1hDoG4I
	 DKUsRqMMpCK3vX4IAEnwk5aQunB08lIo6b234AubFM3PNt70eb1hD/mEnz52daRCx1hW8
	 RfY/8YeyVpm0lpfXqgE82gQRs6DUhsYgMe5ubyxXaMsyhZT7Bq9YLakDPwspwWuN7CYnF
	 8Fdz3F0JyGEjH16k33LBkdvBTGFE5UfCbJWyj5YP7rXuF/Ip79ENdmu7iQXGMdRcKiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xK/bJnAH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28921606A33E;
	Wed, 18 Nov 2026 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xK/bJnAH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B00A1F000C4;
	Wed, 18 Nov 2026 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015271;
	bh=DeHwzQh/WQCnSpbas4x17K6MNfATCbfzGCTo6FaZ+fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xK/bJnAH59OLSwq+LcISMAMhhtnfonyBecIyElCdQS8KY8AWsMMWkL8HxKeLeGL2b
	 M6/CqBSW2iWhV1pk7IHAITG27ei3B8E3mcBc5v8JoxsEipvNlxVP7ZqsTgzRIDjFyc
	 LxWKGnnkEDmcyRZwB0Pe90wEeXRjTji9n0nrZRps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0112/2651] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:22:32 +0100
Message-ID: <20261118150251.916120095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 45f0e21b0e780..ae63366b86c6d 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -157,7 +157,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	buf = malloc(bsz);
 	if (!buf)
-		goto error;
+		goto error_noflock;
 
 	/*
 	 * protect from writer modifying the file while we are reading it
@@ -246,8 +246,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
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



