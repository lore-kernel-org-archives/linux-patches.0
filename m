Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015251;
	b=DKrYUfrFaChsEbuFe73c4Lq6zXWg1voPuNJXce4jPvbz1KdG0+g3vkNhNStKmrA8cFAG
	 QE5XPlzaw+bmYl7gbp4I/93OHEaZaDPj8ewIOBg73HYKk5acK5EeJL9FugQfd1F6VkYk8
	 6Szb63jSwjwE4wsl/CYlFo+sc2zdbsp/gF15X5yXQQ5i/9F5rBsFV+Ip7wyZXufKD/6MT
	 b6nSiepL3EP12JlDwJBnLuONR7uUaKP/MoipjfHI3CGDeciYJHq3Xy16oUt3NFOWWIKP0
	 Ly+zJ9dfbeFyyZ2iDTn15p2T9moCR7FZPEIqjepa3nKiYlFZs27OF9ytPul3jxSw6cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tQXII9Rw1ohCNbasaMPvBvmd6nlwp2vftvOmRklU98A=;
	b=cBXIQjOk5bNZc0nooS1JBaRNbTuEnDOCj5n1pNkSEUPQm+DjLI1+2XxXj9wiMjpFGih1
	 nQdfDydj4QywiwVmi8jkePRfpOHf/rWTapJ2oxhgCAxKy8tms1Y2HuoQTOsqjWrAGG6Zb
	 AbiZPccaKrJjMOHYA1uyXxh7NYjcSUDn8uzn0k+RIxXnFjGK7oLJ97yZafKTfGV/qZava
	 q2JAIs7gAnZhC39Zgy7FUSs968MGsVIsm+RkB5yw7fxMeCVFx/CF4cf0otQUehey0KzMH
	 +70qYYHS3DGJ8HIP3iLSnrpvKjSvFlr0Prp/a1FSCXIZP+od0b9XEQaYJeONLMMGltg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WviihUPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9481606A31C;
	Wed, 18 Nov 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WviihUPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4881F000C4;
	Wed, 18 Nov 2026 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015251;
	bh=tQXII9Rw1ohCNbasaMPvBvmd6nlwp2vftvOmRklU98A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WviihUPoB8dAe3idmobyEQCRJBa4oUR1x0I+o1fxhgaAfF1k7fHCy7SQmlIV1++yM
	 +oIk58G7iz6O4AFhmEaFtAu5jgBA2QQtZg8zhNHPw3mbb0FKLHJzeNZau3ZrNAUWcQ
	 vynfwnQY470PX3kYJxSjmfRuMM2Q8KNqU7xylJ2E=
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
Subject: [PATCH 7.3 0106/2651] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:22:26 +0100
Message-ID: <20261118150251.699664805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 83005b30b9bf3..4b7c7ba7cd95d 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -224,10 +224,12 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



