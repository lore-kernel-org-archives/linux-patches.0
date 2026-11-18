Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023810;
	b=hwu3Rv/4Usrbqhv/aZ7iZ17AT8+BZwo49mM+egYQ4vdldkC4TWQT9t23WXWxVjsdIbn2
	 N/iaoQLOui1mVtyMPLdrutM9iYLPwPNcN4B+Kc32Q3cWsUtW87LgwolMH4yELHZwAHiqt
	 JCpNBjmH+U1vjOJXFXwx+zWi5LxAQfkybwYdzWQO4GFtDJQvNdHHrGbmjsts/IQpvOZfl
	 jSq4xQ+F7QUunsOTaAIxxqIDl/3ebCKM0Vv5Dqy3Zb8as+8OXTfM2apmDFkTVIrg1eRiI
	 24hexMufG9XWO3beWHPbh71uutRP8H0cQ4tYfzsMsbzfm6y9fDIAEvZqKAgUJSXYnwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7xCja6W2beOt1ell/0OwCR6gNQKsotHNr/QXUv+G9Es=;
	b=JpnkE6XFPCfjjj1xC6iVaA4V8HlMELhVX0LSCuR/Qp+zBZNHMZzFZutChUBOl06zKA3a
	 81R7JGgs7kyCZPhDV7CqtIF/Pf0D3pq8t8UoewcxDaYn0nGVIuC2Ir+p6w4nTZI2tRNgI
	 NMWc2UwWs4xrMzCvsgizXayyw205fUtij9JUrNKr9yQ+hgNuE6bAgSM3drw0fkOqj/Qvb
	 uUF5MHoEhnGc7JWXiaewlR6J2agUM11bIg8LvfrcZ3lMnaORO6OG8gcb3EKm2uEUFGDQX
	 W60MTJYrTfRR8U1G1kJ2BtGdTTYMKkwn1ZoQ+wAa5cDnqG/yrH2MIsNuzFKsLWrvOuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gGR/vgqM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4594F606A33F;
	Wed, 18 Nov 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGR/vgqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA441F000D3;
	Wed, 18 Nov 2026 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023810;
	bh=7xCja6W2beOt1ell/0OwCR6gNQKsotHNr/QXUv+G9Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGR/vgqMDmfY3+PkhXu6CgAm7kIkncA3iHX1Ti1ARLh8c7utOzzI+SExm0H5kYG3p
	 tvIcU2k6BoiBx/cBkGHUlLC9MltL3/3iORMKi/DvYz9JJeQKDT4EOF7L5pwWb19767
	 qieiWavEr/2mQ1eYpc0g6xTgCqxJasPdSx6YfjFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0501/2151] accel/amdxdna: Set HMM_PFN_REQ_WRITE for writable BO faults
Date: Wed, 18 Nov 2026 15:37:16 +0100
Message-ID: <20261118150140.302619450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 2d2c4b248bff9ee1ac06054a9138c1a308e2e7b8 ]

When aie2_populate_range() faults in pages, it only sets
HMM_PFN_REQ_FAULT. Without HMM_PFN_REQ_WRITE, handle_mm_fault() does not
request write permissions and may populate the CPU page tables with
read-only PTEs.

Check the VMA flags and set HMM_PFN_REQ_WRITE when the VMA has VM_WRITE.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260917171952.1883974-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index cad1ecdd26f8e..412b48f49fa20 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -234,7 +234,15 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	mapp->range.notifier = &mapp->notifier;
 	mapp->range.start = vma->vm_start;
 	mapp->range.end = vma->vm_end;
+	/*
+	 * Access permissions are fixed at mmap() time. Changing them later
+	 * with mprotect() is not supported: the range keeps requesting the
+	 * original permissions, so the application may see a fault failure
+	 * or an IOMMU fault.
+	 */
 	mapp->range.default_flags = HMM_PFN_REQ_FAULT;
+	if (vma->vm_flags & VM_WRITE)
+		mapp->range.default_flags |= HMM_PFN_REQ_WRITE;
 	mapp->abo = abo;
 	kref_init(&mapp->refcnt);
 
-- 
2.53.0



