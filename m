Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060285;
	b=0y4LQ+RXPG+ZB1/uarev+EznZZj4SEF4XWX9s2m6UBqELT2ETEON8RVEcY09OLr5Yv0s
	 aykus8jOev0316vPvikuDicE8oNaaebRE1ftqOyMBTSDz8tgH+JkrZ6K6qJvM9zTgx86R
	 pj1cWji9pOsgl5qpbmCQpfBbvousDXZcEo+BdsW4tyX6eiMfMiqIbyVHgbbGSlcZ/tHEZ
	 xBw3APqKZXs3jbBTBrO0GcSPXjoU3gHov5rYuarY5Y5LEA+oo9l3zwwtVYs37HsNNp1eN
	 75NwmVHz9LwmGemXWDx5LOdbynq/z0+/HTkIhQFvAAJTclCdnS4yd7+jnMhZVDu2GdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aiCIU/65r4rHt5nGRbWxQRsieRC9l77603D8i1kd77w=;
	b=WYDhBnE8nsLZj0c8xYGJ8MrldGZXooiZKQ3IdRcufgoDjgQO2dGYYFY5KXUA1KrgFBf8
	 koFnO+fvmE1aBv/XzJqqYkO+Pmm29XugpPMKM81tYO6kXj6TJLU1Dg4CKYMvUCRtFvVNT
	 pA1yYlNCpQvAr+DH32KOAhBB4nQMNgqE+hCTTUWLGhsR+tReH6Wz9nRZsaorfJHjUeXey
	 BmITIeeds77xNYM7/5BHRHL6ga7zubAAFeplp3zcpRjkN42Jpccc1vlz5x87m5LFTvySl
	 lg1xufh/SyoitdNuFXoOfRK/6942iieDCq3onfB8/gEsifShImvsvOVh8MvsElbmo4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AprtMjFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307AF606A325;
	Thu, 19 Nov 2026 03:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AprtMjFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834381F000C5;
	Thu, 19 Nov 2026 03:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060285;
	bh=aiCIU/65r4rHt5nGRbWxQRsieRC9l77603D8i1kd77w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AprtMjFkpMAB5SikUkwoDHTzkufEYo+AGsqjNcVmVfphB36ColtkLpaI+Q3ary22b
	 jRYGuAqy7So6fnxZDc2IuEIIRsLdFc+QLT6xurc2a/rsfIyw/mzbB368bc4LLQTF1Z
	 /qWuUL/hkUcM94GpgwRIM9Hdm02QrKMKYX8ctZas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1143/1848] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:53:01 +0100
Message-ID: <20261118150007.508854543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



