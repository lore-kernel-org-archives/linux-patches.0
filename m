Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028931;
	b=RsKYLT5lRXZ7Z8DdmSi6aLli5MeGRfmCt/Hxossl4FZB8pCOgPXRbA8DzN3TsNI4VJth
	 N0Yq6Yo14PUBm4iU9izCAiRlWGT8tcNrPy8/PKNqal4qTfWZPu7nr474UNLj2OEPxtrUm
	 oL1Z+arGvmaMq1UdE94eZwJZbsYJtmtENU/JhI/X/LKp0Vb/eyjyBywwWQODl0weTIooJ
	 aXbgXZ0Zv40/plSuAsNsTKwpxAYpp83KRJfQ5pOmFn/RleHn7q6w5bvCjnfb5HAV/2u7u
	 EY9yqMcpJXlaczXGi6m0rhJTYOkA1mYQbs5MUWxZFGhXuBQeD3+iluf9P7Rhqjl9UyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k9XVsJLvVvQTMmYa4RB0IKR35WeewRxJcpUvrU/y3p0=;
	b=B59ssMOPxV7D6guxYReB/YwCIGzZiVTQIlFMRjrQl2Rvxx3BGMvcWBKSWYhqTgbulem8
	 y6cSpHsIklbIJkSol6XxC0EzkRKSiC8ORsmlDEp5phu/ti1+yh37MWv/l+N1v0Qg8ClC0
	 NOeIjhTRTQk6Z0Rxl+M/eCx2AqHjUsxpz5KEKGuoTggtVcrSh2O1+MLBfDyuN3qBcNznG
	 NRdRC8ELVrBaDhELFHVa+5Hfd2I83iMpUF+hm5qiDHjbrSofI2SJrQ4CwA6MbbB7p5zJf
	 nl/PD1hnvaDjr9RFfUhnrQOoMYD5QSEwPEqCJcpbcjJdWzw86ut/PGgu6EVUmajmfdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWzRD7Cq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626B606A32A;
	Wed, 18 Nov 2026 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWzRD7Cq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16A81F000C5;
	Wed, 18 Nov 2026 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028931;
	bh=k9XVsJLvVvQTMmYa4RB0IKR35WeewRxJcpUvrU/y3p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWzRD7CqycHjcoVOcmkc0p1FFm8v3Iig+MdPsCJvoGKZpfPHaDD69QSeqD1o/YeDl
	 5At9rOEZ05pTv9BlH+01Yqo3rNuNr2rHNNhkz+1bF0Oc/JC8hBTnw4CpMHNb6VwtsT
	 WJTYD2jh/XBErQBxDysT/PxVPyZ8JOaVevBqanlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0171/1756] perf jitdump: Free event in jit_repipe_code_move()
Date: Wed, 18 Nov 2026 15:38:18 +0100
Message-ID: <20261118150015.229038048@linuxfoundation.org>
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

[ Upstream commit 7fc5851aac606b9e4143f6857710cc5f346770c5 ]

jit_repipe_code_move() allocates a perf_event with calloc but never
frees it — the 'out' label exits with only perf_sample__exit().

The sibling function jit_repipe_code_load() correctly calls
free(event) at its out label.  Add the same free(event) to
jit_repipe_code_move().

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index eebfe0d9b948c..e37182242b977 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -668,6 +668,7 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 		build_id__mark_dso_hit(tool, event, &sample, NULL, jd->machine);
 out:
 	perf_sample__exit(&sample);
+	free(event);
 	return ret;
 }
 
-- 
2.53.0



