Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2682463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A429DC433D2;
	Mon, 20 Feb 2023 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901242;
	bh=85VMH/1lZVswfIyXaXbLNR+c6CWzvM7lOPM8oTT+CeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPXOrcwxH4MZHYd8TlLtlOHHObWMz571sfWl0C44CIYTIuEZ4PuyttUh7bBmR/BdK
	 0BU4ikrYejeg/k0QEYVzKbCKGyZ/K2C+uaZa1xa3+dETlDaAaxXHJD5xroqALVTuc7
	 FnEXBU7Ri5jNYycLfud0z2MqtNaxmvKlBlgVJHEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 83/83] platform/x86/amd: pmc: add CONFIG_SERIO dependency
Date: Mon, 20 Feb 2023 14:36:56 +0100
Message-Id: <20230220133556.648532475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit abce209d18fd26e865b2406cc68819289db973f9 upstream.

Using the serio subsystem now requires the code to be reachable:

x86_64-linux-ld: drivers/platform/x86/amd/pmc.o: in function `amd_pmc_suspend_handler':
pmc.c:(.text+0x86c): undefined reference to `serio_bus'

Add the usual dependency: as other users of serio use 'select'
rather than 'depends on', use the same here.

Fixes: 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230127093950.2368575-1-arnd@kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -171,6 +171,7 @@ config ACER_WMI
 config AMD_PMC
 	tristate "AMD SoC PMC driver"
 	depends on ACPI && PCI
+	select SERIO
 	help
 	  The driver provides support for AMD Power Management Controller
 	  primarily responsible for S2Idle transactions that are driven from


