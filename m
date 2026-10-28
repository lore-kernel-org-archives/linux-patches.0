Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208429;
	b=xWHDV4eDDqInWgb7sMLzkUUaIr4QEHCRd29g2FyBmXb7pqfChMKxM5imMbYePKrosoWI
	 LEsi9HIPjAF6rxyJl3bdSqyPObnAkY9bN/TGXMgsGSETt7aFwA1ZPcxaGZMB40NNOFuSy
	 n2PyFKsNi+Nlj4DSGnR9qrIDj82HtFVlg3qAnB3ctpSElXZwHUF62gBc6/R2xdiGBwL5G
	 qaADoaEMij3fj+/glHgCx7U4inpu7Xwb5Wo6LPO+TcxMwNTauiQvLt7v5F7owl39ER2Pb
	 weWRSf9zc4JuH7hW6Lt8+q3rOcivNwWIwpOhn/XXuU+x8ku5dIw+Cqu3CbdDV4GXuKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=92TSIo1wfgy84jTpw13w5/s51eDfmw0nGhPmxr51ef0=;
	b=RFeTZC39kXFvOfeYWjAmIQel1l2NK68V3SC4Y4hWSczZfv4OxjQCUq2VklAuT/YYL6zI
	 GOM1euLG4usp+I/WLu8qydW+vnUi/I1PaBkPm6ESNFyfIYHAebhLo1ZkvNAeOGywMoQVO
	 A+QCISEduY/qddAL9WhW8heBC5G7RFtOeGOeOYOU/TbYJLFnMI1H91l/BJxB+x1mxAowt
	 wq7Iips1KqY4gwyWKNaramsBamsljd/oSc6k+pQlmYLRUnK1tMqq1ZdGjCQL7ytD14/s9
	 YreDN9jFUCAar38MSQk7utjU1EShr7Q081gsE3VpjxYpLCXG2Vg75NonCxvJpXSOMlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ti028qxm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746F606A31D;
	Wed, 28 Oct 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ti028qxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1862F1F01825;
	Wed, 28 Oct 2026 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208428;
	bh=92TSIo1wfgy84jTpw13w5/s51eDfmw0nGhPmxr51ef0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ti028qxmwR3X7b5Vk5PSyCjU3h7EufvjqpTz8YADFjlqO4XzaMljQqcYkK2DQp6TD
	 /EByDJnOraw1EfSRqmnuH2IvWmuM5c2DMktkIuw1htPAwXO15YoWVY4615MKuaLkRP
	 WIXB5NOcZPDE0psfinlNChouvkO+FT3B96B5vKQs=
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
Subject: [PATCH 5.10 116/516] perf test bpf: Address error about non-null argument for epoll_pwait 2nd arg
Date: Wed, 28 Oct 2026 17:54:28 +0100
Message-ID: <20261028170006.266768897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

commit ed847e30f001b207013b6136c264454d7560557f upstream.

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
index e5832b74a845d..96467311b1fe5 100644
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



