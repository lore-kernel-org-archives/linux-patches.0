Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E0139579;
	Tue, 27 May 2025 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365784; cv=none; b=DxtKbZBxhTakwCSopC+eLaxMgeJUI0csDHIv3CreUxkFpjFXHyEbhaKtTCAea4X2G3WOPGOL9nSfc8bx1cl7bbbl7f8ISVf7HtADzjnSG8M8MBHbhYh7IAKJ0sSz1z4IiQPJcc4+iN5TPpygu0PBqpshi6HRT7DKaGFvmKVIJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365784; c=relaxed/simple;
	bh=KZsgiC1cnc/OHE2zn3tnJFceDSaNwXf2u7TpXcCZzaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEOULc/emcySfKkoN62rW6/yxvx14WJ9F3CymfGlohbSGtPGmKTQ7vpNTf/lWXR2cT5//nvLwiHqW7kJZ92ZbwqZh+gnX0LFQKntT8xeoSxwGtQpVxbz4SSk3QCKac773cHkXic9cygAHergZhDK1ShWk6ucM5/MUwKHmLZDNkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKPBg+R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKPBg+R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4116C4CEE9;
	Tue, 27 May 2025 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365783;
	bh=KZsgiC1cnc/OHE2zn3tnJFceDSaNwXf2u7TpXcCZzaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKPBg+R4hm48t5eqZh++iHBqJFqxRuEPiK57jjs9iC2SHueLczCbt8ghiDFUoujVF
	 4TPrkfYxfGtmz3WJmuuuKLvtt7tRC2oUeJxqFnibioMgmi+muA5oBGp/bwLSVgUfFO
	 ulXeJME5Z4d81b19zJwOlOkwdwTQSAdgbx2zaXrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 488/626] accel/qaic: Mask out SR-IOV PCI resources
Date: Tue, 27 May 2025 18:26:21 +0200
Message-ID: <20250527162504.808933407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index f139c564eadf9..10e711c96a670 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -432,7 +432,7 @@ static int init_pci(struct qaic_device *qdev, struct pci_dev *pdev)
 	int bars;
 	int ret;
 
-	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	bars = pci_select_bars(pdev, IORESOURCE_MEM) & 0x3f;
 
 	/* make sure the device has the expected BARs */
 	if (bars != (BIT(0) | BIT(2) | BIT(4))) {
-- 
2.39.5



