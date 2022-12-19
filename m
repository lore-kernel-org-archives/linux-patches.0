Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBED86FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C959C433EF;
	Mon, 19 Dec 2022 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477967;
	bh=eyBEeHqVE8jnV337usYDsK9YZhvsberyh0bWWKcVzC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebm+nuwfy+jkPLfsKRH88x0Qx4CY//XCUDccvXW3FzLuMziWrQ56zHSFnJWGMTwVz
	 LezLbubvcllYEdQ5nwjNSSzIJPP+nIbI144kAk4xXnI8LgiMVKsygT4twc6FUa1zwX
	 pEN2et/HXoOeD4n8G5g5uybk7VNCyDUxIgOErvbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 04/28] bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp
Date: Mon, 19 Dec 2022 20:22:51 +0100
Message-Id: <20221219182944.383209875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

commit 1a1b0716d36d21f8448bd7d3f1c0ade7230bb294 upstream.

Renaming __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp,
because it's more suitable to current and upcoming code.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-4-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2362,7 +2362,7 @@ static void bpf_kprobe_multi_cookie_swap
 	swap(*cookie_a, *cookie_b);
 }
 
-static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
+static int bpf_kprobe_multi_addrs_cmp(const void *a, const void *b)
 {
 	const unsigned long *addr_a = a, *addr_b = b;
 
@@ -2373,7 +2373,7 @@ static int __bpf_kprobe_multi_cookie_cmp
 
 static int bpf_kprobe_multi_cookie_cmp(const void *a, const void *b, const void *priv)
 {
-	return __bpf_kprobe_multi_cookie_cmp(a, b);
+	return bpf_kprobe_multi_addrs_cmp(a, b);
 }
 
 static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
@@ -2391,7 +2391,7 @@ static u64 bpf_kprobe_multi_cookie(struc
 		return 0;
 	entry_ip = run_ctx->entry_ip;
 	addr = bsearch(&entry_ip, link->addrs, link->cnt, sizeof(entry_ip),
-		       __bpf_kprobe_multi_cookie_cmp);
+		       bpf_kprobe_multi_addrs_cmp);
 	if (!addr)
 		return 0;
 	cookie = link->cookies + (addr - link->addrs);


