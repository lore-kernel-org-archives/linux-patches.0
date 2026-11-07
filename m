Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064159;
	b=ApFEl8dyOR1rWsHTjRtoMbBDG8McnFrtGgvix9oesLQg3BGm/Ml4d/A2azHkQtE2vVmW
	 Yg0UnZSaFzKuU9dNBKFg/DD9xpgOQmg080gloZidf/3oEfSf5LKAYztYradXUKRvAV73y
	 7AExNhHjYWfIi/8U3PXXJJvJljKaqZ8Vn+gLi/uOG0FhPO7nlKygUT8rR0lO03Zas91QX
	 oGDNLhTECctL9TKnDOcO3zbqrOqKkNpHsntACHK7paZPMdVNKCPIFkBcrH/Fo1oQVWFkR
	 MkxA18jVhn1aO2Jx1GUPSP7SYidT29WlDHAfdlsiKBC41QLpxDJ6VmgbjR7ArydaGaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AohKuhi3NwRxLwpNLoS3Vh4OTyHpPEg2BoiT0fG4FDo=;
	b=N+MYqBFCYI/lM6EeZz4tVVsu97fn0dlJzjRAhCExGf5u6lrU1KK7IbgNeibtAkwYllgs
	 jcsnH/X69gtCAO52jHg/MKTOWz/2tvLr5dl9npui5yj58pYo4vKu1Q799MOmgEmEjZQ3u
	 3mmoTk01zEEF/qyKp6R6Plcvasm5bRDQ+cqbv/r+wM8zip9UlGEZWt5k4IRDd8qFU4+TX
	 Xa/RxTY6ZcjzsHDW3qjnLq5EKoD5cAWUCaVDpYCkjNA8fhafwyam1e9XwH2B2S6SZZKTy
	 9voAsuw698s/GMGnjdUSIrHzQz9fldLP6wGw+vzz+JbKLixaFUemJ/RZEpSScSd30fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZuY/rbhs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C668B606A32E;
	Sat,  7 Nov 2026 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuY/rbhs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A6B1F008A3;
	Sat,  7 Nov 2026 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064158;
	bh=AohKuhi3NwRxLwpNLoS3Vh4OTyHpPEg2BoiT0fG4FDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuY/rbhsQfypQxsWOJzQlcmW6+jx5gCVX4lQ99sEftVj1jeEBVICHeTERBvS9AZgt
	 /HBEERSa5520LD7CPVD5/NH7sQLFiO7T3Uk/Ey8i/uyuxRl+9kfM+s/pG1G0ciHtHU
	 7uWH+B2gC+9X/jU1i1b11NPVDtUWyjhTofwFmZb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0307/1257] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Sat,  7 Nov 2026 08:43:23 -0500
Message-ID: <20261107134947.920813288@linuxfoundation.org>
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



