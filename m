Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C53942A9B;
	Tue, 27 May 2025 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368122; cv=none; b=MFZa3/CsFUulhruaYeg+d43wEWRASS3ZLtqNfG2km5rwi3wWG5qkoRofHXKgJxASaq3atELPwPzwsjWp9TMFjpt3Rh9GKY89qzfgqQRgXhHRLAnes8cASFwlZFIctCwit6C5wbaoh0YdtSFN+HGIuE/rTe7JyByRtsFhT0BbJEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368122; c=relaxed/simple;
	bh=gP56Edu/PLJEQFk6nA8JcAFDsg9cc4LXfCPPrpK46cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLLHzb5DThtsgJJhOK/xaBb1CeGiKWQ8COoNHefCqf7NS+/CuR7Gk7V1cUnuBe1zBP7PxWFYzxkcBuQLaHN0LIe8n88WMLiX+dE0/q2ztRNVtAjSp65v4WkhLoee+vycS9fbfmVo/98J7hCBYgAhca/FL0Gag75fX08Tc34FhI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLoIv++4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLoIv++4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62AEC4CEE9;
	Tue, 27 May 2025 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368122;
	bh=gP56Edu/PLJEQFk6nA8JcAFDsg9cc4LXfCPPrpK46cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLoIv++4ZQ5+T8LcsXkw/FcEaUY+X1zQKb2EBZY2J9YO7T+BtmOhAECH/YOR9x9UX
	 mvKtOHM0vJvtuwWK0x2eaK0+akUx4/y8ueai1TaoxRg64LJO6WYv4dbo6D6IN3CgXw
	 SKyhcX2gUP8y5PqFuEbEy1lXed5+w1dWbUXgS7Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 604/783] accel/qaic: Mask out SR-IOV PCI resources
Date: Tue, 27 May 2025 18:26:41 +0200
Message-ID: <20250527162537.755715805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <quic_yabdulra@quicinc.com>

[ Upstream commit 8685520474bfc0fe4be83c3cbfe3fb3e1ca1514a ]

During the initialization of the qaic device, pci_select_bars() is
used to fetch a bitmask of the BARs exposed by the device. On devices
that have Virtual Functions capabilities, the bitmask includes SR-IOV
BARs.

Use a mask to filter out SR-IOV BARs if they exist.

Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250117170943.2643280-6-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_drv.c b/drivers/accel/qaic/qaic_drv.c
index 81819b9ef8d4f..32f0e81d3e304 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -431,7 +431,7 @@ static int init_pci(struct qaic_device *qdev, struct pci_dev *pdev)
 	int bars;
 	int ret;
 
-	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	bars = pci_select_bars(pdev, IORESOURCE_MEM) & 0x3f;
 
 	/* make sure the device has the expected BARs */
 	if (bars != (BIT(0) | BIT(2) | BIT(4))) {
-- 
2.39.5



