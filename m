Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039299;
	b=gevovEnKsg4dcxl2PxdgNdtsVYPJK8WO1kiys8Tra73hqO1+NIU3gi6NgriU5yS9EscW
	 N7+cq8qKxgoothpXG+vdpd1y3AThsTmx7p0xS/0O31PYwQKbNks0+7auZ/v6vIoXgK5OS
	 Nw5tmXfktW0cT3uWSwT/f15RiGBx8/BA1xDsZ2GI7/RGJBmE/4EVgUiYnKDkFtFbO/J6I
	 q5WTJGc4ik5JIkun13y4QXBRg+FxgAaC3+CNWavdlJN1gyypxTrlQrAW8tI2AIxiKGfW/
	 1VRjk1wxF11/uB4mLKVd5DqTK+9JQY+ITCe5c5lP5ZiXjGQWVxfQm8TKvomOLoC2vMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=itQmVH2xkRnNvExT64Bj9+JkkbvmVy8JCPcHbxpALQA=;
	b=ef8QRmUHtol9Q/4ZId7zxTLKCL3iMEjiFnqbH6XJIxwYwrq/MixYVdI85lp1VxumNAvZ
	 lECsi3jePpHBJkOntYOJ4bzkOMECzWnSc/AeVLEIPz/lwmFlWjihRAHdgt2UDIjoNGv5t
	 xo/X17ECTrsbupSOZWUnhpGj92217X4VWzpfYW1+XPAdSU//r19xJvZEoDJVPYm0JBCvw
	 45m+cc8nn9shv1PCkjV2QR+3PTQ6ih0n7mP6Mn6f2LTH/Wpkw24C70sbX30yyjAMyDDyl
	 f/Qb6WPcLl6RwAvF9ydtNrV+Da+mKriOLUEY9L7Bb4uXwTsIgD6v/1Bq6GGDvbKvajA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgBAD6in;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98E7606A31C;
	Wed, 18 Nov 2026 22:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgBAD6in
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12B41F000C4;
	Wed, 18 Nov 2026 22:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039299;
	bh=itQmVH2xkRnNvExT64Bj9+JkkbvmVy8JCPcHbxpALQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgBAD6in1pBMA0G9m8uj7LxIMrLpDAFm16kj8OvauPUnWR2o2FgX3phqD7+hQL9el
	 VYPK4yN24MoD7gkbZ3228+7QcqHdjDivNK5mKBHo0klFasIHEDiMe5gbxcz3ozoxdB
	 q+nNCff0TQsPI3Uqi+GWzEwa47MDXz+E39pf22GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2010/3318] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:43:52 +0100
Message-ID: <20261118150422.346936559@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1b5fc048af8b6..f6467cc7d27b9 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -145,6 +145,7 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	ssize_t bs, bsz = 0;
 	void *n, *buf = NULL;
 	int ret, retval = -1;
+	char *dname;
 
 	nsinfo__mountns_enter(jd->nsi, &nsc);
 	jd->in = fopen(name, "r");
@@ -240,7 +241,9 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



