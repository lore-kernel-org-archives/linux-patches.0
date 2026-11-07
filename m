Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060866;
	b=xOs9lijujJXBo7GrmI2OMrElqblPohP+GZ+H3pJZrknci3OO4wzNBThxPO66Tz4xpHvf
	 S3VrnBrCsPAXDq1dPlzIi6LfXu0LDXEGT20hpiCdnLjxewQFa9lfa1AK2Vh3eHQB+LRT8
	 UZRAUnv+vEpEIWSoRZEXbrjaTxorSll6XXrrxQQph4WinvI5OfqZNyTMQv5VlOrilXfM0
	 cnWIO+wSq9LLe+jTLT0CXUTS5FE6rJokS0+07rerq6FNNoYjVqLU7n8al47Nl537Zndie
	 C2spD06NUGO2VLmx0iSYpCS3R/4lyu3SqIEf1eqzVd9BevEh4ZKYKrn/qtsUMN1jSsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ocNZjVLObrygYe1s6QQ72tCg5fpHtw9vmBXUYPrVv7c=;
	b=pK8i6p4fW0tD6kxqufEY6akmk79Ygp9IXX3jk/kMHwDPBhMyOiDZNU+W2qxmSWEteDsL
	 DRC/AedMJLiaL16VHJl97BEdMHE2u6Di5T0TS7VOqnWvTCPeOfO4JxhVjWQZ40iNqM/rt
	 ZWBsQkth/o/zkDuJObUBra8epfufg4V6IJsC0QFHe/Q47Whqqk3Ztl2GgX9HWp/DCz6L/
	 rKvpjtSHITB2UKQA4GmDhBCcAnsU7OeqIASaf9EIk/EsAwo+3NQSljp0gYrhplURQYOJH
	 RmH7HWOiaebU13S+cpC8+X42zX54rDfL8glFyRFpv+bXQioh9l/ooTJ1Nmv7Pep7ekw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G3Ffq1a/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37EE606A338;
	Sat,  7 Nov 2026 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3Ffq1a/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685611F0089F;
	Sat,  7 Nov 2026 14:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060865;
	bh=ocNZjVLObrygYe1s6QQ72tCg5fpHtw9vmBXUYPrVv7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3Ffq1a/tJYsIeMptiQQAQhEmWKCKNZKSZTG5PHIGHjXDFkOd1Xq+x7H5ZgWs43Ld
	 Qx4qn+p5PNvuaNAwzzUVh8eTNZzs5QuLJIbugHVlG7F4UguATH0e678RBgR6qCr/BI
	 JXFyVpXF4MDsBZwkG+hrl/VgDX2VEQnp3bDl4QgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0246/1536] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Sat,  7 Nov 2026 08:37:42 -0500
Message-ID: <20261107135004.590119340@linuxfoundation.org>
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

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit d16447d7470502e998d82e806ca7ed49d1baa853 ]

Some EcoNet based routers ship an on-flash EEPROM whose chip-id is
0x7592 instead of the expected 0x7603. The device probes as PCI
14c3:7603 and the hardware MT_HW_CHIPID register reports 0x7603,
independent of the EEPROM value.

This is seen across multiple EcoNet EN751221 and EN7528 based devices
(for example the Genexis Platinum 4410).

Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Link: https://patch.msgid.link/20260719082530.3879831-1-naseefkm@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
index 88382b537a33b..06f61988655e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -142,6 +142,7 @@ static int mt7603_check_eeprom(struct mt76_dev *dev)
 	case 0x7628:
 	case 0x7603:
 	case 0x7600:
+	case 0x7592:
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.53.0



