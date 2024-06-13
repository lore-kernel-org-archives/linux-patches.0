Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9E3149E0A;
	Thu, 13 Jun 2024 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279956; cv=none; b=fEjXhfTHWhRoppmLxH8BO/uMt5hEbSMugjyjYhCtjdatJzNxoyD+m39RD0jogxw8L2d5GF/q6mxxq036ovIx43zdcFMSHYgY55tqdltiMXfeRP5Cq31bbzQHRUmR6ZRSoByA38L8XzUV0hAocrGpSotXYD9FLXsrrIcD8C6A88A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279956; c=relaxed/simple;
	bh=pcwKK381rf0fnihLb2kimVUrie71p6RKRfO5dZP5gac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLjJ1tF/TMFla0aT7LhymqSoGB67Ec/jTErVqaeHunvNGl2uOe2CXxnOC8E/r4mnwd4W+u9q3JUdmT96vZ+M/r7dI5jW9rn17IiEAusUM6GaDTL9zjJ3Iz4/V+OzPCYE0i4vFDZJ4cadyE1eHdddjRInOVs82pTeczdzVnxvPUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MxjO/oY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MxjO/oY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60EDC2BBFC;
	Thu, 13 Jun 2024 11:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279956;
	bh=pcwKK381rf0fnihLb2kimVUrie71p6RKRfO5dZP5gac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MxjO/oYxn+lbNNsmS06TA/YJ1Ixrx9Mh1rcdrtFMM5xGyrZRTesk/NZZKluYTxaY
	 RrBCSQ/M4r1J30qkw2/Pwy52VDi/k9bw3UcqNlF/cIhWDOXlNyELWu7OBjz0Hn2yGy
	 f28Uda9D+LIOZRrM896mExMQJnt2MaaPmmLFYxeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautammenghani201@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/202] selftests/kcmp: Make the test output consistent and clear
Date: Thu, 13 Jun 2024 13:33:04 +0200
Message-ID: <20240613113231.089890013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Gautam Menghani <gautammenghani201@gmail.com>

[ Upstream commit ff682226a353d88ffa5db9c2a9b945066776311e ]

Make the output format of this test consistent. Currently the output is
as follows:

+TAP version 13
+1..1
+# selftests: kcmp: kcmp_test
+# pid1:  45814 pid2:  45815 FD:  1 FILES:  1 VM:  2 FS:  1 SIGHAND:  2
+  IO:  0 SYSVSEM:  0 INV: -1
+# PASS: 0 returned as expected
+# PASS: 0 returned as expected
+# PASS: 0 returned as expected
+# # Planned tests != run tests (0 != 3)
+# # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
+# # Planned tests != run tests (0 != 3)
+# # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
+# # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
+ok 1 selftests: kcmp: kcmp_test

With this patch applied the output is as follows:

+TAP version 13
+1..1
+# selftests: kcmp: kcmp_test
+# TAP version 13
+# 1..3
+# pid1:  46330 pid2:  46331 FD:  1 FILES:  2 VM:  2 FS:  2 SIGHAND:  1
+  IO:  0 SYSVSEM:  0 INV: -1
+# PASS: 0 returned as expected
+# PASS: 0 returned as expected
+# PASS: 0 returned as expected
+# # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
+ok 1 selftests: kcmp: kcmp_test

Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: eb59a5811371 ("selftests/kcmp: remove unused open mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kcmp/kcmp_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index 6ea7b9f37a411..25110c7c0b3ed 100644
--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -88,6 +88,9 @@ int main(int argc, char **argv)
 		int pid2 = getpid();
 		int ret;
 
+		ksft_print_header();
+		ksft_set_plan(3);
+
 		fd2 = open(kpath, O_RDWR, 0644);
 		if (fd2 < 0) {
 			perror("Can't open file");
@@ -152,7 +155,6 @@ int main(int argc, char **argv)
 			ksft_inc_pass_cnt();
 		}
 
-		ksft_print_cnts();
 
 		if (ret)
 			ksft_exit_fail();
@@ -162,5 +164,5 @@ int main(int argc, char **argv)
 
 	waitpid(pid2, &status, P_ALL);
 
-	return ksft_exit_pass();
+	return 0;
 }
-- 
2.43.0



