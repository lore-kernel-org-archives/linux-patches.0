Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21740BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EF7C433EF;
	Tue,  7 Mar 2023 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211542;
	bh=HXq/6ZjXuusXiycdbXpA5n7j8u0nZx0cU+AyOrSbcWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9U/qEKVdfsf6JHS6+68ydwCErN6mTZLyy6k1K5SXUs5NknHxbYZ4D1g0OQdWulO2
	 4WqxcL5NARQrJCJB5DsZJMOjx0w1KJzieNnp7Js0nBZfZFz2ZTBpG58hli8/oWpSuz
	 ei3Nj8hlSE+X2YkB0E0eqgG+8PEaqYeh+YKWRR9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0866/1001] selftests: filesystems: Fix incorrect kernel headers search path
Date: Tue,  7 Mar 2023 18:00:38 +0100
Message-Id: <20230307170059.451584358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit c2d3cf3653a8ff6e4b402d55e7f84790ac08a8ad upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/filesystems/Makefile          |    2 +-
 tools/testing/selftests/filesystems/binderfs/Makefile |    2 +-
 tools/testing/selftests/filesystems/epoll/Makefile    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := devpts_pts
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
--- a/tools/testing/selftests/filesystems/binderfs/Makefile
+++ b/tools/testing/selftests/filesystems/binderfs/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/ -pthread
+CFLAGS += $(KHDR_INCLUDES) -pthread
 TEST_GEN_PROGS := binderfs_test
 
 binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
--- a/tools/testing/selftests/filesystems/epoll/Makefile
+++ b/tools/testing/selftests/filesystems/epoll/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 LDLIBS += -lpthread
 TEST_GEN_PROGS := epoll_wakeup_test
 


