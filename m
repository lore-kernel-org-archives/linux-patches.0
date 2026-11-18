Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039596;
	b=v4MgoEEvOn7cU3pElFqDgKrilMKas3iEY10/QHduXXI6iO7DAaw8fZZlnYv0u1rXlvS3
	 cNstuoZZiglavMRyPd53qKrQ1PuS3Ld4qlstm3iJmu7XOHcUnvCBt+Lhr0wTUQfo8j9lL
	 /EaePKW+TZu5Xob5MJkoYkBOfBxsUOYTsGU7pa18hJ3UbrMSL+eW/z5c6KynGpZQAS4vN
	 1LLNxfEmvbbkit8jen9n2V67gAXSm2Hz1ruAmqEq5QRCUs6pBaPMh+j6US+yQ2oafFHzE
	 o1VcTjC5GwyW1GghYVtZ0lGmaNIYjf80fjvtp7iGUTlNKsi1BYH1OYMMjF9KEX5nlxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qvEUSq7sONuqctvruZ+16oOj5JoUHFS1iuw7DsLHpOs=;
	b=1sI6Yfwxh7DcCS2ijtIfj0ijqhn32drQsJD0ITjMDmMlCi2qnAYfRk/lm201L51VUFbX
	 Vru6N4uUAEyjSvGrg07AREvT6rQLVo27D3DkxFXJCqR9KZDESmYZk/apaJBjJ5LEI1xyd
	 CkQ0vzJISZ1fAaLFUzDYP+a0CXMMqKU1qzcdGz/4wRUP3R87WwDQnHdEPq99rlbtEOCCM
	 j0UYtA1ns/v8dddZSbPNFRfoaJn2KhGjETotG1PDu9pJaaN12xDbSC1qAo/+Dd8ONmc2i
	 mU35A72JN5vJUVQVPhb3eDjC16HTnq/k4biRrP+ug0WkjFzj1hRliKOJcA5uyCEflZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNvIZP0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2635F606A31C;
	Wed, 18 Nov 2026 22:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNvIZP0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0231F000C4;
	Wed, 18 Nov 2026 22:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039596;
	bh=qvEUSq7sONuqctvruZ+16oOj5JoUHFS1iuw7DsLHpOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNvIZP0tnGtMetGUVPQ6lsvy71gpa3raIRANhshnQAeZyIs2A9FLRCB5tr4QSKa9F
	 u1MPvZGYkP+E5ihqkr/JbLjRVWgbLcHMxMs3ZNKnDABGp07RM2aYO8FlR9YM4FCNOt
	 zh+vF5uHgeGqyvG26ocOxbOpz+v60ztcy93GBDjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2140/3318] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:46:02 +0100
Message-ID: <20261118150426.259686501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit b9022584ebbae81f7bbe4a61bd1df0d0a95e1a99 ]

xgene_pcie_init_port() obtains and enables the controller clock manually.
When xgene_pcie_setup() or pci_host_probe() fails, probe returns without
disabling, unpreparing, or releasing the clock. A failed enable also leaves
the clk_get() reference unreleased.

Use devm_clk_get_enabled() so the clock is unwound automatically on probe
failure and device removal.

Fixes: 5f6b6ccdbe1c ("PCI: xgene: Add APM X-Gene PCIe driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260802221146.573233-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 4c14911170a4b..f0cc52dc4fa9f 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -321,18 +321,11 @@ static void xgene_pcie_linkup(struct xgene_pcie *port,
 static int xgene_pcie_init_port(struct xgene_pcie *port)
 {
 	struct device *dev = port->dev;
-	int rc;
 
-	port->clk = clk_get(dev, NULL);
+	port->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(port->clk)) {
 		dev_err(dev, "clock not available\n");
-		return -ENODEV;
-	}
-
-	rc = clk_prepare_enable(port->clk);
-	if (rc) {
-		dev_err(dev, "clock enable failed\n");
-		return rc;
+		return PTR_ERR(port->clk);
 	}
 
 	return 0;
-- 
2.53.0



