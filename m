Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064157;
	b=mSmf6n9oxPUD/H0r5Z+F41HKPHBwur3xAv0NlcGdp1Dqp68hiisevohsY1s1WuYGJ9Iu
	 9Wxsx3xZ96O5Mi1HpdfxznXlF7Wdk3rss23lena/r9Z0a+m6OJhcx3P/VSniC76F946w+
	 4TCyV1HK8ZRLZ2LD0+OTF/pxR4oSAbzu8iI5HAY3Zc8UdDWaq9vXwlDzrAjwwAzR0EWHP
	 50rfytQEOAbO84zo4zH9Mca0vbKUqMXKQLfk7751N/Gg2mbYcpCYmfHbUZmSodI2vC/+9
	 2u3o7/VAsjUi+uMNT/5Aq7Cj8t/kIBgmD5jpuSYOs3/8q1aZD6RRtUcl/b2sR2nOxOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6m9LA4fEDn36SjK0p1z/jvA5dja+ZcScfSEjuyAp8Fo=;
	b=ye63a3T/DB2GGCxjaEp+QcSZDAlaMMCT5cYeq9Xaal86kh3zgkejtlJrQZlGsoyyp6MW
	 oEpDsWA5j9Y0sQRLB/KRkjgcQLIaz5ImQEZhTccpiaeYFvSg0SF2skH7wGWx6/3FpkPuT
	 dbtFtusDYD9gg+TYNQOBJqrBn4LvX1epUyux3vGCo9K69UJOv4e9Mc3XXIFhlZBr8T6VX
	 vA7RA0Tzeh0kcN3+vr2VICpkBFOaPD+6Lw/mG7/Jm3LXnPXyPVWJO8NBVrqPKrjozocHD
	 jdyt+YSUAqU4HRRH1xDTm6gf4QP/iyURjzoLVYWIoFxocPa7xisi9cF6ktm4qr9OSvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RKN3Mbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FDF606A32E;
	Sat,  7 Nov 2026 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RKN3Mbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A371F008A6;
	Sat,  7 Nov 2026 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064157;
	bh=6m9LA4fEDn36SjK0p1z/jvA5dja+ZcScfSEjuyAp8Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RKN3MbkZmC1kTlFodg/Swr6zy+VlTxVbbJIjdNXKVsNhzrzj5znhZ5q7ueLqY1r/
	 4UFS5HBtnaTxd+n7hsiIQtBsF0S7OuJ0bSb2JHIlVzAlOQVoIZTvAXWXGDu0qpio0m
	 ylhDV/yXfzd/w6o91n638hS78ALRwXcngBnH2K04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0306/1257] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Sat,  7 Nov 2026 08:43:22 -0500
Message-ID: <20261107134947.895519948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 457e6ab7f3fb1..0c3e0eb08b8d8 100644
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



