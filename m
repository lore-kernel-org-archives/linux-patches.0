Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC62D1607AA;
	Mon,  6 Jan 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178767; cv=none; b=DFjWrnIfYum6bC8I6ik2uhJpp9LGV6mK070vuTSt9CLw5IsmOfKZFZKu7ywErdc/iTgsowAVrlHfvA/JMVkFGQx6EQ5r+sHqWm5J4FIPNcZvpZvbwYPfcn+75N2Qb6W00DLFeR+GLUlTDJ5O463T4ictW+g27/YJTmmjMWGLB1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178767; c=relaxed/simple;
	bh=YV7BUOxzTyxSzjeewyuUD4pctxiHzeqcVRp7QrEitro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mawbNNwixep6DPY6hKZmt6p2bvSItBu6wKIDkPDVR08wqMeYmqWpM6jVspRnHUK/+v/dxw8qQ32tSR/p9NuWuQFBe8TK+G93oGWsOTV7rbCajW5/EklZXwvMLWt81OMldfRiRqgjnI8th7PS/fZjAS/8nSbsQod6cPR4cjOi758=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ta+GXY8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ta+GXY8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AA2C4CED2;
	Mon,  6 Jan 2025 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178767;
	bh=YV7BUOxzTyxSzjeewyuUD4pctxiHzeqcVRp7QrEitro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ta+GXY8CQSRuCchzktYGGkegRqI8IKHaeYzfxMfnMmvgwsw5Jr03SBQ0TicyYml1m
	 4FhJIeZJq04aq5Ud05m5TUnSyOdy9mQF8UhU9Urq1DNil2REGbiIlFfBrn9W2ArFPt
	 aBRoaXs/52uS4zionwCKhoIdP3A9VkSGWnOUhJ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	WangYuli <wangyuli@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/168] MIPS: Probe toolchain support of -msym32
Date: Mon,  6 Jan 2025 16:16:34 +0100
Message-ID: <20250106151141.711234038@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 18ca63a2e23c5e170d2d7552b64b1f5ad019cd9b ]

msym32 is not supported by LLVM toolchain.
Workaround by probe toolchain support of msym32 for KBUILD_SYM32
feature.

Link: https://github.com/ClangBuiltLinux/linux/issues/1544
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 3830217fab41..37048fbffdb7 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -275,7 +275,7 @@ drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 ifdef CONFIG_64BIT
   ifndef KBUILD_SYM32
     ifeq ($(shell expr $(load-y) \< 0xffffffff80000000), 0)
-      KBUILD_SYM32 = y
+      KBUILD_SYM32 = $(call cc-option-yn, -msym32)
     endif
   endif
 
-- 
2.39.5



