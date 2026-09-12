Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9F742882B;
	Sat, 12 Sep 2026 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217746; cv=none; b=jsZTK/KYnskAOJkIRNP/LIWxJNhctDdbexF1k/N4fbGI/fHAUL3nvGgTqWZIRLBWao9SmyXHHblP04n7X31FImdj3UGGh6MV5ip+vvtP1emKDIzPfa2N83P5dTQuN7FD3KucEX0Dfb2HizPRbfahw6g4iDBUpv8AfsVouazX7NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217746; c=relaxed/simple;
	bh=V99I5PU4MtNOYnM0XXXAEx8FJxTA98iqfNBs9jccvoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9YrrBO4L8cUA0eaTVxT7KUmduTtKt5gShd88R4TYN4J9CyC3JRNKV/Nti0M/yqOUaHawgI9kPS6twv1yLmWH+37LyqqoQxZ9y7WELQIEbKCWaaL+gviC6lySGJDINLogzY3EXErTo22hy/HAY9OBF+q+oWKOP9nqr72foBUPrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiuElm3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiuElm3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A528B1F000FF;
	Sat, 12 Sep 2026 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217745;
	bh=fMYUzvMqpHbn7oswPRgFc2t3wvuYJatJ7fYjWp2W7wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiuElm3/YDfoea5NfP91ZCVyIlctb92BBlEX1k1UlL+V5ruHDBVQtTvqcsxyLMvfI
	 2NgJADDhItUHtexHuvAZ6LJkjyFauDrqX6iS2kExgPgcKxs/V8mWL5bnl+NbbfvgSo
	 LdUdOefkoDnqLs+wFQT/+M6/7K2La5pMCBnEYMUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Guodong Xu <guodong@riscstar.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1001/1376] riscv: cpufeature: Clarify ISA spec version for canonical order
Date: Sat, 12 Sep 2026 08:57:07 +0200
Message-ID: <20260912065629.874787760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 308430af3e8f8..472de1ed1ad7e 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -263,7 +263,8 @@ static const unsigned int riscv_c_exts[] = {
 
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



