Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562416FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC3BC433C1;
	Wed, 30 Nov 2022 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833066;
	bh=uXpxl+oNrqOgw8cAenGOZxGgnyLWKKoZP9SOwKNlytg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/cY7q+/SP6q/Sn/9MdHeJzdthedSU4dcVhPwdrkxcj05mxGfXDFO8BdGnabuxZrH
	 qexmuwMobxp4r/oMXJ67cawf3zsWIuGshEJzsNnULbyKwQYNb51KnMTlPM5aozyA45
	 DJfiDgPWuCVVAvPV94ejLSWoGKFb61WB0gdlK3GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/162] platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()
Date: Wed, 30 Nov 2022 19:23:40 +0100
Message-Id: <20221130180532.251981586@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit d0cdd85046b15089df71a50548617ac1025300d0 ]

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
before asus_wmi_set_xusb2pr() returns.

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221111100752.134311-1-wangxiongfeng2@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 39e1a6396e08..db369cf26111 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1212,6 +1212,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
-- 
2.35.1



