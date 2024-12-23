Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2787E0FF;
	Mon, 23 Dec 2024 16:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970483; cv=none; b=O7OLW5RKFmoDpmQa+HEDliSst4evmrE2AypKISQG2RtvP6e6RluktwvvoCleyNBefR/+oba1aRjQ02NdCvL7Ueg42siqI6niwsZHNMtmGiroS6CRptDp+8DbXoe8hK2XmlGiSU414n02pE4fzoFfML5NFYJxeEgmYbQl0iBWtss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970483; c=relaxed/simple;
	bh=B3Fopk/dk2mbH4as01KDoT1e7bKOaeRTfpV8Ix1etJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLRzggQK08vHqpUODvqUNAHtMgGQ6bgG3QbIovF4ClmrNVFmrcrALOosC5/1NPBinYtd3kTL8LPwSShstfteXBLDFrwgEusV9pHTCurVDkO+HB5LKvIFziT8b+GGKMtXl82q8/x/zsvul30STCq4nJxE+gSKJS+tT4kVt/s975M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeODyKog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeODyKog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497C3C4CED3;
	Mon, 23 Dec 2024 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970483;
	bh=B3Fopk/dk2mbH4as01KDoT1e7bKOaeRTfpV8Ix1etJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeODyKog/DhZa7K4UXgf+lLcvaK7D5m3LwYMKoGh1gWFeE4+26Qq45FuHZ3tF/uS3
	 eHHZreKBRGPQEony9P1iivEkQKAsymIv5qKtqLOZsMcjwHVVKyr5g4x6wUeIcnaLwa
	 9j57EafwAVWo+GLpIhdwCEcA8Txthb4VIFWqmPD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 095/116] selftests/memfd: run sysctl tests when PID namespace support is enabled
Date: Mon, 23 Dec 2024 16:59:25 +0100
Message-ID: <20241223155403.255632420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 6a75f19af16ff482cfd6085c77123aa0f464f8dd upstream.

The sysctl tests for vm.memfd_noexec rely on the kernel to support PID
namespaces (i.e.  the kernel is built with CONFIG_PID_NS=y).  If the
kernel the test runs on does not support PID namespaces, the first sysctl
test will fail when attempting to spawn a new thread in a new PID
namespace, abort the test, preventing the remaining tests from being run.

This is not desirable, as not all kernels need PID namespaces, but can
still use the other features provided by memfd.  Therefore, only run the
sysctl tests if the kernel supports PID namespaces.  Otherwise, skip those
tests and emit an informative message to let the user know why the sysctl
tests are not being run.

Link: https://lkml.kernel.org/r/20241205192943.3228757-1-isaacmanjarres@google.com
Fixes: 11f75a01448f ("selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/memfd/memfd_test.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <linux/memfd.h>
 #include <sched.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
@@ -1567,6 +1568,11 @@ static void test_share_fork(char *banner
 	close(fd);
 }
 
+static bool pid_ns_supported(void)
+{
+	return access("/proc/self/ns/pid", F_OK) == 0;
+}
+
 int main(int argc, char **argv)
 {
 	pid_t pid;
@@ -1601,8 +1607,12 @@ int main(int argc, char **argv)
 	test_seal_grow();
 	test_seal_resize();
 
-	test_sysctl_simple();
-	test_sysctl_nested();
+	if (pid_ns_supported()) {
+		test_sysctl_simple();
+		test_sysctl_nested();
+	} else {
+		printf("PID namespaces are not supported; skipping sysctl tests\n");
+	}
 
 	test_share_dup("SHARE-DUP", "");
 	test_share_mmap("SHARE-MMAP", "");


