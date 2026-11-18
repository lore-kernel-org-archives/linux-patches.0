Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043214;
	b=LVtvIdEp+od0j+RvFtlv7a4ipmAZNEJmQClYO2X1ciaK0/+ClP9RoUzClVS4ly2oQKdS
	 Hg+f+UQ45t7akrQy5iXK9shpXkmSyWo58Il2/TU+EiRHFUfNpGBHlJG0pRp6C1EZ4OKFl
	 E/ihQrTgkUxsnPKmkmtzXmngVl+L3JM1m0GrTC2pRUaQxqefH7Rmrtm2KzemNr5f0alLk
	 VnJg+PUxS3wIwRdsQ+vEo/43GiwAfYr+2UA/qUsKp3uXkhFeVCR6H8S7Ec5bU3a4k11hx
	 VxpHMtNAS5kNMb3/+k6liwTEhr2e5HHqKkKda0N0u2SZ5YvGiCwEFoh7dsLJSLPo5bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ww5seY0nL7Rx2F3KAFr/6Am4ozzM0QrrwaczmOP55dI=;
	b=AYueACxSre5BSZidoj44NIC4GCEl8l+PfmreUsLk/J59CpKzy60HiVluP3S9p9itdAh4
	 pfUC9HeRxdBigUP1CWLsQtA8p/e6ENTdTvtA0kwKIgkitBf2UORiYUteKyZWM855msjlw
	 rhm0eDkIpqM87/+g+CntOzBgUZT5aGD9cMp5q2EWyiADyS2jlZjsynyA0XakurFHMEPKU
	 8oVCYh3TYOAFcogyvPEyA/S777iJHQajLsR8OyUU64SaZqAZ0QYrUlQaVXEKuQ2R1/GzY
	 SP0LyKERBjhgHFqV5iIe/HqLzR905E7S94LEvgLlnqhVw55Yho1lf1qKg9uQZZAD7CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cd4zNhx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A733606A31C;
	Wed, 18 Nov 2026 23:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cd4zNhx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78EC1F000C4;
	Wed, 18 Nov 2026 23:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043214;
	bh=ww5seY0nL7Rx2F3KAFr/6Am4ozzM0QrrwaczmOP55dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cd4zNhx5aDn1WB1Fi6K2udrAiv3ePX41dEwEq+xFO02klUZAkm5E9J+HWeapm/1nK
	 DZHeX6WTZLvqL1NSNh55Dj8/fLbl1Q9I2yG/ge7w9fxErxo1z+ufZ/q3A90TG33a6T
	 rnHKqUTfNRU/tRjyfNj3pcumqsy2Lb+r5P6sPKiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Mohan <linmhwork@outlook.com>,
	Ali Alaei <ali.alaei.tabatabaei@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0131/2857] PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX
Date: Wed, 18 Nov 2026 15:19:25 +0100
Message-ID: <20261118150206.068005842@linuxfoundation.org>
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
index 771ff0f6971f9..6315504a3aa69 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -639,6 +639,8 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 	pci_read_config_word(dev, PCI_REG_VMCAP, &reg);
 	if (BUS_RESTRICT_CAP(reg)) {
 		pci_read_config_word(dev, PCI_REG_VMCONFIG, &reg);
+		if (PCI_POSSIBLE_ERROR(reg))
+			return -ENODEV;
 
 		switch (BUS_RESTRICT_CFG(reg)) {
 		case 0:
@@ -647,6 +649,7 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 		case 1:
 			vmd->busn_start = 128;
 			break;
+		case 3:
 		case 2:
 			vmd->busn_start = 224;
 			break;
-- 
2.53.0



