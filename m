Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058692;
	b=KhRKYuycNRwBs9/RtYP2gByIUOSlnXJoaTWgsSsSUoKQTo79HuxoTHNexPzypZRxkGr/
	 w5Ahg3CK6Ks+m6y+LXfucIJlWiDZ4nroy3YjXix4SjiA1m+/QwY3mVUXLbrU4eBH9vpJJ
	 Mia7MGcRgTVdFxgliUhiRDmmFuenll3t1sUVTRAoLCSPdQ3B55XlgRujSSEpr9YMjnIpl
	 4xKPL23+q6GCeV5qQCCAK8RezkGYdzSsu4RHuuSYxOR/HciJPzdQubVsH6dj6vaub5W1k
	 zlrWmlOo3UlriJMG2BThjuJ4reMZhA3eeQmYNWhRy+w4MOvAj87JDRV1QngM7B4oEVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9Ju2EyThoHRlzouJ/bLpYv8GIz6/HJ4Bohs6WUyAMw=;
	b=lYTDdDjPinV9QTShlUHU1d/4H/FvgFEFdKCz8zRrBxnR3Nyxd0Tnh0FVlEs6uOc661Jw
	 EP5wkxl0+8NBE03Ld/WmPz5Bs/6tYE3ZJKDf0Elbd2nSRJU7pr4dc+OWddm74ynPUjZcc
	 CCHPkX1SyzLuanlSjxdytW3GkETroxxW01VQlEimlJOLz5aoefWxpSAyRWGEGpt/lJ+v/
	 23je3m4huqtXOjGVtoK7t4xg3KaWJqCxUBjE75dPlIgBL/lyX95AUUg8czRh4cGSaJ5cn
	 65IFi3DmaPaplx2rVY/ij5EJGQXiumRkqQ7sKIOckkINnR34xivC5/H2E0e1EgpuSTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lVp/4jhD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0B8606A32C;
	Thu, 19 Nov 2026 03:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVp/4jhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809C61F000C6;
	Thu, 19 Nov 2026 03:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058692;
	bh=W9Ju2EyThoHRlzouJ/bLpYv8GIz6/HJ4Bohs6WUyAMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVp/4jhDUAVIGllACVpWcgXlmgvywYF6ph6pv/6fOchfUXEBjmBVYfX9i87P4dRDm
	 w05bxiZ+UcUtSJ2lt5TsIsR2bilm9J1SDNi6pYPiNfjsGCBj1041XlXpmYKdADZvAh
	 d5lxMyaT7OzdJ0e88bnu+02StKQZ94iKhV9Ygobo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0535/1848] alpha: invalidate the local context in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:42:53 +0100
Message-ID: <20261118145937.392160176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 850974ed65cce..6c63b0d956e16 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -707,6 +707,9 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
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



