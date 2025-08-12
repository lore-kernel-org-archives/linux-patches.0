Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A46188715;
	Tue, 12 Aug 2025 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023382; cv=none; b=hb/jF4NXud/HCJ/TF37wCvf9gAyGJCCsOOMFofnCl911Ol1L+2Kn3SQli/H1Zsmn+TZG/Prr0Kf1vxmuegiJmFqDs5Gk0tih0pDP+nTL4WUKGPX2ko32dkgtsjpwe/cuDP5tg5RgrRNOBj5bt1o4WoCCSHyhDmHOjIjufltD6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023382; c=relaxed/simple;
	bh=1liWup676ECM/WZDdh3a+Vdrw7a4RY3ElJ8/gGGNabE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du4nx1dPZOx4glKc6J8niYuUMHTl5cKlrjydzX/223rtcDsN+fC1OyHuXzahZYtRXAJK5vv700DPMc229cchSegdVZHJ5O7MJSEw00GlM4MK4urW7IGj2sMO9kYthIAr7chNvQ73uMW/+8GU5F6/0GS1W3p+5RHdHPN5LlWYL1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAYGYs1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAYGYs1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D7C4CEF0;
	Tue, 12 Aug 2025 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023382;
	bh=1liWup676ECM/WZDdh3a+Vdrw7a4RY3ElJ8/gGGNabE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAYGYs1/0WIWgxWYJqKPrDnMHgiPly9d8TrcZSEgOu/DqH6SNDPzlrMvLPpvv7UyY
	 Q3B/b/EpyURayKAEr87YbRF3SZRDG6/NXq5U+SUslczLmHkxJRpFGPEqvFJz8me1EP
	 BF6BxYwYYQUQwP9rnPhTAifQUmhxcZp8a/tk1ecY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Youling Tang <tangyouling@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 030/627] sched/task_stack: Add missing const qualifier to end_of_stack()
Date: Tue, 12 Aug 2025 19:25:25 +0200
Message-ID: <20250812173420.473831323@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 32e42ab9fc88a884435c27527a433f61c4d2b61b ]

Add missing const qualifier to the non-CONFIG_THREAD_INFO_IN_TASK
version of end_of_stack() to match the CONFIG_THREAD_INFO_IN_TASK
version. Fixes a warning with CONFIG_KSTACK_ERASE=y on archs that don't
select THREAD_INFO_IN_TASK (such as LoongArch):

  error: passing 'const struct task_struct *' to parameter of type 'struct task_struct *' discards qualifiers

The stackleak_task_low_bound() function correctly uses a const task
parameter, but the legacy end_of_stack() prototype didn't like that.

Build tested on loongarch (with CONFIG_KSTACK_ERASE=y) and m68k
(with CONFIG_DEBUG_STACK_USAGE=y).

Fixes: a45728fd4120 ("LoongArch: Enable HAVE_ARCH_STACKLEAK")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20250726004313.GA3650901@ax162
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task_stack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 85c5a6392e02..1fab7e9043a3 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -53,7 +53,7 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
  * When the stack grows up, this is the highest address.
  * Beyond that position, we corrupt data on the next page.
  */
-static inline unsigned long *end_of_stack(struct task_struct *p)
+static inline unsigned long *end_of_stack(const struct task_struct *p)
 {
 #ifdef CONFIG_STACK_GROWSUP
 	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
-- 
2.39.5



