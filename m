Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028942;
	b=YPYU0kNGOFdS6I6gGRui7DnD3EAgv13yl2WSlTkxUE4yfOfztCBGc3QDLAYk2r8M4tVy
	 /aB29e7VM65PSjyUghdUiauwON0/h9Fi6xl4nxP0v9EuQ7eWU5exp5qynpTsz9MEw3PCG
	 No2Yg7VyU77ce5q5YiGOpGRaFQOraTEG72BezQVweRzLW10/JYHkMQ/FyjThAYcm/LuvO
	 fcCqL9nWP7d05txuyhZV3Pf/8ICCDCMlXbHqiamj9rmyhpTqIUq6JEkdd4pydE+IBCOA/
	 4h8uJIX1mDPOsH/Rz8ADycvL3mbsGtg7YBXYF1doP+iXD5PmnBEvf+HIZR3JwTXLkUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=00Kliof3C3dBcUtlvMxMX2hz0nTjH9UUmK42nX+Q4KI=;
	b=RHJSTP9e6U3aZgyvhRtSVhAbs7WKKCVhooQd7X8BMrM2f7Al/Uj57YQDeytVGQFTwfI0
	 VLKlTWoPT9F/I9dm2tKm+G2YYoFhLDtmWSK342q3eSr6YLo1PRJcbwPLkJuM6qAIWD1sd
	 yTm21b1Td90I/q1NPhtoHKNB0kY6ags7WUQW0q/uGkQyr4yuZ3f+J26GL3nh71TqUcMG1
	 9VcdKEWFuvGZuksODFypidSWGc0X/4ovzUPrVgE0FS5ATy/aYlXNToY9A4q23W16xeaFA
	 g0f07jmyRsKknlR/4THXcKrRX+bQEw0z/eeahwtXF7RAhOJr+h4kco2+7SqwTmh7kCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGN2zRrO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB95606A331;
	Wed, 18 Nov 2026 19:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGN2zRrO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BD91F000C6;
	Wed, 18 Nov 2026 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028942;
	bh=00Kliof3C3dBcUtlvMxMX2hz0nTjH9UUmK42nX+Q4KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGN2zRrOew3ApWwvjarYaBzVNwp5Bge2yXmmqdhI9zJUkUPnjEOZYqd5HUFfEoAck
	 y0qhVcFzRsB51oyzs+NOBoSyd2MFpYNCB5pSecLxNQ8ReBl/FKcRWEZ8zzVA+K3tl6
	 b5eUE20HYZvxTZyDaSAulgDGkyEBqKPmcyufIWHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0175/1756] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:38:22 +0100
Message-ID: <20261118150015.422681787@linuxfoundation.org>
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
index 5c684db97fce2..4cbae8a02d2d9 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -486,6 +486,13 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
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



