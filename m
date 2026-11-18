Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022876;
	b=LiakWg/Tdp2BdxQmEUBw4mR37J669WvyxYMzDxcVf+yfPtCv//JlbyGlOZK/2IsSwni4
	 6RHEUMsNwIt1NL/qhDusBWpzYEk+ezpnSUhjVDxzZzzC2XCY3dyOOUhspOme9sZ6Sps6g
	 Y/YcpEX3LbwYA1pD4bwm4a55KCls6ZCjIVDpv2bDPGIGhP1vaWp/tNVM2kUBEfsRyB3Pk
	 lObGTsjbPlTx7c6687VrPx3cUsC1EtgAbf8Fts+KNkBRcCgcOdXkJTFa+6tLLrv4XCuv2
	 aVWzcd4o0dHtEQGw9l1IaX/FgGv8yT7IZT9GmlpTc+kz6XUy4oIHAsFoe1hpEgbTwuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7We9Lol7B9Y6/1Ju6kbMmDl92PN3cKMAByte3GN3Pbk=;
	b=TLYbShIxnWBAHcSzeI2yDvqYtE40MjcNZmr8VrsnqfrRqRCshANMlmgWCPiTKxWX+HfN
	 R8sN46kaLR3zmgO1SfsRvGjQCWj1OamRx3gqXWz8iaufdqHzFvPDEhg/TM0AkFRR33u1y
	 x9qnxVJrV0fQzzjwDqf8CNFMh/Uw9QLCxEIuBdvEj5RDAYiB1Mcs5/lQmisC1ZHMfXYiu
	 cqnCfYpEfByr5IIDHV3leCvbLwpq6oTMqjQTjB9h7QPOvQx/u0639BS3/s0xo7T02C8lC
	 eRiGWwEoZyaHMUgnzPHI/AmPEeZf4o8OzpuQKgL9M/b0VPcBi6OHR5rqdL22Ln532KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHLyccgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27332606A32C;
	Wed, 18 Nov 2026 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHLyccgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F37D1F000C4;
	Wed, 18 Nov 2026 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022876;
	bh=7We9Lol7B9Y6/1Ju6kbMmDl92PN3cKMAByte3GN3Pbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHLyccgwinMRnUqavatC8Otlq63SoXzuozUKIcHZ2uwMPIxEMi3TKvbPLJ6gh6gKU
	 N8R1wSxlTRVoKk3AJuQ+vBCyOKNncmRGwYWelIqauXuxZbxdwme3gURLRY3dPf7crg
	 igU/hMPJ+6xawuUDNVH01j5K2B1oVqZfm3GTUkxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0168/2151] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:31:43 +0100
Message-ID: <20261118150127.864418675@linuxfoundation.org>
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

[ Upstream commit 4eddf7d9e341eb8c41704b8aa27b4a91f4e2c7c9 ]

jit_open() calls dirname(jd->dir) but ignores the return value.  POSIX
says dirname() may return a pointer to internal static storage — glibc
does this when the path has no '/', returning "." from a static buffer
and leaving jd->dir unchanged with the original filename.

Capture the return value and copy it back to jd->dir when dirname()
returns a different pointer.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 343ee182b946e..b82a2875a7748 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -146,6 +146,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	ssize_t bs, bsz = 0;
 	void *n, *buf = NULL;
 	int ret, retval = -1;
+	char *dname;
 
 	nsinfo__mountns_enter(jd->nsi, &nsc);
 	jd->in = fopen(name, "r");
@@ -241,7 +242,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	 */
 	strncpy(jd->dir, name, PATH_MAX);
 	jd->dir[PATH_MAX - 1] = '\0';
-	dirname(jd->dir);
+	dname = dirname(jd->dir);
+	if (dname != jd->dir)
+		strlcpy(jd->dir, dname, sizeof(jd->dir));
 	free(buf);
 
 	return 0;
-- 
2.53.0



