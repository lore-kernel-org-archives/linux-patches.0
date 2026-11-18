Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054624;
	b=j0ElfmGH+09pbImZeQexnQVznGQAIRJC4dYlNEvXUJGqxCN6Qzjg7N5NcIy3GJBe0Qev
	 mZ0lf0sGAKN8qT/RbCUqRsgdMCqcZhDZ9BQCcC5+rKIM1ghF7XaduoBl1rvZZM0xNYao7
	 gdV0KlI1xlF4el2aqCA+7DCjTx0eMV17+MKPcoUqRf/gmTuBEM+3lUX5Q/CjOFAro9kld
	 qfmtgekb7oWcq90js4MhJ8dccukavL8MyDCjFwxDVxstN299JvyD34jL2nmHNPtbflYfM
	 BV4quqEOQB6lwOrSKW9Xb5RYSLMbS7g5bv5SUyEWBUpbUZGU0FlUAEjGF4Ijp1UrpOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rRGCtY+OlVfEhWvMf9gsLPJKuZ2PWlDgFuBM64OKDWo=;
	b=nnphkUujM1GF6521VCw/d5QYXjXsswMwdeOEChdKwqpVdF7VOW4VWLlnojNoSZKjHXU+
	 4dAjcaP/ETG6iAhs8u/JE/UttyKhf0sNd1hC37iDL/MDDvYXj0b1/4NO3bEKbwqkpoQmG
	 do1FLaI0ouTreBIICQs+dUbFUZmI+7+QAdTfZcHx6p1rYAE2Affk7TmvssZ3XMEkjG+7Z
	 PzeMxDH1StD7ZBypreUsOfxtKJSPUPQvzi0k7UWc8G02PRctVK0Nt7cbE6e7Kl1fSdyrX
	 mTYI8MC4URWkACLAr+7c0rou3ESWtLKWKe1LzcNfNJGRjTYolPgiidJAaQDTNyEh0rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kNdZOX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C1C606A31C;
	Thu, 19 Nov 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kNdZOX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8EF1F000C4;
	Thu, 19 Nov 2026 02:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054624;
	bh=rRGCtY+OlVfEhWvMf9gsLPJKuZ2PWlDgFuBM64OKDWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kNdZOX0nQZCMEYfCcmIsLf7cJYAMcm/psgiX+UMmiyFS/so7OtExBrLrVhTkCMx6
	 zJS6qjIl2gIVjCPixVKMGjTjrbgu4Naqiml7wXvvWbheah3mfcT52H5T4OMoX3ghV9
	 pn1pD3O6jyg0eLbAj/KjnHQLDoQ/Ib8LuCp5t8+k=
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
Subject: [PATCH 5.15 1342/2214] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:50:18 +0100
Message-ID: <20261118150105.114034933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 917a9c707371a..051a29c29fb81 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -230,10 +230,12 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



