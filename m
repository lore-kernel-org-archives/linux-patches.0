Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D5312AAC7;
	Tue, 23 Jan 2024 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968773; cv=none; b=VcRqIVBCxT9kbOCrzXPaYWpmny3E1KvvX7zNEOrt7W88ZotwSTw17vlQp2CXSAUoi/hqGnpVv5fyJze7Ht2qPFvSFe++oUPBT9P1rJC9d0V6SMw4stgvtZegvakpEiGggeIzG3xY5MOyYbMGdFU6QUeyEVHIOG/dRMuCJBA/Gbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968773; c=relaxed/simple;
	bh=cGd/Bia6tqPrdPmR0hvCspoioc3Pizi/KtLQ8DqJyTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWuP1hL+B+L+M9CpKNMptu4tDpHcSgftKIM2lYHf6VrADyvBjPOFSrjf35T5YlzdJvrOVIXzHui8gemMywz7s9JtGsfC7fydMMdlCvg38K4384aaWdcCiPQZS9/zP85EpOrJVKTuKYLObbTZ7jK5pXUHDK79jVIDP38xqkneMoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usFPTfrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usFPTfrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46287C433F1;
	Tue, 23 Jan 2024 00:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968773;
	bh=cGd/Bia6tqPrdPmR0hvCspoioc3Pizi/KtLQ8DqJyTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usFPTfrfRMrjacenakmzIk/VDRslHe4w6Z9Iq8K/MO8ceh+ZZvS6GeCaVsf1Uj36e
	 ieqfUBLL5IfX7BTclQulOkyHrrGc0CVqkqulCth6DWMOnjVkBfOpdDRhKn4QQBP7Gs
	 BW34deF5AP6Rwnus0HZpXRwqr/W8o75qDKNGaqrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/194] powerpc/44x: select I2C for CURRITUCK
Date: Mon, 22 Jan 2024 15:56:13 -0800
Message-ID: <20240122235721.076952750@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 25ebe634a661..e9d3c6b241a8 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -178,6 +178,7 @@ config ISS4xx
 config CURRITUCK
 	bool "IBM Currituck (476fpe) Support"
 	depends on PPC_47x
+	select I2C
 	select SWIOTLB
 	select 476FPE
 	select FORCE_PCI
-- 
2.43.0



