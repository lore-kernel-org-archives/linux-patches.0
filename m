Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045160;
	b=BBJb1BT46zczd7qaz7JDmm3X3WlSkSeIB2ydQ4ZzgvD9Rhi5Sp2EykiC+askgoxU39Bt
	 I36OS3E4DtJ6S7yLmuAyDF8prCEBrfQsRRCHxbQ5KF1PfuBLeU/MQBJ9ZNuPg34ECcdsP
	 V0dzPCMX44uQ8IkINtOsA+uN+FwN2ZhiGyF0tI1+y1Is0NTjq+IopvV/HbjVntWYcypce
	 Px6Xo9kdIIxFB9ZZMckDJCG4eStpvDieeoH7GeHXOSUZCh/P5miI8+vSQ7CbOVp1tocK4
	 QoduW2m3EfBW+7hwcspAnsHns9Bu40v2Ff+kikHDmPRwyXRHoExeuGIZnaokgfOms/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJx6tp1VUWsjsW2/hbaD7CZzQNGwlM+iGPxpIzgJtxc=;
	b=Jc0uzZZBl38qJo2KQAAz/96zV+7yb7V6bCkjWO6EG+gdhcE/WjkTvFnvdqYIQ+QJ3TEh
	 n1vYXFWysomeKngTPWVEWDbXXStSlABmQ/uu+N2JbIMJnqmmoii/XDQP6wt3ajMNkZpMa
	 9Kv4uCs6QSW66lRqwMPT/QZUnwMla2L5+xTsU3oosOWAExr2F7bBgen1QSd4jwXo0Z/zf
	 p1DIm0fRq9WucCI/IKU+EHyLh6wZ/r22nk0Oho3C8oS4eZgr2ss5/DIHC7hS8ktp2iMq2
	 OrCfrdlvBbMLHHwtkjT8/8m+mR6ibh/fQWzVcTRkpyqM5a035eZIJFEHzkighEVDI7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSRhHOU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6D9606A325;
	Wed, 18 Nov 2026 23:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSRhHOU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716141F000C4;
	Wed, 18 Nov 2026 23:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045160;
	bh=EJx6tp1VUWsjsW2/hbaD7CZzQNGwlM+iGPxpIzgJtxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSRhHOU6C79iyvgJI94YkhAe4B6A98WYPwi6UKFP6UlUrbQ4krsL9114q2S9WmiYC
	 ICn2E4+GwdvFRj7MFGufYXpOjISkvLvFXAJmKkyT7ZlY9DFpnTHaRVovn7IrFi1oRF
	 cFNO8pEMSRLL7CUM+YwBhhvQo6KmRt0Yw0gXov58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0822/2857] mtd: maps: pci: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:30:56 +0100
Message-ID: <20261118150231.170133606@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 3be16e5d4990bf96309ac5ba35cb369c6015bce7 ]

mtd_pci_probe() leaves the PCI device enabled on later probe failure and
mtd_pci_remove() does not disable it either. Use pcim_enable_device() to
release the enable reference after the existing map and region cleanup.

The imbalance is already present in the initial Git import.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index ca00d211e73e4..c6bbce6aed417 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -256,7 +256,7 @@ static int mtd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct mtd_info *mtd = NULL;
 	int err;
 
-	err = pci_enable_device(dev);
+	err = pcim_enable_device(dev);
 	if (err)
 		goto out;
 
-- 
2.53.0



