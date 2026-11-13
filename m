Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591252;
	b=fZizjVmnHITe8MBlxw67CeoIAAPd11p686q+PJZ4AB2Y9NBNEiSljz+GoMVlq2P0WarJ
	 VD7EDV5Zn3QI0inxJcwNDONmTRpyKITItg3FhLyX9YH2EACb5a4y4Ji+0gxf5zUbND6tP
	 paRWm3L6WHDBfyd5irvzkoSd2Mp9+PtGlnMLhpCHUgkX6OATK5Vi+cG/PvC+PJNE6851D
	 nPwATqJ6X+SpiitgFkINAbJqB//z/w8s2uAIZr4Zt5ihpfebNJUG+cQXghPRtkzt8OC2k
	 qF1D8lSLumqXZOf9VQTd9uA8h2uDpvd0Ro+UtimCeZrJ25A03hXQWrmc/FclfMTuYSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kOmqEE0v6mnvDJJp9Lm6sQOowQR+oy2eig9JaZ9G3hA=;
	b=w4gRim39atjJ+8ZOgvYseukJjNf2F1EfgDBP+YVjI2eSfe6djvC6cStiMwTWUPHs33F/
	 7+BeM0wFA38rEtB4gv9UMbgYjdmVPBUWsEJME1AAWyL4MvHeYOrjIAeOa4XFX2dN8E0RU
	 zOrbI+rblbiVHQ1+1p2GyhcEKGOiFWzr1lecYGPXc5lrPfWdxZoyb8m0IZPyCPt1uBQx+
	 57VjsbGPBZ/awP3uC7IAEQRqFPDRKYlpIquzeAxC2LV0bjDBOgikeQdOisaSSxcIinLXt
	 2z+4oKRaHiNR0t/QYXWoZ3JYFq97DRTysHe5jsWian2YjMwdKtgrq3GsZtMjUBuMHVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXQ8dXb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E551560A380F;
	Fri, 13 Nov 2026 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXQ8dXb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B431F000C4;
	Fri, 13 Nov 2026 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591251;
	bh=kOmqEE0v6mnvDJJp9Lm6sQOowQR+oy2eig9JaZ9G3hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXQ8dXb6vPBzWOVnB4azZXjZVV+2QEDbfPzfb/BL/BFyCUVN1S1SRmY88IWuyOgK8
	 QyL19WTfsqYzR46WgTq3uBHMaaDMJqvch63/7PI6yU96LJJNTNxcl0mm2q19ahi0uH
	 Kw1Yiz4jqNI2RbCFAus3FMftnVl2TcRaSiCimSY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/670] net: ethernet: ti: am65-cpsw-nuss: Enable timestamping of unicast PTP packets
Date: Fri, 13 Nov 2026 10:48:59 -0500
Message-ID: <20261113153824.497041003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: James Clark <jjc@jclark.com>

[ Upstream commit 6887a8f98244ba4c0fbe2d2461b9b8f8a300e326 ]

On a BeagleY-AI (J722S), ptp4l as a unicast master (unicast_listen) logs
"received DELAY_REQ without timestamp" for each unicast Delay_Req, and
its port goes to FAULTY after "timed out while polling for tx timestamp"
for the first unicast Sync.

am65_cpsw_nuss_hwtstamp_set() does not set the TS_UNI_EN bit (bit 24) of
the port's TS_CTL_LTYPE2 register. According to the TRM (J722S TRM
SPRUJB3D, 12.2.1.4.7.13.5.1 Ethernet Port Receive Event and
12.2.1.4.7.13.5.2 Ethernet Port Transmit Event), this bit must be set
for the port to timestamp PTP event messages over UDP sent to a unicast
address; without it, only messages sent to the PTP multicast addresses
selected by the TS_107 and TS_129 to TS_132 bits are timestamped. TI's
netcp_ethss driver for the Keystone 2 Ethernet switch, which has the
same timestamping registers, always sets TS_UNI_EN.

Set TS_UNI_EN along with the other bits. With this change, ptp4l in the
same setup gets timestamps for the unicast Delay_Req and Sync messages.

Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
Cc: stable@vger.kernel.org
Signed-off-by: James Clark <jjc@jclark.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20261102135117.419539-1-jjc@jclark.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index e9d9d69e2ba9d..12860cf2fb932 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -121,6 +121,7 @@
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_319	BIT(21)
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_320	BIT(22)
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO BIT(23)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_UNI_EN	BIT(24)
 
 /* The PTP event messages - Sync, Delay_Req, Pdelay_Req, and Pdelay_Resp. */
 #define AM65_CPSW_TS_EVENT_MSG_TYPE_BITS (BIT(0) | BIT(1) | BIT(2) | BIT(3))
@@ -1830,7 +1831,8 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
 			 AM65_CPSW_PN_TS_CTL_LTYPE2_TS_132 |
 			 AM65_CPSW_PN_TS_CTL_LTYPE2_TS_319 |
 			 AM65_CPSW_PN_TS_CTL_LTYPE2_TS_320 |
-			 AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO;
+			 AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO |
+			 AM65_CPSW_PN_TS_CTL_LTYPE2_TS_UNI_EN;
 
 	ts_ctrl = AM65_CPSW_TS_EVENT_MSG_TYPE_BITS <<
 		  AM65_CPSW_PN_TS_CTL_MSG_TYPE_EN_SHIFT;
-- 
2.53.0



