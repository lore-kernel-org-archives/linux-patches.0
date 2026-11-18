Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052719;
	b=GgI+887+4Tmc2xQf2LeNf0FhdO7gInjyNS5Rxi9JL6lXFB2VLnuz9F+IsOsAZ99xVk2+
	 +XEeQdWL/QrMtr1K9cPbwJUSjMB6sCmNBE7bBNd+IqrCmE+TpzRUlQpdfahjtoW0+VXoC
	 fA5WdqfeziiLq8Ob9lJGugjvomTXUa3Cp/EdMhXMWBhEwOWNWHnZ71MhkIjcRe9D1I4dX
	 y/r4hBpK8ap/SRC0sf5JHkb699Kb1/dFpV83oMk/31u0od7i1hIRPi07XPN6VwK7kt8Oj
	 sXByMURB/kbiuhyG7vCQy6tA8QBqwkTIGgh8hgZ+S64Yd8aOsZr42vDmhKOneMRh4bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TyjdTO1JS6qwWxElaOHx6GJpFoKFCYOmHFNJSj9Q920=;
	b=ikxCXIMdvwY5UtMIDbbFgcfG1746hB9HLpmjdrFvlV8TLxvrW+ZksBhe7fagsK5958qC
	 PoC48AGSdxja9ZKtZnqGMMzc3GVERJ3Vci7IGH45s2qMG/aRZqenGSbCOsI9ZgZ7iuPgh
	 qja1cK/KSfoyl4JvRIF92LbAn2qn9I4UaPsIfE/o+vt/Q/zWJVNEHRFSNOG+BWNMKAjhU
	 BYL75owSn+dubiSS/pfvZWO00eqFEVpLHCHQsn0cNYi9bM4PL02mRvp/JWJ5lR8ZnK/tb
	 SU7Wskf6fFsgFQ/qvk3SHjjwK+BeAPYmpw+RLqtfWkD2Gk8PymXPsYrB1KNvBuDx72w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBntk9t5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFE2606A32C;
	Thu, 19 Nov 2026 01:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBntk9t5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876901F000C4;
	Thu, 19 Nov 2026 01:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052719;
	bh=TyjdTO1JS6qwWxElaOHx6GJpFoKFCYOmHFNJSj9Q920=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBntk9t5Q0RvSJSXdinM9b3Lom//AE/CXDFJpc45GGkXV2laANpmcjLD+prxOk45C
	 TFXTJ9V6ytVlbqLNQOqqBLp0F79VxZlTLW32QULJzeDbJAXkqcwXt4vJmdrEZb4c7E
	 3bp7+TOC4yJ1zdMq+MUwycSrAHHx5kA0MmePzbYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0663/2214] alpha: invalidate the local context in flush_icache_user_page()
Date: Wed, 18 Nov 2026 15:38:59 +0100
Message-ID: <20261118150038.317641924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 4244c555ac440a445cc168f860b2677099d761f9 ]

flush_icache_user_page() has the same caller-CPU omission that the
previous patch fixed in flush_tlb_mm(): when the target mm is not the
calling CPU's active_mm nothing happens locally, and smp_call_function()
handles only the other CPUs, so this CPU may later reuse the old ASN
together with the translations it still holds.

This matters here in particular because the function exists for
operating on another process's mappings: the comment above it describes
setting breakpoints through ptrace, and access_remote_vm() reaches it
through copy_to_user_page(). The calling CPU is therefore often running
something other than the target mm.

As in flush_tlb_mm(), the uniprocessor implementation in
asm/cacheflush.h already has the missing case.

No imb() is needed, here or in ipi_flush_icache_page(). Alpha's
user-space I-cache flush works by allocating a new ASN rather than by
invalidating the I-cache: the entries stay, but they are tagged with the
old ASN and can no longer match. An imb() is only required when the ASN
space wraps and numbers are reused, and __get_new_mm_context() already
does one in that case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-9-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 8a72f6fa71388..8a712076436f0 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -768,6 +768,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_icache_page, mm, 1);
-- 
2.53.0



