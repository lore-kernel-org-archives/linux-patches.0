Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FD643DA3C;
	Tue, 16 Jun 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623150; cv=none; b=VsdoR7clqn7ytuKddWYlxDlrAj37Hw+zU71MwN1MFaZ4V/ooAkuXeuoO7nxb+57klReB5cAGXf7NW1EolOI4fcO4pPKqBTgP78p/hdQQ5YWudTAhhlPB/GNJECYVuTolicGrNlOunWBLTWtIQzuMkbvGgj/AD+GII6MymDIBoLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623150; c=relaxed/simple;
	bh=wA8FVcVmbQGFOlNWDBg9rUmvC8sNOLRRgKT3hy1B15Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3PWBYLJwO/1Io9mzwGOWaQAaWmBwgQVrGKaugw4KhqAzjIDWmFdsMi/+FnRA9RWfZm4/GjQ/7UPbQkODvyVO4RVC1mEv63bpI0kzRQ2bEH1R5VTk8W11TD5APIwsizgvkrSRzcPyqHPtFzKS9htf1xfDb+ebrv/h0T+roAR2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoRHoZ2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoRHoZ2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952451F00A3A;
	Tue, 16 Jun 2026 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623149;
	bh=6Vjs3TFUVp/WjwDX45cBawOFKnVV49PDQ2WfrMCQbrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoRHoZ2WSWuU9ujfzJ+0WGI+CuSX3+sVgUTIWWDOkB+qN0Z9QsQF/adzCgK1Y6wcU
	 R3YenvicxsVQXtBqj8/OLzwEBJPKrTO0q2DqmukJwA0688wFzqH8h53um+LHluWl5t
	 rqT3zmrYT1OhE9BowfTVZay0o6a80/+o+uqMIbzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 096/378] riscv/ptrace: Use USER_REGSET_NOTE_TYPE for REGSET_CFI
Date: Tue, 16 Jun 2026 20:25:27 +0530
Message-ID: <20260616145115.346808449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

[ Upstream commit e3573f739e3dadab57ec80488d07e05c8f6e82d3 ]

Fixes a warning while dumping core:

[54983.546369][    C7] WARNING: [!note_name] fs/binfmt_elf.c:1771 at elf_core_dump+0x910/0xf68, CPU#7: abort01/31982

Fixes: 2af7c9cf021c ("riscv/ptrace: expose riscv CFI status and state via ptrace and in core files")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Link: https://patch.msgid.link/87y0hcxuh5.fsf@igel.home
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 793bcee4618282..f336a183667eb8 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -413,7 +413,7 @@ static struct user_regset riscv_user_regset[] __ro_after_init = {
 #endif
 #ifdef CONFIG_RISCV_USER_CFI
 	[REGSET_CFI] = {
-		.core_note_type = NT_RISCV_USER_CFI,
+		USER_REGSET_NOTE_TYPE(RISCV_USER_CFI),
 		.align = sizeof(__u64),
 		.n = sizeof(struct user_cfi_state) / sizeof(__u64),
 		.size = sizeof(__u64),
-- 
2.53.0



