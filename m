Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13E08F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4462FC433C8;
	Sun, 16 Jul 2023 20:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538660;
	bh=/UyJFN8YF2iwl/EKXJKmFOlG+TPPmgaKLa2LZEvvaHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QezsCjqrX9t6INp2zJ4yRVfAOGAC10zzLFrfE1gwXw5aNdvN5HDvawAQYoRo5VNDZ
	 jYGwKt7ppi3kA/EjxEAjKpe5e6NgLBFbhsYpVwnM1TdYEqZ2s50NmdfZpVoouw2ZZ1
	 T8diRfHRvMtQ+i1kfipYuREpGiNMbbhrBLKsZbH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shunsuke Mie <mie@igel.co.jp>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 495/800] PCI: endpoint: Fix a Kconfig prompt of vNTB driver
Date: Sun, 16 Jul 2023 21:45:48 +0200
Message-ID: <20230716195000.578892660@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shunsuke Mie <mie@igel.co.jp>

[ Upstream commit 37587673cda963ec950e4983db5023802f9b5ff2 ]

vNTB driver and NTB driver have same Kconfig prompt. Changed to make it
distinguishable.

Link: https://lore.kernel.org/r/20230202103832.2038286-1-mie@igel.co.jp
Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/Kconfig b/drivers/pci/endpoint/functions/Kconfig
index 9fd5608868718..8efb6a869e7ce 100644
--- a/drivers/pci/endpoint/functions/Kconfig
+++ b/drivers/pci/endpoint/functions/Kconfig
@@ -27,7 +27,7 @@ config PCI_EPF_NTB
 	  If in doubt, say "N" to disable Endpoint NTB driver.
 
 config PCI_EPF_VNTB
-	tristate "PCI Endpoint NTB driver"
+	tristate "PCI Endpoint Virtual NTB driver"
 	depends on PCI_ENDPOINT
 	depends on NTB
 	select CONFIGFS_FS
-- 
2.39.2



