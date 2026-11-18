Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046508;
	b=m1npSxSElGNP4NZ3NXLN7EMRFpsyVNG+bYbMSrHIK85QiOZBwIIDutoXMTL05V4CQ2eo
	 x/TFuPL2mLuMBhGlIRgqiEDqXfOPYBjjSBvAr5e1ACAAwyhJyvNJ8N47rfyB61HqoDPwP
	 O5I0WqHF5+pY7n0XS6WnxEked/xy+UM7PtJUCkxmTgpX7EE5uYQwbQDR0rhOsGauCj+aO
	 5/BymQ5thul48HvScWql9DucMBbZwQOupoDyGvUYNW7PMGYYrgIAH3cRl+xi14iG9hQ1x
	 mxFdqgz5YGCVJEGQjfk1mzwCE9pzrvCGIpc1wTnt53QXsxlv+xOvdf6BD2tfFW15Lpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTt4MOVyfvq7EqkvV+4mLVXYIkbjrhwe8nykf9fB+dY=;
	b=zDrIhajf7d/43ZutKKIJGhaurocCgQObiXt2+JirUF3WM1MG5oKuR9UVZrgT5u1lwUs/
	 gALWUycjsHkjSFXgK+J57ZI5MnGvk3fb9RFM0eefBill44wmbkQpdNpbsb5TZ7SvGeCW1
	 l1Qc+WIVaFjGaXpAhdV85wuzIscz+AZBPTN02h49cbcezYQaF43NXECExY9gFFWv/ePkn
	 1Npnz1uOn69awO5uiR64+yQDIGBUVO1kHyLSr+thbF/7ADeTu9DVN+/WP7vqIlTIE9l/g
	 l4UJgvolNOkIw8SMdMJm8dW6buzlah9bk5kIRYc3XcIKs+vno9kAik3ODj4KqFGe9fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXWwfqp3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4EA606A31C;
	Thu, 19 Nov 2026 00:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXWwfqp3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CBA1F000C4;
	Thu, 19 Nov 2026 00:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046508;
	bh=aTt4MOVyfvq7EqkvV+4mLVXYIkbjrhwe8nykf9fB+dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXWwfqp37Vl5C1uK0zVQQXGokcCgXkc1HXI9qlOSyB10uCxA6pw+C+DuubJi9Oiur
	 OAT2Hf9NiklkqN+UtQBfnhx60SAskzxfam0hB06eSpMTIUI1JGS2U8yBPlAQ2vdEGq
	 UyDsdtFnO1mTfyqd45nbqUIIWK7tKmBBidsGOZ14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1307/2857] net: ethernet: ti: am65-cpsw-nuss: Enable timestamping of unicast PTP packets
Date: Wed, 18 Nov 2026 15:39:01 +0100
Message-ID: <20261118150248.529421575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a4184e9dddf15..cd99d34286a57 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -109,6 +109,7 @@
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_319	BIT(21)
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_320	BIT(22)
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO BIT(23)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_UNI_EN	BIT(24)
 
 /* The PTP event messages - Sync, Delay_Req, Pdelay_Req, and Pdelay_Resp. */
 #define AM65_CPSW_TS_EVENT_MSG_TYPE_BITS (BIT(0) | BIT(1) | BIT(2) | BIT(3))
@@ -1304,7 +1305,8 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
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



