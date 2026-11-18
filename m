Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045168;
	b=OPgNZTXETTpaY/pvJFfSWs0/HZsRky7tCKg8Y4pWE1hdKNg7iDae3NnA4XVFPS0Meygo
	 f+O3W0Y6eak5uThyI3X6F5eVyJAIgkcWBhVlO/mX4iVfYatukkzdM8//dT/QwQxkhVc7N
	 8bN/x8D8cCQX3oZO5zuo08HbcDwKiKmIEScl1DX/JU5VUyayLzeOpvfxShK1z6cYIGk0w
	 Fr7k7HeaQg3efnIkR4OXI3fkYFfl9spvDcymGUB24kPPdzwyUQhxyK0qmnM2xIpgAY0Ot
	 AzjBxv23UVXn5noRhRupljiokTTcfSwXzKe9WOWtELredPwtIYhlwGJdcG/jI9bayYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJTyC6ewfBJKaR8ApmC8ABS311FYZjBm9EhKc41kDAo=;
	b=NUZtnxY1czHvtF+43ywKLNd0zKhH+AuquuRFdIqGlkaQrwGDGdvmYKI4gd1hEAEJC54t
	 E/iTubv3V4rrgP5L4IE+ETXcY9l9ABIvDee6Tjp6voifFbZT+v3QF4W03ZuZ/K9Ay0Xcj
	 i417dH0i8XwfdvXQTp2qz0LGYgjault4rzjmb1vDJ9q/XlhlLHkNdRwBO5hfqDYh+7spX
	 gVakNsLIymZW7QCeqiy/rYNSghRObNDBQfAqaozBXFXdI8YrihdtsoB0wSRLo63URH2FZ
	 cLVjrd6bwWQ7ZMck7sPkMjtUS7kI1rEtLJ4xNZNYvWUV29iH2917o1ObNCghUoMK/Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XxPPX31j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A60B606A320;
	Wed, 18 Nov 2026 23:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XxPPX31j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D439D1F000C4;
	Wed, 18 Nov 2026 23:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045168;
	bh=tJTyC6ewfBJKaR8ApmC8ABS311FYZjBm9EhKc41kDAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxPPX31jpW3APYtRPEKv/AdktaQLih95A7DrZWhRMYq+4Mm2UxsP8rPQwZc8aWjXf
	 e9t4d5Q6+klMriB/IkMMw937cY21f2IXyxQzKUSg/Gy9RYXOReW/86Qc+jO+S3x8j2
	 FFP+iZd3UxzDxdgJAm1GKHgJKtraRwZk18u65Upw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0825/2857] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Wed, 18 Nov 2026 15:30:59 +0100
Message-ID: <20261118150231.277779398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 521ad948e04934b2d70ae899bc016bbb38802e90 ]

init_l440gx() takes a single reference on the PIIX4 ISA bridge with
pci_get_device() and drops it again right after the lookups, before
the flash window is set up.  The pci_assign_resource() failure path
then calls pci_dev_put() on the same device a second time, releasing a
reference that is no longer owned and underflowing the reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 832b880d1aaf8..85cd273ce0654 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(dev);
 			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
-- 
2.53.0



