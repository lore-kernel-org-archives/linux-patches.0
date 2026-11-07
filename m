Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064155;
	b=AqAXXApG3T1WMjeRvzKfGwqOFgMM6go9n7tgsL6tXiaYdFD+fkR9rf0SSGqr9GZG97pL
	 zLaNQualPfqYrKdtAH9RHWvlNnGWa56taAqZMKLgcvCezZac5KYlZDqIpFks3R7S2q/HF
	 iVgdJ2O6RwIu3Xbcdxv+PFggosY3OsldkO1mTT6jhiyXvQfYFJcPrtx8g9oxZNKDK3HAq
	 mXpnYdqCxc04Mstj5oVRQwcxliGHd39o018arafthydWabG+40dOR1jFYWo8BFrNMl8O6
	 Sy7rcbxwU5dM+ZnPI5AHz3n+ukjhapq0Q5vG70RWeI3lenaVVr6kmm9J8NC+YtQst6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2DflodlPDHht7g9mk8NCR0b36y3ZKlkJf3C65PLfbkA=;
	b=iGdMKNh0GbeuajAZvu+AyylwQHvqtR9xFO2NGaz0Qa+M+SEJJgpwWtSEzDJYetTDupqf
	 C9baoLx8W8HNogWQ/MhfnnIvUGcqiMybqIoSJVfTy3S5HgIK68JDgkx7y0WwwLLkPAAx2
	 +EVE9n4AyBObyM8LP2RV1xx/soU7NIc14Xt/H93DskLPw1fTHCdZpwkE1JhYS0590G/q7
	 fFuXR0p6P+YU9EPzrV2DXwtRtAC7IBd8TLQntiVEeHhTMQ+8ljAlVnagBjn5OtBp2F2ME
	 b4q+jb3myzgIBncasHyFJ+LsY/BsBlhNoEvE2I/SKrkI+a3C8U+8rMRjPHgyxIZYMxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqJ+zwHR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAA6606A32E;
	Sat,  7 Nov 2026 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqJ+zwHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFA11F0089F;
	Sat,  7 Nov 2026 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064155;
	bh=2DflodlPDHht7g9mk8NCR0b36y3ZKlkJf3C65PLfbkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqJ+zwHRA41II6BNonrdG3s54826ugXhUOQ5JizDZOM04bXIp+aVD4yu6VssuWYgp
	 eo+VXZCqcCktQF0UKl3sLyd3XL1bHsVDJqirtOVZltz2FX4sd2MeYlbBeapX13h5j8
	 mMndiqPmxiUSK61AXiGMJBEX+KS2rRn4eGodwXJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0304/1257] mtd: maps: pci: balance PCI enable on cleanup
Date: Sat,  7 Nov 2026 08:43:20 -0500
Message-ID: <20261107134947.844788166@linuxfoundation.org>
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
index 34041cc8f173a..f13a1f520d043 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -250,7 +250,7 @@ static int mtd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct mtd_info *mtd = NULL;
 	int err;
 
-	err = pci_enable_device(dev);
+	err = pcim_enable_device(dev);
 	if (err)
 		goto out;
 
-- 
2.53.0



