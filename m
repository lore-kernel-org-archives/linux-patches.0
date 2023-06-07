Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9038E3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0ABC433D2;
	Wed,  7 Jun 2023 20:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171600;
	bh=cWB1dZy+1AbY9jcNQa0xPC8wJXDRMfc8M7uaWfwUlok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfXVC9vIhEvl0uh3DjycicfJ97nQqORo9ocX2YcpT4qWZJ+OU2qlvWq6qkRwYiew7
	 Xht90jUvUvPEEfn6zgi3Rh40FhotPhpcLexfNB27SXV4eB9mtpx/tPnlbxfZ94ver9
	 PG7NecldDzPhpUqGNwv1C+7Msxpgr6idfRJBtNDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Winkler <julian.winkler1@web.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/159] platform/x86: intel_scu_pcidrv: Add back PCI ID for Medfield
Date: Wed,  7 Jun 2023 22:15:52 +0200
Message-ID: <20230607200905.291444034@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Julian Winkler <julian.winkler1@web.de>

[ Upstream commit 4a9b6850c794e4394cad99e2b863d75f5bc8e92f ]

This id was removed in commit b47018a778c1 ("platform/x86: intel_scu_ipc:
Remove Lincroft support"), saying it is only used on Moorestown,
but apparently the same id is also used on Medfield.

Tested on the Medfield based Motorola RAZR i smartphone.

Signed-off-by: Julian Winkler <julian.winkler1@web.de>
Link: https://lore.kernel.org/r/20230416154932.6579-1-julian.winkler1@web.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_pcidrv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_scu_pcidrv.c b/drivers/platform/x86/intel_scu_pcidrv.c
index 80abc708e4f2f..d904fad499aa5 100644
--- a/drivers/platform/x86/intel_scu_pcidrv.c
+++ b/drivers/platform/x86/intel_scu_pcidrv.c
@@ -34,6 +34,7 @@ static int intel_scu_pci_probe(struct pci_dev *pdev,
 
 static const struct pci_device_id pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x080e) },
+	{ PCI_VDEVICE(INTEL, 0x082a) },
 	{ PCI_VDEVICE(INTEL, 0x08ea) },
 	{ PCI_VDEVICE(INTEL, 0x0a94) },
 	{ PCI_VDEVICE(INTEL, 0x11a0) },
-- 
2.39.2



