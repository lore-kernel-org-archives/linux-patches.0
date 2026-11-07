Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064993;
	b=LACvPMgPkoOmOT+XIlKrqqQwLLdacsi0hYX1xODnI9JTtfx8ZbHJdhQX6KqifArh9NAD
	 ZH7hqZKm7eFQ0FfNGLKza+gsfcydL7BZV8uhtAO4nCevIqmducSH7T9Zm1kFURnKA0vef
	 NL8A7UvU4Fu8mIhJeIS1S1S8iEZCR76MgBDwwFL+FlEgNaG5oM7rUKhaV9sXs8yPCuNtD
	 OVA9i1OVnpnxYy5Hnty2GGLwIOLWm9MiyjhIMJThVDxHZboF05V1fdjl4cs4pAi9kPih5
	 LrudwlyTrjI5w9ETAolgWaiD3huXG/Lsqy4CrNVFVHIh2QOUcaz56Ki8/VLGPw0qy4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Igkqi0cstBGWuyLZGzKiLArIJr40ssOSb/gbjjnMp2I=;
	b=M3Nrr6VHzEKgHCdNgnZuZeAP8KlapCPs80eKR+3RwvLOmaEJIMYy34MckpqUOTiuZctH
	 YdT9U16LTAhqWEpvCeMZJOPRXVK+xty5HpQ5XI9Yl8gyL0inY8TOCKxqvBJsdoffnkOe3
	 m1o/dHoTRGEtqWP+QyXgDSLZg1SeA3fFV/qlq46NNqJhTrCV3HBLV32w6EMBrwLr5ffvO
	 RrKCY5AG8DpiBbAafodNhtDGtY5lbIv0GznOfIKkYkJovjFWvD6KkzVhsBlD/UHKL0OXT
	 pvMrsYxwHyMS6IJOUDfDuPl6EDA1io7QjZvtLl7hHSeMbhXm1SMSOl00tOsm8Si2LzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGLeGchR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CC5606A338;
	Sat,  7 Nov 2026 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGLeGchR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2195E1F0089F;
	Sat,  7 Nov 2026 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064993;
	bh=Igkqi0cstBGWuyLZGzKiLArIJr40ssOSb/gbjjnMp2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGLeGchRBw2+lN2WPmuY770+lmvAXat5EB7Tmbxl2MBoJTVm/t7rZ654KyM9siV0+
	 z0HgSONeNyLghA9SnS+DoYPsXlMoqMax/uz3jnlIss3YnxFjbC23NaBvpc70edXDuN
	 6c96ObOJ+TJh9RpcgcxdQ5Dp6LJD94VKSy2LIpJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0864/1257] alpha: invalidate the local context in flush_tlb_mm()
Date: Sat,  7 Nov 2026 08:52:40 -0500
Message-ID: <20261107135003.189870670@linuxfoundation.org>
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
index a5a42ae4a7d80..988e397b0b8a7 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -649,6 +649,9 @@ flush_tlb_mm(struct mm_struct *mm)
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



