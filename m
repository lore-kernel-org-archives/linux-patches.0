Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022847;
	b=rIROrd98ztYNz6J1jwKEGsu9aA6h2vblFyFDtyFuBGJzQvcFpRh57qZ7Uy3w7yMTL1tB
	 ByUBvuMBG4ygSbHJUbFoTA1MO+BXgF242Ui6c5hCYy+i2ddvBtJgr07BoelVUyCxt52+s
	 gfU9Tz38XbsSmIfOEwfvTRu1OU16owD2ACLIk/RoPzDn4yxktxJXcF/tFp0/Jwp3Pl6Ts
	 9so9DbTnelmtIc3/V0r3PMBB3za8PRCgLuMBcIzyGPywKQrqxaz0O1lMzPty7ScAeiDdc
	 LPmPik9Mb5qpEATgtLlv7j2Zsqoil0T2JN1B2ainF+8aYuGwiQWPyoKjQ2sT8tKg0jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nEwgTvcHztcwBSoySgTnSeJjTfhOW29YKGqAXFX8Xi0=;
	b=yDrsA+NjSIGcWcFmyY6klR1DXv09uX1hDdyzsJDw4Ne98+VR+5tzNB9Fc+CJ5dxD315l
	 I+Q6KfJ5C+es0uuITk+UlnXikPaWdnCxvFy6KstGDgzJ+lpoBSYncnlGFV9AXLobjpCzO
	 w4fMViLGmqqt81JdoM973so4Zk/xetxs0sFAzlX0KMPdr8PxKJnSpAddohakMb7blRG/f
	 GshuYccZ+vsBCDC0DfCYFUJ8nozF2rIEr4VyYHrPzm0tWHNG9DK3vvZ6CGMF0Y/4WXcem
	 IKCgtHGZ5cSPoxU355x14Fs7CfT/mLBd7ydAoY9c2Cxp7lbA32bu6s1XKhXgA4U6m/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GxcC/r2H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E37606A754;
	Wed, 18 Nov 2026 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxcC/r2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C818C1F000CC;
	Wed, 18 Nov 2026 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022847;
	bh=nEwgTvcHztcwBSoySgTnSeJjTfhOW29YKGqAXFX8Xi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxcC/r2HmsNdvXrR5gG71WHWwF/4KgBc8hXolcLODC+459Y1MfhO+SiZW6admcOu/
	 rcE6jjiGhOvITG8TU4C1QhNXoFtS/HptIaOsBFfXLUb0sYL1PK/w16Z8ZB4Qnj/GfU
	 faQXZueamQnj6iaSN6/VrItWvybEn2029YRDwkNM=
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
Subject: [PATCH 6.18 0159/2151] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:31:34 +0100
Message-ID: <20261118150127.543003177@linuxfoundation.org>
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
index 2a4c14b003b31..c8934a46f7355 100644
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



