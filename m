Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210487;
	b=1brWKcLuiKNZe5u430WhGxqONG6fRQaxZ4/o0K5PIbzVfeEFMB7ZK2wgn4rEURIgbVxc
	 GKuStVKH+GUPOJQlKzo0fbG+Nysj4nwkSzvS39iboC+DfvZ5Z398CEMjT1ZzPq4PXJdh5
	 DpUp7s6IVvOLPBBJM1DGecjmfEdaHXy/afyFszfI6REIj9T+EwC/3ft5uFInRgMRbI5Tj
	 EPYA2N9Ow0lQTUvgS0M/eCD5MIT2HlpRDotAbF6rYIn8ohZJdSOrI/XjgSId4JhkqnXmU
	 JuTO1v8KenUu5RnvV3ey5QTAMwf8jQW7ineb2R1GXYRDVnyNUOfbLNUoPMYx1GPzV0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HseXowtUJk7+J7+DLswiiFQSYflX6Hw8iC0/Ny25Izo=;
	b=T/NXFK9xMtykVSfVUYWsSqSphEfBJkhyc4FFDwnWEv3ljVMrJzz+I5jOwV2Bv+0dtPQ6
	 DOBuFprNvl8o14R+dJcN2GXoXIj9rsvBX2YiAPB76K0vO0d3p441qOj/6WGq0GfSLd/+b
	 SeclCu8WJ71gDB0phkdzK0dltMGv6QEwYqLggtbqzSARexCKXh6NnlSQEAB/uQPhP8un6
	 WxOAxjpVfgA3JtYVAKnXObhIfJrmGX+cPHPqFYIvmhD6e//emHbILchE2yS507MYrV49h
	 Ubk9xFfAGDkgwN21tEgb6BsuTukh6/laIR10gia3cGb48MVOJVhaFdoT20iyB7KBoGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im8VPxHb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F9E606A31D;
	Wed, 28 Oct 2026 18:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im8VPxHb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CED1F01825;
	Wed, 28 Oct 2026 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210486;
	bh=HseXowtUJk7+J7+DLswiiFQSYflX6Hw8iC0/Ny25Izo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im8VPxHbB8LC8TePvhcvb2CAhaQR0GPweJvXuLbhKYRT0BmR08T18+EuuZ4ljDTtX
	 x6kxWDeA3sfz6gAFI8R8wUeV+6JIFT47bUhZ1i8GLgoyl5ZXcUXlH3qtum/61Ktu69
	 Di/CMXRq5ki0Eeyn0A7NeDSEYxZiRj6HjWhsQjxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/571] perf test bpf: Address error about non-null argument for epoll_pwait 2nd arg
Date: Wed, 28 Oct 2026 17:53:11 +0100
Message-ID: <20261028170009.072643831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit ed847e30f001b207013b6136c264454d7560557f upstream

First noticed on Fedora Rawhide:

  tests/bpf.c: In function ‘epoll_pwait_loop’:
  tests/bpf.c:36:17: error: argument 2 null where non-null expected [-Werror=nonnull]
     36 |                 epoll_pwait(-(i + 1), NULL, 0, 0, NULL);
        |                 ^~~~~~~~~~~
  In file included from tests/bpf.c:5:
  /usr/include/sys/epoll.h:134:12: note: in a call to function ‘epoll_pwait’ declared ‘nonnull’
    134 | extern int epoll_pwait (int __epfd, struct epoll_event *__events,
        |            ^~~~~~~~~~~

  [perfbuilder@27cfe44d67ed perf-6.5.0-rc2]$ gcc -v
  Using built-in specs.
  COLLECT_GCC=gcc
  COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/13/lto-wrapper
  OFFLOAD_TARGET_NAMES=nvptx-none
  OFFLOAD_TARGET_DEFAULT=1
  Target: x86_64-redhat-linux
  Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,d,m2,lto --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-libstdcxx-backtrace --with-libstdcxx-zoneinfo=/usr/share/zoneinfo --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --with-isl=/builddir/build/BUILD/gcc-13.2.1-20230728/obj-x86_64-redhat-linux/isl-install --enable-offload-targets=nvptx-none --without-cuda-driver --enable-offload-defaulted --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux --with-build-config=bootstrap-lto --enable-link-serialization=1
  Thread model: posix
  Supported LTO compression algorithms: zlib zstd
  gcc version 13.2.1 20230728 (Red Hat 13.2.1-1) (GCC)
  [perfbuilder@27cfe44d67ed perf-6.5.0-rc2]$

Just add that argument to address this compiler warning.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/ZMj8+bvN86D0ZKiB@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index fa03ff0dc0831..4486de74eca9d 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -29,11 +29,12 @@
 
 static int epoll_pwait_loop(void)
 {
+	struct epoll_event events;
 	int i;
 
 	/* Should fail NR_ITERS times */
 	for (i = 0; i < NR_ITERS; i++)
-		epoll_pwait(-(i + 1), NULL, 0, 0, NULL);
+		epoll_pwait(-(i + 1), &events, 0, 0, NULL);
 	return 0;
 }
 
-- 
2.53.0



