Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016503;
	b=rq9Nxps/Md86XGczybQGKspB703ThQ0Zp26qIeE37qbHmBh3N/ScSl7Fx0LbNBjJFVXS
	 /7wyMjDju4TzaGLUL0gSRm3dUPNjIZjteFJgRTdWuLLM7ltvA9RcfNmVAJg+JPHXKx2ff
	 KDbAe+EMacTRQ06nErwcidwMzy2xaSgycTOtupt+z95owkdBZ8SC9Zgtt4BVh9WDhKDm7
	 RN3vob69UpkMt/Y7v36BdNHICmQbE8aZd5OhfRVVekUyONf374hHBC+M/zJlCIc53f8ou
	 5cZ5XpfZV1V42BhsUsXa3UN9Na6DQBUmgBx328pCz/mngs2RRTGF8QVV1HYU8K8AgFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYc1DZdPymtnZRvM83h2MkEg3JHTlTdSL8CjGhTOMYs=;
	b=SUb+7C11f/JNR8ZsmBMqGoSjMc9JEEZxzWTmTTpRton840ZmqnRKs38ko17eJ9mwntK5
	 YyaHWTajHI52xSGOkI10c4PqS5l/RZE7Er+Pvc1gVebjRHq4NvGxGEqvu5ahwMPjHTNU0
	 GyIlITnY0Hl9CFDQJlNvT7XTdXyCwznZ5BLTUpfELxvr7QFfzQTiM7gXrsejeMGffeZKN
	 OSSIlkqCEyYIbfijTYnqCS5m+o87DW+Y++c68JAo32wXI23y5M1P7dDnH83Ab+9xyUkIb
	 v1zoESkU7oMBDOoElE8cATYz67xmjCrSaTTqm5jPRYvymQ/H464OqODj1uL2UUuN31A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zh5uizCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC1D60A2601;
	Wed, 18 Nov 2026 15:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zh5uizCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51D51F000C8;
	Wed, 18 Nov 2026 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016503;
	bh=tYc1DZdPymtnZRvM83h2MkEg3JHTlTdSL8CjGhTOMYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zh5uizCEhbCkwqab36pK5xPhoNlF/Ca9xOU/2+0/rAZSzfdzQ9cHRLWiBeHYb3JfB
	 k6JBc8I8c+PJGI+9yHmSMI7WI1c4XXz9NO9m5mpV0Lu5VNmGOnM409ASLFOuSzS/dB
	 oxHi6f/gBRyN/5Wlz+BIMUluJ1wKzJ5Ssh/yU0jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0551/2651] accel/amdxdna: Set HMM_PFN_REQ_WRITE for writable BO faults
Date: Wed, 18 Nov 2026 15:29:51 +0100
Message-ID: <20261118150307.583721987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 398d0a58b53a7..07651ecb2fcd4 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -380,7 +380,15 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
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



