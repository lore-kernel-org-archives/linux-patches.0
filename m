Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039169;
	b=1T4WIcFaNs2FdjchxxAqS0YLFzfPR0dRwg3svB6MCH++pMk+EsalhiQjpYIF/eEypw29
	 NGDxOBB5jwSA4+MQk08+cMXu3iGhUwumcAJt1Mi1q/pm+N5AvN859cSX0fWlSzGiR1635
	 x91UEJ1ASdWVEqrIAszZb3JFxPSTsePaDltQ+Cw3y+x2bzx8KCpucdSIRGJ40It1HL4Uf
	 RKhu3lmMGG1obNgfuNDJqaDn4xLCCFmI8QFS/OeT9/E+erc8DscUaTC/E4sDrxL2fkE5a
	 v7r6eYtEaBV4mcvWXpc3zyXdDJFvhiEE0aFp7qhNF39BVp8xf8ThnrkD54t7X3kDJ3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4JhZPjODckV/6VSI4chlH5gQXK4+CmEBc0rjsX5FLoQ=;
	b=IEAGK6D0w17udQCUC1BFX27ztAST89Wpu27MAUEC5EEVcB3fW9QLnxkRq4fr1EiarOFi
	 Z6YJl0ffa+pLGGBFNZZrnbcQik4o9J+ERw4SHCthJ+WSm+lfmn632EBbVFH3rpEV2KSEn
	 i5Q4oc6TNDYHsPhWgAOik7buSKF8fn2WQKsymdxzMO+0YHemgMPtr+iaeLBItfBwDeQu5
	 97HeusJOa+22FQwNSgc/6hS1qDy5/GuCJ0xFEKPWVRtPcSGsFOeJRHnTVXEwFfhtm3wnd
	 81hRCdsuMP9m59o4yB9PRJHQZkJz6OOYJ2qoQ6/Mqz8rUwFp7a5geml1b3Q6sfi3z2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zd5oDwV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6004606A325;
	Wed, 18 Nov 2026 21:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zd5oDwV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1858A1F000C4;
	Wed, 18 Nov 2026 21:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039169;
	bh=4JhZPjODckV/6VSI4chlH5gQXK4+CmEBc0rjsX5FLoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zd5oDwV2tP1OrNY+xLtq31CAdfyyXdfDdtO4DjbtoCPL0lVNTZdM8AItpzcgt/h4A
	 +8v7Mm2UDgWLFn0bK/bgW7bbWeH8IhIaZcoBtiu5/MxEzbqAZUjOi82NUWSVAobBme
	 9ewFo2KO/JjkIw9dybW59PVIjygD+V9hjftmOnYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2002/3318] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:43:44 +0100
Message-ID: <20261118150422.107874570@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 598e905931380f0714d5fd50cecfac615a1ec742 ]

jit_open() sets bsz = bs before the fread() that uses bs - bsz as the
read size, making the expression always evaluate to zero.  fread() with
size 0 returns 0, which triggers the ret != 1 error path — so extended
jitdump headers (total_size > sizeof(header)) have been silently broken
since the original implementation.

Additionally, when 0 < bs <= bsz the if (bs > bsz) block is skipped
entirely, leaving extended header bytes unread in the stream.  Subsequent
jit_get_next_entry() calls then parse those leftover bytes as a
jr_prefix, corrupting the record stream.

Fix by separating the buffer growth from the read: realloc only when
bs > bsz, then unconditionally fread bs bytes when bs > 0.

Fixes: 9b07e27f88b9cd78 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 6b2b96c16ccd1..7be1501c8c918 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -223,10 +223,12 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 		n = realloc(buf, bs);
 		if (!n)
 			goto error;
-		bsz = bs;
 		buf = n;
-		/* read extra we do not know about */
-		ret = fread(buf, bs - bsz, 1, jd->in);
+		bsz = bs;
+	}
+	if (bs > 0) {
+		/* consume extended header bytes from the stream */
+		ret = fread(buf, bs, 1, jd->in);
 		if (ret != 1)
 			goto error;
 	}
-- 
2.53.0



