Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028985;
	b=JYZMlHIvUcwCPaJVtv5nbcRkLonViALJ1WghkR/thNNGJASW/am3Kl/4JHvkpXOKvKk6
	 5BONVUVhDGHPsO2uyM1xfOn6GYRe46kdH+w2bjdqv+WO7hkvfTxxicvvoZmgcc93FiyoK
	 Un6wy+q3qcJfHu0rM8GbuzRYctKOBF4EiMOqN7zeH8HDkpYkjK1V5mqVefdMcyj8PYcir
	 hS2CI0wgSMfPKy/l9BdSrozTX7X2Q6DYA+8/jYgxVPP1hcHk9x/xoKELkg/OkAsmo+bND
	 //nmNqBCKxKVVqR16itVrmAVs8hW8pSDcujMguu5z+QAHFzbmdVUnSB1uVZUcb3Wjlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GysozX5e36Ub/9JYqjCuQTE119ejwPtGgjyQoHyC1Wk=;
	b=ysXOyqzy7XLTqbgHNTk0HCea4BZHYQgUcqCFf1IZe0Au4i/3X3emIlhpCX89Xy64dIaT
	 x+MqIWAU3rBciOLmLCj5+Xyeh0cr7aok/5fZfnKl0JVrdfiQL1ZRB9RA5EQxixm2DHJCs
	 o0Z4+wmehlEJiiGf+d7X9ioyAtgizl9wxgpW05KkYKyGrkQg5Gx5s0S+TUw1FVwJJwmrN
	 gvjXWv7KJM1r/F6Bqu/nUjHDazh88/TgYzR+18VewCSnd0xnH8dWDhKxHk/QvQrSHDsfy
	 hzcg5cO9kLKkW5UrYzW6mgkwQJ65s756K4i6frIS8kRLybZEGAhZg1e7EzNmyxS/GgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiukPNl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1654606A31C;
	Wed, 18 Nov 2026 19:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiukPNl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424A11F000C7;
	Wed, 18 Nov 2026 19:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028984;
	bh=GysozX5e36Ub/9JYqjCuQTE119ejwPtGgjyQoHyC1Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiukPNl0DqWzwH+EEF1Zs7YbvH7eYy2SlCCC9vzX7uSF0FdiYk1AA2gLSLxBnGNr+
	 yKHg7dsPIfxUoZ/S6XkzLneue1lzl4n2KvQv8PuXVMoMAHaAp8rIjab93TplTyvX9s
	 33oZD9QbBaBHUKaFkDIqdmKwwsQ0INqoOdBvA+wQ=
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
Subject: [PATCH 6.12 0162/1756] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:38:09 +0100
Message-ID: <20261118150014.643058705@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 346513e5e9b7a..0cb6705ab40d8 100644
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



