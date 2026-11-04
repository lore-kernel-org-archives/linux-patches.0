Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831224;
	b=3ZbZN8xm5x7twgLx5jYq4+paTKHb6RnHZUIakciC/82Km86WG5gObsvEaFfCgygOEoJh
	 Rl1ntZqp88gBSxByXYJ15xo/g2lllxBsvYsuXZWii/XDYBCO6X9srr2BNW7eepWn1AicM
	 MdednvPh7GOJLh0uTMrV15KjZYh0irr7VproKHqATMRMzGCFFANnVnubIGh1xKmWy5s64
	 EQy3gkdCuZ33P2GTpuETfYw0h2Wy7Y+4KeIc2F67RoUp0CjCpTKKenQAIGhSOP1bvpeaa
	 hLQ45c0ykqcFSZ6sUyz3C6SHGDqa2jG1s1vdcNjKsHFZKrXUxpmU+FHaiIsyhhwkuvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4CxdRv7tfcSnnEAtQnDwH67dPUBKJXXUS/6CrDFWK6k=;
	b=RfsWydq9UUaq7sgeZ4EeRZSk2GojQSECp5/ojtPz++HBbwjQTIvjQMW7LAL69fgpbgUD
	 x6mratOh09LcF4FhfuHwDQ8klcNnEIQXaDwL/Ukm163Sqk7BcJTMDtToRHbKfflm+wQ1r
	 Ag0zC5gfAjXW6fiPebBWffvCB0NJtKFzW9dId91x4AKrFoQU0eow+OWF3/MRPe4+A83n8
	 1Omae2SlI9tmR7uSk2VkgFtNvX3YyNSpdWav7rlAXfTDlK3skoGoRgomE8dMWfsoFa545
	 lLiwW491/p9gq7qfrjQah5qP716Rl6sdLTIrxhGu46quvBq71IpJSwYKtbcJyJgPeRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNYNTKXX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FC4606AB34;
	Wed,  4 Nov 2026 22:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNYNTKXX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E271F000C1;
	Wed,  4 Nov 2026 22:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831224;
	bh=4CxdRv7tfcSnnEAtQnDwH67dPUBKJXXUS/6CrDFWK6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNYNTKXXzyYix3VT6FRwT7b85CQw35zGjHtJXyZ3M672723pvjgiUMNPzRCrKT6zq
	 ga1+h+2kC9GGVuCNeNpWin0iBqX7AmvJbQyg7DRFSPrhi2XXk9n/n13i5tCjvErsN0
	 Q4wDofr5ZR25RTW8IkJvOhLIad0U6SveETv2x208=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0574/1005] MIPS: Fix HOTPLUG_PARALLEL dependency
Date: Wed,  4 Nov 2026 16:05:07 -0500
Message-ID: <20261104211059.948576038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit c8610c021be3808f0913b8d79822d22e05a5fbcf ]

With MIPS, it is possible to have SMP enabled without HOTPLUG_CPU
selected. However, in kernel/cpu.c, some code that uses
HOTPLUG_PARALLEL also requires HOTPLUG_CPU to be selected. Therefore,
we should fix the HOTPLUG_PARALLEL dependency to depend on
HOTPLUG_CPU, not just SMP.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510270120.21wA1aX1-lkp@intel.com/
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: bbc448c541ed ("mips: select CONFIG_WEAK_REORDERING_BEYOND_LLSC from CONFIG_EYEQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 83a6b68d8a39a..d87db7c535ea1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -658,7 +658,7 @@ config EYEQ
 	select USB_UHCI_BIG_ENDIAN_DESC if CPU_BIG_ENDIAN
 	select USB_UHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
 	select USE_OF
-	select HOTPLUG_PARALLEL if SMP
+	select HOTPLUG_PARALLEL if HOTPLUG_CPU
 	help
 	  Select this to build a kernel supporting EyeQ SoC from Mobileye.
 
-- 
2.53.0



