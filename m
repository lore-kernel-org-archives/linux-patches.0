Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5249D14EC77;
	Fri, 15 Nov 2024 06:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653620; cv=none; b=R8pEgfCu5cd+kueq5W9VPnCgk6ZYao5ZZewgcRd+Qsz5JMuhmR9HuRGfW4U/MLA94ul9FkBo+PxJopbmb7U3PyCL/bIrBNeEVNH1Izop3XBFST3+KDu4g1YdFVzUzK41eEfOl0q2db35Bn6TPNQKVSJNjCAICkuukC0VZC1aU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653620; c=relaxed/simple;
	bh=w+ufMYfNOIEBfiA85LnVqXS5paMBLYBqvomgpeSyR74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utuyxqPItF/BKH+Xx4Sy/t1yr6T/gSGCq2evWQN100haLTbqvrXCWPiJLfFK603QUzp7t9Xjq9yL63889vgnVzeaPfiUHsfRiGd/muBN7/T9sOQeuQBo+gQTSqfREtd0wS1qNdCbkkgh5L/mb8FG/1Xbtty1Vy1lVrExbyMF9wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxCrGgwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxCrGgwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7346C4CECF;
	Fri, 15 Nov 2024 06:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653620;
	bh=w+ufMYfNOIEBfiA85LnVqXS5paMBLYBqvomgpeSyR74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxCrGgwDBaUmb0A/6yxwE1S7hn+/3mBqCKAO6foMcfFiGhxZk2HI17+s92kjNqqQD
	 4/9HWVTUO/YNjiIEp+K67tqwSV0yLI3WH72N1Cgg78/n6iKUtZmH+zKRJApblIIKml
	 Ru1FlIMsExWsQ/8tt6iGVTCCjfBgZY1PZYKyG95Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@cqsoftware.com.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/39] LoongArch: Use "Exception return address" to comment ERA
Date: Fri, 15 Nov 2024 07:38:37 +0100
Message-ID: <20241115063723.588430133@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanteng Si <siyanteng@cqsoftware.com.cn>

[ Upstream commit b69269c870ece1bc7d2e3e39ca76f4602f2cb0dd ]

The information contained in the comment for LOONGARCH_CSR_ERA is even
less informative than the macro itself, which can cause confusion for
junior developers. Let's use the full English term.

Signed-off-by: Yanteng Si <siyanteng@cqsoftware.com.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/loongarch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 3d15fa5bef37d..710b005fc8a69 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -325,7 +325,7 @@ static __always_inline void iocsr_write64(u64 val, u32 reg)
 #define  CSR_ESTAT_IS_WIDTH		15
 #define  CSR_ESTAT_IS			(_ULCAST_(0x7fff) << CSR_ESTAT_IS_SHIFT)
 
-#define LOONGARCH_CSR_ERA		0x6	/* ERA */
+#define LOONGARCH_CSR_ERA		0x6	/* Exception return address */
 
 #define LOONGARCH_CSR_BADV		0x7	/* Bad virtual address */
 
-- 
2.43.0



