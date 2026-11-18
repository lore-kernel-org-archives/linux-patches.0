Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052713;
	b=EFQoqKVpq+VI5AzcvgwHeFIb8lp9wk2beD66PeTXLx1gull124mjQj3fjGXX6XnGLYgf
	 PNHgPEEFuLxqZxeLOXo8WX1lTHLFhsPqck4/UAS8Poqeq/pnpYudwmI/AGQBk19jjkqih
	 aJWrgKbGThb885fGxZG7IJwoZsDFKz2fG2NnpeLS6maW0jG4epzlEplgZoRP2HfiitEHg
	 Q1kJBZWHRt8a0p14SB6+z1GRJyDFIp/vMsQocsXsaINk/YoCwfdykJDgr95Z1YByxV0K3
	 OS2ESNgCz/tm1iFq3l1n0V3bXOQduEoM7Qfs9HZuVRJs/VR/q160nDqFU+d7Aa6v4Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pNDZp3Nm9gf1JLOPTVxMd4aMUuVCeasegfOSmnu0GVM=;
	b=qtbak8/ibgRYI/hfwtVWY/KYIGo7Iba5jWpDuqOJ9Cp3Hwq9BN+dGksSBnkrP9/26hMK
	 L2w2tc2xl06HM+D4b+ld5OtT1iLUJ0HViR3F/tYkELdGof1dVnBfWjeWJKWVHQLxye8EL
	 OkxWDv2zBPPDQarvjxK0VsDzUfm+PPCUCn/ow3/xq4PsMgZ9uCR078UaQvmtQEu/X7sZN
	 hp2pBLNTemFGH9gknIl+ps2U2CdVe/mg8cwRHH2RJb6l69hA7W1CLfEW/NoBjjZQg2Zw6
	 OpbA5VfHBZ5QKWipNgs/Gxt66SdC4Uw0FAJS4V7+O9pf2qQiXnf+MD7SsB2GHmLF/4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCTNEHXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7CE606A32C;
	Thu, 19 Nov 2026 01:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCTNEHXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B881F000C4;
	Thu, 19 Nov 2026 01:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052713;
	bh=pNDZp3Nm9gf1JLOPTVxMd4aMUuVCeasegfOSmnu0GVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCTNEHXzY/wQObOi5doGaptVW7GEEs71b1UF3QdkP8OrYiRrv4Hb3YODRN+EHIUmv
	 nb9/KeTQpj4s562EUimFjTe1/k3iC+grDTJO1uRr5KLHAhaK4x7hmonYVTnAsuESsS
	 MXnCXtmZZPiGhYT5A70E4O+eNv8xYkskQn1kN8Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0661/2214] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Wed, 18 Nov 2026 15:38:57 +0100
Message-ID: <20261118150038.195984468@linuxfoundation.org>
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
index 94dc37cf873a7..64ea0f130cd57 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -118,7 +118,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
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



