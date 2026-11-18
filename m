Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029063;
	b=dhXMy5USw0CIT+Tb/scN2nMzi1jUZl9ou1j7ZuPYzpjP/sKEDgUJZU8W1JlfA8ojkLsI
	 5bX2+TJdSzJdnw6qLjw+jUEf3PsuBWdRkvOX/uJOczvtzuimx49U3/fFDfIP1q60oE4WL
	 TR/0PyJjxoMIBS/heGeSSnlnYDTsi7l0P+HdSlS2vIj2eaXryMchUSnUVLvVtij0SLMtF
	 E+Ajmw1TRkDk7RVSUmS/eKzmmlYX6D9K8Mz8WUH3F/1ZNFYQkSAo4UUjZI9LosyeFwBKb
	 UsAG56KSA8ugYRUz1DbLmlxjBmBRxIIkb09tZUsj7vATLXfRDXPt0u1RlHY5d9FrQPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSUP2jdShkH2HqiK28LHELtQBEfHyb3+fwLTts7jUxM=;
	b=0ttjOD9h4cPZ9zWxIe/8Eqwz7NZ5IO3aGO3V6F1LCPkYRsTgNVVdLU1pTYmhPQFd4f2u
	 nHR2NHnjKqTW95FGnezqq9+W0LhZFBifx5ZE7nLKHTiEi5lyOw8ttnBZoF3Y6Q6wX4Aoa
	 UrBFCd4U6KoZrsV2mIGVURcDGYNikz7pZSIJ0gjZ3t6r5cI68cLQLPGrYmgqlvuuCAmyk
	 Y/PNnNZw8tmHQz3Q0C9QyqZ89IKeMsBTINzmDpuw8NtuRgiiMG+0SCWl8XuCgZKgguuLv
	 +iqSWO675a41jWuP8NBphEAixNhsFdrJsoEC8YnGGK0JmjBV0/o1KdQbop8E8K1Uk4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hnt0D975;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73959606A320;
	Wed, 18 Nov 2026 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hnt0D975
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40841F000C5;
	Wed, 18 Nov 2026 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029063;
	bh=uSUP2jdShkH2HqiK28LHELtQBEfHyb3+fwLTts7jUxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hnt0D975W4vva73npWJjY03yxpt0MVd8zde+pnlGNZaEPoqSwhlmtPjkkEaDJPalX
	 lxJCugzGBwZFljGPVlj6qjonf6VGvhDO5aXUWlydwGQ20olHvcltH2Z+eoXySnWbS+
	 NqtrNTgUGcJK9vX4Y0JdCfzZdVSULQ5aZsMfHkuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0167/1756] perf jitdump: Check snprintf return before computing header size
Date: Wed, 18 Nov 2026 15:38:14 +0100
Message-ID: <20261118150014.972281814@linuxfoundation.org>
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
index 800a888081e60..128f9dad78987 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -493,6 +493,9 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 			jd->dir,
 			nspid,
 			count);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
@@ -607,6 +610,9 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	         jd->dir,
 		 nspid,
 		 jr->move.code_index);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
-- 
2.53.0



