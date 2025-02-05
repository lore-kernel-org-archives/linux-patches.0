Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F197E1632DA;
	Wed,  5 Feb 2025 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766344; cv=none; b=k2LAYt/vHEFVhM3PttimOpjgf5SRgerjLb7SepIWSYwt4YHd+9dpWKsLGGDpHEdLUszW9DBs8iu70vdLoHP+mjllQS4LErXo4sbAd9TJBrCffLQ724qMuw1/8RrPWQa6bLbjGjUpMJEA1SXAy6yfiuLoywybbbzVu66SZYhu1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766344; c=relaxed/simple;
	bh=LqP2VUzPkhKs6zFsAdYQq3kIXmq8jrY1KKjt065LMLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDzfMbq9kmtw1MVixq+i36slE9eMGCZYNqq6ldrnOMUHTW4Cib+D5cyeU6aYpRmh/k7H2MDn2L8RQCY/PJdhbr06psB7GO5ffMsWyDY8lALeS7kYp5RSLxxUhzTzuuMzJT0pIP0xL1INDfxXFeNtMwJnnyY1keUbh5yBueM3cVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIJwabXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIJwabXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F35C4CED1;
	Wed,  5 Feb 2025 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766343;
	bh=LqP2VUzPkhKs6zFsAdYQq3kIXmq8jrY1KKjt065LMLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIJwabXC6lDUDiHWc+I7VtPw8PXPV4+jKePMqJjvzYULtghCG6bKlkDa0JWIHpH1T
	 X5NDGpFgAbyulWzu4KGoaze+nZt6MuZBwD5x+eZxSLAGqK+GdFH+ALfVNPPl+adwrr
	 30I09Zv1lNCDCEyiPm9IZ68VJDONlH4DUbiLYC7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/393] RISC-V: Mark riscv_v_init() as __init
Date: Wed,  5 Feb 2025 14:44:33 +0100
Message-ID: <20250205134433.847588404@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit 9d87cf525fd2e1a5fcbbb40ee3df216d1d266c88 ]

This trips up with Xtheadvector enabled, but as far as I can tell it's
just been an issue since the original patchset.

Fixes: 7ca7a7b9b635 ("riscv: Add sysctl to set the default vector rule for new processes")
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20250115180251.31444-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 8d92fb6c522cc..81886fc36ed6a 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -270,7 +270,7 @@ static int __init riscv_v_sysctl_init(void)
 static int __init riscv_v_sysctl_init(void) { return 0; }
 #endif /* ! CONFIG_SYSCTL */
 
-static int riscv_v_init(void)
+static int __init riscv_v_init(void)
 {
 	return riscv_v_sysctl_init();
 }
-- 
2.39.5



