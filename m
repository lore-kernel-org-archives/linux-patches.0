Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062990;
	b=gITO/iicDNUOHFcLL5LgoJJAylNshjWRVhfCoY4pZgVh3oNBkwaACaazoXUtdtHyn6tU
	 P/TfKafNQ7f0Bde1GHoP3c5gpZXEQpcv1pR85uwNSJ6pJBuc010Fn8Koo07moonlYGy/U
	 U6viB3oxEZ3867JMz3wDtg74MlhBmySeJ/+MKKblTfH0PlUrFLrntVcrQCT0i2vKGO7Re
	 y3KRi1MBMB1sV56CO0y6EKgLqWdv5c8dVAvY06GaMRKnVQYjvCTzj83aXLxxnJc8HSU2W
	 Wdyz7tjQRIzGliH1Jv7/e1mEgjyn4/Bp3Kr0i0lglXO8Q5LGo/KSjJaotriTg+AilVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Puqiu9vmfG0Pv9TSFnkbxyTiLKtP4JUPtxfGh5qOlyM=;
	b=T0enSOHEaqyjlsUxkJ9ToCYgABp426zpllUdmOM5TTSIYAPWjqz2VWQ6V1azoXP7d20M
	 K8hdO1iHeJmPEtNLL6K7h/bGj6NxOjHATg+DSA0P6Xwfa6Ffvm5SryV4ecxzf9jRcjRaJ
	 PI8tqBZT7zSz8KYI1+r0zdOxB7Cvs7pFfxaCedfCHnDPP77m2eR8MPet1Q1pXh0h8n5vt
	 FbV6Rk4c7B/s5t6ndHnwGkoOC+AgzIzIWp4dSpXwHhi3GeaGh9HMRzCl4Q0xqcovam8DY
	 aZwVU2R2kN/VSXRH2xUFyYl0PKbmIg2rh6kQ0JkH/89KjbYXJmPquHKAiVGaN2Vw3Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qOGy5/9S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE4606A331;
	Sat,  7 Nov 2026 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOGy5/9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8EA1F0089F;
	Sat,  7 Nov 2026 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062989;
	bh=Puqiu9vmfG0Pv9TSFnkbxyTiLKtP4JUPtxfGh5qOlyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOGy5/9Sb0ie1GfWPEi7+a+4HHyQkbl/khh1DtVD/CvYgoyi7+7VlTKcNmKK+A3xa
	 3oOhp+GWmwL0XdWsNMcsdfbguPC/TZhOMEjPw6MxcZg1K5Jx/ZNGHLJw2D5HSVNfrB
	 ciaGXg1wMfniv2F/d8n7dD9daeEHX1gRVl6/BcWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/869] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Sat,  7 Nov 2026 08:48:49 -0500
Message-ID: <20261107134900.160731841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



