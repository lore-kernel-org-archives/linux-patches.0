Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD40DC433EF;
	Mon, 16 Jan 2023 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885733;
	bh=gNpQW9dZZFRYyMlS1QkVXN3xPQB/X2xHfD8nb/R8sYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnYvWSYwjx8YVQ4IswGrdApOPa01ZKmVW2KMI/W5+Dmw3rVyhpjGdkTBKJxcfYe0r
	 fLzaLpXe1S0N2kpwTfZ0CRU6yVawIVCPePmiD9Sl+Ly2eC7BaIb1jY/4PnyLnApUrV
	 QY/P4/eMA2kPJmXsWgJw+CcQkk7F/aSHxS+WR/GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/658] ALSA: asihpi: fix missing pci_disable_device()
Date: Mon, 16 Jan 2023 16:44:12 +0100
Message-Id: <20230116154916.972947351@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 9d86515c3d4c0564a0c31a2df87d735353a1971e ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release().

Fixes: 3285ea10e9b0 ("ALSA: asihpi - Interrelated HPI tidy up.")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Link: https://lore.kernel.org/r/20221126021429.3029562-1-liushixin2@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 9790f5108a16..5cab049413fc 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -352,7 +352,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 		pci_dev->device, pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device, pci_dev->devfn);
 
-	if (pci_enable_device(pci_dev) < 0) {
+	if (pcim_enable_device(pci_dev) < 0) {
 		dev_err(&pci_dev->dev,
 			"pci_enable_device failed, disabling device\n");
 		return -EIO;
-- 
2.35.1



