Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037672;
	b=GlED8CqfYK177QhPNYkXDyxtPA13RsYCIssVPR3SPhfwbSBFx5RMKmgv33NfE/r7l1H5
	 DFleC1pXn+9pci+HQUitk1io8WqMlVQ2NGZbMPGlvLmysTZgLZCvGDusFNQf4nIn7dwf0
	 EL6HpC6d/oLEdOADfOrCtedCuZwT6Fw3OD9owmWNxd4IYd0At5dUTOHUYuh88boWy3ICq
	 YNRrsvxszJoktQUWKXXBHT/LFpeIQB9i1llzP2QpMT/3D5noZFLd6rqZyhlu9O6Df+ezW
	 2tXW3nwXtvL2V2Tjqk2QNCwhoeWTGVX17++MCjy2oYKjvuONeMfI+CH6tpzVCJ/phsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wc8w4qziHXknXRZqJOxaqZvV5Th4HhcOh+KdBvkTgM=;
	b=BpeWJnFLEV7Fyw/xQ047AH6B8hc6Y66nKNmBNC5N660wslGisP88kiJTSwJ4Zk+WwCYk
	 bPbZe2heCrldaO2SXX0/iHHElF9XXzrWsaMJOXo5RZow3zOthnzpew7m9uL/PhxQpEKQr
	 Ne3DsvR3guZbk5guYu4sMhPvl6QHMP5wmiVikSO+giriKWl2yySyQinfHP3l0iu1eIepD
	 lHNQiLGr6SKdE9nSS9KqJ+MaihGzsPnsSMDvPcS4wyZsZlPToJhbDFLru0h4CY/f2Db8E
	 DURdscU11PCuAUZBrxB7M4FaVvxiI1+Zy/7IvIyAk1S5YWDiokp1OufaSPP3IkW+Amg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhoSIUm8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4555606A320;
	Wed, 18 Nov 2026 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhoSIUm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E56D1F000C6;
	Wed, 18 Nov 2026 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037672;
	bh=9wc8w4qziHXknXRZqJOxaqZvV5Th4HhcOh+KdBvkTgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhoSIUm8Xez6/8dj+bwQw57VBnfJtbOoG0yIcoBFXJL+a6y/buDmBj5UPadfZNJeX
	 nk/LM/W10aSTVSI0zNLY/yiGdkKEMtlwMyRwDLZHpwl2zxbhKI7bhyhMqZIRNYaEXK
	 rlRVkL4Cn/7dKuSuYeYyU+HbixJqDi03qXGPdVZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel test robot <lkp@intel.com>,
	Bradley Morgan <brads@mainlining.org>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1480/3318] openrisc: export __mulsi3 for modules
Date: Wed, 18 Nov 2026 15:35:02 +0100
Message-ID: <20261118150405.304435792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit 8ff981aa283a0ce516c2dc65a48a185ed336c657 ]

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it.
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/or32_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/or32_ksyms.c b/arch/openrisc/kernel/or32_ksyms.c
index 212e5f85004cc..c63d7f25bc575 100644
--- a/arch/openrisc/kernel/or32_ksyms.c
+++ b/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
-- 
2.53.0



