Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC614A82;
	Thu, 12 Dec 2024 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018868; cv=none; b=nz7lvbHzovJByfraDocBDEcIfSWGh8gCYd4SHFx+K17E+hBPApGLfSsmUdbGUtzzK/pi2N9lz1IAQbj6ix6ty5bpvCVF+9+42t2fkdo7uwJxSm1rOf25J8EblEr9y3Fvfa7YSaY0yG+++QnHMeIuFVpQ0+IYGOEFwqEFleKSles=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018868; c=relaxed/simple;
	bh=4QKlJNBCzqSLhdCZ067AuM2TLRGYwkczfhYkjSl6aKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boN6t/32K91FZpilLR08twZ5DSbLRbQmOUi1UrzeiH2isWS+ZinCMafKjxuFSE6YS2yPBMah0HqjwL8MGQiTbhrchLAtVrGG/Og3Uhmj+mJ69oyxq2VIjqSPV4939hKABNEq0yl8KXaoLFRoxjH2HNhHLwiH/wdiO4kLpLZZIa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqnGW9pF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqnGW9pF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6520AC4CECE;
	Thu, 12 Dec 2024 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018868;
	bh=4QKlJNBCzqSLhdCZ067AuM2TLRGYwkczfhYkjSl6aKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqnGW9pFk0lPMz2d+SKlPLb2ZW2QFp25xW4FZpPcAPVyXtYj3Nwc/3GFOSs/FM1pm
	 wNSMuxOrhG5rZFB5AIQA3ulFljP/c6cn9OZehemyBn5lYdtoFWdSc+PUAUfhCaXRcI
	 ps0U180Ul9AQFpbNXUmVsKOSkWOZFxTt92z9h4Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/772] m68k: mvme147: Fix SCSI controller IRQ numbers
Date: Thu, 12 Dec 2024 15:50:00 +0100
Message-ID: <20241212144352.218173725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 47bc874427382018fa2e3e982480e156271eee70 ]

Sometime long ago the m68k IRQ code was refactored and the interrupt
numbers for SCSI controller on this board ended up wrong, and it hasn't
worked since.

The PCC adds 0x40 to the vector for its interrupts so they end up in
the user interrupt range. Hence, the kernel number should be the kernel
offset for user interrupt range + the PCC interrupt number.

Fixes: 200a3d352cd5 ("[PATCH] m68k: convert VME irq code")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Reviewed-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/0e7636a21a0274eea35bfd5d874459d5078e97cc.1727926187.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mvme147hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index e28eb1c0e0bfb..dbf88059e47a4 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -93,8 +93,8 @@ struct pcc_regs {
 #define M147_SCC_B_ADDR		0xfffe3000
 #define M147_SCC_PCLK		5000000
 
-#define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x45)
-#define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x46)
+#define MVME147_IRQ_SCSI_PORT	(IRQ_USER + 5)
+#define MVME147_IRQ_SCSI_DMA	(IRQ_USER + 6)
 
 /* SCC interrupts, for MVME147 */
 
-- 
2.43.0



