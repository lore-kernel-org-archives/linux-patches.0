Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064995;
	b=d+G5sa1wijMESgb+YjILP/yTSr8krVfxDf6r23FU6SBKd0ZFqEH63XQnZki5LRMiKqlX
	 ctJ/m13WiU5azAwNqwnVzRldms3pirL+QqUh631imuFMHcP8McPKwZBcblFlsOxZc/NwX
	 7YxKyDqLTtq7v3mlQv3wj0t0KMbdRWqnJMLoY8ZeHe8J1GvYcEz6IbK0kQQTQvqPE0Cpg
	 dmXH9H1bWSGseb7UFLVR3hU/mkzZqMCshy2G2hHj99OY3FEtecsej7gqvHZtrudT/oc3F
	 qXmkl7ydTX3riPumS+g2/BBVLcVDL1Za7eTMDtBm5Ke4bTFbcHbXpo86jIiUI36TUNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0jTM1TOk4uGoKemioJz1dUCP9kMPvyj5LWL7fhY7JLQ=;
	b=F3bivqEy3v2zpbjvjoT070STmK1FQhMgB0OyNrnRiCrKb/vNtc7k2+WMRfedqw6FD8QN
	 wav4dYYYhtm7p7V08/fqY5PjktjKFwrGNihXjwxKOTf2bzE+xEFP3zT3bro01gA4LueLw
	 9GW7g5BB/92t/g4+eYVvOm+xGhdCXpHVxaIkjxLobIDEfp+j6gDBwdX1YYLlRarz0XQX5
	 jgOUW2E4xzYH4DnghhSlnKAvEcH3CLP32YOACDkGbKNXi5XtT8lvcbEV5SSuwnCUpIh88
	 mVmmU62wgY+XoPgI48m8FjFpRHCk9jJH57pCxZZp0JYp0NTeyG/6sKue4gRn2UAYSwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNsClmv1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F65606B8AA;
	Sat,  7 Nov 2026 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNsClmv1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6161F008A1;
	Sat,  7 Nov 2026 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064994;
	bh=0jTM1TOk4uGoKemioJz1dUCP9kMPvyj5LWL7fhY7JLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNsClmv1VOULncugc9hcus0JCjfH3qBJuYEwO6TOgKPcTnkfWukbSqwbOqXYeISej
	 NwAmzFnNBSIrM2sbkt3IR4SlJniWVXtdGcbblYzH6PnYtRzT2f5MYtKivy1MeHYNNC
	 BOaVbPfxI1xaZnje5Siqg2f1yquBjvM+9Gmn6YsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0865/1257] alpha: invalidate the local context in flush_icache_user_page()
Date: Sat,  7 Nov 2026 08:52:41 -0500
Message-ID: <20261107135003.217470694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 988e397b0b8a7..e21bc3920bece 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -758,6 +758,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
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



