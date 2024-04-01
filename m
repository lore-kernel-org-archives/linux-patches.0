Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CFAC129;
	Mon,  1 Apr 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988914; cv=none; b=thtqEjW37/jm/PD04zPIAhDn1MdyFIdcqERhFChptzMxjkJmlOrzAe4UQqe+njxSRvacNvlULNh8BvYgCzEWvp42ngNG3plRRhH+eVfenrn/NJ4HbWyPAYeQGjxT9s+921tzijHfxK0UblHk1zt61BEvS53upmxQY59qzC7iqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988914; c=relaxed/simple;
	bh=CVspGQLSDxGg1fW0kInT+gueqqdExUZuNesuM5KAW20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHeL9i6+3wZya9KFaI8gGOLOn3jhiuIgXX1F56lU5uPe9n/y1rKa3OTHTpXYZUgGa8bQRJBorYHpLOwTON8/oDXTwCYc1GygZ6raxigCv89T1JwX/Hcn+heHO3psgvAvKm9u+HB/SjufQtpu29OPUQ1VktAXnvDkm90I2blVy1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8yq9S8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8yq9S8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9AEC433C7;
	Mon,  1 Apr 2024 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988914;
	bh=CVspGQLSDxGg1fW0kInT+gueqqdExUZuNesuM5KAW20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8yq9S8qmtG8R70fK5tD3+NFJLJ+kahlDyE3Xn/+f5Gtv0ec1TSbdCC35zrkMlKUt
	 qTa8XoLKvGf/FeQXMkStiwZKWoaW0yKieWxXRTLjMBMu9RMh2NIr/X6cNTR2roc9vl
	 9ls7cNZXRJhK4ruQ9/0GPGC6+V42ayCh77mWBiE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 319/432] selftests/mm: gup_test: conform test to TAP format output
Date: Mon,  1 Apr 2024 17:45:06 +0200
Message-ID: <20240401152602.716165478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit cb6e7cae18868422a23d62670110c61fd1b15029 ]

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240102053807.2114200-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 8b65ef5ad486 ("selftests/mm: Fix build with _FORTIFY_SOURCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 65 ++++++++++++++-------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index ec22291363844..cbe99594d319b 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -50,39 +50,41 @@ static char *cmd_to_str(unsigned long cmd)
 void *gup_thread(void *data)
 {
 	struct gup_test gup = *(struct gup_test *)data;
-	int i;
+	int i, status;
 
 	/* Only report timing information on the *_BENCHMARK commands: */
 	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
 	     (cmd == PIN_LONGTERM_BENCHMARK)) {
 		for (i = 0; i < repeats; i++) {
 			gup.size = size;
-			if (ioctl(gup_fd, cmd, &gup))
-				perror("ioctl"), exit(1);
+			status = ioctl(gup_fd, cmd, &gup);
+			if (status)
+				break;
 
 			pthread_mutex_lock(&print_mutex);
-			printf("%s: Time: get:%lld put:%lld us",
-			       cmd_to_str(cmd), gup.get_delta_usec,
-			       gup.put_delta_usec);
+			ksft_print_msg("%s: Time: get:%lld put:%lld us",
+				       cmd_to_str(cmd), gup.get_delta_usec,
+				       gup.put_delta_usec);
 			if (gup.size != size)
-				printf(", truncated (size: %lld)", gup.size);
-			printf("\n");
+				ksft_print_msg(", truncated (size: %lld)", gup.size);
+			ksft_print_msg("\n");
 			pthread_mutex_unlock(&print_mutex);
 		}
 	} else {
 		gup.size = size;
-		if (ioctl(gup_fd, cmd, &gup)) {
-			perror("ioctl");
-			exit(1);
-		}
+		status = ioctl(gup_fd, cmd, &gup);
+		if (status)
+			goto return_;
 
 		pthread_mutex_lock(&print_mutex);
-		printf("%s: done\n", cmd_to_str(cmd));
+		ksft_print_msg("%s: done\n", cmd_to_str(cmd));
 		if (gup.size != size)
-			printf("Truncated (size: %lld)\n", gup.size);
+			ksft_print_msg("Truncated (size: %lld)\n", gup.size);
 		pthread_mutex_unlock(&print_mutex);
 	}
 
+return_:
+	ksft_test_result(!status, "ioctl status %d\n", status);
 	return NULL;
 }
 
@@ -170,7 +172,7 @@ int main(int argc, char **argv)
 			touch = 1;
 			break;
 		default:
-			return -1;
+			ksft_exit_fail_msg("Wrong argument\n");
 		}
 	}
 
@@ -198,11 +200,12 @@ int main(int argc, char **argv)
 		}
 	}
 
+	ksft_print_header();
+	ksft_set_plan(nthreads);
+
 	filed = open(file, O_RDWR|O_CREAT);
-	if (filed < 0) {
-		perror("open");
-		exit(filed);
-	}
+	if (filed < 0)
+		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
 
 	gup.nr_pages_per_call = nr_pages;
 	if (write)
@@ -213,27 +216,24 @@ int main(int argc, char **argv)
 		switch (errno) {
 		case EACCES:
 			if (getuid())
-				printf("Please run this test as root\n");
+				ksft_print_msg("Please run this test as root\n");
 			break;
 		case ENOENT:
-			if (opendir("/sys/kernel/debug") == NULL) {
-				printf("mount debugfs at /sys/kernel/debug\n");
-				break;
-			}
-			printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
+			if (opendir("/sys/kernel/debug") == NULL)
+				ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+			ksft_print_msg("check if CONFIG_GUP_TEST is enabled in kernel config\n");
 			break;
 		default:
-			perror("failed to open " GUP_TEST_FILE);
+			ksft_print_msg("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
 			break;
 		}
-		exit(KSFT_SKIP);
+		ksft_test_result_skip("Please run this test as root\n");
+		return ksft_exit_pass();
 	}
 
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (p == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 	gup.addr = (unsigned long)p;
 
 	if (thp == 1)
@@ -264,7 +264,8 @@ int main(int argc, char **argv)
 		ret = pthread_join(tid[i], NULL);
 		assert(ret == 0);
 	}
+
 	free(tid);
 
-	return 0;
+	return ksft_exit_pass();
 }
-- 
2.43.0



