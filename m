Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033823;
	b=SsvEM4Rb3Thcdp2V3c7JtWWu0vzA50OvW4eC+S3G9cgOt5KZ5+hTWDX1EKaOhfEcdap5
	 lUH2p07iBPTkzeQffpoa0eHVfK0A8xi/iMFzW0sM5LhqZCIpoe8MjlX1Nc39QI5r3Bd6x
	 WnuXcYznf+VmiUH+cKzp2Cy1OnEhaHySlMMRhbq1mXdTTwbk/WPQcdDiILDo9p2wTt+cV
	 lj3ciYEWK8RWciHdUVhgd8mSQqoVXj9I+36xuRqfTyEJcDKDmZvVCSc9kQA9r6d5LSO2y
	 Xqe4aDjkFncl20okeRg/RudGGXytRkZxRLglKpexXyKlTSJPw2c0uAQj3VjdQs5sNSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFXnhOhp8tMFfEzA75jrHDkva3nCvZhKDRFcOPlrgQA=;
	b=TtT0ZfRCaVY3qS2GyTCIlnySyfG8X2yHWeasQBL9Psn/cRxw2HG/ut5LppL4qW1RgF0v
	 w/I0c9goK2PQe+5T4TpcMn7JW0FThhy4C0oDT7PLD/N8oaKTZ2mthNJ0S52MJMwk79Oo1
	 9ZiXB/PrKPwQzjSoo0gB/A4AnpY6xgaJW+nVudClS5zrZqs6jhVdiFVze7WYUnrlpJaU1
	 +3dozkSvPhEoudllVpmc9fHWuIX+Pm9lgf0/h5Zm83IcrFcgBCOcXPPjArESXoisbnLRa
	 1NrxZiFOsuEL0UHgo5wWXeCR+MctpFVRszi1A8FV3V4WUdFOJBYcdASdDh12VwpqReQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8b0DYxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B7D606A32A;
	Wed, 18 Nov 2026 20:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8b0DYxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8312B1F000C4;
	Wed, 18 Nov 2026 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033823;
	bh=DFXnhOhp8tMFfEzA75jrHDkva3nCvZhKDRFcOPlrgQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8b0DYxAtu1YrN1puiUQ82x5D6MAcdh10jUlOtE2rkizTNzsjWajUcqIypU98inNr
	 3ehF9xFFRUc1cSkQpXqyEJ4u+s+8aWt9vmFIlkiRC4Vnv4S4nkJSVUmOqd5d4DbrNw
	 9Hxf7/a0p2FkrYCkQ5zv8Fw0ij05VjuKeDCFrVyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Mohan <linmhwork@outlook.com>,
	Ali Alaei <ali.alaei.tabatabaei@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0150/3318] PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX
Date: Wed, 18 Nov 2026 15:12:52 +0100
Message-ID: <20261118150319.012403225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ad82feff0405e..58c863e376721 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -654,6 +654,8 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 	pci_read_config_word(dev, PCI_REG_VMCAP, &reg);
 	if (BUS_RESTRICT_CAP(reg)) {
 		pci_read_config_word(dev, PCI_REG_VMCONFIG, &reg);
+		if (PCI_POSSIBLE_ERROR(reg))
+			return -ENODEV;
 
 		switch (BUS_RESTRICT_CFG(reg)) {
 		case 0:
@@ -662,6 +664,7 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 		case 1:
 			vmd->busn_start = 128;
 			break;
+		case 3:
 		case 2:
 			vmd->busn_start = 224;
 			break;
-- 
2.53.0



