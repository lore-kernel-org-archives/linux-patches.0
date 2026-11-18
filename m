Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052366;
	b=b2TDrcmZC5Zxb3ehXdjKjZsjt+Cz4ykWsjNTUNh/FrJloj8nQewVaLi1Nk/somyYds7E
	 iSgKsSNkHhltDK2L5XdlYkK12bDe+HJom8+YljnbMpwKBvL9M3nLh2HYgTLATbMDnAIse
	 sBpgGpZ0tXYFbew/Vdul2WDxBwwmTgezTtAbrsovNg91VQ7R1s56Nks9UmIV0mjao2+t7
	 qlt5agIqRMh1iOiG2dzJIZNTRGDROJxcYcb4uHTY/eFBAsUqz5CMdqI2tnpxbe6DH23j3
	 vxCTWDurHkMOhHQUoobKLgpNtUAOFMAvSYlBngj4vrHTYDZdep9c6PEx5O2EqHiWJ+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJJsKU8UHYLmuVrMwqhJ1lFuDgNSnAhtMm0A+QrczGM=;
	b=GM9l5J76CQEVtzerk/8ZDcUmmcWitont1RslMJA3ecIDGfBdkf2JXfIsdsuoAGCKZmNf
	 XtopFEXaFojmoGHvrCtzEDUlgrnkl35b1XyQPtTRIaZiIffKuBrWRPhVfIVddCReavzTC
	 NGPelQip/M4cxd8hhmqTYOCNtbVUEEghF1WG/g7Lx3uXxCC44X+qW98XvPYibhChPButy
	 ex+kxkmJYsliiOkT9p/Y5A18QsGMjlfomSuP47o0Xh2q/puWVgPeWb8GlvllS7w6itwuI
	 I+xbZcllea9k/WJQOT8WqL9PPlpE8WxWTAibth+BvOICY7wXHJLnQiufT/zKJF6gNjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Ch8FGuy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD8E606A32C;
	Thu, 19 Nov 2026 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Ch8FGuy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395B51F000C4;
	Thu, 19 Nov 2026 01:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052366;
	bh=zJJsKU8UHYLmuVrMwqhJ1lFuDgNSnAhtMm0A+QrczGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Ch8FGuyWJ4D0zjC3xgjWxSBTXC0bSrBsHK+sYoITPe3g4bpeDMfZ05EeX7wdJ1NK
	 uzp8YsmBt0oIIdPK1HxkPXSixctTe/PIiXlTGl593xwRRhViu7PTJ1ufHRiOXAUxlu
	 X+Y2wMbVZHyIXGwMIszIf+1bJat4mjeR63HJDO/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0539/2214] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Wed, 18 Nov 2026 15:36:55 +0100
Message-ID: <20261118150032.585459844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 1a122f5fecbabd47b81b1be3f0934f57b78aad42 ]

init_amd76xrom() obtains the PCI device with pci_get_device() and
hands the reference over to amd76xrom_init_one(), which stores it in
window->pdev.  When reserving the ROM window fails, that function
returns -EBUSY directly instead of going through amd76xrom_cleanup(),
so the reference is neither released nor cleared.

Drop the reference and clear window->pdev on that path.

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/amd76xrom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index 281fcbaa74e70..43411ec02ed59 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -152,6 +152,8 @@ static int amd76xrom_init_one(struct pci_dev *pdev,
 		printk(KERN_ERR MOD_NAME
 		       " %s(): Unable to register resource %pR - kernel bug?\n",
 		       __func__, &window->rsrc);
+		pci_dev_put(window->pdev);
+		window->pdev = NULL;
 		return -EBUSY;
 	}
 
-- 
2.53.0



