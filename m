Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059177;
	b=LhI6H/N0LZVQZm4T3ZGT4jdFZAo5oGqkbTK9WZcq7jO6kXlTY1G8JiMyh8TukucYbjdI
	 ZeGJj0DzJWkJv+IDAe8aukxuxc6K59RevzETF2h27bF25CUKpG7fKg1d2WJbS8gD3lx5h
	 RL4+u4P+rD+OLalKEWe48zka/mbDkkXbESsMWGtbG/bVvvOvc9F3qQmyZhRYF5Yv7CycQ
	 XM9xO/I7tE7CtGxxf7hc2gVd6av84B5DkOpoYyH6IT8L6620vi+Mk846cWuVLl7lmnW56
	 VIWdvRUZ0g28bSpJUIoLxwYv7Hvbjpa4/xlF1XeMpe+WumzVoEDhOGLf8OrzOHPUGuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rsW0jcIBzk81rj9G0Rf8M2ukpBcfljbq8iHTyzlKJL4=;
	b=lwO2HkZtm+kN/4Rl83U2c5JXzI+Eb69GgD2QDnuUP+QYtYeAFK+XLMPpsQQGTjumeNrP
	 SWJGk1A5P8vDrYPqALR7Ubk/tlicyuy3NlVRdu624a8LyDlwF5QfmiCCMzNxBlcHHKYRe
	 RlesgfVsAYYzv6z37Os0ZfnddASahc9+4sTN12T82CVLHOefsPsiUS9LNbxBn3Hw1RMDo
	 tchAhbcIpQhg+m8TUFvqhf52HOOVDoAsNnF6rc677iUm0CsCgPHnLLWt4UJCxXkQpVrax
	 ZM1t1G9QPFHsa/1wxbNzT1eyrcgXC4+La0Z4wEa1vsskSI1TtkpEp91i7GHU8/Iia+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3askmwZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42098606A31C;
	Thu, 19 Nov 2026 03:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3askmwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D4A1F000C4;
	Thu, 19 Nov 2026 03:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059177;
	bh=rsW0jcIBzk81rj9G0Rf8M2ukpBcfljbq8iHTyzlKJL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3askmwZtMQteuwQS8kLOMRutQuORIET16hHhy0XXsgt6DkXHLX1UBOjd9l8XEbZ+
	 LgLL1D7XgoawSrLiKL3oeqwPJicF+9xo33rFpzlbjEP//UXtIuHS1OlKgf6ZH6nBiJ
	 JtbokT8aS4U0Tt7Jc/UYV/3UyZ+e5RWwxvcbecK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0747/1848] net: ethernet: ti: am65-cpsw-nuss: Enable timestamping of unicast PTP packets
Date: Wed, 18 Nov 2026 15:46:25 +0100
Message-ID: <20261118145947.763204597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 6228faa1a8c3d..ecffb524116ca 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -103,6 +103,7 @@
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_319	BIT(21)
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_320	BIT(22)
 #define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO BIT(23)
+#define AM65_CPSW_PN_TS_CTL_LTYPE2_TS_UNI_EN	BIT(24)
 
 /* The PTP event messages - Sync, Delay_Req, Pdelay_Req, and Pdelay_Resp. */
 #define AM65_CPSW_TS_EVENT_MSG_TYPE_BITS (BIT(0) | BIT(1) | BIT(2) | BIT(3))
@@ -1274,7 +1275,8 @@ static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
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



