Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052361;
	b=ZKvJjuQ6kChXFgxEfVwlfaC2TZZShFjc8NFad+UKZrxoBm7JAkeNlXCexRiHlM+Ez98M
	 PpiRAbKNJ+WZxftB+s78qvMBtvWSGWiqMKuVVIzOIJfqEwnBrjycR/w4SO0GfaeOSCmyN
	 WmMpyIHLkT5JXCWyj2J46fXOX/tjHxk+6ewm8ueOdqAWmYSry4uWD4D/FOp3Jn1i1DIAQ
	 ygoHPnKqtrw2e5dN0FeE4TDajpzrHq7+yuT4B9C+hHpAKWQGxxV1BeUeyWjS4SgTOojLH
	 pxTgwYQO2XF9NWSwiZxM8GKgVFzjS2MXgLO26jQiK2HnPA/WaZsbBJyNQCc+vwZikEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmg5qtGD/DRvmf+kFdnBL/xqk+niAHzNOqaC7OLWLzE=;
	b=lEoadtK5lKMaW9HWTM/9anAuo1vUdfgu5JXnGjpEWXXTfAUc5l9a5zOHZ1SMA3PTZfNU
	 UMSS4PKWW+sQwrLoX5ACkiylP7pQc2UgrYOhUYvjMRWt6NaQex5Q00PrkLmD5yaxleWzP
	 Kf2yF4lzd5s2YXsM9KM/kFPsPRXHDJ01uhnHGgMkU2/duuCZN9I/nkzlTpYa0eGL26O1R
	 hwUYz/6uvpSu174+vtaHpmSfKkkhYCPQC8TgmGUthaIEY3pRwP/fpXlEPshWSoj4Fla1K
	 W2rcpkt0St165gnjv6gok2my1ngA0s3z9SCbY8tWm8uT1yhYKTwu7MO4bJVQjxzIDZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=noheyB4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BA9606A320;
	Thu, 19 Nov 2026 01:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=noheyB4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83BE1F000C8;
	Thu, 19 Nov 2026 01:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052361;
	bh=vmg5qtGD/DRvmf+kFdnBL/xqk+niAHzNOqaC7OLWLzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noheyB4y7eDEL1p5T32Lyi2xz8lMyJ5p+UCIGk+eLc6dlFrS+78OMiMd9BmEil+aW
	 vSKKz7lPB3ukGTqP+fFHf92kCgepf/HU4PRtacYekGpqAagDjTLYynpJIn3jU107fm
	 odNBVKWljYQ/wEdhVCM1Kb/W4a9AjT1065AexwH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0537/2214] mtd: maps: pci: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:36:53 +0100
Message-ID: <20261118150032.517529790@linuxfoundation.org>
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



