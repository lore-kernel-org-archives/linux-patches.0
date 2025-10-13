Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D9D30BBB0;
	Mon, 13 Oct 2025 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368796; cv=none; b=WuU9m8gN85QM1Mpcbr0COmsSKDMoDAymxGr8F5jghyUhryhXWlBPNzquFaVpDu5t8jZTb9rHvK9JFN892lzqL/8i3/WrAF0yb7SrSX/28CowEj6EDKpevvI0ieNbXXwg3EUVJY56NRL7vCIt0yRR/JqX7rDLCPEP+3aewzesNoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368796; c=relaxed/simple;
	bh=Oyfhjdus775yPi73PPBpJ7JD3XHNJ3ctSI163Qs4CQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArcKzXmcKbNEU4pybkdiK0PCtAgupfH4tPxjmb93v7y0765M84mAd1Jn1X6cHfhL1DHRJQu/rVr4WADOg//y63vz5QIoOAWnBHKlbWRC7GuKWUeBdqi/iajkKKuAhi9ynvaIB0A4QntDCvLEwcYl6y2pvfjJctNOrEUgkrqzHHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKllbNkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKllbNkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16926C4CEE7;
	Mon, 13 Oct 2025 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368796;
	bh=Oyfhjdus775yPi73PPBpJ7JD3XHNJ3ctSI163Qs4CQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKllbNkcHyMRSi9QXF3Op5UfXWDLQy7DWUs63wUuKUXxRfcV9R1tAgyXgeDeXhQzC
	 eMHhq63SafpWJPgcQ7gD63R06HHixEXdu/netFguFEXX5yn2fqckXtc+iAt8vv06u/
	 /yvKB88tYDMACJBFg/Jcdxj5lBz7xnzOXhTcjZNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 009/563] selftests: arm64: Fix -Waddress warning in tpidr2 test
Date: Mon, 13 Oct 2025 16:37:50 +0200
Message-ID: <20251013144411.628966765@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

[ Upstream commit 50af02425afc72b1b47c4a0a0b9c9bdaa1a1b347 ]

Thanks to -Waddress, the compiler warns that the ksft_test_result()
invocations in the arm64 tpidr2 selftest are always true. Oops.

Fix the test by, err, actually running the test functions.

Fixes: 6d80cb73131d ("kselftest/arm64: Convert tpidr2 test to use kselftest.h")
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/tpidr2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/tpidr2.c b/tools/testing/selftests/arm64/abi/tpidr2.c
index f58a9f89b952c..4c89ab0f10101 100644
--- a/tools/testing/selftests/arm64/abi/tpidr2.c
+++ b/tools/testing/selftests/arm64/abi/tpidr2.c
@@ -227,10 +227,10 @@ int main(int argc, char **argv)
 	ret = open("/proc/sys/abi/sme_default_vector_length", O_RDONLY, 0);
 	if (ret >= 0) {
 		ksft_test_result(default_value(), "default_value\n");
-		ksft_test_result(write_read, "write_read\n");
-		ksft_test_result(write_sleep_read, "write_sleep_read\n");
-		ksft_test_result(write_fork_read, "write_fork_read\n");
-		ksft_test_result(write_clone_read, "write_clone_read\n");
+		ksft_test_result(write_read(), "write_read\n");
+		ksft_test_result(write_sleep_read(), "write_sleep_read\n");
+		ksft_test_result(write_fork_read(), "write_fork_read\n");
+		ksft_test_result(write_clone_read(), "write_clone_read\n");
 
 	} else {
 		ksft_print_msg("SME support not present\n");
-- 
2.51.0



