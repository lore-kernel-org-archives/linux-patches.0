Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029807;
	b=zQCY/wKwCnuf3DrI4PE1HY7q9MQuhqWOpHvgXyt71iABzB10Yb2fv5ITl8lPPc7IlYim
	 svTrTcOoq3LoCE1rX45r9eWkQTyQel6dxcIOrkUEpWWsY3l8DjT6NwG6oi3lAW2kNOru9
	 Ds1lcLyzladtD4yP3MkrLhrz16tGAsxHr/iKcpxj7p88KDlMA2gw/MpPaosTqUI4nQWlv
	 xonC4sDS0JIGxyJJlic8hvcUkrqTh2X6Z5A1OPNDIoNNROseG4v8OoP7aZL7mfW7qCqoY
	 +6wIp+PcvywIoMgglv6VNMq7l7Hqm2dwPv8F2iq7pxvyZrPBIHbZf3TDhPWmV1vmXEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mz1m0K0ASgj1DZWGMGNkAFsI1GMxeQhGb5hjy0m3sKg=;
	b=dkr5EXaTllEr0ponuscJzMa4qI8lCBXD3KAWOJNc4cu5sQlB3mVQlH29SbdB3kj8LgmP
	 uF1RP3LkWo45c6Ce4rucy1TpRFAhpDKkw0DO634UPxR8dmaObZhZ9l1gn3HBy6V3bw4by
	 L0r0lAbi7BMeSBu5INlL+6vGxU7hd6Uvj19EA3YNO0YFbOuo2yB0cHYiQhnfXPpTBNeYM
	 q9ZiHL+E3cEOZOYZMkxWqvHS2UcDnhaw3DA9llQ6+y3BNTgtjJFF5RkrDX0kb1+ojGZY1
	 dnM+SV4PdGXCTD/84tnPi2DyDLs/am2SuY+U2sbFx4xpubji6zkPSoKfyAYJn7071qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hR6XCX8g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933FB606A320;
	Wed, 18 Nov 2026 19:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hR6XCX8g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE501F000C4;
	Wed, 18 Nov 2026 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029807;
	bh=Mz1m0K0ASgj1DZWGMGNkAFsI1GMxeQhGb5hjy0m3sKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hR6XCX8ghaol60On96HuBKufNeMCgCKxjeX2qUwgk7Ddt/f3tgVahxHe9Uiu7F//p
	 ytCuk0YinpLZAwyQ8Jsu5w0W9n5nxcdsOejumrwJgQilT4jQHUH6ccZlrO0etYt0nT
	 14ziHikR0ew/eFXG1jV9CglnwBU+gGBG66tTMgCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WanLi Niu <niuwl1@chinatelecom.cn>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0482/1756] bpftool: Make skeleton C++ compatible with explicit casts
Date: Wed, 18 Nov 2026 15:43:29 +0100
Message-ID: <20261118150028.084924765@linuxfoundation.org>
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

From: WanLi Niu <niuwl1@chinatelecom.cn>

[ Upstream commit 4effccde0a0521b220c3585c9a0d8e677d345209 ]

Fix C++ compilation errors in generated skeleton by adding explicit
pointer casts and use char * subtraction for offset calculation

error: invalid conversion from 'void*' to '<obj_name>*' [-fpermissive]
      |         skel = skel_alloc(sizeof(*skel));
      |                ~~~~~~~~~~^~~~~~~~~~~~~~~
      |                          |
      |                          void*

error: arithmetic on pointers to void
      |         skel->ctx.sz = (void *)&skel->links - (void *)skel;
      |                        ~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~

error: assigning to 'struct <obj_name>__<ident> *' from incompatible type 'void *'
      |                 skel-><ident> = skel_prep_map_data((void *)data, 4096,
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                 sizeof(data) - 1);
      |                                                 ~~~~~~~~~~~~~~~~~

error: assigning to 'struct <obj_name>__<ident> *' from incompatible type 'void *'
      |         skel-><ident> = skel_finalize_map_data(&skel->maps.<ident>.initial_value,
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                         4096, PROT_READ | PROT_WRITE, skel->maps.<ident>.map_fd);
      |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Minimum reproducer:

	$ cat test.bpf.c
	int val; // placed in .bss section

	#include "vmlinux.h"
	#include <bpf/bpf_helpers.h>

	SEC("raw_tracepoint/sched_wakeup_new") int handle(void *ctx) { return 0; }

	$ cat test.cpp
	#include <cerrno>

	extern "C" {
	#include "test.bpf.skel.h"
	}

	$ bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h
	$ clang -g -O2 -target bpf -c test.bpf.c -o test.bpf.o
	$ bpftool gen skeleton test.bpf.o -L  > test.bpf.skel.h
	$ g++ -c test.cpp -I.

Co-developed-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: WanLi Niu <niuwl1@chinatelecom.cn>
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260106023123.2928-1-kiraskyler@163.com
Stable-dep-of: a885470df10b ("bpftool: Compute map size of light skeletons at runtime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index ab0d780225cfa..40e4b5848ee36 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -723,10 +723,10 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		{							    \n\
 			struct %1$s *skel;				    \n\
 									    \n\
-			skel = skel_alloc(sizeof(*skel));		    \n\
+			skel = (struct %1$s *)skel_alloc(sizeof(*skel));    \n\
 			if (!skel)					    \n\
 				goto cleanup;				    \n\
-			skel->ctx.sz = (void *)&skel->links - (void *)skel; \n\
+			skel->ctx.sz = (char *)&skel->links - (char *)skel; \n\
 		",
 		obj_name, opts.data_sz);
 	bpf_object__for_each_map(map, obj) {
@@ -747,7 +747,7 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		\n\
 		\";							    \n\
 									    \n\
-				skel->%1$s = skel_prep_map_data((void *)data, %2$zd,\n\
+				skel->%1$s = (__typeof__(skel->%1$s))skel_prep_map_data((void *)data, %2$zd,\n\
 								sizeof(data) - 1);\n\
 				if (!skel->%1$s)			    \n\
 					goto cleanup;			    \n\
@@ -805,7 +805,7 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 
 		codegen("\
 		\n\
-			skel->%1$s = skel_finalize_map_data(&skel->maps.%1$s.initial_value,  \n\
+			skel->%1$s = (__typeof__(skel->%1$s))skel_finalize_map_data(&skel->maps.%1$s.initial_value,\n\
 							%2$zd, %3$s, skel->maps.%1$s.map_fd);\n\
 			if (!skel->%1$s)				    \n\
 				return -ENOMEM;				    \n\
-- 
2.53.0



