Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E0299920;
	Sat, 12 Sep 2026 10:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208970; cv=none; b=RRsWKjD4/HhWiQSLx3pzRU0WmXgF53XFUjJXuPG7mN8vWQDnPu7FdZJb/x188nr8Lq814iyd26OH7hDDzIROFUc2+QfbjNAXy94xZgOp1nV+ZXgBB7o0oA09mscgr7d1PCgfz7zfQyfPadnfIG9blb8NIFz6wr56Etlcjq9WBD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208970; c=relaxed/simple;
	bh=q+tXdRctdjZppQVmfsZOS0IKHKd+FziuoNXSAKAy5Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0iM1bSf0HZWMviubg8c4jzXDLAc1gu+ZPuloC+isWhJeWUOI8l84v4idBd5jJI0IEgm5RS9AmG3g7FDAVPNRiWU0m0do7USx/OrCxoVSL8eRsFS5gGeP+7SysZrsCEU62tDPbS/mzojma3RxucEYLuzb9wOLcxNPzdHnxS4E7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2mDElN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2mDElN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2591F000FF;
	Sat, 12 Sep 2026 10:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208969;
	bh=Bpopo9sdwmzTrxbAxt3+xrHHSOwtfke0RpDKhCmQTmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2mDElN9J6dK5uOiT30HXDVV6pQhv9oZ6X8w0kiKMPsvU16eD0g9J2gKKem6rzhtM
	 d8Au90sTPJ/2QUrh6SH5CACBhCBSgw0RvyM8c0XlOlA8CgchPe2vPw/Q6yFPvsZb9v
	 cTnqhxJikf5lKmov+fNvxkZVwmHmdTNyaF8yKFZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Gomzyakov <nicerok11@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0725/1518] wifi: mt76: connac: add MT7991A (0x7991) to is_mt7996()
Date: Sat, 12 Sep 2026 08:48:14 +0200
Message-ID: <20260912065639.835723442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Gomzyakov <nicerok11@gmail.com>

[ Upstream commit 574bd79955d166c00c2b1531fed591ee70b6ba04 ]

The MT7991A chipset uses PCI device ID 0x7991 (MT7996_DEVICE_ID_2),
but is_mt7996() only checks for 0x7990. This causes MT7991A devices
to use incorrect chip-specific settings, such as:
- MSDU_CNT_V2 instead of MSDU_CNT in TX descriptors
- Wrong WTBL BMC size (32 instead of 64)
- Incorrect prefetch depth for MCU queues

Fixes: 7014fe535860 ("wifi: mt76: mt7996: add macros for pci device ids")
Signed-off-by: Dmitry Gomzyakov <nicerok11@gmail.com>
Link: https://patch.msgid.link/20260510102911.1883849-2-kyoto1337@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
index 192dcc374a642..670f59f55605a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -224,7 +224,8 @@ static inline bool is_mt798x(struct mt76_dev *dev)
 
 static inline bool is_mt7996(struct mt76_dev *dev)
 {
-	return mt76_chip(dev) == 0x7990;
+	u16 chip = mt76_chip(dev);
+	return chip == 0x7990 || chip == 0x7991;
 }
 
 static inline bool is_mt7992(struct mt76_dev *dev)
-- 
2.53.0



