Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829343;
	b=AkipHn7STuO8otI2ZN5wE8SEoT6LH6heJuAPfH7dHyekb20pBJx7ic98DQq41VzZ0Clb
	 YrqFYxxE5Dc2s11BRNNj3BOqaVl9xzcgQ49BHwxZuHaPYEWszrSY2ResvoN3vSJfdkUkR
	 +30Y5p3qAKs7Vu8gXmLskkPttkulw1FFpDKht7Us6rfOzsUgMJ0f9e/RZBoKU6O3YenMA
	 IVtkHHtckvYWuVl6xJYpeDO2nghMn63erUWFKbyR9yDTRtUBqGbvpKbhcu/YCGGBLvwqQ
	 bO2rYMfAlOpIHIgWAVCev1DWB1iYqH2/UNLpGHL4dkH3NQurTr3+jk+AgkdSXMqP1Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CMnMO9pIYQuVuE9du7x2t36KRpM85UR6sK/LQts7ZeY=;
	b=YiJeVXOk74iBSf/fY1ahPL13EGrD45Qeor1cNktqbwxJV1lOkqwZryFuDkF3WhddAGst
	 paCZuPkrskB/nTbsXzpFqKf3VfE1A0A8c2bvOgulHdIGfbC57a6wAZyQlT9dSDuEg3H0m
	 cBawwdwaFXKNstBYd+6HBHLALNYpRCFxR6tzEm5St9yqQdX+whcNAORJMrcQcWe4ISgKB
	 KIhBWL7PAXLF0V8JBxBFDx101lXeejk+whF/hMyKgT6AcUPkvXiACjlyuAr+68RZgQmFD
	 AkAq9wlLLeFykri92qCFOOoQO/dq3kj7cWwQRfi3Q6C48SBSERaJF6peOeuFTWabxlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBJUI4UV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D02260A5BCE;
	Wed,  4 Nov 2026 21:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBJUI4UV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187331F000C1;
	Wed,  4 Nov 2026 21:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829343;
	bh=CMnMO9pIYQuVuE9du7x2t36KRpM85UR6sK/LQts7ZeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBJUI4UVJqOt0gVHlpFgEU8AHUL5aHEaLavm3JG1cXFd/IjqDgNG52MB1B2CaRXa5
	 rqYgy3r5xlkPY/dr3nyNeC5BETUr0Uu4WoJiwyeJkANNsKu9QKB7D7MUyXVb21+ZxR
	 619K7ZC4s3s3YMyrEm9iilY4tgXrrKzYH/AvKLno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Jacob <mjacob@feralsw.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0067/1005] drm/amdgpu: Support some Barco AMD based graphics adapters
Date: Wed,  4 Nov 2026 15:56:40 -0500
Message-ID: <20261104211045.489051904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 376a7cd2667f6..845ebe041563f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1953,6 +1953,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6646, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
+	{0x1002, 0x664D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6651, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6658, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
@@ -2022,6 +2023,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6930, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6939, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
+	{0x1002, 0x693B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	/* fiji */
 	{0x1002, 0x7300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
 	{0x1002, 0x730F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
@@ -2050,6 +2052,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x67C4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67D0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
+	{0x1002, 0x67D4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
@@ -2063,6 +2066,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6986, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6987, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
+	{0x1002, 0x698F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6995, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6997, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x699F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
-- 
2.53.0



