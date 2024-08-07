Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321BA23CE;
	Wed,  7 Aug 2024 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042899; cv=none; b=IsYegWN0e14JQjT4N5wsfsAHUZjnFjQJNfy9rN5C72RTddm6RkBBxM66qEEC6WEC174rLhV3+VEN+ApD7iUUzvdxPFzz/NMeh/nSkwjTIf/96wpBeyKChj6DHrWVtPv22/9isS9ESibqitZkCjIBQsAxqwFGG1SknvT/8mgHUh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042899; c=relaxed/simple;
	bh=jauIStteZciu4lpsq+K9VqY4qb98gEvzTVw0JXLVVS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfkGRLME8bxz9vkIEalcclg3a8plefZuthXzYXh14TrAG+cC73XAudmO1mXR9hVZhFIjqYVV2PYc7REbMROc35OJQt0gIexYnxkvhvZLKzpOvvM9nUxDC5jUU/xmnsmFQNkqN1QFiCHNacSjcCTBgNOouAV2wlInYL6emjg8gZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Du9DnMMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Du9DnMMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE980C32781;
	Wed,  7 Aug 2024 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042899;
	bh=jauIStteZciu4lpsq+K9VqY4qb98gEvzTVw0JXLVVS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Du9DnMMoyzl7AARcdTEP07WxsO9A1FBMBYUkVgF1M1vF/FrZu3vQSpeaR53mBXhwQ
	 GR88dj6Fi7p91/nDWiuR9nSx85tJ2UOtSNDJS0L1Iro0vDPZKNLoQT2ecHont68jRi
	 jlEiuFscjtQKj7r49Vu0V+vbWETruFppDtu+uxdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 017/123] ARM: 9408/1: mm: CFI: Fix some erroneous reset prototypes
Date: Wed,  7 Aug 2024 16:58:56 +0200
Message-ID: <20240807150021.377866004@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 657a292d679ae3a6c733ab0e939e24ae44b20faf ]

I somehow got a few cpu_nn_reset() signatures wrong in my
patch. Fix it up.

Closes: https://lore.kernel.org/oe-kbuild-all/202406260432.6WGV2jCk-lkp@intel.com/

Fixes: 393999fa9627 ("ARM: 9389/2: mm: Define prototypes for all per-processor calls")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/proc.c b/arch/arm/mm/proc.c
index bdbbf65d1b366..2027845efefb6 100644
--- a/arch/arm/mm/proc.c
+++ b/arch/arm/mm/proc.c
@@ -17,7 +17,7 @@ void cpu_arm7tdmi_proc_init(void);
 __ADDRESSABLE(cpu_arm7tdmi_proc_init);
 void cpu_arm7tdmi_proc_fin(void);
 __ADDRESSABLE(cpu_arm7tdmi_proc_fin);
-void cpu_arm7tdmi_reset(void);
+void cpu_arm7tdmi_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm7tdmi_reset);
 int cpu_arm7tdmi_do_idle(void);
 __ADDRESSABLE(cpu_arm7tdmi_do_idle);
@@ -32,7 +32,7 @@ void cpu_arm720_proc_init(void);
 __ADDRESSABLE(cpu_arm720_proc_init);
 void cpu_arm720_proc_fin(void);
 __ADDRESSABLE(cpu_arm720_proc_fin);
-void cpu_arm720_reset(void);
+void cpu_arm720_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm720_reset);
 int cpu_arm720_do_idle(void);
 __ADDRESSABLE(cpu_arm720_do_idle);
@@ -49,7 +49,7 @@ void cpu_arm740_proc_init(void);
 __ADDRESSABLE(cpu_arm740_proc_init);
 void cpu_arm740_proc_fin(void);
 __ADDRESSABLE(cpu_arm740_proc_fin);
-void cpu_arm740_reset(void);
+void cpu_arm740_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm740_reset);
 int cpu_arm740_do_idle(void);
 __ADDRESSABLE(cpu_arm740_do_idle);
@@ -64,7 +64,7 @@ void cpu_arm9tdmi_proc_init(void);
 __ADDRESSABLE(cpu_arm9tdmi_proc_init);
 void cpu_arm9tdmi_proc_fin(void);
 __ADDRESSABLE(cpu_arm9tdmi_proc_fin);
-void cpu_arm9tdmi_reset(void);
+void cpu_arm9tdmi_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm9tdmi_reset);
 int cpu_arm9tdmi_do_idle(void);
 __ADDRESSABLE(cpu_arm9tdmi_do_idle);
@@ -79,7 +79,7 @@ void cpu_arm920_proc_init(void);
 __ADDRESSABLE(cpu_arm920_proc_init);
 void cpu_arm920_proc_fin(void);
 __ADDRESSABLE(cpu_arm920_proc_fin);
-void cpu_arm920_reset(void);
+void cpu_arm920_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm920_reset);
 int cpu_arm920_do_idle(void);
 __ADDRESSABLE(cpu_arm920_do_idle);
@@ -102,7 +102,7 @@ void cpu_arm922_proc_init(void);
 __ADDRESSABLE(cpu_arm922_proc_init);
 void cpu_arm922_proc_fin(void);
 __ADDRESSABLE(cpu_arm922_proc_fin);
-void cpu_arm922_reset(void);
+void cpu_arm922_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm922_reset);
 int cpu_arm922_do_idle(void);
 __ADDRESSABLE(cpu_arm922_do_idle);
@@ -119,7 +119,7 @@ void cpu_arm925_proc_init(void);
 __ADDRESSABLE(cpu_arm925_proc_init);
 void cpu_arm925_proc_fin(void);
 __ADDRESSABLE(cpu_arm925_proc_fin);
-void cpu_arm925_reset(void);
+void cpu_arm925_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm925_reset);
 int cpu_arm925_do_idle(void);
 __ADDRESSABLE(cpu_arm925_do_idle);
@@ -159,7 +159,7 @@ void cpu_arm940_proc_init(void);
 __ADDRESSABLE(cpu_arm940_proc_init);
 void cpu_arm940_proc_fin(void);
 __ADDRESSABLE(cpu_arm940_proc_fin);
-void cpu_arm940_reset(void);
+void cpu_arm940_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm940_reset);
 int cpu_arm940_do_idle(void);
 __ADDRESSABLE(cpu_arm940_do_idle);
@@ -174,7 +174,7 @@ void cpu_arm946_proc_init(void);
 __ADDRESSABLE(cpu_arm946_proc_init);
 void cpu_arm946_proc_fin(void);
 __ADDRESSABLE(cpu_arm946_proc_fin);
-void cpu_arm946_reset(void);
+void cpu_arm946_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_arm946_reset);
 int cpu_arm946_do_idle(void);
 __ADDRESSABLE(cpu_arm946_do_idle);
@@ -429,7 +429,7 @@ void cpu_v7_proc_init(void);
 __ADDRESSABLE(cpu_v7_proc_init);
 void cpu_v7_proc_fin(void);
 __ADDRESSABLE(cpu_v7_proc_fin);
-void cpu_v7_reset(void);
+void cpu_v7_reset(unsigned long addr, bool hvc);
 __ADDRESSABLE(cpu_v7_reset);
 int cpu_v7_do_idle(void);
 __ADDRESSABLE(cpu_v7_do_idle);
-- 
2.43.0



