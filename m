Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018F522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77874C433C7;
	Sun,  9 Jul 2023 11:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902536;
	bh=/UyJFN8YF2iwl/EKXJKmFOlG+TPPmgaKLa2LZEvvaHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsmgbxZAj9UIHToET3Gu+5z/iqREd7j9vCCdEclEFa1gUsu+95E10zgqrQnl6jW1O
	 EKks8rOfcTqTMBrkrj0ng8WZj91ykVFDXzK49Gikgwzo4D3wiGaoqQByeadbSbngF2
	 /BXH/G7PtCen346WFg18+QOj7A2I6BDuUUwMVY+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shunsuke Mie <mie@igel.co.jp>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 394/431] PCI: endpoint: Fix a Kconfig prompt of vNTB driver
Date: Sun,  9 Jul 2023 13:15:42 +0200
Message-ID: <20230709111500.409919626@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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



