Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043829;
	b=mjDaZ1TRqCyNeK/Cc6ZYjJ38/3V9RcHJGc0jYsbyeGKkWVK5ln/WCD75/Ze/IjuDqY4t
	 +qPZTYIYCEnnY+dNa26YT5+SKanFFLJzzHZNLTnvLstiQash9Dot0ybUl7kSBRsk91FF3
	 aIwfho5rCCuQ3ZqQ06H3nM5wUpuWNf6x/IkDeIdbmc35UPSg96Cn+GfiHrJD2fV1i5n4C
	 gzVrpbrjpFsimhPOVnzspzCDAPyatSX36X+e0XHvRJXbpnRXT+6UmlsX5XT+pSgKI9xx5
	 dulXqidaUFqU5EqNMck99uOo2ixllHwhD4kWsBo9Qpd8RuOBs5x0UXiP5tQdbhoJpDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5qNh4DincCAWEeGwLDnYzy6Mnl7Zh2y+8XMVrmN3r1Q=;
	b=HOnqhUOA/6AtQ7RUz2YbrRQtGwSd4ZUZXUUx0PEc11UZll/UJZRM0I7URY963b6Isjeo
	 /hA8berGZV5iXXZLHbknPmI3Knw3LaQKwC2MLNccRSDdBuui57OXfGC4gEpnRjCy2vncK
	 5zI7qfK+0vek549Y/vuM3PgwcpIcCNs1YBSh9oYjheRL0HZtxH5Gr586ZxcsnDUsDTcsX
	 4iXK34H3oy81PkZYLKkiMZuZfQMOVpI9no6Rg8DwZRldipG8pwjkHCro52xbr8yTSCz8T
	 pagGWZ7rcSMOwu572yJfPQGHIWhDbDNEWo5mIXSugSowV9aT/74jIVkfAX8M3SuGolA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9fnR2Sp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AFA606A320;
	Wed, 18 Nov 2026 23:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9fnR2Sp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CA71F000CB;
	Wed, 18 Nov 2026 23:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043829;
	bh=5qNh4DincCAWEeGwLDnYzy6Mnl7Zh2y+8XMVrmN3r1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9fnR2Spi3E+txWQb+0vchVdlF826HzGDdMGWNMfkVKtGaSlEXWAiQsavLIPhH3YM
	 6lhjvywNmeogcrijx2UlL1FQtC/H/lwYq2MMlFpvtJliFtxfi5+fGEMJA1i6Gbfg49
	 EC+v/xuTGk5pZv+y/qdo8tCP2zD01E+ZKDEvcEXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0349/2857] sticon/parisc: Detect default STI graphics card for console output
Date: Wed, 18 Nov 2026 15:23:03 +0100
Message-ID: <20261118150214.004109660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit de508ece1d37cdbbbfa52f074954310f9b066b13 ]

If a machine has multiple graphic cards, detect the graphic card which is used
to display firmware messages and use that one as the default graphic card for
sticon and fbcon.

On parisc machines the default graphic card used for BCH (boot console
handler, aka BIOS menu) is stored in the stable storage (equivalent to CMOS
storage on x86) or in the console path in page zero. Extract that path and
store it as default STI path for later comparism. Take care that the graphic
card can be a GSC or a PCI card which use different path strings.

Increase max string size for default_sti_path to 32 chars as the
print_pa_hwpath() function formats a hardware path using unbounded sprintf
calls for up to 6 bus converter components and 1 module component (e.g.,
255/255/...), which can produce a string up to 28 bytes long.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/sticore.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index db568f67e4dc2..07419b22534bb 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -284,7 +284,7 @@ static void sti_rom_copy(unsigned long base, unsigned long count, void *dest)
 
 
 
-static char default_sti_path[21] __read_mostly;
+static char default_sti_path[32] __read_mostly;
 
 #ifndef MODULE
 static int __init sti_setup(char *str)
@@ -1096,6 +1096,26 @@ static void sti_init_roms(void)
 	pr_info("STI GSC/PCI core graphics driver "
 			STI_DRIVERVERSION "\n");
 
+	/*
+	 * Find default console by hardware path which is either stored in
+	 * console entry in stable storage or alternatively from console path
+	 * in PAGE0 used by BCH and PDC.
+	 */
+	if (!default_sti_path[0]) {
+		struct pdc_module_path conspath;
+		struct device *dev = NULL;
+
+		if (pdc_stable_read(0x60, &conspath, sizeof(conspath)) == PDC_OK)
+			dev = hwpath_to_device(&conspath.path);
+		if (!dev)
+			dev = hwpath_to_device(&PAGE0->mem_cons.dp.path);
+		if (dev && dev_is_pci(dev))
+			print_pci_hwpath(to_pci_dev(dev), default_sti_path);
+		else if (dev && !dev_is_pci(dev))
+			print_pa_hwpath(to_parisc_device(dev), default_sti_path);
+		pr_debug("default graphic card: %s\n", default_sti_path);
+	}
+
 	/* Register drivers for native & PCI cards */
 	register_parisc_driver(&pa_sti_driver);
 	WARN_ON(pci_register_driver(&pci_sti_driver));
-- 
2.53.0



