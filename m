Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042950;
	b=SvNDk1JVVZlfMgJH+Itb/4dhw0JiS/P4eSWtf4kbagVIfzd+Uwn+6H4l1qi91mamiw+n
	 qVp3iNQAvj/7PatKQgBwpTRsABc+2PRiyogZeaTIwd8yjry4hIS59mn0sI5Lt4GxBdncQ
	 IIKqa2c0ITeP8vq5eECOjvsz4UlpnzNPkdyu0P+ODm/oIQdohOfQIz6cwj6QJhg1YacOS
	 T9hvqpkIfjF7dk30PHYzPf0zJkgdR5guDbge6FwaC2jxCKKOTSHfT9VIUvBGGeiHUBGT0
	 AY75nXyR8HTlxW512OWHlmabJ6DquWdbAg9BXpJXMQtmNIDhC2CkOEhQPlsXk+F79bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J6A+QDYh7uYtd9qX0jfoW4/MdtGcJrtyJ9BnV9D9GPU=;
	b=g0g9dygT1tqcYwtobk6E7QGXETjHt+772H7th9pEBwMQJ6j+Jc+lb70m30f2H1k3qqha
	 tj8UxGbGWVuWM0g2Kjj8ONO7RoQmq7TJbM51R+oFIW9ISadA7f9A6fmaIP7WBXm491yZx
	 8x02QapTrHIHt1hiE6rdI5bgym0fASR/QmMGbskgp1eWvonvonUZaZVDEbyK/ElxV7pix
	 OnkpJjhbKvcOprzG98Q4913V0xQesLvCC2ygWJ3oYalF8KZXNZ9BBrL4WuVquwxri3cNu
	 6q6Kr65eYncZSx57+vNyAAzVwOBHGtNfgTwe1Q/xzgPCH4w69TH64wcFzl2NL57Wdng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQ6scWGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE75606A320;
	Wed, 18 Nov 2026 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQ6scWGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5C11F000C4;
	Wed, 18 Nov 2026 23:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042950;
	bh=J6A+QDYh7uYtd9qX0jfoW4/MdtGcJrtyJ9BnV9D9GPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ6scWGa7uETNOmzkQlfblFLUUZAZDvIcoJJNHpBZw2c/68fzQy3OSC3W7+Xb4Zio
	 C7Sn3I90zpBne1OoTpo4fSd9jR51KvJ5a0s9v/gZByH7VrYO1IIejisFBmgzxXv0N3
	 TaRqRreliLKrOYUPFTLqYWwoE/fL0HMWL9K9Mt8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Jacob <mjacob@feralsw.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0037/2857] drm/amdgpu: Support some Barco AMD based graphics adapters
Date: Wed, 18 Nov 2026 15:17:51 +0100
Message-ID: <20261118150202.669428549@linuxfoundation.org>
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

From: Matthew Jacob <mjacob@feralsw.com>

[ Upstream commit 3dc4d68ee26a7ac12069ff0562ad8935106c79b6 ]

These adapters typically are only supported by Barco on the
Windows platform. However, with these changes in the linux
driver, multiple monitor support should work correctly.

Signed-off-by: Matthew Jacob <mjacob@feralsw.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 7a19c3e73209e..67b5d0017fd04 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1763,6 +1763,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6646, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
+	{0x1002, 0x664D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6651, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6658, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
@@ -1832,6 +1833,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6930, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6939, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
+	{0x1002, 0x693B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	/* fiji */
 	{0x1002, 0x7300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
 	{0x1002, 0x730F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
@@ -1860,6 +1862,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x67C4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67D0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
+	{0x1002, 0x67D4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
@@ -1873,6 +1876,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6986, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6987, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
+	{0x1002, 0x698F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6995, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6997, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x699F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
-- 
2.53.0



