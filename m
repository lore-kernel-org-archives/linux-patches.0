Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E5515C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D86C433D6;
	Mon,  5 Dec 2022 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267549;
	bh=4ZfV3xv44CazYl0RmDdeim8xMxb7/xuxUyKKs+BBSC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h66SFwyqNEBk0lXvjnvr+mWmLDbLCHhczBQq48nFW6jHECRFWv51d/QzCyIeRFqK9
	 ljyt4pPKnrAaxLwbin7hYha9c2RB5F3ZYMgGp88gudUYPxWl7zATFDRD8M3BPGrCRr
	 ENtVKmRLYSNL3OcOwrApcMXylFWgzXeDx+M9MIyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 27/62] platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()
Date: Mon,  5 Dec 2022 20:09:24 +0100
Message-Id: <20221205190759.123550442@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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
index 4ae758c3d8ba..9f6e462c57fe 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1111,6 +1111,8 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
 				cpu_to_le32(ports_available));
 
+	pci_dev_put(xhci_pdev);
+
 	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
 			orig_ports_available, ports_available);
 }
-- 
2.35.1



