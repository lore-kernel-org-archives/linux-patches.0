Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062991;
	b=WLcdRdbceJ6+74ZyCyuULINoOQwlQAVyuA05cDGukSaerXxv8VmUT6wboCCZhpl5eI1a
	 3wWTSX3hhOA0/+CWh77B3YgPVxagPs763wrqkiPyn1c2GOrY1L3c5BtUOq14sIHGq7mKF
	 jlN+lZEu8M8zATJoR2yfa0WfAk0BGCGT46jPAFJoUzRbA0gpPekwYwQNJaEOHvcVeldNw
	 BM/yfNy4mJk3K2u4J+vuxQWQq/CIwAyxW/b6VrmM+SsTAatUWIoWnMF29/EaQ/Gc0pR5g
	 QtAWZBqQb0U8+HK4i3SXzXHOBUhFud6XWhIMt2trX30kox4aK6Tfl1BOfJsfg0X871A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycIBN7L8RW2N8pvUIKW1s5Np0YTyJKb78UKnc9/xZeE=;
	b=TvhLfqHpntA6Ub3UQGNbbyfMKeSqz/gke0j8PeeLgxqQ/CJXk/CZI1cdSK/0nWaNt7Ep
	 OAQdOF8aZNwUgme3D7txez0OGJL1u7lmkFUT6TfD5lKow6SfkhuXeFfGug3YRkXXczXE1
	 MSKEC4HLZxFkWS0MqjOHpYeWPEhVYwDY0ePAfmYaUSQee11tGhisH0wYGeJM5vMKJrnLg
	 GuNSDq6YZ2EYGP0/43M+VdHIeCdgtirolyBkXr7bRn+SIxc2L/McGLhPcHv9OHGJJ62MU
	 H3pdxY9IDGvvUJ4TRprMyyHOJDkhIS3gK6nWA2SAEqb2uJgrRsdRYVAsoGnxz9Rlh/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atkMRmX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F9606A331;
	Sat,  7 Nov 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atkMRmX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A9F1F0089F;
	Sat,  7 Nov 2026 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062991;
	bh=ycIBN7L8RW2N8pvUIKW1s5Np0YTyJKb78UKnc9/xZeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atkMRmX4PcAvbVTloJDo7GHOwcvbHCnzFSBe1t8KdKWNs1nH99F01DjGV+yn8vWsX
	 ifi0QkRbLfKREL8Xao8L/TZvjqImFCbvraLKrUjVheLb7j1vC/nPnIH6IU4mJusbT0
	 6Z+qfKo1D5T46f3aJYOQjwa+NW7VvfVHH+vl2DrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/869] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Sat,  7 Nov 2026 08:48:50 -0500
Message-ID: <20261107134900.190023444@linuxfoundation.org>
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



