Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE8D56458;
	Thu, 13 Jun 2024 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281065; cv=none; b=oE+vajumYHJO0ni+0HdzgggAAPPdl3RxWaUS9g94FC0FZvPrYl/BRP0oq/HBFYr1cqrhGz563ACZZNZDcOglgKN6PTPMniMadU4lOjGEQ2IyNZ2DkNag19Mc/JgkqghWemQ3KDIcsSe9mjReGM85IyCdvza1msbJ/xNt0DGVZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281065; c=relaxed/simple;
	bh=MoLY7G7oqh9K1AIasR/+0ZPETZXq9fQ602TrSTziiJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feDRFm650mBB0yShZOWb7dEDxYeD0O/79QWBKuLVDV9cXZ2R6+DdA6us72QfNdbehy0BovGKdasmkO/MWTPr5MlASw9i+9FuqPBwGk6WdqOSqyiJp5f0uUlRQfaLMrukrOghTSAG9Rw/7yahYKc7T5/PjZr8s15iymqT0xRpqlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI17gYe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI17gYe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C28C4AF1C;
	Thu, 13 Jun 2024 12:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281065;
	bh=MoLY7G7oqh9K1AIasR/+0ZPETZXq9fQ602TrSTziiJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI17gYe6pvj2WgTN0XNwzRGSQOwHrJIFTIjUF6AFkoOZ97kuJAj8RHENfO41Ase0+
	 LxtQW63OK3gm+1NvdQs+LIYRQgyDqIeHEg7llhQULGW/UCkUybXdfWJ3LUREofYP2f
	 hHkEZ9a6XoR8Iw6epSB2nw/iPZX/3KvkDVLzsRbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautammenghani201@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/317] selftests/kcmp: Make the test output consistent and clear
Date: Thu, 13 Jun 2024 13:32:25 +0200
Message-ID: <20240613113252.472616932@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



