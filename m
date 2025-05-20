Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B248B1922ED;
	Tue, 20 May 2025 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749384; cv=none; b=TAQqgxG5fkSG8OXgF9p0JfSbkzdQy03qAXKAp6eTiwJmiYJUQjY53q1DnN7Z3Q5U5OTKbTXU7TobXMrMqy4lUfgkSvHMy6kG/+rCpwk4bkQQFMo9CiRWNCwUitq7qqXdoTjl9x3+HXwdc4pE34omoWmMTO9UkswytFU3wepa8RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749384; c=relaxed/simple;
	bh=9poz58b06UY5p/ec1+lMJnbX5fLzncMIsEpQa0r8lWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by4h3CwX5MkJUQQL7OvZRiRvkwWeQt7CXhOFwLaFKlxuJJ1VYZqsmc3tsBtMmxE06LGL7HsdzaRlhvDBWqsji6NPbTMwMmpfiMG68aU3qIt7DBZjz/wEnCQYIxgKKIKVblv4JQhB9gqFXULnd3ZGuV090o9XeXCQaOn8L3Kp01o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpaWGD/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpaWGD/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B0DC4CEE9;
	Tue, 20 May 2025 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749384;
	bh=9poz58b06UY5p/ec1+lMJnbX5fLzncMIsEpQa0r8lWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpaWGD/kWGM6snoWNToSJlQw+JXrr6mNjw6RX64mpsV40nE9vJ9/XZgVg/5WT6X5V
	 AAU2yFL4vV71RF+0/pWG2eoUiNWshOlJNLzKlf1Ov93X1gbD31WPuX4EsCBgnb2LC/
	 CaDDxID4ui1sejzcLIljd2Pv2mWK31eJx0Bm0vQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/97] selftests/exec: load_address: conform test to TAP format output
Date: Tue, 20 May 2025 15:49:29 +0200
Message-ID: <20250520125800.836643079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



