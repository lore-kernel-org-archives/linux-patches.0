Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4770A129A86;
	Tue, 23 Jan 2024 00:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971049; cv=none; b=RjjK1jLQ69NrrrdQty98SxM+DDLOEPYGtdEPKGjtUeOqjdmi8ynmlflpEqICPRhGvtPlaMQcAZrMw2/4yQQHIaQkcRvm8JsAJ1+r7DZR6E7Wl697GZ14oxULJqXrS/S8s4Bjs4Q9/utwsT1b+/SuknLrRwgOPCSzuVghw2X/snQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971049; c=relaxed/simple;
	bh=2KZ1YydOHFggzT7omPdVSeq6KeRGaq/o4qjuOBwJU8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE2i9F6hVsVgGAETnkl3tyRHDGXbUvKgePX5rU8LKqEx3N9vkQUBR/VFAZpoMJKUmu1WxjNS771qFTMQp8jM4HGJF2xxjyaze0kkJxkDQYOOWvAEYAcRMXY29O9ytMmpSsATSEKQlixddfG1u+UthOEAcjQBHrO6JU/tyAexv+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6goiCSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6goiCSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA7EC43394;
	Tue, 23 Jan 2024 00:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971049;
	bh=2KZ1YydOHFggzT7omPdVSeq6KeRGaq/o4qjuOBwJU8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6goiCSIxf5sF7IfxpwpwXQzqNGMhuO+DROoa2m8DQ33BnaJdDjJRPhmctSdO+sLO
	 YyPIpyUg0XZaryvhlQIExkPjWv4oWl5DRrVvKGFMssOAcxI1NlZfA2iKtQ3etgaU8P
	 EYC715GwgZx50iJGJo/7UxSnvcPvCAvYc91S5x/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/286] powerpc/44x: select I2C for CURRITUCK
Date: Mon, 22 Jan 2024 15:55:59 -0800
Message-ID: <20240122235734.075462409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 78ac6d67a935..9bc852c7e92f 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -177,6 +177,7 @@ config ISS4xx
 config CURRITUCK
 	bool "IBM Currituck (476fpe) Support"
 	depends on PPC_47x
+	select I2C
 	select SWIOTLB
 	select 476FPE
 	select FORCE_PCI
-- 
2.43.0



