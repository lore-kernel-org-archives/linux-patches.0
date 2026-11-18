Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034082;
	b=1CwEAS+mL3ygXmw3fgJsGr0SrZJ7AT5mOeUetBN45LwyHaxHdIBOCIe3lp/QSFPz6pG0
	 3Qx8NfgANmV4PxJVinrDriYaAABi48HE9NHTR2lkqfDq42+Rtfnops+LlQVqTa/3x8jPU
	 drSvfIH7TboAFBbtYpJtVafIXMLkUQLMk1VtL8CjoJ2PSYqiliuqZGYmgefcP7fsOd71F
	 5BW6uWaaAM30dwaFeeWJK2SDrCTLVQ18PW2nox9DUKtsfR2HHLjYrj67ja8xVJWqDALcB
	 TN9d8llQgWIcGI9hB55Mk8dCW8FXFwsfvfTZjBRdH0MyQTcPFOXxEY130EugZBHOS4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nh+jss6jI69hnQEEHwqW3JbqnFFaurZI2olmaH3/ONg=;
	b=aORso4uJG2IXmARZgsSIOs0eqC80VwRXLIats4XLjc+hRMuNdwJA61SUPcjWRHhzjucE
	 aq7SLuelV9kBhyPP0O6Z5oFM18cAqhg9wJgEwP5p2v3cEwOZ+uAiXtDih7/qBrvSPNzSO
	 I5RHuHkzuPsvAIbt/6ynfzVFtNPM0C2bzMF7sVtvRLazuIc4mUpv6EDpVWqNSZIP0hnhp
	 Rrmg7DpGyZcZlxlq06WIa13EiBgInbqUUSxfcEWC720NHIYSiDEIzzdCmm1Axoyc8atf9
	 UJTqsA4poh6+wLpBkiSdMTZ9CqMQIQxMvcCY4nQ00CkrqPtIDpp5n8aLOfsbZaOwsdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMfRhSZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ABD606A32F;
	Wed, 18 Nov 2026 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMfRhSZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA4A1F000C5;
	Wed, 18 Nov 2026 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034081;
	bh=nh+jss6jI69hnQEEHwqW3JbqnFFaurZI2olmaH3/ONg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMfRhSZPiOKpublwXcBXiBfkANiLsVODGRkGIKrRo7LeAkDENKq0Ho5pqxiXJzHBk
	 kK09uHiA4oyrhLnzRLZuTGo9H5/n9X5oElhVSuYjMAG4qfPwPG73aVpGCssUEOYThI
	 7SJPnK6dLnF3ch47plQ+9XooXJJGV4tgtiLT+uPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0206/3318] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Wed, 18 Nov 2026 15:13:48 +0100
Message-ID: <20261118150321.077491343@linuxfoundation.org>
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



