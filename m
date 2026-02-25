Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F513081D7;
	Wed, 25 Feb 2026 06:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002692; cv=none; b=cAle14m0jgrXWAP2BukhnejAseE2HUjsn1llqW+RBEIq7tl+1QPFu9h7sZUTfC90x2Injb6CBrRBtoja7qfcdgjnGfT0IoMhREmVycPqExV92IEMKBROvDK+NK0QOB0nNkFZcRIQU9YhnJgkfRy9rywYMt3Y1Nxb+3yaZ+Rft10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002692; c=relaxed/simple;
	bh=uXkpV9fdwkUblVen1QaMV+Y1o5UNiFGJxGRfVUjDHzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4Y7ileZNlNzWwRi4JVLfqFMbpwvW5po/UXae/8NSYogsj3O2f/aDHu5dyJ4PbH6bWXjrWFKdXR1hJkFB2v4kgSNQUut5YABQhuqBnrJzgYVArMJrRtHBp4NIKe1BS+r6oHEWBXPAQrl8p4KWZvZXr8Tp4Kmwn4ROs6ufeilCZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6ld8aaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6ld8aaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFCBC116D0;
	Wed, 25 Feb 2026 06:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002692;
	bh=uXkpV9fdwkUblVen1QaMV+Y1o5UNiFGJxGRfVUjDHzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6ld8aafadj9oBqlc4DZxEcOBUwYsaZDJzZDmiITciB4KYuNFSW/G0zpLYRc4HMEb
	 t2d0yGrwRfm9ZB/b8ck6M80avmCCJ7ZAtzbCnTawXudwyWRlc8PPjdsoQuIn8FDPRf
	 nGTES5roAssuUCJPGmlbpFkIzcG9z9O9i+pI7PG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Keguang Zhang <keguang.zhang@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/641] mips: LOONGSON32: drop a dangling Kconfig symbol
Date: Tue, 24 Feb 2026 17:23:32 -0800
Message-ID: <20260225012400.294703990@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d463fc5ca1ace0b2e8bb764df04fc12ecd6f8e2b ]

CPU_HAS_LOAD_STORE_LR is not used anywhere in the kernel sources,
so drop it.

Fixes: 85c4354076ca ("MIPS: loongson32: Switch to generic core")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Keguang Zhang <keguang.zhang@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e8683f58fd3e2..83a6b68d8a39a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1408,7 +1408,6 @@ config CPU_LOONGSON32
 	select CPU_MIPS32
 	select CPU_MIPSR2
 	select CPU_HAS_PREFETCH
-	select CPU_HAS_LOAD_STORE_LR
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_CPUFREQ
-- 
2.51.0



