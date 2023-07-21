Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11F1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D3CC433C9;
	Fri, 21 Jul 2023 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956229;
	bh=8uMn/SSxlgCFLWYzj5tSX5VX8LgxLYbJxe4XVxhE8cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3MBMY04nThkgVcTA+oNkcITvQEwGWz0FoRLyfxfaQ2k9DK2YMVMQxQHNV/+uoyb4
	 WWnfoEYVoXnYYzB7RqEf00f0HV4vXm76c+lS/F5IZ7TPbbZn0mcWwNkwpO4FItUA1R
	 hw5U5/xGZTP5Iwpzp66U6e9z0wDVkG4MEc4TAjZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.4 146/292] MIPS: cpu-features: Use boot_cpu_type for CPU type based features
Date: Fri, 21 Jul 2023 18:04:15 +0200
Message-ID: <20230721160535.160017716@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 5487a7b60695a92cf998350e4beac17144c91fcd upstream.

Some CPU feature macros were using current_cpu_type to mark feature
availability.

However current_cpu_type will use smp_processor_id, which is prohibited
under preemptable context.

Since those features are all uniform on all CPUs in a SMP system, use
boot_cpu_type instead of current_cpu_type to fix preemptable kernel.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/cpu-features.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -125,7 +125,7 @@
 ({									\
 	int __res;							\
 									\
-	switch (current_cpu_type()) {					\
+	switch (boot_cpu_type()) {					\
 	case CPU_CAVIUM_OCTEON:						\
 	case CPU_CAVIUM_OCTEON_PLUS:					\
 	case CPU_CAVIUM_OCTEON2:					\
@@ -368,7 +368,7 @@
 ({									\
 	int __res;							\
 									\
-	switch (current_cpu_type()) {					\
+	switch (boot_cpu_type()) {					\
 	case CPU_M14KC:							\
 	case CPU_74K:							\
 	case CPU_1074K:							\


