Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5A299920;
	Sat, 12 Sep 2026 10:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210509; cv=none; b=hk6S5eSYYNt4Ffy3kn1uITYMoqTJgx6FJ9fxRmMzsjckqYkG8ye8S4dE4lfe2/u908OGSHAB4gF5nRjJuW5zvn9KKY7A0ThO+ekf6h4LFmtmgS9kov2eyb4Autl2J260CCE6dFgs8HnXffvRk+M4dNX/p0haz24iFVEHECAE0b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210509; c=relaxed/simple;
	bh=MMOVyxreYPhml0lXbCC2YLpR+eiF9jqiKU8Ih4W/BbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDqsjuVpk5bKarXGUKaoR5MFvIPsZWvGv7YuPZq5tyR0rhoaS6ovAK35C5E+jIVOuVergv38rBGf53tzsc1X1sDbaXLdH3rMmCjgoxjOw9qjkiOWEC9x+o6mCUASKaXYGjFXGOmJaR1xKXX3H07nCcQ7P6NGH4eqIHEsRqh/4HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTCYeYMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTCYeYMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9361F000FF;
	Sat, 12 Sep 2026 10:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210506;
	bh=7xKzO9V5pVoprUUknMNrwEgpEG7trOcETy2SxVUr9VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTCYeYMX+WhIhLKWh2DUI85fAnQHzINaI5BzpoEYZGXPc/9aMv60KlUFGQEC9xNWw
	 xK9ugQkPwaSEdKNnxzeZmMHGIzDR8DkKE+3Gws3Hf4fxNp+grx2pr1DGxDAOlwCYUP
	 wYmshVFPZSTJ1fGzUOG8GgVxUsIBXOyW+BQpb84E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Guodong Xu <guodong@riscstar.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1039/1518] riscv: cpufeature: Clarify ISA spec version for canonical order
Date: Sat, 12 Sep 2026 08:53:28 +0200
Message-ID: <20260912065646.955180718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2367e9755524a..17d21a708fb76 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -409,7 +409,8 @@ static const unsigned int riscv_c_exts[] = {
 
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



