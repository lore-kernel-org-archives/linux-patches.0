Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5872610;
	Thu,  3 Jul 2025 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554062; cv=none; b=YnBRs4XyhDQFWNYigJ8UCZ62kfj20WxlsELKM3wS/PsYopeoJuNdYhhNg7tmWiOsxjKGYWMEqLFuvSPfu3k6CIWn88W2pxmOO0vB38tDIYT9s+ImAeP6ruQc2APnehUXR0I1csltBaV77bJ/LQHNb8Mg2Kk0rCa6TQZlWGM5yAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554062; c=relaxed/simple;
	bh=vAJ7GZwL+QLJEkyaKfZghcWzcdTPSz+s9eJXZFXiTps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6hFOpWZ7OYjF11Gi6dohUy1LWmcNtSSdYo+40ktjmoUqRbDIDS95XS8rFXcs7tWzX9GLdGLcZjvt5PFBv77LLgxmHJYxWDZZV23m87v8/9LUkTXixL707N/DixDBTOk4tsJ9xMMhLIe9oDfPXkylSMwpurVw37Ti2zdZPXzr3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5KOFN/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5KOFN/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176EBC4CEE3;
	Thu,  3 Jul 2025 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554061;
	bh=vAJ7GZwL+QLJEkyaKfZghcWzcdTPSz+s9eJXZFXiTps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5KOFN/WwdceWFUE/1MfIHaXdunKVAXUVBp7p8XywQUEO0gvZejGmD70sOkOYHBq7
	 sQzkw2yVKll+QsJKKXCoS2E2n7u4xGWmwnxsboDFJ45oz1TKMe2MFnYh6zd4Ff8vqp
	 N++pb96BOdXh94Kc3yO2Dm5qOQpLJkmoxaIHqgNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Marc Zyngier <maz@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/218] PCI: apple: Set only available ports up
Date: Thu,  3 Jul 2025 16:40:17 +0200
Message-ID: <20250703143958.699279553@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit 751bec089c4eed486578994abd2c5395f08d0302 ]

Iterating over disabled ports results in of_irq_parse_raw() parsing
the wrong "interrupt-map" entries, as it takes the status of the node
into account.

This became apparent after disabling unused PCIe ports in the Apple
Silicon device trees instead of deleting them.

Switching from for_each_child_of_node_scoped() to
for_each_available_child_of_node_scoped() solves this issue.

Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
Fixes: a0189fdfb73d ("arm64: dts: apple: t8103: Disable unused PCIe ports")
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Janne Grunau <j@jannau.net>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
Link: https://patch.msgid.link/20250401091713.2765724-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-apple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index 43280a366266b..16725f9536f65 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -789,7 +789,7 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 	if (ret)
 		return ret;
 
-	for_each_child_of_node_scoped(dev->of_node, of_port) {
+	for_each_available_child_of_node_scoped(dev->of_node, of_port) {
 		ret = apple_pcie_setup_port(pcie, of_port);
 		if (ret) {
 			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);
-- 
2.39.5



