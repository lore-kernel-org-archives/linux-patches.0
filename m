Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB215C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0286C433D6;
	Mon,  5 Dec 2022 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269346;
	bh=l4hRGP9qF5Z8s2JuGgAM+kA6Ts73sYSxI2trf5o3kSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyYaB+YLUaeUL1Cegv8Uc3IQME1zieoQdFxGWuwxq2PT9kr07lxu6/JSOiys99ZUI
	 YiGZOAdzocZB36gy8/0AKCCW2s/yBR4hXGlgGTQ36nye9RmVEdt07Cd6h+ds69quEG
	 alm4G6X00GTXP1Wq2pLtXCJLEgXyjTCV1Ose52HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/153] hwmon: (i5500_temp) fix missing pci_disable_device()
Date: Mon,  5 Dec 2022 20:10:18 +0100
Message-Id: <20221205190811.435137401@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3b7f98f237528c496ea0b689bace0e35eec3e060 ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release().

Fixes: ada072816be1 ("hwmon: (i5500_temp) New driver for the Intel 5500/5520/X58 chipsets")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221112125606.3751430-1-yangyingliang@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/i5500_temp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/i5500_temp.c b/drivers/hwmon/i5500_temp.c
index 360f5aee1394..d4be03f43fb4 100644
--- a/drivers/hwmon/i5500_temp.c
+++ b/drivers/hwmon/i5500_temp.c
@@ -108,7 +108,7 @@ static int i5500_temp_probe(struct pci_dev *pdev,
 	u32 tstimer;
 	s8 tsfsc;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable device\n");
 		return err;
-- 
2.35.1



