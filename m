Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060603;
	b=KfgZ7RWBdySmEglyEZ3lRoTgiF9H4MBgY3coWQEvdDEq0sRrsEnk6l546qRaaPYFb6M5
	 uYNppEIzTEOXJni2+iY4b3WCKP7e5EVZS+fBTLypLwxgHHZWk6pABlnpZaeXENjz6NuTO
	 8iQO0Iged9tOrKGdXkD8/e5Jvt3VDiIEdgQqB60SQ6yLI9Xic+WUeksDnC10kBP6sQBDj
	 hUvjbR2HMWog3FombwVx/iutKxLvZXPMnqD89LwcA1QwhUrnG4Kt6HE/4u/0Rx6Zu9zCa
	 hZh5Dxh1ejXE3dUX+ITIej+Bqcr61iLGYvU4Kavh2qznbUDMdDw0C0nkdHxvJaRodPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+R1kdQ1BW9yBcU2T8Vze5S3DmjHxhBlJnhwuPaC1cyM=;
	b=rITzbi4iTekdpLqrIJCkbZ6rhZjaME0ZtKRn6LQDLE9XB1xsrABfWmgY+Ax0O6NncRQy
	 j/uEOigFBzSZXsoDXDV6ccEyhoSSy7QpaoTaJg6ES0DgjvsIr36bn6blAlcruRleyTXio
	 5FmE+Ik2vPc7LE0ZHxiopm9mCgy/pfdzm4DpwKp0sEoWcrwyTkLbYGWsbraW70wcAeewa
	 /luvyhH91AmJVhEWoCKcHzDucVDQ9ks6ejlNSzIc024lC2q1IQ2DVmI6Mu4Xdb6mn65bw
	 FKuVFCEtGZjWiruTe4j4EZMcYvMv/TQZuodrMB1K/VCwru2Ju2gysBEI+7rrJHFmJ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0BkvF06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88A3606A326;
	Sat,  7 Nov 2026 14:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0BkvF06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929A91F0089F;
	Sat,  7 Nov 2026 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060602;
	bh=+R1kdQ1BW9yBcU2T8Vze5S3DmjHxhBlJnhwuPaC1cyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0BkvF06puxvoM3a/l0z9zjPTVRE+Te19t4J1bTbIYGaHA8wDJum5w2mCwcG5MzTg
	 T7USE4aapAlyrIiD249zh7VjcbMYHctm5G+1iGiNIpWe45cPZUurXwj/yZXOuvut1t
	 rMr7W7+khSooIgpJMpvQ263VPyflpux6j2IYM/ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Jacob <mjacob@feralsw.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0056/1536] drm/amdgpu: Support some Barco AMD based graphics adapters
Date: Sat,  7 Nov 2026 08:34:32 -0500
Message-ID: <20261107134959.236699283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 958cfc29315c0..cc95cc43a3e86 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1904,6 +1904,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6646, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
+	{0x1002, 0x664D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6651, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6658, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
@@ -1973,6 +1974,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6930, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6939, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
+	{0x1002, 0x693B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	/* fiji */
 	{0x1002, 0x7300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
 	{0x1002, 0x730F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
@@ -2001,6 +2003,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x67C4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67D0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
+	{0x1002, 0x67D4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
@@ -2014,6 +2017,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6986, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6987, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
+	{0x1002, 0x698F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6995, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6997, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x699F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
-- 
2.53.0



