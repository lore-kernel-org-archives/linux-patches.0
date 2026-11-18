Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024014;
	b=gEwAzCilOgOjN5HyjbRKa5qga39HcZLE4SwC7OfUfPIo2TDTW4TEuAmd1yzjuu+jVDfN
	 LqkWiqOT0ypPrlv9LVL09l/paaHXbY+y3SLeEWdpqdUgiiatnLJNFr5H3KVF7BpBswXGR
	 8iocQMnjxCVMU9y8c9LNNvs+JM9D3CbMAIbvrBc9ZF8NuJtNrOun/iZFRDIO3iPnthqBz
	 5rR5vEEp4DQNSoIVBY0Wm8yqepaoXOUOgeSK7YBCeVQpXFPyikSaaoVYotZfZaqboSKRu
	 Z7yLihopkCOByprUYi6RfWdlQodYq1kNKmse1+ribflZwPWhq51JWso1p29Mk6FHaVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SN/TTJeViwiQaNCDslUuBP/a5r2+0RdNAyYuTxOnpYs=;
	b=Nwp4FKCUxMsLLTNS63jc849GhZUoEdT5V0SmGXrmTNixcmaxP8GDwMWgFlb0kf4CQFTC
	 8Xnx2VU4gXHhY5O/WjgtihFXmiRVveP61EF1Lj3Y/H7DF8K9w7oaa5i7esslakAXQRJ9P
	 V8guYVabvZVpVsT3iZ8fmciqJLfkr+JGtCiZCxNn9iYXrJdoZLnkrHmmV21pVdRd1Tdq2
	 p4x4FYvcjLYU/euaJZA60PA4XomSszW5qRUJaABfqxA6O6nxkJWa8cOgLBBGbZ3l4Ym1T
	 C2F35c6fRi4vJio27WiHo6fZ5PuJQGbgwAtWoZYZ3oDsVAbhd9hiGAR+zqsIE5w2aNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5iQQpYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6D1606A331;
	Wed, 18 Nov 2026 17:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5iQQpYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00841F000C6;
	Wed, 18 Nov 2026 17:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024013;
	bh=SN/TTJeViwiQaNCDslUuBP/a5r2+0RdNAyYuTxOnpYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5iQQpYGbd9s6tMcBMXbw9ZlI29kpPq1QEbGCLGBrlw1mZ5aP32FmT7rkNKo9DiWg
	 zrwcI7zGU+0DK12SUflVtysV0fHMr0q6CrNzvQuz7LOrwVsxFi0hqrGTzzJMeJaMkA
	 r5mCbkAQ/dilInTLvTV7pLckBSS2CZZTyRyb1VuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0575/2151] perf test: Fix a leaked map reference in the arch dwarf unwind tests
Date: Wed, 18 Nov 2026 15:38:30 +0100
Message-ID: <20261118150142.898483604@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 1622c9ae39e2882fcbbae7c9d27dda13f1880b93 ]

maps__find() has returned a reference to the map it finds since
commit 42fd623b58db ("perf maps: Get map before returning in
maps__find"), which updated arch/x86/tests/dwarf-unwind.c but missed
the arm, arm64 and powerpc copies. Release the map after reading its
end, as x86 does. All other callers of maps__find() already release
what they get.

Fixes: 42fd623b58dbcc48 ("perf maps: Get map before returning in maps__find")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm/tests/dwarf-unwind.c     | 1 +
 tools/perf/arch/arm64/tests/dwarf-unwind.c   | 1 +
 tools/perf/arch/powerpc/tests/dwarf-unwind.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
index f421910e07097..d4707e9ffd2a8 100644
--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
diff --git a/tools/perf/arch/arm64/tests/dwarf-unwind.c b/tools/perf/arch/arm64/tests/dwarf-unwind.c
index 440d00f0de141..fbc161a493697 100644
--- a/tools/perf/arch/arm64/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm64/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
diff --git a/tools/perf/arch/powerpc/tests/dwarf-unwind.c b/tools/perf/arch/powerpc/tests/dwarf-unwind.c
index 66af884baa660..b4bade5d59e24 100644
--- a/tools/perf/arch/powerpc/tests/dwarf-unwind.c
+++ b/tools/perf/arch/powerpc/tests/dwarf-unwind.c
@@ -34,6 +34,7 @@ static int sample_ustack(struct perf_sample *sample,
 	}
 
 	stack_size = map__end(map) - sp;
+	map__put(map);
 	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
 
 	memcpy(buf, (void *) sp, stack_size);
-- 
2.53.0



