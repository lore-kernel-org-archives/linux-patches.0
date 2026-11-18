Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015268;
	b=iFjOshX75UxvGWBZ303XjBneU1qRlzjPiqBUbiyB3qbr7GDfM3XHEsLJkoVfAIC7fFLd
	 S7ZZODYoc7Jti8Hzr/6zS9FrLbToBJGZmBDgC18P3sx94R58KW9p4viL439gnAcYaQ1jd
	 j5eef2zhSvtB75kKw7hNlRTu7TvjMjOx/5CNwFOgVcTOixFxDnKdE4HEU8j1CPrTM/eGS
	 NrG8/mifBeYFoPCiyhstlJ9yo9JIrr7rrh1n81nSD4gBteEvWjmWTJ8hwnwqYuwlKN1/T
	 a0U7/vUFFMEXI3E8yxCJoAY1rfg71MFQgbRRujlauaTdBsqa3XnscPhevUTwQOQHLiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8y9CK6iT2o8A92oogsh1WtVomwhpBbOCvycWYlJXEA=;
	b=MfU9YVijQpGPUQ9ucwsPTipZSv3kP+6MZzeSERW8jS50TJp8Draz9G3U6JZXTcBhhOg3
	 YW3+zpe9aR49neNExgt6sIVkbKZp/kd6lTPN5SXsiWS7frLVJQSCNAfHvZoGYmI5zRVia
	 xUXRMjWaobRbmkuozULGwRcRCw2xdvVR70DYEO1+FOKgabxIqWnWo0su49y4knjRisQG/
	 k/Frz84D5qKThyHjAFc36unoM0WCakAhkjedHyv2tPG8IxTRhlf2/kGO1VPQdWw3Lpz1H
	 VE7PGuRUZMlWMYhfvKxliL9lIaLG9RzuExuGZRaYxGF6bvETePi83kDqgmTbPDxrJ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5rwO4Dp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6587C606A320;
	Wed, 18 Nov 2026 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5rwO4Dp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61B31F000C4;
	Wed, 18 Nov 2026 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015268;
	bh=q8y9CK6iT2o8A92oogsh1WtVomwhpBbOCvycWYlJXEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5rwO4Dpn3tWGn3HoUURqZ3gzlsSqn1uTvc9+NaZXHd+vt9HSbeo7AXvAz4u0tXHy
	 Ecue3OdJecugJ0w3zZSzhw5IuZLhdiMADjdTU4xflATVOqwx1sK62bAatbRIE3g9qz
	 E9e+SDCQtDCpMN71e9oTpKa95O5hRfiDFcKMQeSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0111/2651] perf jitdump: Check snprintf return before computing header size
Date: Wed, 18 Nov 2026 15:22:31 +0100
Message-ID: <20261118150251.880017069@linuxfoundation.org>
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

[ Upstream commit 0155f05ea6e133c18a04b8b5945cac59870da156 ]

snprintf() returns the would-have-been length on truncation.  When the
jitted filename exceeds PATH_MAX, the unclamped 'size' value inflates
sizeof(event->mmap2.filename) - size into a massive underflow, causing
the header.size computation to write an oversized header.  The
subsequent write to 'id = event + header.size - idr_size' then corrupts
the heap.

Clamp size to PATH_MAX - 1 after snprintf in both jit_repipe_code_load()
and jit_repipe_code_move().

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 7efbaa07f1ba7..45f0e21b0e780 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -495,6 +495,9 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 			jd->dir,
 			nspid,
 			count);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
@@ -625,6 +628,9 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	         jd->dir,
 		 nspid,
 		 jr->move.code_index);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
-- 
2.53.0



