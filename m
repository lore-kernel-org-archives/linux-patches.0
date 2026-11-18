Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019621;
	b=KbJ5hJtfVSL3onku6J54Kue0zjQ3l4cGVHaILDbipNazxBHElbHHVrOyPo8yY82+1sBR
	 6HnO3ezkGt8qrheWiZaaNi/gANdogXKkrafoqyN1JvIv41EtJoRl25KKD8fDG2vlXzuHR
	 2jJytxv2Sef7NZDGOEu/YtgapLUX3fsdpNss61KH/Lzyjt5t3RAHE8CEcLriWSOx+oTyH
	 D4YciQtRo338nqNfHmlaLE8MXGTN0zIG2hE0jKz1XjYTLQecwTvFvCffHIOZs+c2Y1aXK
	 qw+LD+m0SeOZrZrp942OfElOfB/M/5+TblYQov9K9x59u9dLMyXc29Go2gnYrFTkcRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hKlSncK1s4hNSnxmWVsANShUUQO6hi3iqWFhSTddqMs=;
	b=UUtXsscT23F5HEQx4sVvQuCz8Zc1Ow53MAq55gV3bv38sMpJJqcfg0gFCEmXhsHACEAx
	 nNR8LGmBpTUE86gylwQlG+NyvHkpAjEe2WiJTEa/78lXBHmRWeWlBRLZolqGrUmqnBZsc
	 UKhv7klru/Qmcp64HsTpfZcRomL/W0RgjXC+ggzhspJlyrxZ+2TCTM6DODKOJVGriY7hC
	 4HPEolYY/fxJUfPQ5kRSBGGtaR7L2Z/C/GCHK+FlLCH0VHlf8hVnUIo6umbe+aFFTrc8q
	 8fY2ihTwtbFDIC+TZ5o4ogRc3JVw37Goo+N2Ju0Z3GdZLyLfWF05gWQY+Qc7EUfB4gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHeRx3bm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A9D606A32C;
	Wed, 18 Nov 2026 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHeRx3bm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BFB1F000C4;
	Wed, 18 Nov 2026 16:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019621;
	bh=hKlSncK1s4hNSnxmWVsANShUUQO6hi3iqWFhSTddqMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHeRx3bmOlNj+nz2/kmrp+95dmBhEUGohK6jtYYLwBVrz5PwSBuTVR2L2rCmUA5bd
	 oZeysbcNTw5OJPLrSNKOB8pVi/cxfk4YUE7mK9NSpBtRjaVcfBSCWBlr8Q8LR+C9KZ
	 bMm+iC3cl5DKu0n8LaASsA1RY5p9E0hG207YBgAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1621/2651] selftests/namespaces: Wait for thread exit via pidfd in active-ref tests
Date: Wed, 18 Nov 2026 15:47:41 +0100
Message-ID: <20261118150346.211834127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>

[ Upstream commit 123dcfe87d5f8c9a2ff489545e85c0345de9e21c ]

pthread_join() returns once exit_mm() wakes the CLEARTID futex, but the
exiting thread drops its namespace reference later, in
exit_nsproxy_namespaces(). The joining thread can therefore still see the
namespace as active, making the final open_by_handle_at() check in
thread_ns_inactive_after_exit and thread_ns_fd_keeps_active fail
intermittently.

Have the thread open a PIDFD_THREAD pidfd on itself and poll it before
pthread_join(). A pidfd becomes readable from exit_notify(), which runs
after exit_nsproxy_namespaces().

Fixes: 29f083c49982 ("selftests/namespace: first threaded active reference count test")
Fixes: ee861032381b ("selftests/namespace: second threaded active reference count test")
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Link: https://patch.msgid.link/20261001-selftests-namespaces-nsid_race-v1-1-25f542cf0b9c@marliere.net
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/namespaces/ns_active_ref_test.c | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/namespaces/ns_active_ref_test.c b/tools/testing/selftests/namespaces/ns_active_ref_test.c
index 093268f0efaa0..ab5ffe4de5213 100644
--- a/tools/testing/selftests/namespaces/ns_active_ref_test.c
+++ b/tools/testing/selftests/namespaces/ns_active_ref_test.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <linux/nsfs.h>
+#include <poll.h>
 #include <sys/mount.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
@@ -20,6 +21,10 @@
 #include "../filesystems/utils.h"
 #include "wrappers.h"
 
+#ifndef PIDFD_THREAD
+#define PIDFD_THREAD O_EXCL
+#endif
+
 #ifndef FD_NSFS_ROOT
 #define FD_NSFS_ROOT -10003 /* Root of the nsfs filesystem */
 #endif
@@ -2120,6 +2125,7 @@ TEST(ns_mixed_types_same_owner)
 /* Thread test helpers and structures */
 struct thread_ns_info {
 	__u64 ns_id;
+	int pidfd;
 	int pipefd;
 	int syncfd_read;
 	int syncfd_write;
@@ -2152,6 +2158,13 @@ static void *thread_create_namespace(void *arg)
 		return NULL;
 	}
 
+	/* Open a pidfd so the main thread can later poll it to detect actual thread exit. */
+	info->pidfd = syscall(__NR_pidfd_open, gettid(), PIDFD_THREAD);
+	if (info->pidfd < 0) {
+		info->exit_code = 6;
+		return NULL;
+	}
+
 	/* Send namespace ID to main thread */
 	if (write(info->pipefd, &info->ns_id, sizeof(info->ns_id)) != sizeof(info->ns_id)) {
 		info->exit_code = 4;
@@ -2169,6 +2182,20 @@ static void *thread_create_namespace(void *arg)
 	return NULL;
 }
 
+/*
+ * pthread_join() returns once exit_mm() wakes the CLEARTID futex, before
+ * exit_nsproxy_namespaces() drops the namespace reference. A pidfd becomes
+ * readable only from exit_notify(), after that point.
+ */
+static int wait_thread_exited(int pidfd)
+{
+	struct pollfd pfd = { .fd = pidfd, .events = POLLIN };
+	int ret = poll(&pfd, 1, -1);
+
+	close(pidfd);
+	return ret;
+}
+
 /*
  * Test that namespace becomes inactive after thread exits.
  * This verifies active reference counting works with threads, not just processes.
@@ -2234,6 +2261,7 @@ TEST(thread_ns_inactive_after_exit)
 	close(syncpipe[1]);
 
 	/* Wait for thread to exit */
+	ASSERT_EQ(wait_thread_exited(info.pidfd), 1);
 	ASSERT_EQ(pthread_join(thread, NULL), 0);
 	close(pipefd[0]);
 	close(pipefd[1]);
@@ -2317,6 +2345,7 @@ TEST(thread_ns_fd_keeps_active)
 	close(syncpipe[1]);
 
 	/* Wait for thread to exit */
+	ASSERT_EQ(wait_thread_exited(info.pidfd), 1);
 	pthread_join(thread, NULL);
 	close(pipefd[0]);
 	close(pipefd[1]);
-- 
2.53.0



