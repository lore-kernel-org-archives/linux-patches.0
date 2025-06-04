Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4484192D6B;
	Wed,  4 Jun 2025 00:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998400; cv=none; b=CQXflf63vR+RihwTB3ZVeWTYjVft9kMhR/C1zr4noqqrG3Zc/5xxT79hu0fpLIY7nCpFn7MauV1MzomnB0ZBOLFob6Zz61rSfh7qR045A0udp44NMr17u8hXX/9diN/wCpMBc9yKIXls6VhCoAHZrhNYMzRZn8WzZF4/EgbaT+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998400; c=relaxed/simple;
	bh=kNrTHjvKm2VWJs6SvCLmvxpTeN4B9WR3gAIli9ok2gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=peYwou0RhOcrLnDJTv0IHgfhAZJ2PPoI6MbLCPjPhsmMu89ArfKmuOSTGG09OXrUJyEe6epZtQ3/jykLtp32HKdRq9ZD+5fHZi5iS4GMWPYIM9D4SjliOoJHD02TjYHY8nRYR2cGMuhz2jldQI9eu1QHa37cCQNOfTrSaCs7YQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYAItiex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYAItiex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B87C4CEEF;
	Wed,  4 Jun 2025 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998400;
	bh=kNrTHjvKm2VWJs6SvCLmvxpTeN4B9WR3gAIli9ok2gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYAItiexPqGDqwK6VbIFS82BWKsS6Dt8uD3C/2mWci4/Wp5zMKZfvaRFfTBqK6oks
	 VAFTUpsYLITb0JQ0hlS7lvU/YxibuYrUNiPpXVVm0ild6PSY0yLUxQk4p1hqJaWj6r
	 okLhXIV/kCxj97OLDzHG/6Ua6FMZur9PItW57ho6ov6qbatR0I/9xgseMWTnveDEr9
	 xRXaA3oF+xdn/QQbnd+JSp+Jcw4grsnzw3wlMsgWo0bv/lGCRoIT2vhjeIJtoQcE32
	 eXB4HFaV8veTixG60pmskLrMeWixdKAWZ3m3hyTUdjMLCsW9np/mceXbHcMHrLN32v
	 fk1HlT+PtW+Rg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	tglozar@redhat.com,
	jstancek@redhat.com
Subject: [PATCH AUTOSEL 6.15 064/118] rtla: Define __NR_sched_setattr for LoongArch
Date: Tue,  3 Jun 2025 20:49:55 -0400
Message-Id: <20250604005049.4147522-64-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6a38c51a2557d4d50748818a858d507c250f3bee ]

When executing "make -C tools/tracing/rtla" on LoongArch, there exists
the following error:

  src/utils.c:237:24: error: '__NR_sched_setattr' undeclared

Just define __NR_sched_setattr for LoongArch if not exist.

Link: https://lore.kernel.org/20250422074917.25771-1-yangtiezhu@loongson.cn
Reported-by: Haiyong Sun <sunhaiyong@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and examination of the kernel source
tree, here is my assessment: **YES** This commit should be backported to
stable kernel trees for the following reasons: **1. Build Fix for
Supported Architecture**: This commit fixes a compilation error on
LoongArch architecture where `__NR_sched_setattr` is undeclared. The
error message shows: ``` src/utils.c:237:24: error: '__NR_sched_setattr'
undeclared ``` **2. Minimal and Safe Change**: The change adds just two
lines to define the syscall number for LoongArch: ```c # elif
__loongarch__ # define __NR_sched_setattr 274 ``` **3. Follows
Established Pattern**: From examining
`/home/sasha/linux/include/uapi/asm-generic/unistd.h`, I confirmed that
`__NR_sched_setattr` is indeed syscall number 274 in the generic syscall
table. LoongArch uses the generic syscall ABI (as evidenced by
`/home/sasha/linux/tools/arch/loongarch/include/uapi/asm/unistd.h`
including `asm-generic/unistd.h`), so using 274 is correct and
consistent. **4. Consistency with Similar Commits**: Looking at the
historical commits provided: - Similar Commit #5 (Status: NO) added
RISC-V support with the same syscall number 274 - Similar Commit #3
(Status: YES) was a build fix that removed unused functions - Similar
Commit #2 (Status: YES) fixed compilation issues with glibc The pattern
shows that build fixes for architecture support are typically backported
when they're minimal and safe. **5. Essential Functionality**: The rtla
tool is a real-time latency analysis tool that requires scheduler
attribute syscalls to function properly. Without this fix, the tool
cannot be built on LoongArch systems, making it completely unusable on
that architecture. **6. No Risk of Regression**: This change only
affects LoongArch builds and follows the exact same pattern used for
other architectures. It defines a constant that prevents compilation
failure without changing any runtime behavior. **7. Stable Tree Criteria
Met**: - Fixes an important build issue affecting users - Change is
minimal and contained - No architectural changes or new features -
Extremely low risk of regression - Follows established patterns The
commit perfectly fits the stable tree criteria for important bugfixes
with minimal risk.

 tools/tracing/rtla/src/utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 4995d35cf3ec6..d6ab15dcb4907 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -227,6 +227,8 @@ long parse_ns_duration(char *val)
 #  define __NR_sched_setattr	355
 # elif __s390x__
 #  define __NR_sched_setattr	345
+# elif __loongarch__
+#  define __NR_sched_setattr	274
 # endif
 #endif
 
-- 
2.39.5

