Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060255;
	b=jyvb7blxZafyxiCKxMrqEQH49TFVReeB+FHAsbsBQUfQ3Vu6iDHMxNwlIdBrzoq5SSQF
	 4SVbWWHcbt1BYOwdCl4nB0pU40GSGEsdZcqMIXmgbmi9UEMG591fPfedzMnhluzPBSc6N
	 VQ8hVAyTZcpwK6VUPPhjTMH61+PAHJFcoL7o4MJEZFFIyQI0PVQKiDyGQKlAGVa1FpS5n
	 /PR80Y7ZCsVAgx+I6Vb6anTNNj8Bk1xM6OCK4WOqfbIeR2LwvmfrJau6c9JYFQi/8IZoo
	 91/j/PjbXPQlDk5rsVSwTTt+NRYl/a302g76Azz4BsYYfjimw5QoKLBU/22AwK8tb7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W8JRy/WWiQ3UDCOJJKdSBc+fIpCgtQgh3EFG3JIQDEU=;
	b=bPemq0X45GkdW6geGTjlxU+2Nl3XvKzCiZ6NIq13fP48YLYiX9xNOb+nd+0UYpPWoLxB
	 Ep9qCibBxoPA3cEXdiLg4uGiuYD3UrLOd1UutnkLEqt2IGzt/Ke2GrpnIsSeDrMUYSRLP
	 2xnKo2YoMkPWnT/8JQzBs2zHdPVPFL6WxEj+uy3DGHb79toQ85fnoSOL4sJOJ3cBYFYdv
	 zSJcf/5oV3JwYh4ah6YXG+9vWrzwQf2+xIkhleZUCHUCXMsAs9NAdqzhEnFrM9px89SWX
	 40ztdI59ALJlHI6RiaDyHwiuCPCBJEdOGs4/rxQmM7G/Rp7C51WxDvgDmTDtxk3euyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgKqXHf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE85606A320;
	Thu, 19 Nov 2026 03:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgKqXHf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B371F000C5;
	Thu, 19 Nov 2026 03:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060255;
	bh=W8JRy/WWiQ3UDCOJJKdSBc+fIpCgtQgh3EFG3JIQDEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgKqXHf+QyvpC5O2UHuFwkx6SpAUMhZSy55yg7BqLPxB51gUcHuPpwnjaTRAQQ0pa
	 bWBN0nCqpHNtwtOhZRokfwPRqx2Dz/51TwzA4Fj5vHvNfRlRQQtIZaZ72NeXOHNzHP
	 X4tZLqdwwEzO+i0aeRDh9hW9GDSQlhwozzQ/rLZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1133/1848] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:52:51 +0100
Message-ID: <20261118150006.870014064@linuxfoundation.org>
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

[ Upstream commit 598e905931380f0714d5fd50cecfac615a1ec742 ]

jit_open() sets bsz = bs before the fread() that uses bs - bsz as the
read size, making the expression always evaluate to zero.  fread() with
size 0 returns 0, which triggers the ret != 1 error path — so extended
jitdump headers (total_size > sizeof(header)) have been silently broken
since the original implementation.

Additionally, when 0 < bs <= bsz the if (bs > bsz) block is skipped
entirely, leaving extended header bytes unread in the stream.  Subsequent
jit_get_next_entry() calls then parse those leftover bytes as a
jr_prefix, corrupting the record stream.

Fix by separating the buffer growth from the read: realloc only when
bs > bsz, then unconditionally fread bs bytes when bs > 0.

Fixes: 9b07e27f88b9cd78 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 64d8f9ba8c034..881327bd8da1d 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -217,10 +217,12 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 		n = realloc(buf, bs);
 		if (!n)
 			goto error;
-		bsz = bs;
 		buf = n;
-		/* read extra we do not know about */
-		ret = fread(buf, bs - bsz, 1, jd->in);
+		bsz = bs;
+	}
+	if (bs > 0) {
+		/* consume extended header bytes from the stream */
+		ret = fread(buf, bs, 1, jd->in);
 		if (ret != 1)
 			goto error;
 	}
-- 
2.53.0



