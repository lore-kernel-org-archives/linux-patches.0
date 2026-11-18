Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019890;
	b=Dw+wJDE1K78GLnpE6eGy3ttIuYHSAa5qKG+Ixq1HUiaiFxwNNksLCUOBPB2jCHQeZQCI
	 WQEfp597gZ0d3KvYGBjixbZwLE/WD/AQiW8jG9ND/zI79xskhJlC6nQu2lZgurc2+88iq
	 JR26iesFqs6ko5urwxzD8dy9VHxa7gboRzQctlJFxC5/B4CIYaImIvtApwLusFO3DtnNB
	 k2A9aQZ/JTP8temJiF+xCU1YS9Qk/BBimI3Z9rK95B0t/4YMHp4VWy4L1ZSRgTBWaMGeA
	 EIK3Mk1Ps4VWakSvWsrlxmQkltPIZaGEEDG5YNYd4gtGP72AyLXCTb4W6sz8Hq1OZ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WGzLsBLA0hpDVAsw18VIG5qMdBxvEBxZ1k9927SnvvQ=;
	b=icMoqiRit2I7Ygg4MFbKuvV/rR+hGNrZr+rUIv9D19KEoWuMFgsofP6pHlML4oTyBpvQ
	 v9u4Rotg+uiDdUn42RbF5IO3ToXuxRt/TG6FxRAqfjgh7Rae+rY2lLLFijepC7zvBDL32
	 J3yWT6wJEMZYrZxjRJzOCNivxmClQ4p/Ih4Zrw8ifN6RB1Tw0ESndLXl1iNno6XiuGog5
	 iMo8oW0J2PpsCB3jvuC++xdRDBMwniBybGYI6eYhbyCLB4BtjU3+k7YHjmGKbDNXNHFGc
	 ejhWxdnzcKpWUrTKJvRZb1LR6dHSkEBUUzItsiaTvgAagFezJtD1J5+QY7jvaEqQgtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1IgDh6l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCC0606A31C;
	Wed, 18 Nov 2026 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1IgDh6l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132521F000C9;
	Wed, 18 Nov 2026 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019889;
	bh=WGzLsBLA0hpDVAsw18VIG5qMdBxvEBxZ1k9927SnvvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1IgDh6l9YzEwr86VBDZyjAjuBqQcD/alvZlQic9SGl7JgpA6aut6pREkJnzjiisP
	 sLgV8bnTmLifk7p7yTWLf/AV6+cn4gFyePH5VO+YrdcucsEbIADscgIAM8mh+zsgNI
	 Fp00hXOOayU4ZIjNgwZ7LhjcMcTrp3e+l7pZAGMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1757/2651] s390/early: Fix early warning handling
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118150350.724138165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 646dc01d634bc182529d7cd5f5346869aa7d58ee ]

When adding support for __WARN_printf() the early program check handler was
not taken into account. Add the missing support to the early program check
handler. This avoids that the kernel crashes instead of printing a warning.

Fixes: 04dabb4261c3 ("s390/bug: Implement __WARN_printf()")
Fixes: 79996065cfa2 ("s390/bug: Skip __WARN_trap() in call traces")
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index b27239c03d799..1fc153d8385bb 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -153,16 +153,25 @@ static __init void setup_topology(void)
 void __init __do_early_pgm_check(struct pt_regs *regs)
 {
 	struct lowcore *lc = get_lowcore();
-	unsigned long ip;
 
 	regs->int_code = lc->pgm_int_code;
 	regs->int_parm_long = lc->trans_exc_code;
 	regs->last_break = lc->pgm_last_break;
-	ip = __rewind_psw(regs->psw, regs->int_code >> 16);
+	regs->monitor_code = lc->monitor_code;
 
 	/* Monitor Event? Might be a warning */
 	if ((regs->int_code & PGM_INT_CODE_MASK) == 0x40) {
-		if (report_bug(ip, regs) == BUG_TRAP_TYPE_WARN)
+		enum bug_trap_type btt;
+		unsigned long ip;
+
+		if (regs->monitor_code == MONCODE_BUG_ARG) {
+			regs->psw.addr = regs->gprs[14];
+			btt = report_bug_entry((struct bug_entry *)regs->gprs[2], regs);
+		} else {
+			ip = __rewind_psw(regs->psw, regs->int_code >> 16);
+			btt = report_bug(ip, regs);
+		}
+		if (btt == BUG_TRAP_TYPE_WARN)
 			return;
 	}
 	if (fixup_exception(regs))
-- 
2.53.0



