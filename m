Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028937;
	b=t3qOVIQx1incFJRGdhPSEvoq51rn13ubzxiOjukQq9QB3mp7Mowxb/LfIPaE38/trJgV
	 G56LO9QtWpLuDt5soknTpYQanRJYvzRWyXdS+XiM7kuOGW1cei6DbqaLlMbBCxQtVV86m
	 MLYoGd7/17Lbi3PWhFxQuFdsFoipkthxE6FiyGyFhj9er18P2rQMM9B/05/F+zkrDwXqB
	 RACD1DhJlWbxiYpGefRcEkLQm4AEchCSJ+BoFkWUbAqFkZaqkNRXpQM5qnMfMqIsizgN0
	 XJJDIOzAztp/GE+T/X+ih+vwpu3ilmfsaEHOMY/1Jfz/qy9VT5p7SW63aZHKEH2w23Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FvAWiI+XeJEs5u31C0bXYRz5/evktjfvvq0q6SBT40E=;
	b=f3qBOirVF1P0aFNAMPeb55js7dpYUpCSsD0eNQ1rxmH3wnj5wDLQUN6G0vlB3XqnKWst
	 3tfxwJQvSbr6gulMdyNat51Ihmh5YbYAWjzBmxdQZhQuv5ieW5Vt8ips5lWOc0fHpVLo3
	 RG7St3z/Kfx5rTjzPR4hxyaT6x7duEqFVqK0qUbYOiO9xOwIVjdOL5VP/Hrs/fOotp3Nw
	 AYADlqeRK9Ev/EIp7iM6FQZ26x8Pr3U654oVbYgAy7w/VzDG/esLVxsPgJn4A9YE9Kbff
	 i5Xdclv9GJs+1/X2SLgmd60mvIFmPcUqJrT4DQjtYO23wZSxZiyxgsT4Huav2yqB1Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISP50QYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20815606A32A;
	Wed, 18 Nov 2026 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISP50QYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E811F000C4;
	Wed, 18 Nov 2026 19:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028937;
	bh=FvAWiI+XeJEs5u31C0bXYRz5/evktjfvvq0q6SBT40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISP50QYWu8n7C5zO5irHQYDSCEs8Z87/xkSV4NDgv+RtO/g60F+vGrDZT5WIcrlgj
	 6wXcsBinAkspf01L3+iCAUZo6iFIhMXVYOgqV6c+58eVVo908y+2WAyqx2ASbnsxLu
	 BDN0cI1xhBzoOpwTjSuGFfYpqK1xjWTdcWvxw/HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0173/1756] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118150015.349277739@linuxfoundation.org>
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
index 48749561c77f6..d118a39fb2058 100644
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



