Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061920;
	b=jg8FfnqqJhpYQOITGOw21Qa8Zb/9/ZBSP5me/VMLpyRYJLU7XlU9UUpNjamjT+W853+R
	 X4U0QOBMDNuL8CmsZTTgswq51O79kAsNGBUBq/dtwKFEBdXzEapo7eYQHUxJeUjqUEdGb
	 HoFlxPOjuFrhREIdRkLUROsKaQxxyVvs3eFquY6ImhCFau76ENFo63ZnLlX/RtUDFla/q
	 x9fINUKZ9ktc+BK70HG6GuHHoxheY1aogqIJ4D8v1kX8sZ2tT9lGrWe4stmZY/Jnvf8SE
	 DBVsMJXmFwUqnLF2nWzZfK+fnfaHxmkISIvkRR81MnTCad8bm4suJa81nKlctW4Pa+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5XBCPDRMkm3B10338hw4B3ZSxynUafxJy3fB0sk/wQ=;
	b=Ud7wNziKu29vUIY/vWDYc33PEtj0bgEpZR7c4DsApzcDmOdkZ6N1cPgVnyh1+AnlMpwr
	 8SURV212G8Q7y6PWmef5mZtMgkKT7BV/MR/yV2jrG+doiT/bYhDyaQaeErrdyqJj+EwXZ
	 oua3X9+qbdRn+kwv9qb0cxjb15Wczhw/HLagzujbeBxUMbG+5mUKxfSGvbAYCN5SHF1TS
	 /HBNwAY8P1/jnF1ZRfd2LjKOSlAGwZfjZzsdWQo/MZ6IYqXd24gazRQNOV7B+i4m08aYq
	 AbRRRbLk8TjEOTz7XsArHr50NAgs74zrVt4BJNTHrxJR51jzpmg6QbeIQet3pYJSIbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTGo3IQr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CB3606A325;
	Thu, 19 Nov 2026 04:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTGo3IQr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469CF1F000C4;
	Thu, 19 Nov 2026 04:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061919;
	bh=t5XBCPDRMkm3B10338hw4B3ZSxynUafxJy3fB0sk/wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTGo3IQrmr13OPlv/2Y64MAR8ec1uML1+3BDYurgqPStXeQ6+q62ZZEy861gmxzMY
	 nlRC6zRtp9n9ABkZbTuEqdauaiRH2tfq5FzqFhHNvQs4KS3uvEWXcERfiU+HG7adXB
	 mG/Z4hped9q8mVS5JDukdgXi1jMLIdQRIwVt2tiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Robert Richter <rric@kernel.org>,
	Vineet Gupta <vgupta@synopsys.com>,
	William Cohen <wcohen@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1688/1848] arch: arc: Remove CONFIG_OPROFILE support
Date: Wed, 18 Nov 2026 16:02:06 +0100
Message-ID: <20261118150030.454611808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 993b832fda6ad4f350dcc4440113ba95c05621ae ]

The "oprofile" user-space tools don't use the kernel OPROFILE support
any more, and haven't in a long time. User-space has been converted to
the perf interfaces.

Remove the old oprofile's architecture specific support.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Robert Richter <rric@kernel.org>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: William Cohen <wcohen@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Stable-dep-of: ca201ad6e92a ("ARC: Strip libgcc debug information when generating BTF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Kconfig           |  1 -
 arch/arc/Makefile          |  2 --
 arch/arc/oprofile/Makefile | 10 ----------
 arch/arc/oprofile/common.c | 23 -----------------------
 4 files changed, 36 deletions(-)
 delete mode 100644 arch/arc/oprofile/Makefile
 delete mode 100644 arch/arc/oprofile/common.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 0a89cc9def651..7f4feaabc104b 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -38,7 +38,6 @@ config ARC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select HANDLE_DOMAIN_IRQ
 	select IRQ_DOMAIN
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 18f4b24520747..9681534ad7b39 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -96,8 +96,6 @@ core-$(CONFIG_ARC_PLAT_TB10X)	+= arch/arc/plat-tb10x/
 core-$(CONFIG_ARC_PLAT_AXS10X)	+= arch/arc/plat-axs10x/
 core-$(CONFIG_ARC_SOC_HSDK)	+= arch/arc/plat-hsdk/
 
-drivers-$(CONFIG_OPROFILE)	+= arch/arc/oprofile/
-
 libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
diff --git a/arch/arc/oprofile/Makefile b/arch/arc/oprofile/Makefile
deleted file mode 100644
index 698367bb41d03..0000000000000
--- a/arch/arc/oprofile/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_OPROFILE) += oprofile.o
-
-DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
-		oprof.o cpu_buffer.o buffer_sync.o \
-		event_buffer.o oprofile_files.o \
-		oprofilefs.o oprofile_stats.o \
-		timer_int.o )
-
-oprofile-y	:= $(DRIVER_OBJS) common.o
diff --git a/arch/arc/oprofile/common.c b/arch/arc/oprofile/common.c
deleted file mode 100644
index 86bf5899533b7..0000000000000
--- a/arch/arc/oprofile/common.c
+++ /dev/null
@@ -1,23 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * Based on orig code from @author John Levon <levon@movementarian.org>
- */
-
-#include <linux/oprofile.h>
-#include <linux/perf_event.h>
-
-int __init oprofile_arch_init(struct oprofile_operations *ops)
-{
-	/*
-	 * A failure here, forces oprofile core to switch to Timer based PC
-	 * sampling, which will happen if say perf is not enabled/available
-	 */
-	return oprofile_perf_init(ops);
-}
-
-void oprofile_arch_exit(void)
-{
-	oprofile_perf_exit();
-}
-- 
2.53.0



