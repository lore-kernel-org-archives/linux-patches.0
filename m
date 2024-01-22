Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D38256754;
	Tue, 23 Jan 2024 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974023; cv=none; b=JrWIrEdaFtOfReyYjuOXbqiNT99hJJrfcWjIBq3Ssztdj7Y8kSY36cddLAdq9GAIQKnsxQeIeOS6Lij47V3zc/nGdJh3fvFqWj+8pluBJA4lvtqLKrJYvXXtQaqSbbgg6b0moyAk2Vy6vjK4013m0SWpfGhAlzRxARn8JFDfQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974023; c=relaxed/simple;
	bh=2Jp3aKiq6qrikJzGCNSej93OQ8xeN4sg5nM2c8uHMzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9M+p9xFxvbN4zjBl8LrlmRI/ekTAhOqGI5EvKzjLUEfC3AX0qYoYPpi7kriqMcC/jBSzEO6o1Eoa/wVEr8PyeGA/nqxOtlaT6e3r84aRJPYVJydozxJCGSvLs+Zlra+/YlRPuyWrtO9v6wWK1Xzt2Pw7BSSglTUUg72wQFN1AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/APKJ7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/APKJ7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F75C433A6;
	Tue, 23 Jan 2024 01:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974022;
	bh=2Jp3aKiq6qrikJzGCNSej93OQ8xeN4sg5nM2c8uHMzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/APKJ7Ug1XWFVlSilWGO9IqPJNRjtfqLSFoK/9qUyAv3AYiFsV11Y6W2eVTsKQiv
	 0bKqje4FN3MkM8wE6KZ+7yAxs2tgRB2KKL3QK5TIhmdYCoAI17REZTHRoXIyQJpa3A
	 cGISv+epkexgcYPKzHUi2/hFN95saVwAfsc6wunI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/583] powerpc/44x: select I2C for CURRITUCK
Date: Mon, 22 Jan 2024 15:50:57 -0800
Message-ID: <20240122235812.429422327@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4a74197b65e69c46fe6e53f7df2f4d6ce9ffe012 ]

Fix build errors when CURRITUCK=y and I2C is not builtin (=m or is
not set). Fixes these build errors:

powerpc-linux-ld: arch/powerpc/platforms/44x/ppc476.o: in function `avr_halt_system':
ppc476.c:(.text+0x58): undefined reference to `i2c_smbus_write_byte_data'
powerpc-linux-ld: arch/powerpc/platforms/44x/ppc476.o: in function `ppc47x_device_probe':
ppc476.c:(.init.text+0x18): undefined reference to `i2c_register_driver'

Fixes: 2a2c74b2efcb ("IBM Akebono: Add the Akebono platform")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: lore.kernel.org/r/202312010820.cmdwF5X9-lkp@intel.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231201055159.8371-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/44x/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 1624ebf95497..35a1f4b9f827 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -173,6 +173,7 @@ config ISS4xx
 config CURRITUCK
 	bool "IBM Currituck (476fpe) Support"
 	depends on PPC_47x
+	select I2C
 	select SWIOTLB
 	select 476FPE
 	select FORCE_PCI
-- 
2.43.0



