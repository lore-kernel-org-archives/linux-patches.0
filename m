Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064992;
	b=4Ri5J/TvFEZvrHCg3cYAq4k+l7L4nQBD9Z0NxMy9FAEoC3KoEJjS09W1HDz2zp0j8OGU
	 A8TzLiSdHnlXJu0tzCc1gYvSdvsUTa8xWoVLxF3oxdkjjKwy12zcLAK6n3l2YbKr2SwQ8
	 q+b5jMFW8Z66zOx0o6ohDXP2lpCNdUoA57ScqG+ULgMjLIdNmHtBJxJOCvQxeoHc221VA
	 Q+fXxZUeVPMLat9OvQibSuJWmHmCyfaUd/psUelf+0sjhMZ3Ee5xpMxFXdA9fgXRmdC6/
	 AbUO+WFf2ynRW56nD6meR0sb2jqyeqywRxNtXbiPYfSUeg9AO+kbo1R9pg/DsxdDc2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2jQ4Vw8iZ8P91re/ibMl0CF2jXpW0nKxk1GLOOQYPA=;
	b=4/HBSSCrAqo9SMhIM4Bh30/bjyGDBBUfkEeF9xknsYbY7LvDoD4SptubToqtS9+gWhS4
	 0N59tOwwGYmuQzTYBset9Gyfgy/tLiT5OJKPlyfGzKrLwVGbu8zfHpA6ypfgvAMBMEkVK
	 5cxA+8cdXUcxrRpMRgNJjh57Fucl6wLuFSlAFsyrYjCVV0AfR3CtKdRRFwTEoXp0s+/05
	 Ufd/UpINrnQbWUI7gPmB0ZIu1atgR9pLxGtQSfeZPU0UKZ9lLnE9mC7PJnFgPNiE4Zu4F
	 vIPb9xHSc5vOCu0+P6/TVtZkKHx4pKNFbEAfkorG8dFMOG8I12bTt2qOkvq1jDoHj0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5w1OqA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E3606B895;
	Sat,  7 Nov 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5w1OqA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42661F0089F;
	Sat,  7 Nov 2026 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064991;
	bh=Z2jQ4Vw8iZ8P91re/ibMl0CF2jXpW0nKxk1GLOOQYPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5w1OqA4jHso6POIqgz0scTwqIvidMwQsp16ZWhI62pP+rtZRQeDVPyQk7id/nrOh
	 yl3D84sRJcqZuWCWcmNAY0WzYaPmmeficMaRBLeleCoVqbNPz8l4n1j/HEA3aYjFXt
	 YGRb4ildJF8MU63oG94U5VHt/2zc8VV5+7MiEtsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0863/1257] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Sat,  7 Nov 2026 08:52:39 -0500
Message-ID: <20261107135003.163660695@linuxfoundation.org>
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

[ Upstream commit c825bf802a7a43fd302c879ef25c975e067a2e94 ]

The uniprocessor flush_tlb_page() in asm/tlbflush.h has the same wrong
test as the SMP one: a targeted tbi() is only guaranteed to invalidate
the intended translations when the target mm's context is loaded, but
the gate is current->active_mm, which a lazily borrowed mm also
satisfies.

Test current->mm instead. The else branch it falls to already exists
here, so unlike the SMP side this is the whole fix.
arch/alpha/kernel/smp.c is not built with CONFIG_SMP=n, so this is how
the same defect reaches a uniprocessor, where the flusher kworker
necessarily shares the only CPU with the writer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-7-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/tlbflush.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/tlbflush.h b/arch/alpha/include/asm/tlbflush.h
index 0c8529997f54e..9ae1902faf8ec 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -87,7 +87,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (mm == current->active_mm)
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm)
 		flush_tlb_current_page(mm, vma, addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



