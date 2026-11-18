Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022861;
	b=QAr9oMhJWcx/onQOEH+d8iZ+RsYY8NkNAY5+emt96jpjsb3zd43BbckL4/458kL/qBG7
	 vSJT8F5H7MPOv0+gJUaSQwg3XTO9g6iKRa6SBrxTo+kVOjxvYbAYOxePYFkPJMbqocJRv
	 tzqdmTe/OzaLpQ1+4NurXmyDhDExYUzRaUjni+7KM4B2ac0g1cDRr+CMdQ1cajadgRH1S
	 J1bofqsUbh6DBKafWh7BcPTIM9SSpISphFDHFx9BDhLeKVWI8EufzPBzxNue4wD7zUp3w
	 MGRrMD+foUEtZzvhSiERGgzNsnWju3UbMMonMkcDqhbDmU7phGCuOWi5altjNqPOzVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5+r8jtoLkXyn9AT7Y1zzQ1JZPADQ8oH+LMFnKlEzxGU=;
	b=AU7+9cPAGEiKUTKZ0B1tNUacnIxMAlQTijs+gh3jJjYx1Jzr+zRv+PhPB3k+XF88E2hI
	 QADnRt7zrzSilMmcN17FMdZq0dcYrk3/kWmzpjZTngyEK++1qa7Ox0bvKJQvGPBP1JaDp
	 RRRaZPNX7JE2uik8MkjV+4QBGatexdlWP/QLVxcvJBiZJyvWhf4ajChYetVDtk1diXio+
	 r1Uk0ci15LGIcUIZcRPKKJa5/oqkRBkzPpKjaP4m0MhIo15DF9FRDKy/bDfQQXJxqvREA
	 tkTXzfOVN04IRPl2i5B7nNq/snseYRKmCB9criR05fiUWj/5XIGtXcPHPa+nqRV5coQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVuWtEaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1A3606A33D;
	Wed, 18 Nov 2026 17:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVuWtEaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2931F000C4;
	Wed, 18 Nov 2026 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022861;
	bh=5+r8jtoLkXyn9AT7Y1zzQ1JZPADQ8oH+LMFnKlEzxGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVuWtEaCtKM6Q5k3zAhZ12/yANEmQKzJt0x54+QIGyGmI0D4ZWdd3E7+UMYJOQh4b
	 lec+SK788KBoMAy6c2g6IaI1Fj+sFd0vQLUsSYy7xG8o35NCEX27FidCqSXOS3Bwjs
	 vqHH+5vqboRLMGbj84eYjbuG2K9NLGYD+DYnS5eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0164/2151] perf jitdump: Check snprintf return before computing header size
Date: Wed, 18 Nov 2026 15:31:39 +0100
Message-ID: <20261118150127.721462084@linuxfoundation.org>
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
index 5174946ffe870..8e561a0eeaa7d 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -494,6 +494,9 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 			jd->dir,
 			nspid,
 			count);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
@@ -622,6 +625,9 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	         jd->dir,
 		 nspid,
 		 jr->move.code_index);
+	/* snprintf returns would-be length on truncation, clamp to buffer */
+	if (size >= sizeof(event->mmap2.filename))
+		size = sizeof(event->mmap2.filename) - 1;
 
 	size++; /* for \0 */
 
-- 
2.53.0



