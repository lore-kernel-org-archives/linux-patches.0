Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B81420CE;
	Tue, 23 Jan 2024 00:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968169; cv=none; b=dN22RgNu+50ZSVnFZQJSaoHus3Eh1E7b02bXrXvqaLg7zuy7CnHQz447VBKsitfcgkrmn/6Va5UqBNRMKaEN7fEZpz7RlDA2E3tbaklMZJi4Zm7LdQLMZW65jgUJguo/wBbgSWSgQ07zmBhrzPgqdqbiBaP7Kz3o5G6f0sjUHmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968169; c=relaxed/simple;
	bh=xRh1GHewGPHHCGKOyXG78oB8VzqbUPV82ZEg4mBZpMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIGB5U1hZ0+jkTOrobLm4qwJP3iwzykzwIw1fwKQL9cH8p4Y/ITgw4WRcpK3gOW/BoERwJ4htQikgEksAoUzEDTbjuKQPPbQg13vwwomT8+wOZMAYypmHezkIAQSi6Vew+wz27KDZRGjQkPEkmO2j8bU6fn6qgd//pZrsQaCTxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1s1pt+GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1s1pt+GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25476C433C7;
	Tue, 23 Jan 2024 00:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968169;
	bh=xRh1GHewGPHHCGKOyXG78oB8VzqbUPV82ZEg4mBZpMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s1pt+GVGIKcpAa36qdN3Miq06n7pJqcWIxLQV14MF25xIcd+rGxmWZGCw10I/UjK
	 Hdam35BrW+4DKmKNInE6DNDE0vSBv6Wclii+sc0Cw+RU+ASPd/23PkNcT7PHdgBoV1
	 ZsNEuXvkIljn3zDIyJQdGJ2/d/5Dt9ySdH3HXyy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/148] powerpc/44x: select I2C for CURRITUCK
Date: Mon, 22 Jan 2024 15:56:27 -0800
Message-ID: <20240122235713.659858386@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f024efd5a4c2..559577065af2 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -177,6 +177,7 @@ config ISS4xx
 config CURRITUCK
 	bool "IBM Currituck (476fpe) Support"
 	depends on PPC_47x
+	select I2C
 	select SWIOTLB
 	select 476FPE
 	select PPC4xx_PCI_EXPRESS
-- 
2.43.0



