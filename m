Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064987;
	b=WLugpElqW71BsnLBaC72qUT2caRyj39lIp0c6DLWAPcApppsZG9v9LXodMWP7nBI/f3Y
	 sRKVwiSGbyZkgHWJySCGuKehZat5iQB0tQwmo/Mg0CCQld2+GnGAXj3lriZ/G45lNkUE2
	 lZJjY8BZ1N2MGbh69adVGinWzBvgBm5+xswSAB7jjDhYx4xg/tsBpUTVHgaj86ghqOGnx
	 VWQMTxp2IB37qCCNcuRL5WTsSE/7Qj6FESPyYLjyLGBO+Ec5JLpiF12WitWJrI4YpMIvJ
	 3iLYw9Hy8d9S5ZqYk2z5wy/UIbuiRDNYjX9c9fJ3hnOlXG4kR/F/rIkYvXj22xtoSwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vCppsotxkb9cKH6Z/sr0gm3q4e99VJxCLFru1N/b5CE=;
	b=cOp0jprmjgM4t/5fGReDY1gKDVsDQa7kmQf7Ztbdh/ZSl+s1T0WaPGzaKaaZfeR45nVr
	 EZ+FPlUogys5vrSrY82bKaOkrYwEJTPZ2ZdqfGuefOy+ADHEg1abujcDGjHjxTk1DKMUM
	 c5Jugp4Rh8CBCtwHDnY3PjSpSwAuwFzaC3WiPVPGCbkn03PV/4NcXoZacOt4PeBUU6oX7
	 Mn1E/k/CQQmXVsCOGqYjFgz3QoPr8J37Fb2Xq6+cv7/23xO6IerNq4sN6bm3dmpS5i3+g
	 VUXqkQLQHbckn/P1XUtVIY5G5erdFQkE3MyCcsWbqL6mUwRQUnP5wtw8J0AxlmlQZWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBxAnufr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7610606A33A;
	Sat,  7 Nov 2026 15:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBxAnufr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931211F0089F;
	Sat,  7 Nov 2026 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064986;
	bh=vCppsotxkb9cKH6Z/sr0gm3q4e99VJxCLFru1N/b5CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBxAnufrJmfl97tu+kXKsg3bhhb49MfLVfekRwpKLF1Nq+PtK7kRBlku4ffN9iQD5
	 33+XOkLk5kodrBwIys8wAOu6CPB3636MxT9TH65lA/q7C5rYvXX7qmOjWrO2i1uLK0
	 zoDrxs3OPqiB3bbCb2QXprgjwC+hpb1qNlc56j4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0861/1257] alpha: invalidate the local context in flush_tlb_page()
Date: Sat,  7 Nov 2026 08:52:37 -0500
Message-ID: <20261107135003.108466899@linuxfoundation.org>
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

[ Upstream commit c0db730bf05eb3c10c1fae64b19f6913dce129fc ]

When the target mm is not the calling CPU's active_mm, flush_tlb_page()
does nothing locally, and smp_call_function() reaches only the other CPUs.
This CPU may still hold translations for the mm and can later reuse the
old ASN together with them.

Add the missing else branch. flush_tlb_other() clears mm->context[cpu] so
a fresh ASN is taken at the next switch. Add this before changing the
current->active_mm test to current->mm: that change will also send lazy
callers here, so their local invalidate must already be in place.

The uniprocessor implementations of flush_tlb_mm() and
flush_icache_user_page() in asm/tlbflush.h and asm/cacheflush.h already
contain exactly this branch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-5-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 1ad448105201f..e4ba0aab8a669 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -697,6 +697,9 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	data.vma = vma;
-- 
2.53.0



