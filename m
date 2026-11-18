Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051305;
	b=GC1stiBzbg6ZAEXXS5miQspr9kh6eZGgS9xIr/YscycC4+YBbBsXFMoF11Wh/I/4xyt4
	 7a0G6t3dcgEOcWQsTwh7i15XOBQNPOGp0Mixcqm77lsYZWY04UuBvAw3G+DylZui6Tk5q
	 QZcTBFCsfO7SpOaFSTHu6f3ooA6uyfB327xAddviC0UKR0LQCbseuDt5T0YbpRXrXJGpD
	 NmM3HPLnK5TSQdDNp154P9PPSIm6UfmJy5JSoCw337+qc/azM9/9v0sr7P91YlcaQiwf8
	 8nXpqyY5SPiQ2h0U74h9wPhcJVzJddzvT+3XC1cP5FyrEYTwDNmi94Gp1MTSKjzyzMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQScV3/aX1k1oKTjYBjPWxk5ff/iDmiibhdeCe7a7qM=;
	b=ONoL3yC4/N375KfCOUoR8fDdfTW+QlOjIgjgyKEzQ4+2PoYutL4kP3Vv1AtbtSINRwl6
	 G9YWA1ZH/4kUkkxFcOFGlmtxdJSy22RCdvIsNwv6sk/ed5STk4YiDu7owUlw2Ds56u1VE
	 NU/jFEjQpYzu3yEikoZYFHZm+pNrnEftdCqjUjYUbsu+fEedEH5eErF9vIT26JQ3QqNHo
	 5ajLbr3Xf6iEu6YUElJS0o/zijKOouIL6RewPtdnJot26DEXuUnO62ye5jJ9UTivm/c2B
	 iQw0GKVsMiJ6/6Noh3LHCYUmqL5YsG99s/P+c2POKPq7D0Kvcihfh4rU/2bxFKkj9cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aV8MVk/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22E1606A32A;
	Thu, 19 Nov 2026 01:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aV8MVk/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF5D1F000C4;
	Thu, 19 Nov 2026 01:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051305;
	bh=vQScV3/aX1k1oKTjYBjPWxk5ff/iDmiibhdeCe7a7qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aV8MVk/3AYzZ2bCGnFwIYzB4n5qOu8h2OflKnGZQs03R7N63Y7LFIhv7KiAZVJjqK
	 xtilOVYopb9I0uFqEIBEDBqYUbf5vFReRHeDAm5AqAj0GdUT4orIEDvJDGqMABlvLW
	 Zj2LA/xROXLyRfq0noHO4GtQRfmelCAKlRfUg8Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0160/2214] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Wed, 18 Nov 2026 15:30:36 +0100
Message-ID: <20261118150016.525470747@linuxfoundation.org>
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
index d951cb81df833..7d316212ac59b 100644
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



