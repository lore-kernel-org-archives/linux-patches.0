Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015276;
	b=QF2PgqfAs29eatbBRsGbMGf3axk+mH6XCZ7e8fbRmmb9XtlAqgNTmqb5pkOdvC6NKWWs
	 PjeS3ayTS1SzEnjFUd5dMBYgx/Z5p778++sl2S9XP1y24m1VNl5hbOSvvShj9ljkOu2Uz
	 hAEoURQXIiQ0NuO+lkwXs4gS5ROMBNC9eG7lsX53hBPZvNZnrvBwrlCUwR6Xp7dz7O6w6
	 nbEHGhYTW/SrfQv58+lv9tQtFA3iUdFYh7j0v4yVNwOKZgeiZSqHvNDIKQI2unEfgQ5UQ
	 R0TnhKD5+oHV/0YV5eJf0c/jS88DjiFqa2JZGmO7x9D2D5G3NzOqHArlvY8rzy+hyKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oLkIGYKRjkMFsnqRPM+XmNyyXBlXsMJ/GmvUjSlAwhI=;
	b=OigeYTFyjplcYnHdQZg4GqPf9W7SURUciIVxIswUqRsET6RaIIop3hua7Bqj6QO5QZ1C
	 v6AiNYhEHPbksWFE86P5N+TaP4KFZxx6v/qyBF+jzpBXqeAU8JijO1/woGXM7HKk1Hxaj
	 k/+DpG7FYnOnK8vIFOh+e7llcsr2AcIZRIR66zG3ZO4pDgLnSrr4A311+YModnWAyvNYn
	 12U+zI1YtQG7e1/anryKo67Y1+0BBCRFPIj7aBc8tA8X7WBTHfYqecuY1aquCl90MewMt
	 VvJS9w4mjlhywUQCVCzGnkCxoNcA4MACZB5If4lDlcb/R5IQP6HvJ/S6QBnCkP6q23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g4f9qq/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7831606A335;
	Wed, 18 Nov 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4f9qq/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E4B1F000C5;
	Wed, 18 Nov 2026 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015276;
	bh=oLkIGYKRjkMFsnqRPM+XmNyyXBlXsMJ/GmvUjSlAwhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4f9qq/LfU+2vMExfBAr90WrvRk8Hv12a36JTHlOQFyBF706DhIPnuQEH0BLmaxpf
	 P74U7ccUTEmZ1qvSEFMil0Uy/FmEXedJPQ1eEMsJO+PFz0GWh2LE3ruwja3npmooUy
	 hO/PkqHXMw4ZlVgUmOH2VNsdoA9j/JvKcEK6Apok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0114/2651] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:22:34 +0100
Message-ID: <20261118150251.986016614@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4eddf7d9e341eb8c41704b8aa27b4a91f4e2c7c9 ]

jit_open() calls dirname(jd->dir) but ignores the return value.  POSIX
says dirname() may return a pointer to internal static storage — glibc
does this when the path has no '/', returning "." from a static buffer
and leaving jd->dir unchanged with the original filename.

Capture the return value and copy it back to jd->dir when dirname()
returns a different pointer.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 91aa1eea8229f..d3de307532d55 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -146,6 +146,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	ssize_t bs, bsz = 0;
 	void *n, *buf = NULL;
 	int ret, retval = -1;
+	char *dname;
 
 	nsinfo__mountns_enter(jd->nsi, &nsc);
 	jd->in = fopen(name, "r");
@@ -241,7 +242,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	 */
 	strncpy(jd->dir, name, PATH_MAX - 1);
 	jd->dir[PATH_MAX - 1] = '\0';
-	dirname(jd->dir);
+	dname = dirname(jd->dir);
+	if (dname != jd->dir)
+		strlcpy(jd->dir, dname, sizeof(jd->dir));
 	free(buf);
 
 	return 0;
-- 
2.53.0



