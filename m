Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065515;
	b=EcWaidaEBitdZmfnFRVWDggWORx3uPTMfT+TcPxIDBv+Y8Fafr/WnYBm1ChgieGgtadm
	 mF51PgOEWeEqM3jt4aRcdhioo8tzRpcNbJEheuZ7VkAzWYXn471pM4WRX4ZkpS60M/Bxx
	 mO7r9Tq2zFL2rOs3i6X9wsvWfBwW1zAkOisXvw3jtCj+1p7haruU7G24GEkW50uBY5Huz
	 NpC94s+3TlaAJ32EHrnIo1iXEQK/ZESlqYdsb4ea/muyRa8rpO+QZBbZrkMGXrz49HFaR
	 8To9Oc/yE8UqUn3fZolTuf1OSsVRl4jnhfUPSsdDJYHKkKZ2dR2hJbPw1c9YnYReOIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPg829iKgvz1nadeH/X19UkRSnBt7EBl1DtS5/N9ehE=;
	b=KUpBsBsFhtvAWTanXKmdRrixKt0hUxBb6uIzXCFZxDWuxXjEgHoV60iHXLveLhWgoODo
	 65ycmMLPPLkZDzQY5pyVLEhOBCeMP1aq2tqZoW3kljmceokilgaSECc/O8kiOezMmFq2H
	 3DK4HRj7i+kIvCPEDFeuNUEQFSl9Wlt/JxNEz8vXYmCYHbZH0DSUhnZ/LfUx/p6Ou8rhY
	 BJN2HCEm+JQ46V0TioGFoBHNBc3fJNBVyp6EeRrEihuIoP5cjo12i53RcV5KmVRsprcUv
	 ii8DmkFVXtpubIr8Uie0vtxJnJLzedC6jeI9Hzqc6kVvXvKCXqZGU2WDvxumkUx/Mog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3ILkfcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DFF606A32C;
	Sat,  7 Nov 2026 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3ILkfcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38E81F0089F;
	Sat,  7 Nov 2026 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065514;
	bh=HPg829iKgvz1nadeH/X19UkRSnBt7EBl1DtS5/N9ehE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3ILkfcL+cyUOWV4Kh5DTdsVPjOP6Lkvq9lxtvR5HUB/6U/n5uIxUfVMF9cjmL7/t
	 hDL+Ag2wL3aEqN58Aoom8KAyA/fdgMzJ3lCJEWcJjWFN41XeuRh6ljNKHneoCoOtfa
	 2MsrkYDtfWg+8QEMnRykYj9qaIm+SVLJbmwAg9Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1197/1257] soc: loongson: loongson2_pm: Fix build warnings for 32BIT
Date: Sat,  7 Nov 2026 08:58:13 -0500
Message-ID: <20261107135012.221573359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 48b960ad7057f84a375ae7ec803ea3ba6b038b5c ]

Since loongson_sysconf.suspend_addr is unsigned long, use "unsigned
long" instead of "u64" for casting, so as to avoid build warnings for
32BIT:

   drivers/soc/loongson/loongson2_pm.c: In function 'loongson2_pm_probe':
>> drivers/soc/loongson/loongson2_pm.c:178:49: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     178 |                 loongson_sysconf.suspend_addr = (u64)phys_to_virt(suspend_addr);
         |

Cc: stable@vger.kernel.org
Fixes: 3d9aba6618d1 ("LoongArch: Adjust build infrastructure for 32BIT/64BIT")
Closes: https://lore.kernel.org/oe-kbuild-all/202610190549.WM2PO3vO-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/loongson/loongson2_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/loongson/loongson2_pm.c b/drivers/soc/loongson/loongson2_pm.c
index b8e5e1e3528a6..1e2c897d055bd 100644
--- a/drivers/soc/loongson/loongson2_pm.c
+++ b/drivers/soc/loongson/loongson2_pm.c
@@ -175,7 +175,7 @@ static int loongson2_pm_probe(struct platform_device *pdev)
 		return irq;
 
 	if (!device_property_read_u64(dev, "loongson,suspend-address", &suspend_addr))
-		loongson_sysconf.suspend_addr = (u64)phys_to_virt(suspend_addr);
+		loongson_sysconf.suspend_addr = (unsigned long)phys_to_virt(suspend_addr);
 	else
 		dev_err(dev, "No loongson,suspend-address, could not support S3!\n");
 
-- 
2.53.0



