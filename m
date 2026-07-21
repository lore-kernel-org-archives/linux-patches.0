Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97F146F4AB;
	Tue, 21 Jul 2026 19:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661259; cv=none; b=gO2iNsEIggpltCzjh3Z28W8Dm+r/D6gWHXD3qZyabN4IfF+qni9NFsNVM/z3KDg8snU/B5ZvorhML75cbS5TQOauh7SmnbPNPqUBBRb5qRAxP1t76/tyrJL4hk56Bst57jpw2FmGVvQBfreBt5CyLynFIAsy/4uNYyAE93d5Gnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661259; c=relaxed/simple;
	bh=xxfgTcTvfE3Dx9QVjgA0ZUwEdWXnAtmzJi9GE41HxII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mb0t38YYf8W+19No/KbAio3EXCJ58AbhsfSphEaVq6nPnqoHJsC04k1AF8ezY4QJ79568C4P56iPeXitzkMQ+gypZF/MGB64JZn+IUVDwC7iTGnHSNvt/uCMUCRcc2aGjwyhCV5aWD3IX5Ol4qwdqxAGYX6onUpGU3A/KI4pHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opYfFlco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opYfFlco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54CF1F000E9;
	Tue, 21 Jul 2026 19:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661256;
	bh=veFfC9J4fc8jdh+h4TiXyN48ai/LPyMpflrGy5OccrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opYfFlco6qKAWwHo3eY8KwoV0VbZEU2qkZZV1Tlm3gt1LDf4uI7A9r2c68z1aJjq9
	 i8q27WelUbwonZOyu57PDQb4BOxZonP5YjJ2gx30AfhcUD2h8moXT8NFrGcSnMtTC0
	 Qow4D/41s6siqnCkXdTYDXAQyYMsxbqjyspG0dF8=
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
Subject: [PATCH 7.1 1247/2077] alpha/PCI: Add security_locked_down() check to pci_mmap_resource()
Date: Tue, 21 Jul 2026 17:15:20 +0200
Message-ID: <20260721152622.225228233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3048758304b57a..2324720c3e83fb 100644
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



