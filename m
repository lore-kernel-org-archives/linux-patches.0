Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAE22EF659;
	Tue, 17 Jun 2025 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174213; cv=none; b=P60/LMsUwvxrvIURH4+TqAKIg1KDhtIdbMKdSK3bE7k69J7if8gbSoVT0Q3xH2tBSggIioHYl9g8fMF6kjoI1xhv9a2d91lFKkMm8vgrU3XIM3hk4TviCkX6R8/l1CzRDQLCH+BaljlBPVDj398A8VK3c0VHUSyyD6hr/atUsuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174213; c=relaxed/simple;
	bh=VRygZOIfFamILu32BiD7qmDdOtadFWHkqv+c68sQCsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDBJ3ShkiExfmt2eNVHdPwbysB5I8s2JMD6zHVMfeSL1b6dxl8+vx8ee8m8WbMguJQl2SpqtDKwWAgFQRpHxs5meyHvamVaMbgQZ3NJfOSbOnMH16rcHuvDor4BtcIIg96YFBddddnGIOrEFmal1gNO/t9uptPNq+e6ouOE8i1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBS3yCUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBS3yCUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA2AC4CEE3;
	Tue, 17 Jun 2025 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174213;
	bh=VRygZOIfFamILu32BiD7qmDdOtadFWHkqv+c68sQCsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBS3yCUEtNQrt7LlF4U10DJKtbqXYt+FzzzAlBpqM3w76KAkRYoo4lk6u6BB0rgxZ
	 JnV/oUg7ehN18Mf/DNJFL2bUogAtbXVndtuxQ8vAPHF723wE2xkn5EYW0pufKzM12H
	 EsxP7bmWzr9EnMED2RVx5JLrwlQbhyuEE4Sbadmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remington Brasga <rbrasga@uci.edu>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/356] tools/x86/kcpuid: Fix error handling
Date: Tue, 17 Jun 2025 17:22:13 +0200
Message-ID: <20250617152338.971521490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Ahmed S. Darwish <darwi@linutronix.de>

[ Upstream commit 116edfe173d0c59ec2aa87fb91f2f31d477b61b3 ]

Error handling in kcpuid is unreliable.  On malloc() failures, the code
prints an error then just goes on.  The error messages are also printed
to standard output instead of standard error.

Use err() and errx() from <err.h> to direct all error messages to
standard error and automatically exit the program.  Use err() to include
the errno information, and errx() otherwise.  Use warnx() for warnings.

While at it, alphabetically reorder the header includes.

[ mingo: Fix capitalization in the help text while at it. ]

Fixes: c6b2f240bf8d ("tools/x86: Add a kcpuid tool to show raw CPU features")
Reported-by: Remington Brasga <rbrasga@uci.edu>
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20250324142042.29010-2-darwi@linutronix.de
Closes: https://lkml.kernel.org/r/20240926223557.2048-1-rbrasga@uci.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/x86/kcpuid/kcpuid.c | 47 +++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/tools/arch/x86/kcpuid/kcpuid.c b/tools/arch/x86/kcpuid/kcpuid.c
index b7965dfff33a9..8c2644f3497e6 100644
--- a/tools/arch/x86/kcpuid/kcpuid.c
+++ b/tools/arch/x86/kcpuid/kcpuid.c
@@ -1,11 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
 
-#include <stdio.h>
+#include <err.h>
+#include <getopt.h>
 #include <stdbool.h>
+#include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 
 #define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
 #define min(a, b)	(((a) < (b)) ? (a) : (b))
@@ -156,14 +157,14 @@ static bool cpuid_store(struct cpuid_range *range, u32 f, int subleaf,
 	if (!func->leafs) {
 		func->leafs = malloc(sizeof(struct subleaf));
 		if (!func->leafs)
-			perror("malloc func leaf");
+			err(EXIT_FAILURE, NULL);
 
 		func->nr = 1;
 	} else {
 		s = func->nr;
 		func->leafs = realloc(func->leafs, (s + 1) * sizeof(*leaf));
 		if (!func->leafs)
-			perror("realloc f->leafs");
+			err(EXIT_FAILURE, NULL);
 
 		func->nr++;
 	}
@@ -222,7 +223,7 @@ struct cpuid_range *setup_cpuid_range(u32 input_eax)
 
 	range = malloc(sizeof(struct cpuid_range));
 	if (!range)
-		perror("malloc range");
+		err(EXIT_FAILURE, NULL);
 
 	if (input_eax & 0x80000000)
 		range->is_ext = true;
@@ -231,7 +232,7 @@ struct cpuid_range *setup_cpuid_range(u32 input_eax)
 
 	range->funcs = malloc(sizeof(struct cpuid_func) * idx_func);
 	if (!range->funcs)
-		perror("malloc range->funcs");
+		err(EXIT_FAILURE, NULL);
 
 	range->nr = idx_func;
 	memset(range->funcs, 0, sizeof(struct cpuid_func) * idx_func);
@@ -387,8 +388,8 @@ static int parse_line(char *line)
 	return 0;
 
 err_exit:
-	printf("Warning: wrong line format:\n");
-	printf("\tline[%d]: %s\n", flines, line);
+	warnx("Wrong line format:\n"
+	      "\tline[%d]: %s", flines, line);
 	return -1;
 }
 
@@ -410,10 +411,8 @@ static void parse_text(void)
 		file = fopen("./cpuid.csv", "r");
 	}
 
-	if (!file) {
-		printf("Fail to open '%s'\n", filename);
-		return;
-	}
+	if (!file)
+		err(EXIT_FAILURE, "%s", filename);
 
 	while (1) {
 		ret = getline(&line, &len, file);
@@ -521,7 +520,7 @@ static inline struct cpuid_func *index_to_func(u32 index)
 	func_idx = index & 0xffff;
 
 	if ((func_idx + 1) > (u32)range->nr) {
-		printf("ERR: invalid input index (0x%x)\n", index);
+		warnx("Invalid input index (0x%x)", index);
 		return NULL;
 	}
 	return &range->funcs[func_idx];
@@ -553,7 +552,7 @@ static void show_info(void)
 				return;
 			}
 
-			printf("ERR: invalid input subleaf (0x%x)\n", user_sub);
+			warnx("Invalid input subleaf (0x%x)", user_sub);
 		}
 
 		show_func(func);
@@ -584,15 +583,15 @@ static void setup_platform_cpuid(void)
 
 static void usage(void)
 {
-	printf("kcpuid [-abdfhr] [-l leaf] [-s subleaf]\n"
-		"\t-a|--all             Show both bit flags and complex bit fields info\n"
-		"\t-b|--bitflags        Show boolean flags only\n"
-		"\t-d|--detail          Show details of the flag/fields (default)\n"
-		"\t-f|--flags           Specify the cpuid csv file\n"
-		"\t-h|--help            Show usage info\n"
-		"\t-l|--leaf=index      Specify the leaf you want to check\n"
-		"\t-r|--raw             Show raw cpuid data\n"
-		"\t-s|--subleaf=sub     Specify the subleaf you want to check\n"
+	warnx("kcpuid [-abdfhr] [-l leaf] [-s subleaf]\n"
+	      "\t-a|--all             Show both bit flags and complex bit fields info\n"
+	      "\t-b|--bitflags        Show boolean flags only\n"
+	      "\t-d|--detail          Show details of the flag/fields (default)\n"
+	      "\t-f|--flags           Specify the CPUID CSV file\n"
+	      "\t-h|--help            Show usage info\n"
+	      "\t-l|--leaf=index      Specify the leaf you want to check\n"
+	      "\t-r|--raw             Show raw CPUID data\n"
+	      "\t-s|--subleaf=sub     Specify the subleaf you want to check"
 	);
 }
 
@@ -643,7 +642,7 @@ static int parse_options(int argc, char *argv[])
 			user_sub = strtoul(optarg, NULL, 0);
 			break;
 		default:
-			printf("%s: Invalid option '%c'\n", argv[0], optopt);
+			warnx("Invalid option '%c'", optopt);
 			return -1;
 	}
 
-- 
2.39.5



