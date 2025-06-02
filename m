Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8398220F07C;
	Mon,  2 Jun 2025 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875564; cv=none; b=NDNhurqjQ/nRDMLpaSeDQAiG6eBI3kuORpiRukU7it5tfQyveCMbiancvLW0KaBC41XZguSs+PXHXO0C1F6DdW9WzfaMsPZm8Xmtmg7hQn6564/uBAIcsaij5ZgtZRIcdKIZpIOtB6azGzko9ny0sVeBbsHn3cx4N23StLuxYhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875564; c=relaxed/simple;
	bh=3sEHSVKNLM21dAS0waLbeV/TYn/m1O/4GXHTGQn5iKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hilSkDwmpcdqheBKYe39cr+GS//fZjG0RRg5vxRlIIbVi/mCOPfy+D9EptAoEQCX6B+6g2/WKUDm/7EgvCFBtMvqd6Aartz/kzr2z40N5iFy7wmOAqffoJgi9MuruRj0IrU2jlIgDQ1INGBoiyibOMBDkSn7RV7kp04tPkWWaQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXU9DxvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXU9DxvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C974C4CEEB;
	Mon,  2 Jun 2025 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875564;
	bh=3sEHSVKNLM21dAS0waLbeV/TYn/m1O/4GXHTGQn5iKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXU9DxvQHuJ8s5b0T1m3lr6Kfo+YBh44UuIidYoAt1q4/az96lVk6Y5TKfw0vHCEZ
	 1UnfsSVpjHk/zShgHiRdwc5yOh/vsfXubnP+j3M0ktcmYvoc26S7IXd0L+jkvEI3jN
	 ZmBvqvc1EeL1cQezqZ+a46DVcrEOXj7DHpF1nRPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/270] PCI: brcmstb: Add a softdep to MIP MSI-X driver
Date: Mon,  2 Jun 2025 15:47:40 +0200
Message-ID: <20250602134314.370531498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

[ Upstream commit 2294059118c550464dd8906286324d90c33b152b ]

Then the brcmstb PCIe driver and MIP MSI-X interrupt controller
drivers are built as modules there could be a race in probing.

To avoid this, add a softdep to MIP driver to guarantee that
MIP driver will be load first.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20250224083559.47645-5-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 2fc4fe23e6bbf..85be07e8b418a 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1326,3 +1326,4 @@ module_platform_driver(brcm_pcie_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom STB PCIe RC driver");
 MODULE_AUTHOR("Broadcom");
+MODULE_SOFTDEP("pre: irq_bcm2712_mip");
-- 
2.39.5



