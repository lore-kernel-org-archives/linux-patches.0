Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028477;
	b=macUjXlVspaxWgRmZbj90n2bPC5NkGQhStc4TRAFOIrK0dnXjmaNZlnTiGdFcITA8GBx
	 dcjB3mCp9Re4ERmI+eCl0R6lyYDESDMG/i53IFw+cK5MyCfEfhSafaD/rZUxLm1nMMHMC
	 xG48jwo/wJuflc097h3+YL2Mpahcxry/55NBa8qLHAT2ZZNl+0leR1A9wGXwoALYRa2b0
	 FfkXcZvaLyCtTmakFJCSiVH2Z+UnSGbiIrFFyE4o214qfdXbx+f+koIfz7o7H46vULG5r
	 Yv2E1ytRXZLBcxNky7WBVTHcjWN6GZnschz7qbfcLM7ly0M2xogIib/TkRfDH9ps29Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uQmWqV6iaAE8QqIw5NqkIEINoOWqk8IAGtlxm8Q6WOY=;
	b=Dywe/N53lX921U1a2Gd0kBg9ARCiA6g9Adezrv77Q02/oIQSfthh+eOQV9hOwtADurGw
	 cB0VCUoA0ecVnpSbldopyeXpmO4iGRxR4bFCq9QSP3DRYPOVmIS1THo5vaAOglmL3yVOT
	 PgeDHo5dcKN7h38NR8NemPw7n0To/ZfnpjzFpNvFIYX1k8y/rNNLiKlUlTCTPSgwWZYkR
	 xwIcK8k7FxjBjGDRjWXv/t5iyG6KQHk9P18lPRALxQrlw7eZGNWVO7bVCFiZe3xs8TAVb
	 UsUmwBzFJjuGadhb8vn0vFV/j+W16o3Cfgx3ZeIbGy/fyarcAhS2IIEQEN0XQrjzMVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1exeMWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A2E606A32C;
	Wed, 18 Nov 2026 19:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1exeMWv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8541F000C4;
	Wed, 18 Nov 2026 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028477;
	bh=uQmWqV6iaAE8QqIw5NqkIEINoOWqk8IAGtlxm8Q6WOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1exeMWvTQa4seVFLKR2qmpp7sXEER1uVQpvDa1r9Wpw5xg1g2dCtnuyWpaKCCS1d
	 DDDzOovCwlxAG7ywd1ef5AR32ipSykPq+2kj+/jmlHXLHcMzNTSCzhw0Pi7dAlvs3K
	 XgW/pBcoR+8AK0fxK7d62JsBwBV29r1h/Xa+ZfBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.18 2140/2151] perf auxtrace: Include sys/types.h for pid_t
Date: Wed, 18 Nov 2026 16:04:35 +0100
Message-ID: <20261118150239.628202066@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@kernel.org>

commit e28f834f57131be2cfd60a1c9c580f0a71995dc9 upstream.

In 754187ad73b73bcb ("perf build: Remove NO_AUXTRACE build option")
sys/types.h was removed, which broke the build in all Alpine Linux
releases, as musl libc has pid_t defined via sys/types.h, add it back.

Fixes: 754187ad73b73bcb ("perf build: Remove NO_AUXTRACE build option")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/auxtrace.h
+++ b/tools/perf/util/auxtrace.h
@@ -7,6 +7,7 @@
 #ifndef __PERF_AUXTRACE_H
 #define __PERF_AUXTRACE_H
 
+#include <sys/types.h>
 #include <stdio.h> // FILE
 #include <linux/perf_event.h>
 #include <linux/types.h>


