Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA215E8B;
	Mon, 30 Dec 2024 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573851; cv=none; b=M+ZTNIoWHNx/Q+FLqIbHRacfQMD+GC8a5GZc0ZfREeaARJQeoOwe+oeGs6BmPqiN6IMzPArvYnpnUA9TMyw7XAEiqmd3zK06qv4aDv0HYUjyfe2XH8o1EPqyXvDqsopJZC10VWHomHbjfrFI2AqS/8MvGnAn/r3h+pRYoD1MaLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573851; c=relaxed/simple;
	bh=EFDBmvbgKXUDFbFHtxo6ChDXr+l1nkscXDJdlUnbL8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV9g4HdGod5ZjAzV/0YqX22p/6ttoyXlquSoA2Bwf8v1IWKfedSOYkEu0TjUTRX0ulGEag9YPyu7tyVp+E3va+yhUXjW8T2W/oaUZKctyrDgHUomTRKTmNl+A4Lx2Q9M10rmICnNo3PREA7kByFxJANIphwiF0yXfEkT4qMbcf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gf5/ldtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gf5/ldtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9B5C4CED0;
	Mon, 30 Dec 2024 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573851;
	bh=EFDBmvbgKXUDFbFHtxo6ChDXr+l1nkscXDJdlUnbL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gf5/ldtxtoAs7NTYc+1m5VGVeH1ez+s8znmna6byOkNK5+Eix+DDqqowYk4cQSPiH
	 qi50jVRZbjLWvBC/Iyout323ZGRM223frKs/ulwOja+5Ryf7w94y/zZqGFzIbLQG6l
	 L4cfEh3s6kkKE2A44B+MmISJN6LIKYKrQMzi6Y8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	WangYuli <wangyuli@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/86] MIPS: Probe toolchain support of -msym32
Date: Mon, 30 Dec 2024 16:43:00 +0100
Message-ID: <20241230154213.699625999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f49807e1f19b..0888074f4dfe 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -299,7 +299,7 @@ drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 ifdef CONFIG_64BIT
   ifndef KBUILD_SYM32
     ifeq ($(shell expr $(load-y) \< 0xffffffff80000000), 0)
-      KBUILD_SYM32 = y
+      KBUILD_SYM32 = $(call cc-option-yn, -msym32)
     endif
   endif
 
-- 
2.39.5



