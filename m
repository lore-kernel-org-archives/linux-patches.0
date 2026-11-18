Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015297;
	b=fPDQ1Rd1gwAINvh+64mb0TSzGNydRx6cwW47wfzlk0aSdAw2FYyBfXeamoaigsSe1MCH
	 URyjf+lIcWdBgeb/pMV35ct+kT2R+4skJyjOMGD5jwV/R4gUO4EH+bRwstpi31QSWzsyP
	 Bq7068hlCtNMtbCaFKnTFgzDBvZQhEl22jzAKZSRkVmsGP0MZYNQgRTNMCXYiOtAkubCC
	 C48xocrUEsvEVPwtpk9rirWGtgne4P3miD3QNJ2KDRFYOlMO8dA1d5SC1lM7gbxBS+Ey0
	 d30q4aqp5jHU2yoQhxzmUDhsKd2WNj2sZnfKbO3KdUHia4Z4cBmy3sCaD64YhswAh2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cs3JczpzQfP6u+mbt4ZFM6NY3MZAtG4J4YRrFl9Sges=;
	b=D62uMVIygZJTcOF0B03hJaaDTZN4PuiMq8obi4dnMgTOXi1vXg2VzD6H683+UzJgCvJR
	 6pVDmwex+NALkWPesgHox/u4+Wpe3V0pshY2mAO4AwWP6y8Bn9MMuP97RHN/mAhJSjA5T
	 syyxuWMIe8jQp4AH/az6xGAlGZoUvc9WsomgzKEUWPORVVnFPE5zq8XIOAe1oe09epc3U
	 h4ibapyK4o6Bu+qUqqp76OuZvOrxd9iMkS/4kfgO65Mny5wjkDNAxK4WoKH6rX9PR80RV
	 Ucv30qULeezZFqrYsqtJH/wU7S2UoT3/RpFbjERdgDXr+FzmZds2ddfoK0YlbOuecVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGrT3mG7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF09606A325;
	Wed, 18 Nov 2026 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGrT3mG7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB6A1F000C4;
	Wed, 18 Nov 2026 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015297;
	bh=cs3JczpzQfP6u+mbt4ZFM6NY3MZAtG4J4YRrFl9Sges=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGrT3mG7+UyhUPshII4mtY9NdZI5xWwlk5M96GGTpGbY2OR+kCzGagA15Cnpoy20l
	 TC8fCY8wtbSiWQFSr7WmnFUG1CXyb5L6dNewC3gBvVl1FuFBdb1mI+wojIl3hJTBZ7
	 oHHTkwpPIMiDE1Jyg7eBRpWHRq1oZYlQUZ0qCWjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0116/2651] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:22:36 +0100
Message-ID: <20261118150252.052818844@linuxfoundation.org>
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

[ Upstream commit 98bfe1142ccbaa5ffdca5dcdddd26f238ad33585 ]

jit_repipe_code_load() computes sym = (void *)jr + sizeof(jr->load) and
passes it to jit_emit_elf() which calls strlen(sym) via jit_write_elf().
If code_size equals total_size - sizeof(jr->load), the sym pointer
aliases the code blob with no NUL terminator, and strlen() scans past
the buffer into adjacent heap memory.

Add a memchr() check to verify the symbol name is NUL-terminated within
the region between the load header and the code blob before use.

Fixes: 598b7c6919c7bbcc ("perf jit: add source line info support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 5a3ea2681fb37..5898a7d8eb962 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -487,6 +487,13 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
+
+	/* sym string lives between the load header and the code blob */
+	if (!memchr(sym, '\0', code - (unsigned long)sym)) {
+		pr_warning("jitdump: unterminated symbol name in code_load record\n");
+		return -1;
+	}
+
 	count = jr->load.code_index;
 	idr_size = jd->machine->id_hdr_size;
 
-- 
2.53.0



