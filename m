Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CCD155A30;
	Wed,  5 Feb 2025 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767950; cv=none; b=lDUZhLmCP1HCQ7ICzi1MgEGxTWoqVOneG51Gmx/MsRfhsYWNuJibsFJeBkaRu6X3zWP8cWeEGOD3EstFbSMjNtQhTJzA6dO7R7MrRmeCmsg6B9aT1TTvO5M4kAapP/nz9G6IbrgGk3+V8Vf4Ip5p8ncEdCTYQH/4o9BCksk7JLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767950; c=relaxed/simple;
	bh=2n/iQvDP+U807TrnpBAa2+JyCqqYz2PSoA8ePO4DFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqH4dC3CMFI0TYOC+rhmtRpZ3kSysdJfAY1DvGJ3MgHKF2ztLgCLT5yXN4pOT7CcSmvOqJ3gqhKwzoMnn41BlLXDA8mtG4Db/y9srWQEUWUf5o29KV+AsuYgGLNe6Up+UNqi3v73HydCXm0W7/zsVlzbljzj7z1XD/Cl5S9zxZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/gVQa/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/gVQa/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A170BC4CEE2;
	Wed,  5 Feb 2025 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767950;
	bh=2n/iQvDP+U807TrnpBAa2+JyCqqYz2PSoA8ePO4DFvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/gVQa/ni+wOnIexO0Qao9EqMH3M6t9Y+2iD5EDw4eQdivEogmYziyquYgcnWlJEi
	 MIiguEcyn8D2V/ZfPM/rWLrtLXFEvOMp6FZ4vTc7KmHnkMFR7/PUKpyJjbR5C1gJQ0
	 gD/7JPG1EBdRimQ1Y1iQ66kkPf0XdKj06PST01OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/590] RISC-V: Mark riscv_v_init() as __init
Date: Wed,  5 Feb 2025 14:44:40 +0100
Message-ID: <20250205134515.351238552@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit 9d87cf525fd2e1a5fcbbb40ee3df216d1d266c88 ]

This trips up with Xtheadvector enabled, but as far as I can tell it's
just been an issue since the original patchset.

Fixes: 7ca7a7b9b635 ("riscv: Add sysctl to set the default vector rule for new processes")
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20250115180251.31444-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 682b3feee4511..a30fb2fb8a2b1 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -309,7 +309,7 @@ static int __init riscv_v_sysctl_init(void)
 static int __init riscv_v_sysctl_init(void) { return 0; }
 #endif /* ! CONFIG_SYSCTL */
 
-static int riscv_v_init(void)
+static int __init riscv_v_init(void)
 {
 	return riscv_v_sysctl_init();
 }
-- 
2.39.5



