Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047752;
	b=2LsU3f/K2XCxEYeTdr3ZigpL3rAB1OrsuEF7Abw1BbGwDeBkqXFso9I3wkUxwcIwqq8B
	 lmr9RPvDdD55Cz48j0pTBBsBgQC3DtQSHtgiS9WpA2p/pfX1zPv4KE5YKHhmUcwLFo6pK
	 YSD4hAyT/HPAB2bdPISdU32UNyKWzRghKuzKtWn5LZvAyXKlpsCr8ROY8X+DCvfDX6f1+
	 kzvVSC5uoIab7Lpvyow+sAgsBw6FJdnyjgYywT4Y2VbG4jrLBu1q2f9MUpfDVooOQ4agp
	 +Ggbb5rIerCrPeh2VsuXPYHNSY02j04jDtrVcPDK6RU1O9JfBd5xi6ZDPwe8EMLxq9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGGMsELhIcKPAtGNkI0UF1+ye/RM86ctkpDES8Px5rc=;
	b=vxd1fh7Zd4gASNtIQjE/oFSGsqf9uTKVqvtORpZucC0jNAWKyRT/X1D6fhXKbHtWqszy
	 ayrhPiurtRdrNeu/TquzzcDOdi6bGe17elCvfJuxvhQWeqaVbKVWqw1PH5N9cA8vMyDG5
	 fknHLNq5ZRpE83eErgfkKv+89/NhUJ1xwqBRPjSrgYugjySupfL5A/wL/POcoLtSJ4WlD
	 FzHvHCL3e4M+R+dTcdAzNBx/OQOcfuvw/KWQH+NnSlhDxZc64qvj1/4XlgtgN0TcOVvmi
	 t4BYyVEiHVZVND8tvbfFUxRoMUc7U15x5Maaia0gIrSZqCXKjdWfLTbl1vew3P7VONQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJjG0Dcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6BF606A31C;
	Thu, 19 Nov 2026 00:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJjG0Dcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716231F000C4;
	Thu, 19 Nov 2026 00:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047752;
	bh=tGGMsELhIcKPAtGNkI0UF1+ye/RM86ctkpDES8Px5rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJjG0DcgX0Xp2UuqoT/fe+nvGehatdtOTdNiVlsQk55VfRkv8ZcCfuYY9GaG/zd0B
	 bPhQuIToUYaQHyGd+zt/xh0sFmP5HlBTHzlS+ZNmemJvMJPCztjc8UUvbv1bvsT0ve
	 C4XONI78dHNnb2z+po+uivlZeYoZQ6TwRft0qj8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1751/2857] perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path
Date: Wed, 18 Nov 2026 15:46:25 +0100
Message-ID: <20261118150304.345171551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
 tools/perf/util/jitdump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index e7674162add99..9d44a039464eb 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -156,7 +156,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 
 	buf = malloc(bsz);
 	if (!buf)
-		goto error;
+		goto error_noflock;
 
 	/*
 	 * protect from writer modifying the file while we are reading it
@@ -244,6 +244,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	return 0;
 error:
 	funlockfile(jd->in);
+error_noflock:
+	free(buf);
 	fclose(jd->in);
 	return retval;
 }
-- 
2.53.0



