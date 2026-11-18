Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045597;
	b=OPCjY4IOVQodABVGpRaufPKUrrN6JVt85yITgT5lz8Zi5NG51yDzbZRPmQifoN/KppZu
	 KVaCfn2Nxc1lZ2/aFR5D+QyMHymMMpMt63xkc06yqgyoYEd6XqO0htumGIQL6wBYgrtsc
	 stf9gdl/GBXDw4L/x2uXbRCzaYUKfUo3Ip5/L/8UH6x4Hao1L/TixOVNhE5aV2hcjQUwu
	 e/nM8VV9ExT9JFwcitnzV63WiLXo8AC7ZNfknUp+3IN+KOkrGURXbsjYjqvM4Ct+211IF
	 N5xmUVwlQKutNB42bO5BOC9nPLeOnZWPWzIyAINBVJzqHvUDPePPaOqx2trjaJq+Wzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aelOio0nK3KZ/9N0F4SfxV8zT9PsICRjSLh0EPRZIX4=;
	b=AZHszD+q4NbcHP2aJs5DUHPWZ+9Bh7C52P6Eg+aBHkUFnkvWDFWXUn5fDa1OUEikILkE
	 mEiVaGLFbVyADI5f0IQC+bKwBbLozeV8rkItMxM6lJ43P+8tDxq0x64tpNuz+hFWcqOWF
	 NtHuuto+4zUyMrLMTmASltukks45AdAQEY7f8nqJkC5/9nw7QC6UeTDbSooBTf1Y0q62f
	 +1f8IH85i6npHJs+emHhgupcSBTY9I+D14zsTYASAt4duzSV6P0MzEqaI/gjIOnyH7GN8
	 tA/2Cd6eAMxu5XH9Iset4gTUfQU4Na31gNb7yn5+v4IjR6q2T5EpYlUO8nrpXHnpX0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsBzh+Bb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF5606A325;
	Wed, 18 Nov 2026 23:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsBzh+Bb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE601F000C5;
	Wed, 18 Nov 2026 23:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045597;
	bh=aelOio0nK3KZ/9N0F4SfxV8zT9PsICRjSLh0EPRZIX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsBzh+Bb6Nrr9YS9fAG5Hq9j9/NIe+iDubapNUvix5RdgX9gzpA5niW3nCpYobMe8
	 5YN/RnGLiINgwmbXj/7IW1M5TfQIwtpa1r35polcl0MCLJLVoDNcjDskkPDssBSmmp
	 pfd4pHzNAx71wHhRsoBBAf79M5Jl6z31Ah3HERuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0979/2857] alpha: invalidate the local context in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:33:33 +0100
Message-ID: <20261118150236.854357552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a4bc77f2fa8b4..4aee15f99b66e 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -701,6 +701,9 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
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



