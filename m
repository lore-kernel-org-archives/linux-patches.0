Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE79231F9B7;
	Sat, 12 Sep 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225166; cv=none; b=mtWbtZ2x0OZlY7CZjxJFWLUeLQDpkg1woBhobR1oSDvlVVP2huV4LenAmxeZ4E+4h+lvT+Km17JwWEGJegj0rbbVFuRJLWlojOoeKggUKHcOdHN3vUs+MxMx47YC7EykKcA8AIrz6GlhAeAx2nYHnaSpjpLaB/e3JDNK8wKNRdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225166; c=relaxed/simple;
	bh=EswijadtP24GgCueTBZul/JN0UiaOVObL5c14z15z+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StgiNDJgEU+CVvYYEIO4t4Yul96hhsSvIIfX7ew4rN2/MGroayZ712ua3321tuj3l45GBYKqhvGx0MkIw7jfVBTak47L3SOnGlW67EmIi1u7BmdZPnSJz4KHg2oxJos8oEqfjPTgUIhVl3Mqtyhyu3fLKWGA5Zt1pU237XHl89s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3k+QxDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3k+QxDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6211F000FF;
	Sat, 12 Sep 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225164;
	bh=75B9mw4I1oGuo0Jngehau1KOA7TzDAZS4SvS2f8TuEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3k+QxDODvBq/qtetoR+UvgWgfcZJXsv5siVQqw2zMHjkSSkLqrnbZZSeZmvsFGk7
	 aDPWl9kbJCVAoGxB1d7bXPQV1rUsNDabwEbmxjWUFYodiq/DDPW+C5MEx0kpQr5m47
	 nwUNz6Mv9ZE1PPErFrkU+ejM40Bk0OvL3z2TJ5sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Guodong Xu <guodong@riscstar.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1135/1424] riscv: cpufeature: Clarify ISA spec version for canonical order
Date: Sat, 12 Sep 2026 08:59:27 +0200
Message-ID: <20260912065632.718698346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3f0ad09e16500..5615b358df020 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -114,7 +114,8 @@ static bool riscv_isa_extension_check(int id)
 
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



