Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618618;
	b=4wYIP+Vf+0Vzn+RPCOhXmDmEyPG4jtJaZVrsrra7al6Zi1Ck0fYtrZOHpM3IZSGl8IAh
	 e9oPuQ/bDxDn/FR5ANcnSTSwLwX2MJiVeD4CYSM+T8gnlRVfTlfyyvPNYeXvvQkTvVhpB
	 68QltCPtPqRIEmdqVwvrkvkkS7qZsNtIxOifulekocp9mPPboIUemPooprfWNuLuz+sS0
	 MkiyKF0DxqztdanE7L61gHbPR5OsRkxDZYYSs2buPQK6U2L8S+mG5o318DGWpXuvgBPLl
	 8rw2EGtiPLf228heuMXQRtQgo2yq0Mi/59ujegMY3GbjH5OoDYs73+2lJh60znUxNzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4fsExEA6p7fOO2wc2dw6xMX2sJLRCir6GCttIu3EYU=;
	b=A+38BsUVxMBC+xa1ME0gX+6wolYn7vwfSn2NJx7TenqJ7WnYxkxbdfP8Zr160eGK1ktK
	 mV3a3ZZkSDgqp8bLZvtAM9UsDkhxQK+vZ7ZAPko+oZBQpjY2iesMJcUkmXCPO+sVm/olq
	 yflerXs+V+bGPJCu1/J0MUADMwNFoERzxMzBxpLBsyJ76q20i+W0M5/T0TRc7Tvb2q2Sc
	 Eqezdme12l8XrIQnnlZW1r9hUBbHGh8U4YOgfjGwZsPi77Ihc38xAgjWixO3EcpIQltNl
	 NbIhGRwqvpEWHooEmM98DGBpmUg0t3D7HxT1nN/NnQoxcKDQ5Mw7Pvyd1J80Ob5jh/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R35h9cD7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFAF606A31E;
	Wed, 25 Nov 2026 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R35h9cD7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73F41F000D1;
	Wed, 25 Nov 2026 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618618;
	bh=M4fsExEA6p7fOO2wc2dw6xMX2sJLRCir6GCttIu3EYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R35h9cD7X2UhUZ7X3vIL0POJEC7dfi+0eiLfwJlqnRe4FCtrB11wwZxcIpgnNDbaG
	 pQg4AE7omuTN2wqTZ5YFWjHDLli71AVPOa/hvLiooyS1Cvzb6haTfkNNfzob1nFxYr
	 b4uX92msM9UYir5KT6kmDD+leNVqZwBmLZqvkGmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0336/1005] perf/core: Include perf_event_attr::defer_output in is_sb_event() check
Date: Wed, 25 Nov 2026 15:27:54 +0100
Message-ID: <20261125143829.605465094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 772f38fc69d5cf22f13b43dec30c2bbc5bdf4eb8 ]

Events configured with attr.defer_output = 1 receive deferred callchain
sideband records (PERF_RECORD_CALLCHAIN_DEFERRED) via perf_iterate_sb().

Include attr->defer_output in is_sb_event() so that such events are
attached to the sideband event list even when no other sideband flags
(such as mmap or comm) are enabled on the event.

Fixes: c69993ecdd4d ("perf: Support deferred user unwind")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20261025215508.1237480-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e8293a0e7945c..2cd3c5def0499 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5347,7 +5347,7 @@ static bool is_sb_event(struct perf_event *event)
 	    attr->comm || attr->comm_exec ||
 	    attr->task || attr->ksymbol ||
 	    attr->context_switch || attr->text_poke ||
-	    attr->bpf_event)
+	    attr->bpf_event || attr->defer_output)
 		return true;
 
 	return false;
-- 
2.53.0



