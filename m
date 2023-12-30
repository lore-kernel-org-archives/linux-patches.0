Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194CD8483;
	Sat, 30 Dec 2023 12:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRcFbQPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9665DC433C8;
	Sat, 30 Dec 2023 12:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938115;
	bh=C+6sOcmXyIWn8sLEUUnFum5FYCUAs9uAVKArBmAe3V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRcFbQPotoyYKJ1iNcExoqjlp41D8UAZ3BQRSVR4WVQo0Mo2Rmbmz6ponrVxtBMjN
	 jx6lGrb8i9MsxWy9Nb5lMUvHHWpamKKMasu6o1HxA31hoSL7+oJtGm+IVYRzJbygNr
	 GdEGYpGV3/0qU/+lxyTVc/nkEDe7t+TI0NnqXoT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/112] net: mana: select PAGE_POOL
Date: Sat, 30 Dec 2023 11:59:06 +0000
Message-ID: <20231230115807.810902711@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 340943fbff3d8faa44d2223ca04917df28786a07 ]

Mana uses PAGE_POOL API. x86_64 defconfig doesn't select it:

ld: vmlinux.o: in function `mana_create_page_pool.isra.0':
mana_en.c:(.text+0x9ae36f): undefined reference to `page_pool_create'
ld: vmlinux.o: in function `mana_get_rxfrag':
mana_en.c:(.text+0x9afed1): undefined reference to `page_pool_alloc_pages'
make[3]: *** [/home/yury/work/linux/scripts/Makefile.vmlinux:37: vmlinux] Error 1
make[2]: *** [/home/yury/work/linux/Makefile:1154: vmlinux] Error 2
make[1]: *** [/home/yury/work/linux/Makefile:234: __sub-make] Error 2
make[1]: Leaving directory '/home/yury/work/build-linux-x86_64'
make: *** [Makefile:234: __sub-make] Error 2

So we need to select it explicitly.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Fixes: ca9c54d2 ("net: mana: Add a driver for Microsoft Azure Network Adapter")
Link: https://lore.kernel.org/r/20231215203353.635379-1-yury.norov@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index fe4e7a7d9c0b5..8b6c4cc37c53c 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -19,6 +19,7 @@ config MICROSOFT_MANA
 	tristate "Microsoft Azure Network Adapter (MANA) support"
 	depends on PCI_MSI && X86_64
 	depends on PCI_HYPERV
+	select PAGE_POOL
 	help
 	  This driver supports Microsoft Azure Network Adapter (MANA).
 	  So far, the driver is only supported on X86_64.
-- 
2.43.0



