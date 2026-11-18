Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051179;
	b=hBlfrTQNkxoyf1X0aYVyIrD1hTu/hDGhjmNT40D1zwxSpixz4Mh7HGLAzZPmL354Yn43
	 a7BoeK7y6jmWsw4xbXjCVEkK9aUQ1d84ls60tmYECjsjOSgxBnB9kuN/QQ/tTs7UNPE0J
	 hLM+f+r+AFHp71Y5xYVnqQnTWvBVoPezuK562b/baHovLmo6yEfLtJA4d9jPzUBoDzhaq
	 fGuCSas94Z63EiAZ33eutPfNjie3e7empyt/CLHwqAlAxj40PIt38vz096VVwUYFXhmbY
	 UY/5Yoez2R6DLSGYGqXqxrWyQGhEwpiUzTzkLszOqweTKZxErijfjBx6xZ6yDTjj97Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VJaU1qYe0YKTRkZlug5JpHH6Eh1E0ltZChbkAlB1rHE=;
	b=fgHYlv9cQxhbPa/UmWAr3fIL8wxn+FI2/5t1t1cnO4JgPV5mLmEi5W9poVLig8U7Bp8r
	 sMRNHKVgQ4Q07UA2jxbPhpnJemgsuugQd6UJsPKJgE8dMkf1TXwvJDtfv9WS9afgTZv4E
	 t8HDZBoqlMrycm7YnmIIM1GAlFtmftVc59Ecu9rODEB24Ls0rjQwJC9tO62NtujmZAIMe
	 uB3UwD06r/rh9kPzP3+3eOOx1QtYLG+PCsa0/VB3MJhKFeGvnh0VFGA5afpSaSM6d24to
	 97RVnKk/3v2bXf8ZU5q+sJVlqzFjglmejurKDHAPk/MIKEGsLHty89A8o8qnr2lkikg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSTfStXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE735606A320;
	Thu, 19 Nov 2026 01:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSTfStXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149BD1F000C5;
	Thu, 19 Nov 2026 01:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051179;
	bh=VJaU1qYe0YKTRkZlug5JpHH6Eh1E0ltZChbkAlB1rHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSTfStXAGyCZvA1nArPLFMISdB72NKhrTFTvidnsnW3PhGQkadzm34+e6nXC6uWiC
	 pHZ9qzhPws0Szrv1gfCmVB87tYF56Uz1oaEPUBk6VcbJcIxpBXJe7fsWRS2FRunARY
	 X4gdpZKjc55aP/AhpVpOghS5JrTxguPJxST6nh+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Mohan <linmhwork@outlook.com>,
	Ali Alaei <ali.alaei.tabatabaei@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0116/2214] PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX
Date: Wed, 18 Nov 2026 15:29:52 +0100
Message-ID: <20261118150014.630890040@linuxfoundation.org>
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

From: Ali Alaei <ali.alaei.tabatabaei@gmail.com>

[ Upstream commit 72b32eccbcd591b9606edacf3bd7c455176d7660 ]

On Intel Arrow Lake-HX systems (e.g. Core Ultra 9 275HX on Acer Predator
PH16-73), the VMD controller reports BUS_RESTRICT_CFG = 3 in the VMCONFIG
register. The existing switch statement only handled values 0, 1, and 2,
causing vmd_get_bus_number_start() to return -ENODEV and aborting the
entire VMD probe. This leaves NVMe drives behind the VMD controller
invisible to the kernel.

Hardware registers (VMCAP/VMCONFIG at offsets 0x40/0x44):

  VMD 0000:00:0e.0 (8086:ad0b): VMCAP=0x000f, VMCONFIG=0x03b8
  BUS_RESTRICT_CFG(0x03b8) = (0x03b8 >> 8) & 0x3 = 3

Add cfg=3 as a fallthrough to cfg=2, setting busn_start=224, which is
the correct bus number base for this hardware.

Also add a PCI_POSSIBLE_ERROR() guard after reading VMCONFIG: a failed
config space read returns 0xFFFF, and BUS_RESTRICT_CFG(0xFFFF) = 3,
so without this guard a removed or errored device would falsely match
the new case 3 instead of being caught as an error.

Reported-by: Lin Mohan <linmhwork@outlook.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221137 # Arrow-Lake-S
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221136 # Arrow-Lake-S
Signed-off-by: Ali Alaei <ali.alaei.tabatabaei@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260628143450.92492-1-ali.alaei.tabatabaei@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index d0d18e9c69685..c41c5ade5d8a9 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -590,6 +590,8 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 	pci_read_config_word(dev, PCI_REG_VMCAP, &reg);
 	if (BUS_RESTRICT_CAP(reg)) {
 		pci_read_config_word(dev, PCI_REG_VMCONFIG, &reg);
+		if (PCI_POSSIBLE_ERROR(reg))
+			return -ENODEV;
 
 		switch (BUS_RESTRICT_CFG(reg)) {
 		case 0:
@@ -598,6 +600,7 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 		case 1:
 			vmd->busn_start = 128;
 			break;
+		case 3:
 		case 2:
 			vmd->busn_start = 224;
 			break;
-- 
2.53.0



