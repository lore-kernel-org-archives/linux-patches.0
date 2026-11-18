Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022850;
	b=j3nhLL3kYV9H+RyXuHiEIh+tFQlZCS1Et0+c+OSI4zfpGdHICisQDgSIuR4JeCl6QPN9
	 HtLEtSbJ0CDorxijHG5W82cE2Wk5jAU7QAfhFXcKwhb2VKq2OpPWvoZ/LSxv5sY9jamVc
	 yKe4/d0p5ESNaT+tK/5bmwlBgesJyc2Vq9YbUMErrxUq2tWbxx7oPP52Tc3Lx1d8f8409
	 PYrHmgkIV/zzU5zGHdvxcMo26g3K5NMA1Wbapl/PGQuMcD8cTOMNx3tfFbGTnI1NdyevN
	 rKJgUP/RzlQ6+HrtBYPYKmK2vMfwJjALVRs8h2jdV/C0ADN2j1+oYGoJxsmKodgRQBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=35UhEWz6EjQSo6gc1EBs2pIoHsd+SN3nMESPAed38AE=;
	b=R3RbQeKdMVw9z32hsYhu/v5YE5tDIx5Ac6Wz0zyjd2GRE1HdchYT0kWhAvlIcEj1bBWC
	 vrprA/wOgUP9UziNIjK8lZa/afEue06LOqxl7b0S9VHcW6+e5YevzjjLjLjd79c4YKzcn
	 sFioP/ws3IbdJ/+d1rK/LlL+6W7+dXpXBDlvNqRbUdEVqOCGwO/yf3dAwuhPm9Sm+qR7h
	 R1DiGs3KayM6pqNxApFiJfT2BO1lzdRztdr8kt1AHIa8MJpP3XeowNDEg8fMSyDH92Zwv
	 /nE264t3M0gRvRpSoZLKq7VSCVh2lE1Fdjf1jlZFH739AmK9okIR6jOVxbDXEXuVTgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MP2nXohb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308F606A325;
	Wed, 18 Nov 2026 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MP2nXohb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16211F000C6;
	Wed, 18 Nov 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022850;
	bh=35UhEWz6EjQSo6gc1EBs2pIoHsd+SN3nMESPAed38AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MP2nXohbUhHz8yJ2zFf/+LlZNr26j3tKIaq+t/Yh83FM05bX32FDo/BJSA2v9ywxr
	 Zr/GSowY+Cgx0UaxClc3PUST7RmexR+Zy/s044L5aAuCxJyGk1lL9sCm8kyxM2nYVY
	 ySUqvU24iH2HpALnhii0aXuRs6i4mSU8yXX8KAAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0160/2151] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:31:35 +0100
Message-ID: <20261118150127.578216069@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 2bd967f3adcba1d3e54f10b0d8b25f950e4f03fd ]

jit_repipe_debug_info() overwrites jd->debug_data without freeing the
previous allocation.  If two consecutive JIT_CODE_DEBUG_INFO records
appear without an intervening LOAD record consuming the data, the first
allocation leaks.

The sibling jit_repipe_unwinding_info() already frees the old
jd->unwinding_data before reassignment — add the same pattern to
jit_repipe_debug_info() using zfree().

Also add cleanup of both buffers in jit_close() so they are freed when
the jitdump session ends, even if no LOAD record consumed them.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index c8934a46f7355..ed489d22c2fd9 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -117,6 +117,8 @@ jit_close(struct jit_buf_desc *jd)
 	funlockfile(jd->in);
 	fclose(jd->in);
 	jd->in = NULL;
+	zfree(&jd->debug_data);
+	zfree(&jd->unwinding_data);
 }
 
 static int
@@ -662,6 +664,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



