Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029844;
	b=2Ct8gUtLAunyp1rEXyL3zKoXiLKawbC9AiKh+VjwU/W2AXW/zJXcT7aTvvENJjbK/5xg
	 +O1n39LPm0qBEaYj4ZxaPBihT+/kSrx/3WSzIWUnt7hou/YdpOmzoXVD+mHRQJ7Dzpxmj
	 CoL8H8Sw4ETglIMiuECEld4OdxnRjmSxiztcPgoA4FqwnQt1J7qpAKxSzITtsFDqt2f3m
	 Os2lAhnINS2Mmjxf6duDbQB52VhE6K6E5/SmSIED5Yp5idA8QRKIxu63/IH/ySCrEZjox
	 zBrSw73g1sN1JPi65nSoUoVMkGsLlXf8+yo1io6RoxntWeuK9+16uaASVUzxcBfQXlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5P/fv4yGI+4H5iFp08f0osnfqEox4naD4MAHfOy2lgo=;
	b=AVPkLVTBLMcRdLeUDfoguHdl4kHnowGLYRH4SWmFljomBjQdPAz5e7Akc/7Y+qZu8hry
	 LbZp/Cm2CKcrXMRTmRYL19DkZJ01xNtFGVI6Hu2SAN4SCDPLJtF1sZ+SqmDT9hLB+2SGI
	 aRa2ohSuVizru6D5/s/Z6NCLEJl6g0D2PoZwyF9TiizdzNcvEvF1oOUxbttsy0gNe04GK
	 /lne57RIgFsy3WoRFpE7n+00GOSyqYRasz/641tqoSB/+0ob0Ofw2iw5nxg7SV9UyyM8l
	 X7u8Zy4RhgNATk+Ecw+QBnpZnEONeAnobwprmY/066OzVAyaT4yK5qGsT6P+PpMEKQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+3D4P2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9D9606A31C;
	Wed, 18 Nov 2026 19:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+3D4P2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB42A1F000C4;
	Wed, 18 Nov 2026 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029844;
	bh=5P/fv4yGI+4H5iFp08f0osnfqEox4naD4MAHfOy2lgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+3D4P2BMFzL+1elAZifQGq+NzOLLxgjtO7x3eA8TzbRmn9J16fxG2aP+pv+29awf
	 teLHAmEUOvHYfNWVzGIq5N8+eohPbYWe+mLAbFch9eVDJBmMpkpPOwIsFV+zThaIsD
	 OLdta1whqIMoE9LiyKzAt84KtRvSO2uHwSR2l7Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0494/1756] perf annotate-data: Show the sample count in the data-type browser
Date: Wed, 18 Nov 2026 15:43:41 +0100
Message-ID: <20261118150028.760860192@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9db4e9d6cc7c7d318fb6d6bb73abe3fed27385a8 ]

The data-type browser has a samples view, selected with -n (or with
annotate.show_nr_samples), in which browser__write_overhead() prints a
local nr_samples variable that is initialized to zero and never
updated, so every member is listed as having no samples while the
period and percent columns for the same entry are filled in.

Print the histogram entry's own count instead.

This predates the load/store counter split, so fix it ahead of that
patch: the split then only has to adapt a line that is already correct,
and this fix can be picked on its own.

Fixes: d001c7a7f4736743 ("perf annotate-data: Add hist_entry__annotate_data_tui()")
Acked-by: Namhyung Kim <namhyung@kernel.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/annotate-data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate-data.c b/tools/perf/ui/browsers/annotate-data.c
index cd562a8822b7f..e5677aaa651ce 100644
--- a/tools/perf/ui/browsers/annotate-data.c
+++ b/tools/perf/ui/browsers/annotate-data.c
@@ -370,7 +370,7 @@ static void browser__write_overhead(struct ui_browser *uib,
 	u64 period = hist->period;
 	double percent = total->period ? (100.0 * period / total->period) : 0;
 	bool current = ui_browser__is_current_entry(uib, row);
-	int nr_samples = 0;
+	int nr_samples = hist->nr_samples;
 
 	ui_browser__set_percent_color(uib, percent, current);
 
-- 
2.53.0



