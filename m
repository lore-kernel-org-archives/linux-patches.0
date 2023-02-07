Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E453212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C23C433EF;
	Tue,  7 Feb 2023 13:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774965;
	bh=avgIJFoAwkVyXw+pmuHPyUQL4/YLW9nDIp6h6euGxg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTJhSnxGWWTjz2S23lZzIWEdBGzsJib75vIKmS4wzYlH06pM9xrIh+kM7Ggse0HmF
	 qDF/UUvkLuPw6xfcYtaHUmQ+Co+rsYHewq+GJgglnoTD2odI5ZwBVSMYeeI3t4Zl49
	 QgWPdIR2gYnO9Cjwzu6wTrUDx1/ScYKEnLTCcays=
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
Subject: [PATCH 6.1 093/208] i2c: designware-pci: Add new PCI IDs for AMD NAVI GPU
Date: Tue,  7 Feb 2023 13:55:47 +0100
Message-Id: <20230207125638.575540559@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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
index e499f96506c5..782fe1ef3ca1 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -396,6 +396,8 @@ static const struct pci_device_id i2_designware_pci_ids[] = {
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



