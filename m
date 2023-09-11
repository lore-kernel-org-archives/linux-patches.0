Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988A71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A819C433C8;
	Mon, 11 Sep 2023 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442042;
	bh=zoBDYUCnVSJ+lA4ymyEr/iITlW0wSBqtPAM/PY6su7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr/J/6fFpiu6+KNzythqR9afsXZkCrXvlt5g9nTqXEzpX+ySsOqie+Y1rvrnKypJR
	 o1Roix4ZNILduxEnj4Im2tzG8VDBh/Shi5zZ0lG4lStWXIr0+Gw+Ty6zzkYHFizSmP
	 FVwndwgObUcmL+3tC2UOG1Zho9bCqUkYuIejw6B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 626/739] um: virt-pci: fix missing declaration warning
Date: Mon, 11 Sep 2023 15:47:05 +0200
Message-ID: <20230911134708.582321752@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 974b808d85abbc03c3914af63d60d5816aabf2ca ]

Fix this warning which appears with W=1 and without CONFIG_OF:

 warning: no previous declaration for 'pcibios_get_phb_of_node'

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308230949.PphIIlhq-lkp@intel.com/
Fixes: 314a1408b79a ("um: virt-pci: implement pcibios_get_phb_of_node()")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 7699ca5f35d48..ffe2ee8a02465 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -544,6 +544,7 @@ static void um_pci_irq_vq_cb(struct virtqueue *vq)
 	}
 }
 
+#ifdef CONFIG_OF
 /* Copied from arch/x86/kernel/devicetree.c */
 struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 {
@@ -562,6 +563,7 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 	}
 	return NULL;
 }
+#endif
 
 static int um_pci_init_vqs(struct um_pci_device *dev)
 {
-- 
2.40.1



