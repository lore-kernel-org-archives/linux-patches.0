Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3795198845;
	Tue, 20 May 2025 14:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749657; cv=none; b=WsQvBmCJZFznJeYNp9mdN3SGzE/kr5SAPOv0QZbhddu0gLEbXDveq+18wjHRGXHgTMqLKJiseoxblv2llEaMDFTIJtPbARwrgvqdOS+6YW/x4dLQQE8aeg+RqFHaAIIeYGZbjakj0b6gN/VCDmaAZOTboEPgxshyoujjMQj8Mow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749657; c=relaxed/simple;
	bh=GABmKWUOYWo6jleUPaGrD8LXmx8N515bW3VJh901OO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQBVrzubZ8DdTC0+dSrODzCn09utqZ3xzUuXdYS2xq8tQaw9ZJM6p320QOstHhU52NO91SH/Il4JfOlzrCmLpMsJrJkjWVUPWM21mHtuw6fyaTQAt49u2fVs+HVRXr4uNg5YCDhovARRg86iYpMFyf9JFWPU8gsOgFNQ0D5sAoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAQ0hIi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAQ0hIi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D40CC4CEE9;
	Tue, 20 May 2025 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749656;
	bh=GABmKWUOYWo6jleUPaGrD8LXmx8N515bW3VJh901OO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAQ0hIi9TBmu11sgVkCIm2PZtdm77bu/934ZyN7da7b6C4F5zjEcBKEXzerEjqK9p
	 ZlhhMfBoz0KmnT/OtSf7NqAwtSbWHm3mIuJQtc7Scu9aeBR5VkbSmhZRLvxW7Yb+/M
	 fyDnaBQ62D1k/8GB6vGGdro4t4Si4mWYnH6tRVII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/117] selftests/exec: load_address: conform test to TAP format output
Date: Tue, 20 May 2025 15:49:29 +0200
Message-ID: <20250520125804.166608341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit c4095067736b7ed50316a2bc7c9577941e87ad45 ]

Conform the layout, informational and status messages to TAP. No
functional change is intended other than the layout of output messages.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240304155928.1818928-2-usama.anjum@collabora.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 11854fe263eb ("binfmt_elf: Move brk for static PIE even if ASLR disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/exec/load_address.c | 34 +++++++++------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/exec/load_address.c b/tools/testing/selftests/exec/load_address.c
index d487c2f6a6150..17e3207d34ae7 100644
--- a/tools/testing/selftests/exec/load_address.c
+++ b/tools/testing/selftests/exec/load_address.c
@@ -5,6 +5,7 @@
 #include <link.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include "../kselftest.h"
 
 struct Statistics {
 	unsigned long long load_address;
@@ -41,28 +42,23 @@ int main(int argc, char **argv)
 	unsigned long long misalign;
 	int ret;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	ret = dl_iterate_phdr(ExtractStatistics, &extracted);
-	if (ret != 1) {
-		fprintf(stderr, "FAILED\n");
-		return 1;
-	}
+	if (ret != 1)
+		ksft_exit_fail_msg("FAILED: dl_iterate_phdr\n");
 
-	if (extracted.alignment == 0) {
-		fprintf(stderr, "No alignment found\n");
-		return 1;
-	} else if (extracted.alignment & (extracted.alignment - 1)) {
-		fprintf(stderr, "Alignment is not a power of 2\n");
-		return 1;
-	}
+	if (extracted.alignment == 0)
+		ksft_exit_fail_msg("FAILED: No alignment found\n");
+	else if (extracted.alignment & (extracted.alignment - 1))
+		ksft_exit_fail_msg("FAILED: Alignment is not a power of 2\n");
 
 	misalign = extracted.load_address & (extracted.alignment - 1);
-	if (misalign) {
-		printf("alignment = %llu, load_address = %llu\n",
-			extracted.alignment, extracted.load_address);
-		fprintf(stderr, "FAILED\n");
-		return 1;
-	}
+	if (misalign)
+		ksft_exit_fail_msg("FAILED: alignment = %llu, load_address = %llu\n",
+				   extracted.alignment, extracted.load_address);
 
-	fprintf(stderr, "PASS\n");
-	return 0;
+	ksft_test_result_pass("Completed\n");
+	ksft_finished();
 }
-- 
2.39.5



