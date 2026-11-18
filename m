Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054652;
	b=mPrvBzuz+hVrJ3eHsmGs4gqP3XpNSxmrPNDSTX8Yg8MWwnj/x0jKhNWJnlNfrhYQvYZ5
	 /JjFBgPC1E3MfEOzMhcd2vvG/S9UWXchwGaT5BIgi9L4UsyF/F3/P2T2Gj89c5CQ3ckRU
	 SuX+w1c7JsZpPmEsQ8ldCMcaTGhvKfHLMcAOrSPhWqpVRdgpHtyy8Ax3p/+rmVLhB9sU8
	 8CxfXUCdmprNPMsB+IDxDsUAqy88IAl+r1S2fUhDJtN57a9+ifZpSLCX+QgDPcZOZ2548
	 ddJpMkHTx+5EaJeUmyLsYJjR4xsoO/HisE6S3CEW6lYHs92DZqkYqT8yjvak4ExZl6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7k3lRfAqiW00jccRNISSxEQrP8ZlLGEZ1L/sY+ar/1I=;
	b=y1f+IzO8/3WOQHXRTEcxy39ihwMESMoESIZaUkxAwIYVbaU06by9GnMmbPY3BUlaY6Ql
	 ELNPTYKuskUusRYCgWxEmSKwDCtbSJtnZA6PFJQ5vlzBLso5cpmqQOewM3CYuBEhoI9dt
	 9lgfqBeaS8cG2p6hgIWevQsITVHblDNil9+VNmUq8mIVBSrmiXh+tc/iyztEuXq59npVo
	 O9fikoMNy+mztz/9GJzG1NOECI/YljmkpS/KFmVo/d6kEDHpX+eEwtKK2iekh3m0iVEmJ
	 QjQVMF24+jyOOdSZ4E8zuDTE0jr8xKw2JEyUq9dhY8Smnqi7g345OZLFSobAH29ilUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3+DOcWO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A315606A31C;
	Thu, 19 Nov 2026 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3+DOcWO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E131F000C4;
	Thu, 19 Nov 2026 02:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054652;
	bh=7k3lRfAqiW00jccRNISSxEQrP8ZlLGEZ1L/sY+ar/1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3+DOcWOh3Xr2DMRcubzRXIrmf2nT4YzSaF3hzItlwv9SJH96B4hVTS0T1U9Pfc5A
	 MWXFkLgKrgDP0pM4CzU1cMr+LgMoOGi93NcMK5dGqkaPzZjcllfHFYkwvvxu2G5eKl
	 o7WmzQS2JGdUFR6VeiGVr2bsIuqE+bsPCP6FeaVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1351/2214] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:50:27 +0100
Message-ID: <20261118150105.490853817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb9e01faa721c..3577098b1fe6b 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -152,6 +152,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	ssize_t bs, bsz = 0;
 	void *n, *buf = NULL;
 	int ret, retval = -1;
+	char *dname;
 
 	nsinfo__mountns_enter(jd->nsi, &nsc);
 	jd->in = fopen(name, "r");
@@ -247,7 +248,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



