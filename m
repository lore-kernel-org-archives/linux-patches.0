Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D89634B1A6;
	Tue, 21 Jul 2026 22:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672030; cv=none; b=OPKReX1r9mqPzy6n9T3+g2evj69NZio/JMcqt6ZgtwoQMc2XRzl3h60CRKwAwVTfAHjLVdg31E/TquRzdS+AfSHBO9cBnrodjlfabGBn5qy1H3T8s2Pks+8ZeubxWlRk5GDInQhiEC/Yzd1Z6pI0Qm2tuBksVQt0wLgnvdywy2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672030; c=relaxed/simple;
	bh=YtR5MaPFd01Gr/JOEldCa6HBT6etej5GSfbOo8U9pUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZIHFQ++jDYi6rgXrKrDRG/xiaIAusyFcWYiJ9G/5XkfDiB5kOM+fZ+y2Nnb0O3QR1SwGrWx5A3dtwTKo83ss3EbLFmxUKxZJv9y/WoYgP+19JzjrGuZ8l9QyCk0fpN7DxAvBpJ3yWS8g4J4mBNwVBg8uuaK4aVs9bL/YI9CCDM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkAR2hrZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkAR2hrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1951F000E9;
	Tue, 21 Jul 2026 22:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672028;
	bh=lUZLuMzNkEJx1/21VQf1b0VhQ6VW5AmXiv08OxantkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkAR2hrZsw3KHjf4xQ1kvkRqvi2hrEiPozygfFSvCmN6eC8QsCVZJhu2lOjpiqtGm
	 MF33Bls8sc9KkHDBI0OoipJrtqvPRzb2IdoC4b3XUJMaq9dKhZPE5fkOtccUF6JBP8
	 l91xUyz7zENU8VTFwyO1Npc/R8T2kSgm6o14aK30=
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
Subject: [PATCH 5.15 470/843] alpha/PCI: Add security_locked_down() check to pci_mmap_resource()
Date: Tue, 21 Jul 2026 17:21:45 +0200
Message-ID: <20260721152416.610681098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



