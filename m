Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE6C37AA97;
	Sat, 12 Sep 2026 08:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200772; cv=none; b=ofSwz9EQk+pjZ2jc+TDYiyny1wfPV+OSUq8fnhEEZApTkYzd26PNx0m2DtGOYbPp2DhGlE6DNLTuwMqPURvd2ggVEf8CM9BSAxza3FQKksfroC4wS/dD9Vmd0adU4upiIR3VG0dSW4XJwSPJQbqrpHHCwBa1dp9vl8CmGjh4Ats=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200772; c=relaxed/simple;
	bh=fIiT3XO6GlDBccXNX/32h168YfM1Z22lsd9hh4W3VeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpwqadToiYCpYc+hcqXyNiy3cEOP3EWNak0Si5vJgLsQNLX/Qazx+XPNALKrOhTw1nzcY50BtCqpRn9KbNx1dg9EiTRSEDGTMSy+YgDSyyt4mf/N2pqdHMcckrRDqDMKBx4UBbbIX2Hym4kIHQqUR2nHu5dngP94UXk2jto92dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5tU+NfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5tU+NfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870191F000FF;
	Sat, 12 Sep 2026 08:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200771;
	bh=VyNjyr9UpFGi+qcmvQcM4jr3DiRK7AxLGRX24KDzkqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5tU+NfRKiEBhcSvBU/LkxDtcz3/lGL0w8GgmFZ9DTa3d9qoXDwbDnoe0ePYc+09G
	 vaqAC08z+HWBodJWDFFGhmOQtxID5dhuEa4oJfh9JWMUgr2UHeYIoSx7vDHujVgSHY
	 mKJfbUI7uMQN56Dx2wam5OHTM0WY2N1Pu687WfR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Gomzyakov <nicerok11@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0858/1815] wifi: mt76: connac: add MT7991A (0x7991) to is_mt7996()
Date: Sat, 12 Sep 2026 08:43:28 +0200
Message-ID: <20260912065709.066815360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2aa6078993e9b..d15cce296c1e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -245,7 +245,8 @@ static inline bool is_mt798x(struct mt76_dev *dev)
 
 static inline bool is_mt7996(struct mt76_dev *dev)
 {
-	return mt76_chip(dev) == 0x7990;
+	u16 chip = mt76_chip(dev);
+	return chip == 0x7990 || chip == 0x7991;
 }
 
 static inline bool is_mt7992(struct mt76_dev *dev)
-- 
2.53.0



