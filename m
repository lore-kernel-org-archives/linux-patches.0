Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060258;
	b=wL7W7aqr2CEq+ei98UZkF2VLrc1DztkfoGGVjjWCF1RmndL6Yoyn58iRLe40dUVzwsP5
	 s/mPOPd2vquR5+ezXiG7fj5TJx+KcFGLr8oA4kbyix6ykotsuRY/hZ0dCwTFJHLGkdvDc
	 Z3k4YZZRLXMUKV5nlpumk12VeWyuEYU+WDanlYyaWhZ6BnVknqqPqZ4hTauzapVkgTTU8
	 dstYrZsq1zxHn50U3abyvUqDAcWMrq/B+0OTG82yg610unZN2Pr1+2NSykgh3ykC2whGh
	 RFsQgkUV8CgFUhMclgvbAlxcRQ+U4Xv0kbExQkGuf8FWxbTDAVISuXvTYEYzcpzyWMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CbxyWRfMWUC/8Me6/MVNY7URIy+orpdbRXO+Q/wL2fo=;
	b=v+M3+cTMOIqDMg2aFAVY/QvkvUnzKMb+8P95qVUsTFT3EfKFcbNXsmWXst6NvrboDAR3
	 k9anPcF1u9y5O1a8F+WnFbJjO9mfYUPeNpjBvbughIw9DFf7VJNC8b800k32VVcrahqeZ
	 7vSCKbzXM00JcxFb3M1JPpIdYcTE5h4u3SAx5HH81NJy0pDQ+6A3yqVCs9HStXRq11f5e
	 fUVMXoSIWEZqCW11BJNcrNISUnL8FlwN4Hiak20OmDUoBHAlq8toTW+gUok76IxJIqEp/
	 q0s9g0Bu0sxGPHqMp+3L8H+/QbivAYZel5Z451TLxvpWpBwlt5gdVwngTvK3p0Z+ijw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvRuFMVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B5A606A320;
	Thu, 19 Nov 2026 03:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvRuFMVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DDA1F000C4;
	Thu, 19 Nov 2026 03:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060258;
	bh=CbxyWRfMWUC/8Me6/MVNY7URIy+orpdbRXO+Q/wL2fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvRuFMVaWlWqtDVtJFnmTiohOsoRz7fao3bnf10tqI5OBUbUEC6oUW/lL5sgKOspv
	 DepxMEyJDFWsqFd9CB2xSMQfhNRQfWb43ECbGp2P89m79rr9lfYeBKSoD6nzWZ88qA
	 m9u+/QG2rqL2Td7r9yB+jv2f3VECii3ATv5yF5ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1134/1848] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:52:52 +0100
Message-ID: <20261118150006.943436377@linuxfoundation.org>
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

[ Upstream commit 2bd967f3adcba1d3e54f10b0d8b25f950e4f03fd ]

jit_repipe_debug_info() overwrites jd->debug_data without freeing the
previous allocation.  If two consecutive JIT_CODE_DEBUG_INFO records
appear without an intervening LOAD record consuming the data, the first
allocation leaks.

The sibling jit_repipe_unwinding_info() already frees the old
jd->unwinding_data before reassignment — add the same pattern to
jit_repipe_debug_info() using zfree().

Also add cleanup of both buffers in jit_close() so they are freed when
the jitdump session ends, even if no LOAD record consumed them.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 881327bd8da1d..0ca3024622a6a 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -113,6 +113,8 @@ jit_close(struct jit_buf_desc *jd)
 	funlockfile(jd->in);
 	fclose(jd->in);
 	jd->in = NULL;
+	zfree(&jd->debug_data);
+	zfree(&jd->unwinding_data);
 }
 
 static int
@@ -620,6 +622,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



