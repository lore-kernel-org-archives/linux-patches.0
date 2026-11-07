Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062986;
	b=TrJkfyAZJ9y3KXglbMsZ88qgiO0dlTgUcNx6FwSvXyzEFbaVX0fF4pWOoY1zyJA6EZto
	 ZtZk0A0CSQzw1ASakd1ZwIjQxEja3DgETk44q3L0Ek7WXVB5LZM4gY5r/R8VVPmAY0Jus
	 82ia6qrpFv68qOzxJO9782WhfhH/vWFKo4lodFFy/QD6hm9u1Vh1F5ZC+EiNPVUk60xlm
	 FdzifNDlCvL4sq7F6pjl7wRBBB0j6pwgE8H6ijezURrB9wsWyKHxYmDJ8k3NWaZwMFYBB
	 0vB4iK4HxKsTaKFYmhYDukhVUrYghiwh6vQLIUf9l2xpdVHVMeFzCO5ElBsBn+vpZ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jSSCii8chl9wOSRWP/6z5NdbR5FYjLzaNH/7wNGSEGA=;
	b=0tJBbA8rmWuNZNZLUN6pQitMNn4CAmSPSE2Ow6OVazdOtcp7ho91UubyWqvcv7a1V8ls
	 jR2qQO5I0agUE9hzPNPYFh8OqXmAPEtZkrC5hl/wbPRDtOGJWfHVAnELA01n4/jXn1EJL
	 MLM2vQYPlO0cO17CdNkWReJaG9XsyOHpVP9fXrHAH1ZSJnV5NuxSIlxuiSpFCH0Hzt4tH
	 h+HS4a0c8LCi21gxAvDcCXgqKeUjRJIRvnCi4d4gOTb08aFmI10V97kv8u0Jp0M2uufpt
	 LwsNAA3q/bFLXZehFNBeE8XQoZjmZEXSjx7gaI9/MoY0wSDSgbCnKmCLmXLFqRrUN7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTVORvwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C3D606A326;
	Sat,  7 Nov 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTVORvwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02AE1F0089F;
	Sat,  7 Nov 2026 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062986;
	bh=jSSCii8chl9wOSRWP/6z5NdbR5FYjLzaNH/7wNGSEGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTVORvwjW3n9ypsd3ZlEeVPJaUGOYmk/0KljhcEf4OIgfoxq5357AKX3e38TiU1MO
	 1vG0bGblsLtFxLl1zDih5SnacKBuXVKj50tDtKGvJqxZXsX9ZihRE5VZjnF8qUnrl+
	 wWPe3Jd3EYWulH/H98VXUK3y8QD1+d5eJBvBGcfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/869] mtd: maps: pci: balance PCI enable on cleanup
Date: Sat,  7 Nov 2026 08:48:47 -0500
Message-ID: <20261107134900.105203953@linuxfoundation.org>
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



