Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208573;
	b=tfo1jjxmsKX7fQ9fxPnqmM4JK/8Ry+0O+2Yjattks0glLfBWloV3RW06WNROeGs59FoR
	 brs3/zqCWFLBd9M3Gg4coxhn7r5Yk1XzSqmKGAV+0Dr66mAl2mWPmxmgTDM5UtbHJKPRk
	 oWDPi8hO47Cyn4/3ZxFhkyKDK16bPSVTdRvjRmlhIqoEkx3v0KZpXZn90+GjTufXhe+UO
	 xBmkYXejENoiMgWzSHNwv4TD5Se1QL/upIixP8d54cU3zvp/W10UcC6rPqe7ll2Wy67FC
	 PZiBINlH/5qqoA0aHPd6L8KOHI8E7ARYCRvAnfYQITDoQO+CRj9vdnoDZbt79XS/cUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n96838nWKoRBe8CZ15ifXrPAjU3Rk+CmxZpaOiS3EsU=;
	b=3pWUUQbKypXposR7WSDnlTs1Qprh6cGxaPxZ3Kreu48mVSm+Rlk5OSNhRt5cprnlLcey
	 QAyHtA6XJLid2o6kHay/VdQZxrXyUKToByl4onpgZs00+LUn9W9o+YEzzZ7MC334yPqw5
	 0MGusL1RuStBhFlo4p4fswILkS55ZOK6Ek2XYZdYmzqQZSXv4XOIJ7DoUp/i3Wssjzfmf
	 k/+g2mF+3nHpjGrHnj4HIyY5Odmo0FRCMPDJwS+nRQEKcYAL/nTaOPw2G39Cf1zsn0Bia
	 kyvz2k7Yb9HlBMTV+yckG8buyT3EvelqIZ4fdRqoQS77OqkHitebw9qB/7jxNFf3ezg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SmO6ovQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E22606A31C;
	Wed, 28 Oct 2026 17:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SmO6ovQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39C41F01825;
	Wed, 28 Oct 2026 17:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208573;
	bh=n96838nWKoRBe8CZ15ifXrPAjU3Rk+CmxZpaOiS3EsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmO6ovQ6opbCUCVjaqc/Ha7vKQAyS1VI6FWljHdzz0FXqgt+Kj25GF4C/mrNB6JcJ
	 oL3G0xA4qu65g/7Y7QTmnA/Lb2OfK01yF+H2Kd06AlK5D4pcOVvuaS6KI52mihr65L
	 Gfyc2OfP18mE8qwHIRs7UEBJoyB3z1aGtBe5oCYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/516] net: systemport: Fix RUNT MIB counter register offset calculation
Date: Wed, 28 Oct 2026 17:55:19 +0100
Message-ID: <20261028170007.462326238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 242935adfeb096f09b29fb2cfcf12f9eb2911fc6 ]

In UniMAC hardware, there is a 0xC byte gap between the RX MIB counters
and the TX MIB counters, and a second 0xC byte gap between the TX MIB
counters and the RX RUNT MIB counters.

In bcm_sysport_update_mib_counters(), 'offset' was only set to
UMAC_MIB_STAT_OFFSET (0xC) for all non-RX counters, omitting the second
0xC gap for BCM_SYSPORT_STAT_RUNT counters. As a result, all 4 RUNT MIB
counters were read from unmapped gap register space.

Fix this by setting offset to 2 * UMAC_MIB_STAT_OFFSET (0x18) when
reading BCM_SYSPORT_STAT_RUNT counters.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 1c6b7808a100d..d77156f0b3256 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -421,8 +421,10 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (priv->is_lite)
 				continue;
 
-			if (s->type != BCM_SYSPORT_STAT_MIB_RX)
+			if (s->type == BCM_SYSPORT_STAT_MIB_TX)
 				offset = UMAC_MIB_STAT_OFFSET;
+			else if (s->type == BCM_SYSPORT_STAT_RUNT)
+				offset = 2 * UMAC_MIB_STAT_OFFSET;
 			val = umac_readl(priv, UMAC_MIB_START + j + offset);
 			break;
 		case BCM_SYSPORT_STAT_RXCHK:
-- 
2.53.0



