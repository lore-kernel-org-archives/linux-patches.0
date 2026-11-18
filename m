Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022881;
	b=sZCjVUgo1kNuVdcXvhCuMMHgeA58XJid+rpkhYeVCY+7cvr0Tn8H62tRXg8MQ+Oqik2z
	 HjISlD9r1NdN2vDxePZr+fO8vBJu3Eo0W3sv6wDQRRJnDPIlMjhFhTPU1DEDDYdZWH4Sx
	 PXhWnFfYWvghqdKq3zrextHrM1+9ZeULfxe9kzcNknWHxM6sMep7yn18q9qGR5sCjp831
	 Ko3UPnQsxryDzVllbXaSroAzPrhjk2HDwaUOwaJnKlV+b3QG0/MraTnD2KL6YGB5yKvhM
	 1md1bIOOu7/37HaLGJTaT2qEwjEAjlXB6lJNSceBzB5f+/s9uNcpS0WsgUEChMXxIxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeXdbAybmlh8THOnqRUeT7pAdFKqcTcFjNP81/PUp+s=;
	b=wF8T5rhlkprCAJt6F8WCwvOe1Dkns5zXHia1u6nX+Y8OhhQ1EJtZ0fcnMxi4X/VcmkXs
	 6FLGWll7N4OJwiO06JCXtxBy85yypLuF1NvDd97s/wfWQSOa0s2Ue2LPJdf8bL4oJF6ZW
	 NOFUlUs8R1gdXQiNAXm5YugDIp1POIAOngXPuBapx4HZYoCzIZ1rOirfLNbfsghW5xwg9
	 JRzN0AtsFg+M191sQnX2hcAwiLtf7NS6uW+F4RbY44jyLXaIgOxMH+op1du57/GhZ0CTE
	 YT+dpFFiHkjW0P8iEaEVvLPdS80/bgHI/3Ue267v9NnU75e00CQk2zvNTXWcbW3fX8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zSMDv3ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD83F606CA66;
	Wed, 18 Nov 2026 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zSMDv3ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3798E1F000C5;
	Wed, 18 Nov 2026 17:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022881;
	bh=AeXdbAybmlh8THOnqRUeT7pAdFKqcTcFjNP81/PUp+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSMDv3aysKdUEYxxxk/hLrVKpFBmDM1btXNhxcwKPKVW7nneDgWn1pSSzBVZ5CCDQ
	 1w8Udw5Dh+n1zov/2iUMgjhOyHElVVEzuEkCAGB9wztWgJaora1cvCy1+8wWuf8Efx
	 ea9HlgszDkm/ibobFf0JWvijHKtPt4fHJ956u3Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0170/2151] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:31:45 +0100
Message-ID: <20261118150127.943024945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 517deb8466493..be56de79eb4ca 100644
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



