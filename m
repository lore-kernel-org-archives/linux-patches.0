Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041311;
	b=joOpk/d3EF2nPnnr4vS+2/w8Etp0opCqG2iiTBxNTCKPO0mmqJWsX0NBdEtQXJ5HW0mq
	 MZbdmmDxTNaLSBsAKsUhtFhkrymhgphs761b9wSt5a5nVmWvkOF2sewuj3dFCDoi66fkY
	 8YInHKYQHymtTeBibxh5gY+GPHNer8rMdxNBB4+z/cczWAllIHbldph7vyNF2qkxfealU
	 OhyD7JwsapVZiOO+mIIGePEcYZypItn0DP1k7o+Z3rmlwX1LNV7hsTt0XoR4JGw8Gspia
	 fb5U2J7CzCj4sjNq9vCBe5phzo9JBVMrVNE9wZrhETrji8DOlI54AI5OPsjoc716cvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=puwaE6Jq48sGV8z0Lzm59ggJHV1yq3vZl2/A70wZH/I=;
	b=GMZ4Uidc5OU07HwtK+IWbXaMxQrx6jUv7z+tREYp0sCKY3hQdkG5Lg0NXSBcCABttQxH
	 M9cVQT+V/7lMioBDlE0Wg6zIQHqTWIb46yEBE9vLT233VGIcoeDMaHdbOrvWmJH3QiWjU
	 cwGTl6y6JbKcidXASpQXNIQ1kke2Bt9Gct1H7EsqbezZgr0wtEoxJCfE7ut9HLPIMENJo
	 mmc0QcEbSGFA9rZf79tUWRwx0uH030+tbFpQ3Syhx0I3VVHL3Sa3yVoDhVfi9+gYtvzcG
	 3S/ljx3I1Rk8s/jMMO4PIxChThQUP5zxGi9bAIFkxr/PXKU2ApE0ugZi2FZKNx2zQUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbZwgEr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15634606A320;
	Wed, 18 Nov 2026 22:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbZwgEr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6802E1F000C4;
	Wed, 18 Nov 2026 22:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041310;
	bh=puwaE6Jq48sGV8z0Lzm59ggJHV1yq3vZl2/A70wZH/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbZwgEr89bEA07CKX25ahj5rfWz49jwXkAnm8I/EX5UaC9Eyc06TzJ1I/UQvv3kCf
	 6y8Nz4mHwBRP7qmLia0t5RVd1an24A+A8u01HvK+DNLOwWKmYZgbNisAZ7Ge7AS9y/
	 nUmZEmBCmPVteAD2Uu08Duxjszg4P7FtjC3ZAG1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2769/3318] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150443.784878034@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit b71e0bb7ad40c005b167e9b48be3af5a3fa51974 ]

gxt4500_probe() adds a write-combining range before allocating the cmap
and registering the framebuffer. If a later step fails, the range is
not released. Add the missing cleanup before unmapping the framebuffer,
matching the successful remove path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 38fc4d45fae5 ("gxt4500: Use arch_phys_wc_* for framebuffer")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/gxt4500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/gxt4500.c b/drivers/video/fbdev/gxt4500.c
index 15a82c6b609ea..138f5efbf4f40 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -719,6 +719,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_free_cmap:
 	fb_dealloc_cmap(&info->cmap);
  err_unmap_all:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
  err_unmap_regs:
 	iounmap(par->regs);
-- 
2.53.0



