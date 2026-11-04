Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829721;
	b=Izs01pyc3A7jXRjZ8mYAxhjuIzmEokTNTbuH7A+nwy8eK31adspa8ir5/bd1kNm1qOvS
	 mr+fpUooOuECzl+Lp6ohQLkAIwiOqxjzXBLVgxDZGpO4MUJZ8bJ2lCMnaLisBLyPrADSM
	 PVo/lohjkDp28n9eYwMRw901Kk4KG1TGSm7u6QASM4fJzl+MhK3CL7d8B/jvp6NRQpZBM
	 Y2nmd5/Oly33TomDu1RuYSHfQCWxOU1Hm0yoTIT30HpHMB/+/tN2sRpccJn2gAz73T90v
	 LZJXGwdVNZOP7hNtWURDE6Hzyt/fdUUYEunBlB8Y1KjwCQeyKzqPk18LBd0V6KeR5sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSYOmJ7KuS/dF164QYStqzT5HbG0eKFkJgDj1u9N/KY=;
	b=wk0rpC0CuVL552mxKHiz9BF3jsGYuCm7sLlYfwa3hWSvaNAMyvXYYx60ugGv+6evK6WF
	 iDB3PTJ7QF8cWvtxCcm5+iT3IPEs9rqF24EULLQpIGMuVdf8Ej3B/GGKYK1dqvuz7hxWn
	 4nByXa4hcUZ4PiWyM+EqMYXNeNgpHgp1NZ70Lw/IQaH2OEL4I+/+fBT2my+VTZARKVb06
	 FMI4CYs5WjrC62vEhdN1mduvPG18Zuv40X0fiGvnYmQHjfRdApUXrIFbv+M8l4L5mB+cu
	 JREpoBWuzmEQMu8/79wLMGXACLZFOIyAanY9/ASVUS0C20o+bPxup7rs7zar9q7XjrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuMiEr2h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A40606AB3A;
	Wed,  4 Nov 2026 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuMiEr2h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7245C1F00A17;
	Wed,  4 Nov 2026 22:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829720;
	bh=HSYOmJ7KuS/dF164QYStqzT5HbG0eKFkJgDj1u9N/KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuMiEr2hEvlEiK+BUqvP8A6+MzqdlMRBANeFj8LDbnx6bldJ36jfUz0Gue1JnHuto
	 BQKQus+wT1SmEu+kl/HSC3iL5Yznm9TyIhsmdBurDrkQIxIXmgtdVmxPqgGODhxYzH
	 zzAik38Tv/q0N80x9x9TFbvNF6DIEH8W1KC4APDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0299/1005] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Wed,  4 Nov 2026 16:00:32 -0500
Message-ID: <20261104211052.288543757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



