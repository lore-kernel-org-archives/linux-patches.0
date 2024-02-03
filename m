Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F1B17551;
	Sat,  3 Feb 2024 04:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933936; cv=none; b=BUjnQW+F/Emq3X0lD/f3uOnK/oYPrBzrCwF9RTpd6KLtLn2cVBVebahvOPoQ3zNJ0kp17kDurowoSJOCI1IfDr/F74nvZhuRYijwN9PSF02rMQ0ct9bkUL28HWOGY06wsBf7m458R/PlgPoijdpTL74UiHW9lXaJ9CZ6MW7B16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933936; c=relaxed/simple;
	bh=rvGGZb+RK1JBagTdT/0+yffwJWPRdKLLgHpFDy8xTF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS3+b2C1z/AXW8ONMZ4NMIy9Hoz9VzxcLmwy1lYg3CuMCdD3Ta+hzcGEhYoqbdt43XsAEW1WDp0UShcZif1HkOFAOAl7z0j15Nko+jbCcBEmb1XGeOz+m+yfz4FhsgKCC788Z76QagtoQrzWsdxoZcO+0FvFJtMTibX47JqOqxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AB6HwaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AB6HwaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CE5C433C7;
	Sat,  3 Feb 2024 04:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933936;
	bh=rvGGZb+RK1JBagTdT/0+yffwJWPRdKLLgHpFDy8xTF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AB6HwaCSjE+SP+VoNL9KzbXJsf384cr4h1qz6rGSBLyhnpG0vMbveUWLy/N8hM3L
	 ABvrtFDyFt7+GRdcG940jtNvoCmO1gvKOhpoT94r4LABDLpAJUTaxsKttH8BPVMDvE
	 zWq5FGR3+3lPHjATnVj3B5qnE10GLTMFvKfHWP1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 298/353] selftests: net: remove dependency on ebpf tests
Date: Fri,  2 Feb 2024 20:06:56 -0800
Message-ID: <20240203035413.259378707@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 98cb12eb52a780e682bea8372fdb2912c08132dd ]

Several net tests requires an XDP program build under the ebpf
directory, and error out if such program is not available.

That makes running successful net test hard, let's duplicate into the
net dir the [very small] program, re-using the existing rules to build
it, and finally dropping the bogus dependency.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/28e7af7c031557f691dc8045ee41dd549dd5e74c.1706131762.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4acffb66630a ("selftests: net: explicitly wait for listener ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile          |  5 +++--
 tools/testing/selftests/net/udpgro.sh         |  4 ++--
 tools/testing/selftests/net/udpgro_bench.sh   |  4 ++--
 tools/testing/selftests/net/udpgro_frglist.sh |  6 +++---
 tools/testing/selftests/net/udpgro_fwd.sh     |  2 +-
 tools/testing/selftests/net/veth.sh           |  4 ++--
 tools/testing/selftests/net/xdp_dummy.c       | 13 +++++++++++++
 7 files changed, 26 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/net/xdp_dummy.c

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9e5bf59a20bf..c1ae90c78565 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -84,6 +84,7 @@ TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
 TEST_GEN_FILES += nat6to4.o
+TEST_GEN_FILES += xdp_dummy.o
 TEST_GEN_FILES += ip_local_port_range
 TEST_GEN_FILES += bind_wildcard
 TEST_PROGS += test_vxlan_mdb.sh
@@ -103,7 +104,7 @@ $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
 $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
 $(OUTPUT)/io_uring_zerocopy_tx: CFLAGS += -I../../../include/
 
-# Rules to generate bpf obj nat6to4.o
+# Rules to generate bpf objs
 CLANG ?= clang
 SCRATCH_DIR := $(OUTPUT)/tools
 BUILD_DIR := $(SCRATCH_DIR)/build
@@ -138,7 +139,7 @@ endif
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
 
-$(OUTPUT)/nat6to4.o: nat6to4.c $(BPFOBJ) | $(MAKE_DIRS)
+$(OUTPUT)/nat6to4.o $(OUTPUT)/xdp_dummy.o: $(OUTPUT)/%.o : %.c $(BPFOBJ) | $(MAKE_DIRS)
 	$(CLANG) -O2 --target=bpf -c $< $(CCINCLUDE) $(CLANG_SYS_INCLUDES) -o $@
 
 $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index 0c743752669a..3f09ac78f445 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -5,7 +5,7 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
-BPF_FILE="../bpf/xdp_dummy.bpf.o"
+BPF_FILE="xdp_dummy.o"
 
 # set global exit status, but never reset nonzero one.
 check_err()
@@ -198,7 +198,7 @@ run_all() {
 }
 
 if [ ! -f ${BPF_FILE} ]; then
-	echo "Missing ${BPF_FILE}. Build bpf selftest first"
+	echo "Missing ${BPF_FILE}. Run 'make' first"
 	exit -1
 fi
 
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index 894972877e8b..65ff1d424008 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -5,7 +5,7 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
-BPF_FILE="../bpf/xdp_dummy.bpf.o"
+BPF_FILE="xdp_dummy.o"
 
 cleanup() {
 	local -r jobs="$(jobs -p)"
@@ -83,7 +83,7 @@ run_all() {
 }
 
 if [ ! -f ${BPF_FILE} ]; then
-	echo "Missing ${BPF_FILE}. Build bpf selftest first"
+	echo "Missing ${BPF_FILE}. Run 'make' first"
 	exit -1
 fi
 
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 0a6359bed0b9..bd51d386b52e 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -5,7 +5,7 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
-BPF_FILE="../bpf/xdp_dummy.bpf.o"
+BPF_FILE="xdp_dummy.o"
 
 cleanup() {
 	local -r jobs="$(jobs -p)"
@@ -84,12 +84,12 @@ run_all() {
 }
 
 if [ ! -f ${BPF_FILE} ]; then
-	echo "Missing ${BPF_FILE}. Build bpf selftest first"
+	echo "Missing ${BPF_FILE}. Run 'make' first"
 	exit -1
 fi
 
 if [ ! -f nat6to4.o ]; then
-	echo "Missing nat6to4 helper. Build bpf nat6to4.o selftest first"
+	echo "Missing nat6to4 helper. Run 'make' first"
 	exit -1
 fi
 
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index c079565add39..5fa8659ab13d 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-BPF_FILE="../bpf/xdp_dummy.bpf.o"
+BPF_FILE="xdp_dummy.o"
 readonly BASE="ns-$(mktemp -u XXXXXX)"
 readonly SRC=2
 readonly DST=1
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 2d073595c620..27574bbf2d63 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
-BPF_FILE="../bpf/xdp_dummy.bpf.o"
+BPF_FILE="xdp_dummy.o"
 readonly STATS="$(mktemp -p /tmp ns-XXXXXX)"
 readonly BASE=`basename $STATS`
 readonly SRC=2
@@ -218,7 +218,7 @@ while getopts "hs:" option; do
 done
 
 if [ ! -f ${BPF_FILE} ]; then
-	echo "Missing ${BPF_FILE}. Build bpf selftest first"
+	echo "Missing ${BPF_FILE}. Run 'make' first"
 	exit 1
 fi
 
diff --git a/tools/testing/selftests/net/xdp_dummy.c b/tools/testing/selftests/net/xdp_dummy.c
new file mode 100644
index 000000000000..d988b2e0cee8
--- /dev/null
+++ b/tools/testing/selftests/net/xdp_dummy.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define KBUILD_MODNAME "xdp_dummy"
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("xdp")
+int xdp_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.43.0



