Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EC943BDC0;
	Sat, 12 Sep 2026 08:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202735; cv=none; b=XK/3iQs3cybDpMYD0vae82jCKRq25H+3XUmAtMZJFvoxBvAWH1pah70cky+gXPjDdFyTx1wCCU7GAu0Lp84UQ4VFVvM4NxZW8DSPpBJet2M0rT2IjBEcwPlL0t4J3iKKCppdagaUGk0CekkL48jAqn3h6OtVjzjCk3gkHBUQKKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202735; c=relaxed/simple;
	bh=DYQmoHUubZFRKtjZMlZ8ygpWz7frcYsjviZJFMpTpqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F87Er+/onfGrg/4hITd6JnTMUttWkVI1WsNM50LqcG7/xa2o9wDIeewhPDwjlNEAkOZkB3g4G/qdoUwe+aWqUSTWu6iH61GaELHTH6g2RaDFFoFIFJLplHWa2d9I5unRBKyjids3Q6y9x1VRY3hdHw7Qy8QJHi0NT3wTThM8QiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX7cz45G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX7cz45G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62251F000FF;
	Sat, 12 Sep 2026 08:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202733;
	bh=XeZIhLzt9iVox03f01TwzZFWRDpiRxl/nVQqBQMvAAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xX7cz45GKD1p8se9mo6Zv7mstHVnNsEsk4bQcqbsMgjLnrM/Ksa4s2asBLAc7PUNP
	 SVN80WB28/0uSiGqltwkw/nH731FlTf8PAG273NKnLQwUNSAwHPkeqmWPyJSLEUcln
	 hHAG69L4EYmeEvcCfjgZ2znglk29hxELz6HDL0D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Guodong Xu <guodong@riscstar.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1263/1815] riscv: cpufeature: Clarify ISA spec version for canonical order
Date: Sat, 12 Sep 2026 08:50:13 +0200
Message-ID: <20260912065718.666926579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guodong Xu <guodong@riscstar.com>

[ Upstream commit fdef048705daa3d4ed1fa212ee071bcbdac02d80 ]

Specify that chapter 27 refers to version 20191213 of the RISC-V ISA
Unprivileged Architecture. The chapter numbering differs across
specification versions - for example, in version 20250508, the ISA
Extension Naming Conventions is chapter 36, not chapter 27.

Historical versions of the RISC-V specification can be found via Link [1].

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://riscv.org/specifications/ratified/ [1]
Fixes: 99e2266f2460 ("RISC-V: clarify ISA string ordering rules in cpu.c")
Signed-off-by: Guodong Xu <guodong@riscstar.com>
Link: https://patch.msgid.link/20260125-supm-ext-id-v2-3-1e3b9714c860@riscstar.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index f46aa5602d74d..64c7ec6abbf1f 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -452,7 +452,8 @@ static const unsigned int riscv_c_exts[] = {
 
 /*
  * The canonical order of ISA extension names in the ISA string is defined in
- * chapter 27 of the unprivileged specification.
+ * Chapter 27 of the RISC-V Instruction Set Manual Volume I Unprivileged ISA
+ * (Document Version 20191213).
  *
  * Ordinarily, for in-kernel data structures, this order is unimportant but
  * isa_ext_arr defines the order of the ISA string in /proc/cpuinfo.
-- 
2.53.0



