Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38091DE8AE;
	Sun,  7 Jun 2026 10:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826974; cv=none; b=sTGZLEmwR4n1Ws6AsXxoZL1X8Ng+fbrFXyBemIsJqEFjPCe18yNBbfANi/XkgXK5H59WTKwPIuBOhFjXxgrZazkeTBPqSvOJNO0/HmDHxPVL4qkiD7Dvq+nyYb7xVatfgxGTLpeaz2Wrj2ZBStkf2IYrHejtWeWOptkSJ4NiRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826974; c=relaxed/simple;
	bh=wFXhYxzBWJI86gwiAKUYFE5Et48Qho5yVeeChHaZEkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP3tcBVx5CFa+8+Rp0YY2dMkDcEMfONc5P1umqdd8eSP79PiWTXLLiZW2IhRrEKn/d89BAmYD4+xOQUlVyHJu8bwaNKrn2y/V/SfF/HvKH9dMy301lylllbJdSGz5y4owu1yZe8H8Q/8++OzuE0qS7q8UHwZN8gBxUHb52vSyJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEufEN4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEufEN4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483D21F00893;
	Sun,  7 Jun 2026 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826973;
	bh=8w1Eo1SuDxehnGg2d8Ov2CpW6ed5O7b1PS1ftqeM4Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEufEN4W67pGZCdH9RNqAl3JcNI4Doob4g5vvlW2xCiAMFF0Qs+6Wr/Xs9OdojlaV
	 M5emtuS7Z1w9bn8zB2AzSY8iDZVWz5B3HDH+C+1bkjk40RYYXUmiSoZqs7VkKOCjTA
	 yiev14mBp4emrAYTHBC3OHAkOVTC28YTFoav/3xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/307] arm64: debug: clean up single_step_handler logic
Date: Sun,  7 Jun 2026 11:56:48 +0200
Message-ID: <20260607095728.047675023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit ad8b22648b7d0bc6f84230508436b1aafc2e2516 ]

Remove the unnecessary boolean which always checks if the handler was found
and return early instead.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250707114109.35672-2-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/debug-monitors.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 024a7b245056a8..b7a2155bca42b1 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -241,8 +241,6 @@ static void send_user_sigtrap(int si_code)
 static int single_step_handler(unsigned long unused, unsigned long esr,
 			       struct pt_regs *regs)
 {
-	bool handler_found = false;
-
 	/*
 	 * If we are stepping a pending breakpoint, call the hw_breakpoint
 	 * handler first.
@@ -250,10 +248,10 @@ static int single_step_handler(unsigned long unused, unsigned long esr,
 	if (!reinstall_suspended_bps(regs))
 		return 0;
 
-	if (!handler_found && call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
-		handler_found = true;
+	if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
+		return 0;
 
-	if (!handler_found && user_mode(regs)) {
+	if (user_mode(regs)) {
 		send_user_sigtrap(TRAP_TRACE);
 
 		/*
@@ -263,7 +261,7 @@ static int single_step_handler(unsigned long unused, unsigned long esr,
 		 * to the active-not-pending state).
 		 */
 		user_rewind_single_step(current);
-	} else if (!handler_found) {
+	} else {
 		pr_warn("Unexpected kernel single-step exception at EL1\n");
 		/*
 		 * Re-enable stepping since we know that we will be
-- 
2.53.0



