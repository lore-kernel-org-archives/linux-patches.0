Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B51DDC1B;
	Mon,  6 Jan 2025 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179274; cv=none; b=uqoZVRYCyueN5I/lJiQEf1lNNp8DOtw+03n8fOeXz2878Yw1KfFlBDgGvrjkXPde2fbhJgNbAH3tB2KeKPju1IUQB4lVFwoqNNCI7oHJ7vTsR8T9GoSCabkHi43T0/mPFHBdWUEtRD9Fo77mGKi6JWh4376cCj5Srn6C59txoQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179274; c=relaxed/simple;
	bh=LXsYLOk1cjR5a0dBpGRG5Yhk+aNrhZ80y/BEHr/Nxpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWGHzq2T1sJ9l24DYnSSVBEyvLoizW1bQXTAUuzrevaxo+2tDVzGVavLO4vKzmBZ+GRSXgHYvlaUBugHq8iZxU2q6SEXGZuPY0me9o7SCvKRTqQEgcYLf1eNN2bK7rZhJJ3DmR6OwD1AgUw04RLHV5O+weduI8RhkSyJ6NvZYA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxS5aeX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxS5aeX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB19C4CED2;
	Mon,  6 Jan 2025 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179274;
	bh=LXsYLOk1cjR5a0dBpGRG5Yhk+aNrhZ80y/BEHr/Nxpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxS5aeX5jtGxYs6ryUCg8d2lx46vYVBkBJR5ZWVb9mqpw/OjrbfhUDFs4b1GaVbtw
	 8IefPPz6sm4mW2BZnZZyIJwPp5EXoMJPu39EnFiG8Umh+P56PMopuILQ6JS3MuFDbq
	 tfa/0kgE08dW0+bC6SVGTdixfx14yXFD0/dTvpVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	WangYuli <wangyuli@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/93] MIPS: Probe toolchain support of -msym32
Date: Mon,  6 Jan 2025 16:17:28 +0100
Message-ID: <20250106151130.667939481@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9ff2c70763a0..e2a2e5df4fde 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -272,7 +272,7 @@ drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 ifdef CONFIG_64BIT
   ifndef KBUILD_SYM32
     ifeq ($(shell expr $(load-y) \< 0xffffffff80000000), 0)
-      KBUILD_SYM32 = y
+      KBUILD_SYM32 = $(call cc-option-yn, -msym32)
     endif
   endif
 
-- 
2.39.5



