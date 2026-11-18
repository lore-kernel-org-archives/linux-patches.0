Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049319;
	b=PV1rEccGQU9csVpQkvxac2ILsjk2FdsY8ff0pbbr6/qECsmwQVSCXie4jDuW70nKmKRN
	 IJkolKjWeRxoz5DYI3uT3aoJF6B0JOC4oQoDsE9qFYnWzrnMIhBExcTOcDXmOKaB7KZr6
	 CAuHaf15rppjh0MsR3MG8H0HCxvgQNpIsMx2ClFjf/v+4JCqOF/PUyaGQR0dTgS4Kieog
	 vrWCr9Us/a1TWfO4KJCsrT8d1YkmqmtQb7a1ZsyrudwqYSmZn4zQXTOxdLGhIn2EAcP/B
	 WpO49CbifeK0Lv+2g5jSao8R304T9NYnjMi9UCERX+60rLkj/dJwC/dfunzFVyzfQ+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kT9NYOgxy7CAnfGeDH/5ujhgC6TvxakCSbGs8mA6RwI=;
	b=0IVjm3n2WtTn+UT1/HDfIk6Ag07hMIoQw8LfbQPxyTo3zo8FtEbSUVXnl7sbaqeFASSj
	 cOmRBTysLtltbN2LerQ8aH8dnNuYVl2pGTWk4E/cDIRqYZVjbKvzJyJjvN8voRp0itC4E
	 XPzeLTa5bzlOPyDxRgYILZGvBFB1Zr+pQEhMVxNYQ2AUcYKNROMsoTO36az/REdAt2N78
	 xdcizY5Bxy7rOIRsRy9UXmvgjUP4AYmBvoniE3jzEgcT2vFdqkydWcVqgaghrnyubvbDo
	 gfsJsfqvEYQxQUe2vDZxMaA6HMWERYeboY9yJm5rP/qKGwWk79m+2Hwdved23FoEYZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvsvfCvG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615F7606A338;
	Thu, 19 Nov 2026 00:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvsvfCvG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E6B1F000C4;
	Thu, 19 Nov 2026 00:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049319;
	bh=kT9NYOgxy7CAnfGeDH/5ujhgC6TvxakCSbGs8mA6RwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvsvfCvGX3wcnCNQFiqZC6CLmvrAgd4OWb8jhF/RB85ly+WHzb7/z+/Wkgf/rHhA6
	 /aY+93a22yoCbzzvGd+URZtLNxZmQIt9Bvk0OBfLWTl1kGuMo7Y+u2uGy1FhNcKk8c
	 NTAKQttj4HcgvFno47GP3APNpf66pT/3YTyTqZ9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2308/2857] wifi: mt76: mt7615: validate MCU response lengths
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150324.597422583@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 356735fc612ea54062eb741ea15fa4ff7df4fc36 ]

mt7615_mcu_parse_response() reads the common response header before
checking its size and then consumes command-specific fields after unchecked
skb_pull() calls. A short firmware response can therefore be read beyond
its current extent.

Validate the common header and each command-specific payload before reading
it.

Fixes: 0e6a29e477f3 ("mt76: mt7615: add support to read temperature from mcu")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830131049.2097-1-pengpeng@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index f12378f564e50..a51236e9faf37 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -145,6 +145,9 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	}
 
 	rxd = (struct mt7615_mcu_rxd *)skb->data;
+	if (skb->len < sizeof(*rxd))
+		return -EMSGSIZE;
+
 	if (seq != rxd->seq)
 		return -EAGAIN;
 
@@ -152,11 +155,15 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
+		if (skb->len < sizeof(*rxd) + (is_mt7663(mdev) ? 8 : 4))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		if (is_mt7663(mdev))
 			skb_pull(skb, 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
+		if (skb->len < sizeof(*rxd) + 8 + sizeof(__le32))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)&skb->data[8]);
 	} else if (cmd == MCU_UNI_CMD(DEV_INFO_UPDATE) ||
@@ -167,12 +174,16 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		   cmd == MCU_UNI_CMD(SUSPEND)) {
 		struct mt7615_mcu_uni_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt7615_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
 	} else if (cmd == MCU_CE_QUERY(REG_READ)) {
 		struct mt7615_mcu_reg_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt7615_mcu_reg_event *)skb->data;
 		ret = (int)le32_to_cpu(event->val);
-- 
2.53.0



