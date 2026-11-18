Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019018;
	b=nCIZ7aEHt71VFvybDQXYxNRhNQ7Cm2BDxwety1D/gMLYp1atjJQtAGeAInOYoUy9MoGj
	 PFn5h2oW/dUWPa6AsLM/2LsqoIWrctllL11pk7k0jZAlpSO8r/F8R6TvSH7DuZf3ijOew
	 BpfCt2aG0TxixZ2yzcBzLP6P02A1r37ceVaVrWaAzbS6dklPFb2q67YURS4m7+RyUjpho
	 8XwB2p4CT0STbKxEDvejBLGOoYqsX3J/o//rDtVCR0y0DXdSS73gn7OAz6LeFBqavd6k4
	 kLPvUkI4c4pvpPYM9glkcmA0nMyDLJCsYnfHjtKKSpCOPQtAYIHLyjyWQrOo/Hnaxmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9t4w45YNVvB5qfplvseAH2Qw8CURWhJMeRXdhLsYZmg=;
	b=xWkhUamGkshCNXKBdeTvktJ5MzMzyZKYC4Oxf+Ar79ogEznIPKEKqz9OyUBXtQRDFKyd
	 u3RsB5jZzsIU9GwRhL/1MGwkM1VNKt4ADINEl/RsnDCpXcYoJsHP2mTw2ZHIB5goKEBJY
	 0jMUnqprXE4hj48sLn5B+EMWq9Mvq1sUmEMtN2A6oVBX9FEHCHTN3sIKCG9Wo+z7ozco8
	 QZqdxs4K8lg6kirDe2M/vDEWKxGp+uNT2b1NnMejMgMjbVBlCw8Ok4OwHZKm99fLDJxya
	 BYGCKM2AvJr9PJT0glNzYeOBCzxnq3mAi7R96Z15fMiJ81jI0Fq7oFo6bg6NBHyuP8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eiqAMsWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C59606A31C;
	Wed, 18 Nov 2026 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eiqAMsWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C5F1F000C6;
	Wed, 18 Nov 2026 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019018;
	bh=9t4w45YNVvB5qfplvseAH2Qw8CURWhJMeRXdhLsYZmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiqAMsWiPit0ZDcGGCNhg5xAMnevcYLMA/snfwgsxCRRMqa4r3UuDbPloZRz1ITsP
	 LqUKVShok6sqC2UmaeXdWIotGp+MTUFrjf7/wwkAZ6nWlgqeKN3pYMe3vP6l2qlNPQ
	 Vw+hHz1QHRg+2MLW5WE2DVrSOohI0y7wOsBgCBNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1447/2651] wifi: mt76: mt7996: add NET_AIROHA dependency
Date: Wed, 18 Nov 2026 15:44:47 +0100
Message-ID: <20261118150340.138975395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 29329dfa41de31f8adc7ff0aac0abccb555bb738 ]

MT7996E fails to link as build-in when NET_AIROHA=m:

WARNING: unmet direct dependencies detected for MT76_NPU
  Depends on [m]: NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_MEDIATEK [=y] && (NET_AIROHA_NPU [=y]=y [=y] || MT76_CORE [=y]=NET_AIROHA_NPU [=y]) && (NET_AIROHA [=m] || !NET_AIROHA [=m])
  Selected by [y]:
  - MT7996_NPU [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_MEDIATEK [=y] && MT7996E [=y] && (NET_AIROHA_NPU [=y]=y [=y] || MT76_CORE [=y]=NET_AIROHA_NPU [=y])
arm-linux-gnueabi-ld: drivers/net/wireless/mediatek/mt76/npu.o: in function `mt76_npu_init':
npu.c:(.text.mt76_npu_init+0x4c): undefined reference to `airoha_ppe_get_dev'
arm-linux-gnueabi-ld: npu.c:(.text.mt76_npu_init+0xf8): undefined reference to `airoha_ppe_put_dev'

Add another dependency to prevent this configuration, with an explicit
special case to allow the NPU to be used while the PPE code is stubbed
out with NET_AIROHA=n.

Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260928145210.3153783-1-arnd@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/Kconfig        | 1 +
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 2ca96e0527c02..a4ece38f938df 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -40,6 +40,7 @@ config MT792x_USB
 config MT76_NPU
 	tristate
 	depends on NET_AIROHA_NPU=y || MT76_CORE=NET_AIROHA_NPU
+	depends on NET_AIROHA=y || NET_AIROHA=n || MT76_CORE=NET_AIROHA
 
 source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
 source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
index 5742bce12fbb5..3c51b402f44e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
@@ -17,5 +17,6 @@ config MT7996_NPU
 	bool "MT7996 (PCIe) NPU support"
 	depends on MT7996E
 	depends on NET_AIROHA_NPU=y || MT76_CORE=NET_AIROHA_NPU
+	depends on NET_AIROHA=y || NET_AIROHA=n || MT76_CORE=NET_AIROHA
 	select MT76_NPU
 	default n
-- 
2.53.0



