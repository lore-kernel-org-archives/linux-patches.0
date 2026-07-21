Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A253B4E9B;
	Tue, 21 Jul 2026 20:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666716; cv=none; b=qrVESAHE5CQ9xrHUmyBNFuagBhlk+MwVTC9JvPupSaDVJu0VVFFci1ZoU5grsUJ/GLn61Sxe+H/CqKTOowoL0S7a/6/hie7mq6E6fslSupDUfb30VegOWk+0dRwmK2X1nuMki/DGY348MhlNVJ3tdX/zhAd5Zzs2QJNCIBWOB9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666716; c=relaxed/simple;
	bh=q58flGjCj73SnoAYzTF523agiNwL+NuqL/n4z7f1VxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rmc43IWFZJfmD7/wrcanFcClh/LJmw3JB7ZHaOmCUT93IpHpqh1DpqcrfkBR9ZhJxg7m9p2lkls2BRZb8fPvb9yPo8VMJGCTh4HHZEFkxXuqBZ8DgSINz8p8kxBSmXimsITfbMJCDJ3yC6AA+IvC6tCyFvVFhW3pmyNvUlFv91M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vW4n6MEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW4n6MEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D977D1F000E9;
	Tue, 21 Jul 2026 20:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666715;
	bh=weynd1e6o7873x8m/O5GDNxX//aE6s8FUX+A4umPx5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vW4n6MEz7hQWrQdrYgXUmqhRVMX1+hASzLXGzcwnYR9zTEXQKSiHkHmccFatY9RqL
	 OTeiuUZenSz+rKPW+SVi0AugqKtLZYOr2by0LdEtpQ+u24CMj/X1ILL8cD8li9328m
	 4SOlO+BroNbDZPUn/df/6kECN8SOvOoLGpCas+Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0781/1266] alpha/PCI: Add security_locked_down() check to pci_mmap_resource()
Date: Tue, 21 Jul 2026 17:20:18 +0200
Message-ID: <20260721152459.338307608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 78a228f0aa0e9eba31955950c8a40a9945e2c8bb ]

Currently, Alpha's pci_mmap_resource() does not check
security_locked_down(LOCKDOWN_PCI_ACCESS) before allowing userspace to mmap
PCI BARs.

The generic version has had this check since commit eb627e17727e ("PCI:
Lock down BAR access when the kernel is locked down") to prevent DMA
attacks when the kernel is locked down.

Add the same check to Alpha's pci_mmap_resource().

Fixes: eb627e17727e ("PCI: Lock down BAR access when the kernel is locked down")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://patch.msgid.link/20260508043543.217179-12-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/pci-sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
index 5808a66e2a81f7..80a5fd642e7f32 100644
--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/security.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -71,7 +72,11 @@ static int pci_mmap_resource(struct kobject *kobj,
 	struct resource *res = attr->private;
 	enum pci_mmap_state mmap_type;
 	struct pci_bus_region bar;
-	int i;
+	int i, ret;
+
+	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++)
 		if (res == &pdev->resource[i])
-- 
2.53.0



