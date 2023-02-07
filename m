Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4982C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255A6C4339E;
	Tue,  7 Feb 2023 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775469;
	bh=ORxyPurPUpb2eVfx7B8dQLqy0+8bI7l7yIYrqlAgWos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8ZGLJPXarvhdh0BvrO100hp6cr4eYR29mbN1qyQVIaJ0DsNg5kiGX+E3z82ZVe/j
	 CGQEt3Ug2l6pofvqcmeWjYjz5PQP95IBkpD86Z7l9h9fQNoOPvb9KkmzpGNqniildx
	 StrqXTtyR6gjCxJ3X3v7gssROisx+ycEWUYzwnP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Sanath S <Sanath.S@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/120] i2c: designware-pci: Add new PCI IDs for AMD NAVI GPU
Date: Tue,  7 Feb 2023 13:57:02 +0100
Message-Id: <20230207125620.950133320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 2ece0930ac5662bccce0ba4c59b84c98d2437200 ]

Add additional supported PCI IDs for latest AMD NAVI GPU card which
has an integrated Type-C controller and designware I2C with PCI
interface.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Tested-by: Sanath S <Sanath.S@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 5b45941bcbdd..de8dd3e3333e 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -398,6 +398,8 @@ static const struct pci_device_id i2_designware_pci_ids[] = {
 	{ PCI_VDEVICE(ATI,  0x73a4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73e4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73c4), navi_amd },
+	{ PCI_VDEVICE(ATI,  0x7444), navi_amd },
+	{ PCI_VDEVICE(ATI,  0x7464), navi_amd },
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, i2_designware_pci_ids);
-- 
2.39.0



