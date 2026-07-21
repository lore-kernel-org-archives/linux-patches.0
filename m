Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4AF418A58;
	Tue, 21 Jul 2026 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669639; cv=none; b=eggYHIZI1zoQ6Vcj8sdaPUnhreZAX4KBa5PsFiU67zVhHcMeYW3/zMk33BABLvSrWfRpWtr7ZDhd0XwlR2GIN8di+2UWr8QmmHDnn4QJsKxmCeRCr7xQ2l4UwTQv7vBTjypdy7Eo9h+o2syFBRIKG2al6awa1fX4uqW9x408wV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669639; c=relaxed/simple;
	bh=77trls0mbN1AumnAwiiyKlTo3IMEDZhKaSM+1pi3P4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MtAfiiz2XqoHQyM+DBOrAxeSwK4TzGk3kjqPFNKrqyeobR8FHMNNoV3uMh8WvI0jvr//ZJNVOMUBLDiiFSahSxuygsQ9+Vyvbyw8SMalQWBHHume60NlTq1CTfmQdcgqmNL47oszQOrWcF3m8CKX0JGgQ15DFyCcS7GMsiTboIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbSdPll6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbSdPll6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DA91F00A3A;
	Tue, 21 Jul 2026 21:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669637;
	bh=s7bV2KQO0QDT7Y8H5yVMzQ2L0zb5N2TW7jdvwdxoit0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbSdPll6UStE7HwpNWVhNxW6l8z+dR4Bpzf4UlNg2Oj1tUT2JItPdH86mrjNMKVED
	 kyzIc/oBbXOMmu2phtvowjI1C5VUfQBbJLYUWMUQ4ix+0zh+JNGW57mryN7XtKeEBD
	 UCr1PN1ZUhdU71o6tzd1OODf8wizxs07SYBqbmLw=
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
Subject: [PATCH 6.1 0630/1067] alpha/PCI: Add security_locked_down() check to pci_mmap_resource()
Date: Tue, 21 Jul 2026 17:20:31 +0200
Message-ID: <20260721152438.690211310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



