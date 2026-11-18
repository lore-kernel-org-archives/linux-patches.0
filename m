Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024082;
	b=tm9t6C1p19Hv1aYnClkrdXRPI6A4/GxoSGD9myuz8F0CAE05pdt9j9m7ZYuVAv1OLMYi
	 uUjdBJHF8CfthIq3CEJrs5Ypqw5I8j6PR1pzMjjI2r43kbx7dIP/ayVgOh/TWD+jGjrMI
	 IY5NAMOV7gu5wYUrDWWaIxlsmU6InIFhJWQ1l7+NSi2soh8wOwUnzeCJ5eNH5P5K0N5Dn
	 Qq3SKL9rx/NYKFqySmhuZ3CxLYUGcCwccVGzHq/hrILWBJ1e0y2xL5sauCyekLQLpHFOo
	 HNOgl7mE5+kk8asCEdcO1tDtqBktYhKHVJt1n5NYF/Mg+ImV7sFBqghuQpGFWmqOQaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ifPGBq42aYFtRxbyJEBTIMJMyUUVYNOcn5WSQwOggBQ=;
	b=OFunPGwzmRiKd+uFcKwg6kymQ16tjbG4cUO90vy5AkNRX2/IekHZDqUv9qAqNTecKYZ9
	 pwYxPwM006bwhyM3iqG6RHcxwhOqXvpKpJ3KVtWdk2o5/Uy3E4rZg+8hHA2rkF4tEyzx4
	 txGWkdOundYmtH8r0yJWVmMlY5+o71rZOq1rtJSGavnogSkgeML4CGzgTv3CVC38JOpL3
	 w/8JVT2SJ7LOx2+SExdjWrCUw01iq8DIVVG5lQCTiqNRtHGHpvA20Kj5vZ4/pt0xCRdZJ
	 gWCMCrz7tDAhs/yNoq2Tj/L53dfDYNOuUa6dWn0ew44eIMlyuXDrNdbfU2/z3e3N6DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCuOZXkh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD068606A320;
	Wed, 18 Nov 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCuOZXkh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166C31F000C4;
	Wed, 18 Nov 2026 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024082;
	bh=ifPGBq42aYFtRxbyJEBTIMJMyUUVYNOcn5WSQwOggBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCuOZXkhyKliAOY9qYUFR+xs0XFcjyMwkO46+Z26Ys0JCVa6DiOUTUjnxhmgcKbG5
	 /ZFL3GrnDO41qyfYxrJGgFwo6ARTy5fdL3kiTVxvn1RzERrFuWzF4ZNB4wT0ng/Cu0
	 d5QQSdYhgriCJp3jJe1XwDJbUdiqKRywx7Ltdvuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WanLi Niu <niuwl1@chinatelecom.cn>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0562/2151] bpftool: Make skeleton C++ compatible with explicit casts
Date: Wed, 18 Nov 2026 15:38:17 +0100
Message-ID: <20261118150142.426924932@linuxfoundation.org>
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
index bdef69c5e6cd4..d6040b52d4e1b 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -731,10 +731,10 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
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
@@ -755,7 +755,7 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		\n\
 		\";							    \n\
 									    \n\
-				skel->%1$s = skel_prep_map_data((void *)data, %2$zd,\n\
+				skel->%1$s = (__typeof__(skel->%1$s))skel_prep_map_data((void *)data, %2$zd,\n\
 								sizeof(data) - 1);\n\
 				if (!skel->%1$s)			    \n\
 					goto cleanup;			    \n\
@@ -857,7 +857,7 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 
 		codegen("\
 		\n\
-			skel->%1$s = skel_finalize_map_data(&skel->maps.%1$s.initial_value,  \n\
+			skel->%1$s = (__typeof__(skel->%1$s))skel_finalize_map_data(&skel->maps.%1$s.initial_value,\n\
 							%2$zd, %3$s, skel->maps.%1$s.map_fd);\n\
 			if (!skel->%1$s)				    \n\
 				return -ENOMEM;				    \n\
-- 
2.53.0



