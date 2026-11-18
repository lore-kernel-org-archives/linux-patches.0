Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047749;
	b=UpL0tQtkBfZysVRngyTPgNedsDaz+0iQtgOTp5gYX3Y1FZhOllbzISd1A0RHngUUEgi8
	 SxM4gbpOv5rG6ZbozCquFv53GwyKav7jjWdykfsx8Wu9BSYbj1VG8JGB8cMZwLv+vE+mu
	 NeDRi5VnADBFFqr4FiPcSARi5+Ju9FP0MDB0gEQqjwnYatftIUHHWD+c6wFnHIhsCVgw6
	 lvagps/9vSrF+C9zRx+wdhUihwkjbxq6pKd0O8sOHfFoh7p2jGl0UIj17BD7kiSayxbZg
	 H10E5ML3WHzgiJXV9sdgesD/MPehcpqLS4ED8znwzbYfAVfNfOfJYLWhQWMoWZus2rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FuSpnj/H0OoxH4GgKygMvhO5taJxm0ty4Vw7xkbo4xY=;
	b=pg8GWi+uoEOmS0+oymKEdm4GHm4DZC5XJghkZCh1yPp7snVk/5R0jz1jI9yyVQfuO080
	 bcZqRXFCkquM0MfyvD5MmaiorrNWe7bLVq35m9AgnQy4B0n6XPWc5++8KOD2/rtnn/3qh
	 tQuatcY+fld4qb4GBcIHa1ZIhSp4wNIwvAmhCEVCMO+qm0u8prUcwe7b77NBMYhuZMnd5
	 eCTZuc4xlghvffR1UksSYsOThJXVub/oI794MyD6OmIiCzu+zxYjYUDXVL14B/f3EXiD/
	 p7lEFZGiKkAlwk4GF4XXPt8bnSjyBoil4bWoea+8LQ89P4IxPb8ITxGqKpD81PaCw8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9zdwnih;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB29606A31C;
	Thu, 19 Nov 2026 00:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9zdwnih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C671F000C4;
	Thu, 19 Nov 2026 00:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047749;
	bh=FuSpnj/H0OoxH4GgKygMvhO5taJxm0ty4Vw7xkbo4xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9zdwnihqgziMXJnY5ndcjYx12k00jTD2rOtdMJ3XH0Y++wMseXSK6pS4fr3F/4IZ
	 x4n+cXQmcNh+y2N8Eo400zJZZp4NMpEvBbGO7UWiSRXjT1g87ZOe3Y4gzpLurFI+iQ
	 I6C2PhLRu1BRWAJ5TsB2yTx2hGsU1QCZFDrP7M2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1750/2857] perf jitdump: Check snprintf return before computing header size
Date: Wed, 18 Nov 2026 15:46:24 +0100
Message-ID: <20261118150304.308359902@linuxfoundation.org>
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
index d7f58e22f40f0..e7674162add99 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -491,6 +491,9 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 			jd->dir,
 			nspid,
 			count);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
@@ -603,6 +606,9 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	         jd->dir,
 		 nspid,
 		 jr->move.code_index);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
-- 
2.53.0



