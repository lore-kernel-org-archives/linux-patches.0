Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045608;
	b=kPrLx6TFFkF6h2M0A3cSuBJ/v24TPUhQJ2TkzEW2CzUakKHis+do/PKPrd+fvguDn+BG
	 ODBB4fvDiwdCi1L2wFTMZOhi1ZFNyb/FKuhuadWO52xdxUN0/LIQFQHus/UoqsWgSVGqE
	 Wu+vYulyZwfGPvz9SxqnLouGPpoI44J5HU0dbNqiKtwYU3D37xbGoS/SsIx5RfgtWQv+H
	 jgFbVmqicOqBSCaZMVbWTNtLeFXXBcnpXL89076+ZYjKww8K4uDNKu+hTmTZABQ7jTvu7
	 G7wT0+V+2gQDPwVOsWruYdLpYk7J/QFeAfr3B0Hd0Wat7LURp2CvMo/n/o8nkAKKwaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4b1lYID28EiLuPMgVejnFXkX2/vZ5lwzYZeATyYgbA=;
	b=cVTaYx2Ly6mh+r2Q9jZYkGZ9BvJLOcdq9GgqHIfL6mQn19+v37qpVnPSdhoPnxJUeik8
	 lf229oI607W+Uvqzk99cVtrZ1Ny7ZOqZpf7LHHBsAEGFbVWwBB27UzZTf7Rmnny1g2hGH
	 BZlHsru+sZRAaK9jIXrHa1U1i2MU/cHJU+QwfrWOM83iGwWnRZ841r5FOTJYuY5exK/ZF
	 UyogUIkMXwTjeH7sq/ZLXL9K4RV2upf7IQ2ouodcE4B9i9127d4h9RH+v2Dh4WUkL4qfW
	 IMCVNxiOmWjJ2fu85tDea5WmIDRuwZ+uL4fcSp7rsif9bfECoKECoH8PUeYCSmW7j6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuGPchGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9E606A325;
	Wed, 18 Nov 2026 23:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuGPchGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB9F1F000C4;
	Wed, 18 Nov 2026 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045608;
	bh=Q4b1lYID28EiLuPMgVejnFXkX2/vZ5lwzYZeATyYgbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuGPchGrDnoc3ptAposAqspgZDafW8HNY+8+XfTrQPcvaab92Ga0yCSPope/hWihb
	 zyvR9dIGrG5VXRLZqG1jjtJp5W+wC27cGdXjhGWF74Vr5q6i4kZNFLTW1Hjz9qgyzp
	 IFJ5smygAiElnVAed4jBiQvsPAC2Z0nWnfADe0JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0982/2857] alpha: invalidate the local context in flush_tlb_mm()
Date: Wed, 18 Nov 2026 15:33:36 +0100
Message-ID: <20261118150236.963599986@linuxfoundation.org>
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
index 1c2536d5fb9ff..5f80f9682a828 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -653,6 +653,9 @@ flush_tlb_mm(struct mm_struct *mm)
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



