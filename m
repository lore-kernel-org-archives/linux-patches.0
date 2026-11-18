Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052716;
	b=qyePF2n2xppnaXESWCM16Ndgbl9JbZyy+1GnQRwM+PBidNvKZ404QSkvsEgILOnszijx
	 Z8TMZiTWiwBEvb07MSJ61t4VfqzpjDC5whLhiR9o1DSnKyewt2ogRvCgoLHQRzJxgb7Ty
	 AEmybsYrjQym3YrZTXdnslyJKgn9aKl8mdKBrRUoBbCNjC0+19edwjvgL2n16bYWNMBmX
	 vsI+vYSkvB0xS9QGrrWcxziWqmtBcr0kFUHFmXOv/H2rY5vKjw5s5jRbavEpapWgKz1jy
	 hcpcdX7t9d8fllLZ6swcGF2XcFETI8cWCOCmlD0VG9xEivO6Gl4ucjKPBoa1pmGglUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y+VMdBtCStirvczGL3UX7xLz8Nj90Z2OVb6v37cB+WM=;
	b=zeqMpqoX5IzJ0g7uGMJ6H09PNWLPpW/NCLip8RFLz83hVM0BwElqBqWBV86oym92w35b
	 7swki8RZxHfZ49F+spKgqIM3PCYcCEvLIkCdMgO+X/KJdpTtKFVpUB/UVz1z3iy4s4I0w
	 Dv5VEFDuAWbrVbWpjeL6eX7SmRR/VMj9tOq8/w6N2+HOTbI8XeDSgCKj+Wgum7r9dkHMh
	 lB2nfU9k7muGrKp+khV4F9BycyMBGd7KNHhun1HWCEmJuC4Vg+Xq/ALqB6EjR3muqDWqg
	 6M3ZDxrDoJnV5lENDb7IxZo4kRiRi0q4+nPEfClxEe0l0JW5d63Ixa7JqRJzq3Qol8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgZtACKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD1D606A334;
	Thu, 19 Nov 2026 01:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgZtACKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17D81F000C4;
	Thu, 19 Nov 2026 01:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052716;
	bh=Y+VMdBtCStirvczGL3UX7xLz8Nj90Z2OVb6v37cB+WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgZtACKsguaVqzCWO2tPNIYbqWYrsE0/3UO+re8DdOxKOtZciHnXaDsE6/MGE7Gp0
	 D9/dngAulWvMese7ivrlw1AGENrpr1fEu3pTwTrWgOcPzezRx18rt2Bmp++yh8WQgb
	 TbiU3FLyEWaOtZvbgNfRUEddXtH+sGyhoMp5k7Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0662/2214] alpha: invalidate the local context in flush_tlb_mm()
Date: Wed, 18 Nov 2026 15:38:58 +0100
Message-ID: <20261118150038.284258271@linuxfoundation.org>
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

[ Upstream commit 721bb7a129771f0ff9cef1dd5abfc106ef65feba ]

flush_tlb_mm() has the same caller-CPU omission that was fixed in
flush_tlb_page(): when the target mm is not the calling CPU's active_mm
nothing happens locally, and smp_call_function() handles only the other
CPUs, so this CPU may later reuse the old ASN together with the
translations it still holds.

The active_mm test itself is left alone here. That path calls
flush_tlb_current(), which loads a fresh context through
__load_new_mm_context() rather than issuing a targeted tbi() against
whatever ASN happens to be loaded, so it does not depend on which context
is current.

The uniprocessor implementation in asm/tlbflush.h already has the missing
branch. Counted over a fork-heavy run, flush_tlb_mm() was entered with the
mm not this CPU's active_mm 2934 times, and 632 times while otherwise idle.

The proposed Alpha hugetlb support routes hugetlb invalidations through
flush_tlb_range(), which calls this function. Unmapping or migrating a
hugetlb folio from another context will also need this local invalidate.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-8-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 3e25329d5d124..8a72f6fa71388 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -659,6 +659,9 @@ flush_tlb_mm(struct mm_struct *mm)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_tlb_mm, mm, 1);
-- 
2.53.0



