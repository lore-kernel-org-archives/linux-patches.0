Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047735;
	b=aJUWGwbQPQLxq/2qts84BEoUXVV/LTLHQcQ3U4g1HJneszp+oRCec8XvnR8QJ3PH1uH4
	 iYCZr0sOljCEVm8KW/NFatc+3D0sLMBMAxA/pMT/fHGYxj42nX6zUrH8i4C8ZHPtGN/dX
	 BzWKYDDjuYEwAq1A3CHSCkmt3BzuAXBYK6Mjdc710qi4QpRa/VCTHdpxZ/YrhVq9UUuaZ
	 zStNf2PzAQGp15ZDWjuoSN6KEmdFpWoH0okc9u7hGPfYXFaHorUTGeYMQM9TTtgP1j1yf
	 0Gwt8NpSB4aKUBAhXriiqYDEd2pUFA2IkqdgIyA1dzz9s3pW07uTaBnkPkCCOdszmBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=th65INViaQwUxEl7ithPyqFu1u1a7MEisiIYshsa1e0=;
	b=01dADNMumYNM6alt1Uo7oavU1w6pBizfCzbfFvRj+aSy7YeUvYH7TZSIqgsdc2y6upEq
	 Iu3yRcVE2hHBNouIIC24N84Txa4TFMu4Cf5NyuvSsnW4mIRA8q0bqybtaNShGH2ip+C/5
	 d7YNCLls2XM7FqJE2qtOj3piDzLYzaQXQwXHxvId2v3ursJT+djWV9jG9xZb/DXelVNPI
	 58ejzlXfKFnTCbIdtL8eYGuIkSboNvYCjOZAcVHURCBWEvmqLNJJxRzLgaizY2yk07Nvu
	 pr05M9uXgwhu5KBYOxMyeW48KMqccPJtFi6MS96Y3d0LzS+hBP0WvRUq0FCJSlca6TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M56UOHLT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A9F606A31C;
	Thu, 19 Nov 2026 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M56UOHLT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC0E1F000C4;
	Thu, 19 Nov 2026 00:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047735;
	bh=th65INViaQwUxEl7ithPyqFu1u1a7MEisiIYshsa1e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M56UOHLTR05TjBKTgqhGz5HWpqmEJHIoPaD+SdknfOP3Pe7RprYBTmw3VJXPS8r+y
	 G2TubEi8hJpfX5+gYTW9qkdbstioYMMMIsdM8Q4qecWru2Iaf0kpKUjorC+j6NMqW+
	 5eBgifgAkstGPrvP9cth/ArIlRGSMNcVb89q1iMA=
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
Subject: [PATCH 6.1 1745/2857] perf jitdump: Fix extended header read that always fails
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118150304.132201697@linuxfoundation.org>
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
index 0e033278fa127..00c435d1a4175 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -223,10 +223,12 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



