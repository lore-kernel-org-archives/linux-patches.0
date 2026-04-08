Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEFE3B19A3;
	Wed,  8 Apr 2026 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673642; cv=none; b=dlJ2GtrSlaTzjd/qhIbG70DthAt73yrN4ECOMRxptD+Ys+65zm949uLjRdPRRBMgcaDwHjXJXf7EIrX3IQ3AVJ97VIJTeosXGzUtkVrvfGmw/3PBwgAkry+gs/vR+/TPh8jjZ6XU2L3QP0+qOdYl7B3VJbLvroHVYK1dvFk8QYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673642; c=relaxed/simple;
	bh=Qp32owjLdkjZaO/PVZIPDIVs7S1ECyfRqMt0eYFwR2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJyammYXaACZIkbyN7Tr60yeDt9hon6UuaXz86Wkio97+RZ8uYAWCDlM4hzf3GQ+L8NZJvBd+5kggnwI0umpLhOd18CBTe+osJfRZaxClQhl6VEauxDNicVgvHANEOkvs6cSlo2HoN9BS6sZ+KSH+GEOroOJkJ07u9fAyiJ/+rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2imyuE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2imyuE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021CFC19421;
	Wed,  8 Apr 2026 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673642;
	bh=Qp32owjLdkjZaO/PVZIPDIVs7S1ECyfRqMt0eYFwR2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2imyuE5AtrJ3PIoE7p2ppkkD1f7MKYtVGDoU9ShES7UcgBnwycjIiNh+IjpzkYId
	 plB13gUVUGukymz/QWmft2ReFb0z5hGEVAY+Z6u65Mh5LTzz8oZN/Mj4HtWS9OF4RB
	 kyGM7zjkv530CievjVmiSKjX4tjU0u1c8YMYw4/Y=
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
Subject: [PATCH 6.12 032/242] tg3: replace placeholder MAC address with device property
Date: Wed,  8 Apr 2026 20:01:12 +0200
Message-ID: <20260408175928.274215487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dc170feee8ad7..288ab0e007557 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17015,6 +17015,13 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
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
@@ -17086,6 +17093,10 @@ static int tg3_get_device_address(struct tg3 *tp, u8 *addr)
 
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



