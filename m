Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84F31E3772;
	Thu, 30 Jan 2025 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246817; cv=none; b=pcexwxkGb9Y48hdD9DXjqR8yCSCvRjTP08thDX7aoOUb8MTLrn3kRYZt/qypvz7nJRslAqaAN1ml1Yxz9JuEYjvEFUDrjGwauMdTQLlKMMsD+1zX/JpGwW/AVmtftwHJCBIu6SvPHruAhtflYBkBEk6Fh+EivU9unUjRb9fMmQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246817; c=relaxed/simple;
	bh=zm+cr5IID31BnPhK1tLgxsAygKLxf7uI5Pc8HA9ZblE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhR5IGhJTD2apwAE3Vberd9nSQTL+tuL/gcM1Ykg7vDoWAMA3bAOHBIpZ/aoFnvJsTQMgkcAgP8kqzZ62Qfvmc1vs4J2OC48/74VUdIUdlvJl6WIN4OsN5kYL4Pvhu/LcjQjlgL22UzW6hj5RexM0eTQVLaY9isCQ9/dNeVRNAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3lKiu3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3lKiu3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5188AC4CED2;
	Thu, 30 Jan 2025 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246817;
	bh=zm+cr5IID31BnPhK1tLgxsAygKLxf7uI5Pc8HA9ZblE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3lKiu3NkJHmmDP4X5yPAxm58UXZbR+N6Fyx646plJoaUzb2GlLycpfFmyQFwf2R7
	 yVb/5SzfkXKjRZ9s7Dj5Ik/abCacAEFN3MyPx9Bb0bvzbQc6zi9w0nVn8g1BDs9Hp2
	 UZtakgHqN5Qco8HpctHzLn2RkYfk53M4CzhhJlJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rouven Czerwinski <rouven@czerwinskis.de>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/91] riscv: remove unused handle_exception symbol
Date: Thu, 30 Jan 2025 15:01:07 +0100
Message-ID: <20250130140135.594803763@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rouven Czerwinski <rouven@czerwinskis.de>

[ Upstream commit beaf5ae15a13d835a01e30c282c8325ce0f1eb7e ]

Since commit 79b1feba5455 ("RISC-V: Setup exception vector early")
exception vectors are setup early and the handle_exception symbol from
the asm files is no longer referenced in traps.c. Remove it.

Signed-off-by: Rouven Czerwinski <rouven@czerwinskis.de>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 6a97f4118ac0 ("riscv: Fix sleeping in invalid context in die()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 030094ac7190..184f7b82c5ae 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -23,8 +23,6 @@
 
 int show_unhandled_signals = 1;
 
-extern asmlinkage void handle_exception(void);
-
 static DEFINE_SPINLOCK(die_lock);
 
 void die(struct pt_regs *regs, const char *str)
-- 
2.39.5



