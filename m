Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E82EBDD5;
	Tue, 17 Jun 2025 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174124; cv=none; b=Sr+Tr0ZmcnfSOfxM+axhEde9VhSYxVQ/YOWhJOHxRa9EDBjccQH69rHRzvKQPIFcVbmXppCxyeYHWAkVJ9XLXqLVuhMnAZNeIZJ1qQKN/WIV4Ksvf0x1SEcQds2msHfdEf8eaGkllVvWefGGuwVqeKfSQvQNt9QFllU8rMKufFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174124; c=relaxed/simple;
	bh=/jvQxfu1UTn4FiyDBLEt6XjLQ49x/Fl8ikF34UHW1KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMmjfFpOVjOsHm7y11Z22+Lc3qdYTox/VLfvnWreFPq1BHRT/uK4q8KrAWTvIsgAi7DKwnLY29t7uw81MBAiu1FMrsOg7z1j473K5Q5guWMHJN/KIQjpxBdlVqbtARvkbMeJ1hOR2lTqFT6LrcjT1QyMejAhISQF+8MPeUGjPCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRgA4fg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRgA4fg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EF4C4CEE3;
	Tue, 17 Jun 2025 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174124;
	bh=/jvQxfu1UTn4FiyDBLEt6XjLQ49x/Fl8ikF34UHW1KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRgA4fg0JnAfsTasaet9vj3wpdcpA9JHCaKMkLpyvy/OCvdrnQVKoQ6oLhd91FTrW
	 BCZYGBKrtrZ6wZJeseSHIFNQ6GK7yDdVoEf3EQ1p2zeGq9SgOpsZIJVd4LIvVasFaO
	 hvP+9/os4gq3JSSV7Heh+t0Vm4ZJ3e+lUqlh3bQU=
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
Subject: [PATCH 6.12 001/512] tools/x86/kcpuid: Fix error handling
Date: Tue, 17 Jun 2025 17:19:27 +0200
Message-ID: <20250617152419.583775991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b25c0a95d3f9..40a9e59c2fd56 100644
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
@@ -145,14 +146,14 @@ static bool cpuid_store(struct cpuid_range *range, u32 f, int subleaf,
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
@@ -211,7 +212,7 @@ struct cpuid_range *setup_cpuid_range(u32 input_eax)
 
 	range = malloc(sizeof(struct cpuid_range));
 	if (!range)
-		perror("malloc range");
+		err(EXIT_FAILURE, NULL);
 
 	if (input_eax & 0x80000000)
 		range->is_ext = true;
@@ -220,7 +221,7 @@ struct cpuid_range *setup_cpuid_range(u32 input_eax)
 
 	range->funcs = malloc(sizeof(struct cpuid_func) * idx_func);
 	if (!range->funcs)
-		perror("malloc range->funcs");
+		err(EXIT_FAILURE, NULL);
 
 	range->nr = idx_func;
 	memset(range->funcs, 0, sizeof(struct cpuid_func) * idx_func);
@@ -395,8 +396,8 @@ static int parse_line(char *line)
 	return 0;
 
 err_exit:
-	printf("Warning: wrong line format:\n");
-	printf("\tline[%d]: %s\n", flines, line);
+	warnx("Wrong line format:\n"
+	      "\tline[%d]: %s", flines, line);
 	return -1;
 }
 
@@ -418,10 +419,8 @@ static void parse_text(void)
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
@@ -530,7 +529,7 @@ static inline struct cpuid_func *index_to_func(u32 index)
 	func_idx = index & 0xffff;
 
 	if ((func_idx + 1) > (u32)range->nr) {
-		printf("ERR: invalid input index (0x%x)\n", index);
+		warnx("Invalid input index (0x%x)", index);
 		return NULL;
 	}
 	return &range->funcs[func_idx];
@@ -562,7 +561,7 @@ static void show_info(void)
 				return;
 			}
 
-			printf("ERR: invalid input subleaf (0x%x)\n", user_sub);
+			warnx("Invalid input subleaf (0x%x)", user_sub);
 		}
 
 		show_func(func);
@@ -593,15 +592,15 @@ static void setup_platform_cpuid(void)
 
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
 
@@ -652,7 +651,7 @@ static int parse_options(int argc, char *argv[])
 			user_sub = strtoul(optarg, NULL, 0);
 			break;
 		default:
-			printf("%s: Invalid option '%c'\n", argv[0], optopt);
+			warnx("Invalid option '%c'", optopt);
 			return -1;
 	}
 
-- 
2.39.5



