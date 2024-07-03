Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E271D17B43F;
	Wed,  3 Jul 2024 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003834; cv=none; b=PboZKdj7Spc+uwZOL17RvfOSW6aKylbM2HRZTXAUB+WWaNHCTedPDB03Mst26Jx9KzvWS7Nw2k0VbL1w4+GwoX1A5BBBgX92nAmB9sQFj9ErU3/BiGYY3UC0fJS8+4LBk7FqbOh6T04ast01elDN4T02RDA9KNOqtUv0re5jl7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003834; c=relaxed/simple;
	bh=fuDmjJDuRtMDWmA9yxyHw+MPOzCDLP+lQpSwMjA9iTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSjtBWiPGdBXf5EHik2AgcVFtWMTJNfD0h8aEQ/883iw/TT3ee19xtAvr2CQZ+AVV1KAfsQLdjLhN4QNAug4c0HPaEG2riyqBUpFuxQYeTpuIPcoq/KuHWgLnb2EgQVXPMFyKEFHvtKDH/nK/OniIZEjkF4amMnRUL/HjqH6GRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAWzpycr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAWzpycr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CC2C2BD10;
	Wed,  3 Jul 2024 10:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003833;
	bh=fuDmjJDuRtMDWmA9yxyHw+MPOzCDLP+lQpSwMjA9iTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAWzpycrd0UxtTFVN2+7s5D/SvLRLnEdnMeuKvfijZF8HiKleaZPvi0p5lsn9sGJB
	 T67rg/kUj2xpEjM9rzW12AYdBu4ZE1ilnY8SMxfhQTggzOvByvgA7goHm3NArSd7HD
	 pD6sFrYSFfs3SPeXZiI4EGUXTVxjJhlwyhWeZfmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/189] selftests/mm: log a consistent test name for check_compaction
Date: Wed,  3 Jul 2024 12:38:17 +0200
Message-ID: <20240703102842.873055476@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit f3b7568c49420d2dcd251032c9ca1e069ec8a6c9 ]

Every test result report in the compaction test prints a distinct log
messae, and some of the reports print a name that varies at runtime.  This
causes problems for automation since a lot of automation software uses the
printed string as the name of the test, if the name varies from run to run
and from pass to fail then the automation software can't identify that a
test changed result or that the same tests are being run.

Refactor the logging to use a consistent name when printing the result of
the test, printing the existing messages as diagnostic information instead
so they are still available for people trying to interpret the results.

Link: https://lkml.kernel.org/r/20240209-kselftest-mm-cleanup-v1-2-a3c0386496b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: d4202e66a4b1 ("selftests/mm: compaction_test: fix bogus test success on Aarch64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/compaction_test.c | 35 +++++++++++---------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/vm/compaction_test.c b/tools/testing/selftests/vm/compaction_test.c
index 43f5044b23c57..6be4b70a26592 100644
--- a/tools/testing/selftests/vm/compaction_test.c
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -94,14 +94,15 @@ int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 
 	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
 	if (fd < 0) {
-		ksft_test_result_fail("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
-		return -1;
+		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		ret = -1;
+		goto out;
 	}
 
 	if (read(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages)) <= 0) {
-		ksft_test_result_fail("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
@@ -109,8 +110,8 @@ int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_test_result_fail("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
@@ -119,16 +120,16 @@ int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 	/* Request a large number of huge pages. The Kernel will allocate
 	   as much as it can */
 	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
-		ksft_test_result_fail("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
 	lseek(fd, 0, SEEK_SET);
 
 	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_test_result_fail("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
@@ -140,24 +141,26 @@ int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
 
 	if (write(fd, initial_nr_hugepages, strlen(initial_nr_hugepages))
 	    != strlen(initial_nr_hugepages)) {
-		ksft_test_result_fail("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
 		goto close_fd;
 	}
 
+	ksft_print_msg("Number of huge pages allocated = %d\n",
+		       atoi(nr_hugepages));
+
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less that 1/%d of memory is available\n"
 			       "as huge pages\n", compaction_index);
-		ksft_test_result_fail("No of huge pages allocated = %d\n", (atoi(nr_hugepages)));
 		goto close_fd;
 	}
 
-	ksft_test_result_pass("Memory compaction succeeded. No of huge pages allocated = %d\n",
-			      (atoi(nr_hugepages)));
 	ret = 0;
 
  close_fd:
 	close(fd);
+ out:
+	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
-- 
2.43.0



