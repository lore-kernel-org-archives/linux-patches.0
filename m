Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B1A2727F3;
	Wed,  8 Apr 2026 18:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674224; cv=none; b=dSz/yKjaeaaJk1qbEY7mnx/LI2vIP5Qhm8P31EGwW8L27V0hCUsVHf8CZ1PmNKkMhgzN/jEALHgXe1zJqTJOEAWcYT9hDcpGEhkv7/+KbZbxMbzEQAuDB8g7GOT3kS8eqaoVhA6HuX9idvAFNOCLPPiOthlRSlwvhxWJ+Mp7x2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674224; c=relaxed/simple;
	bh=PTP9CFiBYdS/sRKTXlyYVCw2fg0ZVgDKh2SVvyKFi1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itCuBIRZqdP+ZB0mA01wAA2+Bk40nzWzWAZnkcj33NPlarME4ZTG7HVs/Z+KwGYNQeasKZAzfJKU44hvHbwFehfdEXyuBZAiApqk5Qyb+LAAQhmW00Z0zSzO2mWRKvhTt+TbTgYiKuBGp+c27U9CXUcqiJOawy+u8guY6o91x4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHk82Vvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHk82Vvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BA4C19421;
	Wed,  8 Apr 2026 18:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674224;
	bh=PTP9CFiBYdS/sRKTXlyYVCw2fg0ZVgDKh2SVvyKFi1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHk82Vvl1Y7EWJYsimdlwFPEjqzwYW8z3n0bVk3iv24F9l2zO6b4YizlcvptrzQNw
	 FvxRvb0bsQbZOd25wQpCABiPZvFDNXJyxjeM7GLcjtxMoE/PSjwV8vQ/tfIAlEaLHn
	 hJy0HkTlMLgRT5fYZicv1jmDTkWkBdIJCogzV7yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishon Jonathan R <mithicalaviator85@gmail.com>,
	Vincent MORVAN <vinc@42.fr>,
	Paul SAGE <paul.sage@42.fr>,
	Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 015/311] tg3: replace placeholder MAC address with device property
Date: Wed,  8 Apr 2026 20:00:15 +0200
Message-ID: <20260408175939.982359983@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul SAGE <paul.sage@42.fr>

[ Upstream commit e4c00ba7274b613e3ab19e27eb009f0ec2e28379 ]

On some systems (e.g. iMac 20,1 with BCM57766), the tg3 driver reads
a default placeholder mac address (00:10:18:00:00:00) from the
mailbox. The correct value on those systems are stored in the
'local-mac-address' property.

This patch, detect the default value and tries to retrieve
the correct address from the device_get_mac_address
function instead.

The patch has been tested on two different systems:
- iMac 20,1 (BCM57766) model which use the local-mac-address property
- iMac 13,2 (BCM57766) model which can use the mailbox,
    NVRAM or MAC control registers

Tested-by: Rishon Jonathan R <mithicalaviator85@gmail.com>

Co-developed-by: Vincent MORVAN <vinc@42.fr>
Signed-off-by: Vincent MORVAN <vinc@42.fr>
Signed-off-by: Paul SAGE <paul.sage@42.fr>
Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260314215432.3589-1-atharvatiwarilinuxdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 75f66587983d7..a80f27e66ab52 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17030,6 +17030,13 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 	return err;
 }
 
+static int tg3_is_default_mac_address(u8 *addr)
+{
+	static const u8 default_mac_address[ETH_ALEN] = { 0x00, 0x10, 0x18, 0x00, 0x00, 0x00 };
+
+	return ether_addr_equal(default_mac_address, addr);
+}
+
 static int tg3_get_device_address(struct tg3 *tp, u8 *addr)
 {
 	u32 hi, lo, mac_offset;
@@ -17103,6 +17110,10 @@ static int tg3_get_device_address(struct tg3 *tp, u8 *addr)
 
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
+
+	if (tg3_is_default_mac_address(addr))
+		return device_get_mac_address(&tp->pdev->dev, addr);
+
 	return 0;
 }
 
-- 
2.53.0



