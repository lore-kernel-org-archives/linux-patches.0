Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622946;
	b=bdhEgtlIF1mIkS6hNsrooBLQrz7vezb8hjMGuRloaA/g+OfPxRLVnAWa/D9xBALfuWAL
	 y5UCg3TQGVh51y9q0SCeVcnQov6YGg0QBIr+wr1TipgGLhopP3D1wdAyzCKTlq+FHBidz
	 DtTI++5b6/nmxmS1gSAsNk5miKd0dxlqI2q4KrWVNJ6e7tM8vAXeMeGGZ+RS3CEcOjAr2
	 TYNW2LthtEO55T9Z0YwijMIsflN4ZqdDFoaGVPTwU9Zzm0eUtE+4oPpxJmJl8lN+ehSql
	 ZqoIbbdkdl+hYlwvC1/o8Y3330fDmX96/eeH7T5btYtR0pbYXxvxsSPKOxoR2Zz8djA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UEbs/ReTdbkf6xhjrSXquOLxYjGOoV71ZtLWwUmmPO0=;
	b=UUQBJDnHiuR42DbPwQ6KXbSniVxHxZeYUzuDIAi9zAmW4hzerHXK8+ZjJvmJnThYI1VX
	 c7f8Zl3jhSxaliw7hlAjotFyEkFeZpNbtIHFUdsKspu6MfOAsbxogjrHgaq6M7h8pTBIN
	 3chbETCgxWcDUl8Hk3t7cGuqxwSFR07yP3B5Gt6Bl1TuvnsyqMJEsG/hQI5u0O1EHtxff
	 7mqX6/38o/43ffti4FubrdrpupxQa0NyzjdJAG2AULNfPNk9F43K58sVEWwAuZEqMpZoP
	 h5rwwAN1KK8fRKr2J1XAGplS3ySTG6FAQhhVba2WMk++MrSq/Gpld3tp42T/y7fq2Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtVarXmG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC34606A31E;
	Wed, 25 Nov 2026 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtVarXmG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC511F000F0;
	Wed, 25 Nov 2026 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622945;
	bh=UEbs/ReTdbkf6xhjrSXquOLxYjGOoV71ZtLWwUmmPO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtVarXmG8fUcRPG1UQelckv/NzvLW8O0m5OR8ryp/nFJ6RsAwSkx9iwfObEsYuTOb
	 KzLmtcabx6UG5iA05jb3ZlhQTxgxahUDol62k7jYvHz1lRZtzqkm76u+8esObI9dx0
	 v9jUcaZp+ixe7B/WrhhDaraWEH6W7Y3+a2YKYKxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 701/990] net: stmmac: ptp: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 25 Nov 2026 15:34:28 +0100
Message-ID: <20261125143838.503091887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: James Clark <jjc@jclark.com>

commit b66fca408bf85bb40f48a689daac75421f5283f8 upstream.

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") modified the PTP core to validate the supported flags
of external timestamp requests, rather than relying on each driver to
check them.

stmmac_enable() and dwmac1000_ptp_enable() ignore the flags, and
neither stmmac_ptp_clock_ops nor dwmac1000_ptp_clock_ops was given any
.supported_extts_flags. Since PTP_EXTTS_REQUEST2 always implies
PTP_STRICT_FLAGS, the core now rejects every PTP_EXTTS_REQUEST2 for
this driver with -EOPNOTSUPP, where before that commit the same
requests succeeded. Only the PTP_EXTTS_REQUEST ioctl still works.

Tests on an NXP i.MX 8M Plus (FRDM-IMX8MPLUS, GMAC 5.10a) show that the
auxiliary snapshot inputs timestamp just the rising edge. The reference
manuals for the STM32MP13 (GMAC 4.20a) and the Cyclone V HPS (GMAC
3.70a, which uses dwmac1000_ptp_clock_ops) say the same.

Encode this in .supported_extts_flags. A PTP_EXTTS_REQUEST2 for the
rising edge then succeeds, and one for the falling edge or for both
edges fails with -EOPNOTSUPP.

Fixes: 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to ptp_clock_info")
Cc: stable@vger.kernel.org
Signed-off-by: James Clark <jjc@jclark.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20261104052504.1886335-1-jjc@jclark.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -302,6 +302,7 @@ const struct ptp_clock_info stmmac_ptp_c
 	.n_per_out = 0, /* will be overwritten in stmmac_ptp_register */
 	.n_pins = 0,
 	.pps = 0,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine = stmmac_adjust_freq,
 	.adjtime = stmmac_adjust_time,
 	.gettime64 = stmmac_get_time,
@@ -319,6 +320,7 @@ const struct ptp_clock_info dwmac1000_pt
 	.n_per_out = 0,
 	.n_pins = 0,
 	.pps = 0,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine = stmmac_adjust_freq,
 	.adjtime = stmmac_adjust_time,
 	.gettime64 = stmmac_get_time,


