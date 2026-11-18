Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057188;
	b=aZzNyakg+sU/1wmNm4sueT5rU1gfwT+vZI9l+Hk+e4xriqvYp+qIM4Ca0+kxXUbvplWw
	 IjY2F5Cpld6p6YbHC8G7clryWGt0s7L2DFVKlpQbigW03SHUDA99oZl6J9IkBXDxK92vd
	 aoiT7ds21IZS/2bAJuZL75LM5vEfMD/ERFEelrROIbrk2H7aFTurBAZ/0byUpKvZmDiyo
	 7pALknh/wh8uH2J3Zw9eKTPWLcA1R+w/NL7kOKWOG8f0YtfR4XM7fMM3iRrBjSdEFjxXl
	 RjNT5SmhWMph0KDdbiy7czHnToaAQpL107XDYDDUm9Sm3kvSi3oJhTT2aHS/DYwZVwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ES79ggx1tRsK/wClonB8SMav6sDIiCuxcB7QSRez0ik=;
	b=vzfk9164xikbHt58/K6juGO9S6mKgA5paWj+eZnEsV1/QbFoGPJYmKAIIoPebSniMnsI
	 ySdgrwRr7Jg6gIKTIhdDAyCZ4vpufqVT+LTTyOyc9YZKzvRxb8vq7azY5clLT1YQ+ssOv
	 vkxK0XZOp5o28RDWRx1UVbLL/M+6kIiedh5OMxH4ry7Am5Jn438B5NIawZ4rwk4GwmbBT
	 INAVZz1IKQT/YC/P1v/DP9TDJE124roEU0Vxkrinr/aCzB82MgDd/J5HUVKJjWq7k1y8K
	 hdOQHXYy+faojJ+7nurbdbosYURH7IPlqvbefhhHcCAyLFYoU3T+tyjYgYre/7WCkKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcNbdPXR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BDF606A325;
	Thu, 19 Nov 2026 02:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcNbdPXR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542AD1F000C5;
	Thu, 19 Nov 2026 02:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057187;
	bh=ES79ggx1tRsK/wClonB8SMav6sDIiCuxcB7QSRez0ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcNbdPXRM5NWCc1XNrwPZUkTKYgW4M2xQ3306orqEfKqaLv3Ngzc9466vo2EK9uD8
	 QFK177sxD0vsdeWPcbSDTFZjUDo8v2xqlIDb/OZJCPHa1T6k2S4m09KFibtTZSVftM
	 uURAqj6/ZNiOrIVufAGyPqBvDBKInEi3uPAsIUNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Jacob <mjacob@feralsw.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0041/1848] drm/amdgpu: Support some Barco AMD based graphics adapters
Date: Wed, 18 Nov 2026 15:34:39 +0100
Message-ID: <20261118145912.842606717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d8c1c318ce89..56a20f867dc46 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -907,6 +907,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6646, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
+	{0x1002, 0x664D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6651, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6658, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
@@ -977,6 +978,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6930, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6939, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
+	{0x1002, 0x693B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	/* fiji */
 	{0x1002, 0x7300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
 	{0x1002, 0x730F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
@@ -1005,6 +1007,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x67C4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67D0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
+	{0x1002, 0x67D4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
@@ -1018,6 +1021,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6986, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6987, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
+	{0x1002, 0x698F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6995, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6997, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x699F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
-- 
2.53.0



