Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015510;
	b=Q3uviCRikR8HWbr+mNYr/Aq90GoMFfUwMconykLdJmOsCUkhiachJAK2ldx8Mtzmsd5g
	 NzuCXFRKU6hxzZPI4Fj/QIV/1yrnZlanvQM3pvhAcTGhLvXr8PVdKarWsi2YuxpdB6Lon
	 SPb7IiyYpIAb00AVoo9UaBKIkSWarz6SvzYiMXki+RYfpmwu677OggKZrJj7+ylvKuUVV
	 BV/8pxxyTSoi/AozHtztQ1Vzb9yaDSUX84stTRKCk91oua24jIbxCJ+Y6/OUgltHDBv34
	 vtM7aScdC2f5cRWGbqqoAfU5md0BozZRtyL+qUZmKuBTv3ez/UVq4gi4j3uS0yED0gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aZalvUsIr1+r00aaQoDV0aZ9LJv2yTJhXEH40Ndm5mA=;
	b=tgJKZ5EaFG0Nb2fI3yjqtsTWUrzGTn/64Tn7PXUdcbEVQs+Qs/CDKzCUlXHFp68G3EMd
	 5k0yv+OwrAxg5dZTjYO2rZcnLEMDXdmOVZ+Yc3EDxWxGAvfNsdn45ekpt755uxvZSkKYm
	 mzbJ6mGak5QfJWiUaKoJfGdn+pT+c6xkp/0ZzA4uvJwAmnUhUgrNn8iyCWHsKMmAAERAW
	 kZG9FKi+ITCH5mqdoGYK7MT5tF7OdDKsgdGkVgS68PX2IbOftDecqQZOdHHI89ZLOUjx5
	 9hniVPdW0A1FQUrrPEvaa6Qwpa/uU/9TAnftzdKJZBkbmxZGq9vpzCB4R1wCuV3KDnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpRcryqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80FE606A335;
	Wed, 18 Nov 2026 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpRcryqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FB61F000C6;
	Wed, 18 Nov 2026 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015510;
	bh=aZalvUsIr1+r00aaQoDV0aZ9LJv2yTJhXEH40Ndm5mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpRcryqn1Rj/VvTTGjV8RXsak0FvsbR0KtZOSSyamq/YlW0ncijPKMIZwnZHeeW81
	 ViRZ8nkeQsoOoObT8NOcK8bte/5uEWWDEZi9Y91d9V2AjNpY5tU/1xE/z5mIe/kZVU
	 ZTUbHFAgaaK0TH5n7/GvRIvtblQKiIGZLXJcGCwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0198/2651] wifi: ath11k: fix sporadic WLAN initialization failures
Date: Wed, 18 Nov 2026 15:23:58 +0100
Message-ID: <20261118150254.991870808@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 32ec8488d75d122768b1977501bcb5ec799230c4 ]

On WCN6750 platforms, reboot stress testing occasionally results in WLAN
initialization failures after boot. The WPSS firmware reaches the running
state successfully, but no WLAN interface is created.

Analysis shows that ath11k_ahb depends on the QRTR SMD transport for QMI
communication with WPSS firmware. However, this dependency is not
currently expressed in Kconfig, allowing qrtr_smd and ath11k_ahb to load
in either order when built as modules.

If ath11k_ahb is loaded before qrtr_smd becomes available, WLAN
initialization may not complete successfully.

Make the QRTR and QRTR_SMD dependencies explicit and add a soft
dependency to ensure qrtr_smd is loaded before ath11k_ahb.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806101331.484063-2-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
 drivers/net/wireless/ath/ath11k/ahb.c   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index 122726f84492a..44b520d2e66ee 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -14,6 +14,9 @@ config ATH11K_AHB
 	tristate "Atheros ath11k AHB support"
 	depends on ATH11K
 	depends on REMOTEPROC
+	select RPMSG
+	select QRTR
+	select QRTR_SMD
 	help
 	  This module adds support for AHB bus
 
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index ec5bf5c9fd792..e417b0a0f2d7f 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1343,5 +1343,6 @@ static struct platform_driver ath11k_ahb_driver = {
 
 module_platform_driver(ath11k_ahb_driver);
 
+MODULE_SOFTDEP("pre: qrtr_smd");
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN AHB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.53.0



