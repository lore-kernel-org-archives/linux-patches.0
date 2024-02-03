Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82CA10A23;
	Sat,  3 Feb 2024 04:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933695; cv=none; b=BJ6PfEp86B2n9kusUazY2SsW/sc+NLoiujZi53dAWqKDebpMgSkX8ERpu5BDKR1f/g0ybspYxTgpDVwADc3AStsEoplSGR6PqFNZvbnzDngdkkwN63Jn3BiB1XAgHdUVyIsEeX7xOhHjWkdEL5dl14FRtN9Q6zwg8ltIIGwVSx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933695; c=relaxed/simple;
	bh=tOKrQKxPXFzNo/q2b+mfey36H9FuHlcNhbsweTSomdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNOxLtrFOBeGmmh6cVKbIaB8BGg3MgoykRBjs63+aWnWL3SuaKMXfUUBzIIl8+3LYX/gfiZWfB4Z5E0DVAg8/5voBndI0MwhFlpcnsW+qs8UnTl42Q3439xrqEEFKZawjCqe1OOQdc9SzzjWF9Yiwru2diyo12L22JRVZBhBYj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJFGVITi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJFGVITi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F19C43399;
	Sat,  3 Feb 2024 04:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933695;
	bh=tOKrQKxPXFzNo/q2b+mfey36H9FuHlcNhbsweTSomdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJFGVITiunmq6onESqsS7I/zqT2RV9m0uhJ0yBLY7rromkgbtzMt79pWhPhNqMBL0
	 Yd29BWWsWOSVYjaBcXaKY1EWX6L3c9q9okn/cCcUyaxUe0wUikIUybm+4bJTtgMDEa
	 8HxtxeJAllC1ini4HtWj/ForGNFvOm5jtebyGcSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/322] selftests: net: remove dependency on ebpf tests
Date: Fri,  2 Feb 2024 20:06:06 -0800
Message-ID: <20240203035407.805043480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a2881d43989..de4506e2a412 100644
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
@@ -100,7 +101,7 @@ $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread -lcrypto
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
 $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
 
-# Rules to generate bpf obj nat6to4.o
+# Rules to generate bpf objs
 CLANG ?= clang
 SCRATCH_DIR := $(OUTPUT)/tools
 BUILD_DIR := $(SCRATCH_DIR)/build
@@ -135,7 +136,7 @@ endif
 
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



