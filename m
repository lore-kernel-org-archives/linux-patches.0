Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047760;
	b=Xxz+5PkNxocOxD81CQM8Rq6oJR8EL/2q9K8UYD+aKizAqT2JfJnxzSTVqbWQZPhu+3Sm
	 Iah+tqOdscdY/cH+pvG6Za0xwxForaEBtbNfV+aakw4hQkXf0NMuYYqQTBmIJ6BnRvwid
	 DynBdJKEmL+yr1bpciV5/HHQMpNYqPTgmqWpDbrvrBc9WGDu4DW9l5SBocymIyCvuuL9L
	 GbUIwOPg5rpmBJ7pLG4uuIx7Yrh/Wi6RDrXJFXbB4kkTl9nsdPd/NioVwkJ3onbSQFX9n
	 rvx9WbVdULZnRB9F2rluSvYgu1pDfKM4UCb/vq9962u2yNf3InUXd3zmNVPsAVkwEEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Sbd2YVHiGLLB9hMWYvReSpGi7ppZbbQN5xJWAcKmlys=;
	b=cIwdap2Gj6CCegikPJYFBNuhBEe8dEvLnL/ZyaD4o7v/DEz4Wa89mRRznExPfrZIEBNV
	 4rElOy1TYM9SfBV2+31ozDfVMIeHVkIaDT2gWd5lUZDSNk2Fn0hDgrRqL06Omk9vtunKF
	 QiJG2+o+y9TRlrgtJe7Ax1Jd90g82sE9ogeMo2MJbhWAxNBAMgypAN1HsQGB6EGwyUxPp
	 lkYK1/ksFG0XnzlvHDANO0U92BfdgxSiB+gbNt1lhndOhpC2K88GSF6SxAXfjl70cs//x
	 r89/Z5sksDEVatPs4myiMjEuo7l4OTXMephxLa7wwpi5rt7/uVBxGIyMjsveG3Fz+Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjOClwtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E11606A332;
	Thu, 19 Nov 2026 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjOClwtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880F61F000CB;
	Thu, 19 Nov 2026 00:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047760;
	bh=Sbd2YVHiGLLB9hMWYvReSpGi7ppZbbQN5xJWAcKmlys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjOClwtWQ7T93K44AwU6fCPSdyMAuwXcjFjUUcN1EnU+iuURn61u/a6P6N2bAbACz
	 8N0ZAwz9tg3Fyr+LKzXxo8Rec2gL2jFmBUsEFNEwc6wYgDxiKsJJVhf3vet7yPsdVA
	 kuD/WJt5YiBGQt4+7McztOM3uPswZgOzymM7zal8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1754/2857] perf jitdump: Use dirname() return value in jit_open()
Date: Wed, 18 Nov 2026 15:46:28 +0100
Message-ID: <20261118150304.451857597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5e9be11473ae..e6d8b1aedcb0c 100644
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



