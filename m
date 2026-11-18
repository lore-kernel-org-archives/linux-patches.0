Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039225;
	b=TxaeBuDh+U3HUQnZUikSmL14/QBCJUmn0n1i/Z1XhEp3QzutYf3ie2IAz6x58bH9XtsF
	 JiEPASxPumLAkHlUM+cZehHplawM2mump75Oeq8yZIt5INFwiAu9q7EKAY+C7L+W/ZYLN
	 8oBXzORtPFGF+9L8I1e+qNcY4pj7NNC6XK7G5+OqgSX+b0Db8LzZMUyJE8Wugq7cOhJtz
	 WJvEe9GSx2sNVpNZlB9siQ00wEUQN663m9Vmtr7R5+yIk0fHjCFSIMbyz6vm3P219WdkS
	 SuWIrBoXffTipNXIqnNSWbA4EDdlJmawbK/9gqXd4F92IP0NdJJpB0MYOEd03rwEP5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1D9ekCLi8FlBKwpKAJ3Fay962nFHtgKeDC6ByVb8eQE=;
	b=abnNum1tJffNKY7wtGiYa0bINdZPnSF2in3KCZAjdEbq5mDbHIa9gds0rd3iDCqwxKbw
	 ymsjDUUyeEY1mYBTzOloKP7u7VcsM1yPaQqh+VkK8KYcFoTGibvsgbmr5FmQTfm+dALHu
	 fcKxhZO6HHGLxTFAQVE7fzkEVFR3vGSNvXNZSS00WTMNywAMi2EAT4wagrAqUoQcZRZje
	 TqQnwddfiai103uY4NAAYkREXRWIj8+hSa1Ma1cZFC3GN3tMpyu7GfyVoHDFNO5umTB1h
	 ma6Bp1GDc/kYpeUtZeYhZ57+hTwS422MApST/JqIF2PrspeUNVnCX1/CySbGZOY0fUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4zPwc3O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA2606A32A;
	Wed, 18 Nov 2026 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4zPwc3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F256A1F000C4;
	Wed, 18 Nov 2026 22:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039225;
	bh=1D9ekCLi8FlBKwpKAJ3Fay962nFHtgKeDC6ByVb8eQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4zPwc3O3ZtMl4NbWRDVQu+92CfVnSAaxbXu4M1jniW2tfSvqbUo3U6WFGDr6eR8d
	 d7XhjSSyDrh9i/YC8oeB39IEf6W0FwZ8UTQctqcKig7n0ShoI4aE929UZwLxzB+SI3
	 NJY4qjoLul+bCsyCPRnAjvXC+VFVnqlArs4U4L8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2007/3318] perf jitdump: Check snprintf return before computing header size
Date: Wed, 18 Nov 2026 15:43:49 +0100
Message-ID: <20261118150422.260217195@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8264d03260706..37aa6729ab0f2 100644
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



