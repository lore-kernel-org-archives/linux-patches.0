Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055901;
	b=SYC3KViYp85NIJD/ywVfFcgePSBUiO1RhlWdaRjCl1WJ9bfSoHsCtYFxhAiSqe5K3tWO
	 icFOJlqvqGodl5cEulJZzoD7HO+jOun3w5TAUl1upzhArkKADXH9ZpjqITMul27XiuStr
	 5wYgWqIkbXplET/mJiRk25UpJZJlT7EOd1BROkkEO8qPqpiUHIjbdeSBbv0CoILv8Ti+2
	 65mMwqbZYqCiSNsjFXUPKfh3Jd5RA3JRuqdDZi0ycQW+wibgPyTUrpm3pI3syNg0HVD0A
	 NbM143eBwWFD5d15bemc2Af7jGu1oGjMnsyn7ZsYNSs33M0sgXqO133NQ+r7SbNVCow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2n2udeW7h0UKgPDSgrxjfnc3c2PfA9fvM0qWY5l1uOc=;
	b=fvjEghh6h+OxBNO+PntXVjs68J4vCnI4XcB6sSV8oX7v0Ur4e4lnQ0RxifeV4RFeT6sA
	 zXdEh4cig8dsUt5/ps99pRHaAPJFmDBDP+97xOFtz/RSmOh32PICQ84v88aLWVaztG53/
	 GknS4vb8tOoTHgvZDDu4L6S8OvxAwwTDYDXPIP0QrJoFQn/pTdaK1aycM13xr/h+Q0VSD
	 8WCVQA1v5NMZ0h28JtcBwz9E4v1ixpfM1oBUUqQT8fMFe4aZAy7Z+/g+crzt8wnSOPVKX
	 YpuXzb7ezSwfcKDgnVGDbz8tuvVrNgD7kZfuRD4N3c9LRZ86JxCXJ23yhj97mU5/UFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ib27NqzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A0606A320;
	Thu, 19 Nov 2026 02:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ib27NqzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4520F1F000C4;
	Thu, 19 Nov 2026 02:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055900;
	bh=2n2udeW7h0UKgPDSgrxjfnc3c2PfA9fvM0qWY5l1uOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib27NqzUdJmlTtnvOPXADaxwy9UDSC8D9PDbY/0pcrpmDXYffucv9URt2FbSYIL25
	 ln+o3Ikut7YfbCWn4CPEvRT1gzmIDGWmR2lHh9B93/Cdo61to++Y6JZH+z1imviOZe
	 6yuw+fALHy4fbaKzKayY0NmNe6A6SN7SCVv4qa3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1796/2214] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 18 Nov 2026 15:57:52 +0100
Message-ID: <20261118150123.348506261@linuxfoundation.org>
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

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit 40217d8e6cba433a6ccb8c73737dd38b54dcc26f ]

On MT7663 the hwmon temp1_input attribute always reads 0.

mt7615_mcu_parse_response() takes the temperature from the first dword of
the THERMAL_CTRL response payload, but MT7663 firmware reports it in the
second one. On a DASAN H660GM-A (MT7663E, N9 firmware 7663mp1827) the
request and its response are:

  request:  00 00 00 00
  response: 00 00 00 00 2a 00 00 00

0x2a is the reading, 42 degrees, while the driver returns the leading
zero. mt7915 and mt7921 already pull sizeof(*rxd) + 4 for this command.

Restrict the extra pull to MT7663, as no MT7615 or MT7622 hardware was
available to check whether their firmware uses the same layout.

Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Link: https://patch.msgid.link/20260819192911.1886457-1-naseefkm@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 0776af7f74d94..360379ec3601e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -191,6 +191,8 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		break;
 	case MCU_EXT_CMD_GET_TEMP:
 		skb_pull(skb, sizeof(*rxd));
+		if (is_mt7663(mdev))
+			skb_pull(skb, 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 		break;
 	case MCU_EXT_CMD_RF_REG_ACCESS | MCU_QUERY_PREFIX:
-- 
2.53.0



