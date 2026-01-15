Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2963BF2F3;
	Thu, 15 Jan 2026 17:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498913; cv=none; b=nhBl8dDTVjBheN8N/unPcWRhFZU7rE36EcNSP+z/U4+Ohr2eHZerN7U+JdNrhgqJFwTpfaoykyTi5ngvnga1HGydQ3Gwb9PLLDxvKC5Onaiuyf49eVz4MUaQom+EZoUyGwQQwB9khHg2HVHu607oBz46nRxSYhlqj5F4bHTsV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498913; c=relaxed/simple;
	bh=LCN8wS7arpRyg+Cs49rm95IpLG8d3p24D3PsKcYzgI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1TURKQy0gStIZM0y6A/nJ4PhdelCfvt1GEyBrLASwpj5CZjRpYS89oYOj2+jfGAv4MowTS7rmjgI08llQRNtJsnYWqAN1TG9dQ+7sHiJa5jkiMiEOBVcgvg9Nbp/MZtFcYrofojYfhvgtJHBxICc5p0ifzCkI4/VcphiR71uA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enOUMd08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enOUMd08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC05C116D0;
	Thu, 15 Jan 2026 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498913;
	bh=LCN8wS7arpRyg+Cs49rm95IpLG8d3p24D3PsKcYzgI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enOUMd08uYm4sA4hzqMPlHlyLb+kkv/cNoAAvzVh8rfplUW0sg/HT2gpcKFrZ8rKw
	 cfCfgtkoHfWrVy6MAe6vaU5i72wQxniwCClnimjJz3JOAg4skoh0weCxP2w/Xlj3ko
	 F7gqbpwipndnl1XEPu18gilgrCl/Rc/bm8FZWBG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Borislav Petkov <bp@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/451] x86/dumpstack: Make show_trace_log_lvl() static
Date: Thu, 15 Jan 2026 17:44:03 +0100
Message-ID: <20260115164232.415699574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 09a217c10504bcaef911cf2af74e424338efe629 ]

show_trace_log_lvl() is not used by other compilation units so make it
static and remove the declaration from the header file.

Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201113133943.GA136221@rlk
Stable-dep-of: ced37e9ceae5 ("x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/stacktrace.h | 3 ---
 arch/x86/kernel/dumpstack.c       | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 49600643faba8..f248eb2ac2d4a 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -88,9 +88,6 @@ get_stack_pointer(struct task_struct *task, struct pt_regs *regs)
 	return (unsigned long *)task->thread.sp;
 }
 
-void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			unsigned long *stack, const char *log_lvl);
-
 /* The form of the top of the frame on the stack */
 struct stack_frame {
 	struct stack_frame *next_frame;
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index cf92191de2b2a..7a1fe0d382ce6 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -183,7 +183,7 @@ static void show_regs_if_on_stack(struct stack_info *info, struct pt_regs *regs,
 	}
 }
 
-void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 			unsigned long *stack, const char *log_lvl)
 {
 	struct unwind_state state;
-- 
2.51.0



