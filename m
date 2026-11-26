Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704324;
	b=uN4T2X1aGu0gl15kJZPPI0wIrrcWhoITxrsuFvfQXs7rGgCCfLiihkFIru8Cyh1BPqNH
	 Ad6viJSRRFz3Nmcfrfhx4pbuFFJszFJF4ARorRmhCxgxuaT1ugRt56j3ckg52RZAOQuL1
	 dmhlgyAUHtmQOrWVwVUkv6RmmuGgK4NZ/hgllmLhgOGp4XnQMn7gzQA/HVdSE8UcNB9Us
	 qMPVGRrfbLgMDhRtndjdghBZ6t8XXeuGETdXa7Wny1v4x4ZWCr+oELeH/Bq2iQafRsV6P
	 lJUu4cVoX9ChczU97rhkfhZCSFxtOBXmt0poF/BR3rfxkYn6XIAD/n+YuW3wmryhy0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TUENofe7wIALtGi0yxoi2eCf8QSKVL+ONW5rnJq7Vto=;
	b=Lt/RGFYhkJaddfXiBIyGy4YVUefXkGtxv0nb8JmqKlfAqV83mMX0w1P4FftbzPq2M5dI
	 EaeRXokZDpReTR3skG9fMhTlejU5a7LHvEmobMXrytEsyC1TcYuGd0+6fcn+lhN+BnaDO
	 hKERYPYzaVDz4cp9WpksamuDURd2PFKPQkxyfeVXYH0iCpss7U3KV0ZYuqho/1dKZmXCg
	 Dai8xrquf6bV53RYVexjH2zZkawbeFK9Jy/BCd94lADM0nbdg+3/M6zjx7eUT1lqrGipr
	 5+mAcRBHGCrEizOGAn1FajBhzDUzYoLLBmH0MxBvNIaaHXyyVlLfkoU61TZwJx3nmsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+JnCufO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE86606A31E;
	Thu, 26 Nov 2026 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+JnCufO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8891F000C0;
	Thu, 26 Nov 2026 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704324;
	bh=TUENofe7wIALtGi0yxoi2eCf8QSKVL+ONW5rnJq7Vto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+JnCufO4JTXU8AWyf3CGnzVI3A4UDtBjVHL0TyFGA0fjaOLMRsYD3uzO7BuIFqcW
	 OeGvNtiFDuDqqY5hnv3Eid/ZhZqCxrqa/r84dq2EH/Kpu39hsX9vsWvHASTJ99/Hnj
	 TKMZ2ASa5ZjOzQ03dMLMCFqh1RMCnKsFAQj5O9qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/265] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
Date: Thu, 26 Nov 2026 15:36:53 +0100
Message-ID: <20261126143610.834891355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

[ Upstream commit 41af38324341df9d769641d6485abb67fd5209ed ]

The Northstar Plus IMP port uses the switch's proprietary 2 Gbps mode for
its internal link to the AMAC.  Its fixed-link description reports 1 Gbps,
so applying that speed clears PORT_OVERRIDE_SPEED_2000M and leaves the two
ends of the internal link configured at different speeds.

Force the 2 Gbps mode and flow control for BCM5301x and NSP CPU ports.  The
mismatch caused switch output queue discards on both copper and SerDes
ports, with one discard for every TCP retransmission.  With both ends
restored to their high-speed modes, iperf3 reports no retransmissions.

Fixes: b6a8a5477fe9 ("net: dsa: b53: fix resetting speed and pause on forced link")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261029211540.4123250-3-florian.fainelli@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bd0b3dbb4df4a..a6eab07ae07b2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1474,9 +1474,15 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		return;
 
 	if (mode == MLO_AN_FIXED) {
-		/* Force flow control on BCM5301x's CPU port */
-		if (is5301x(dev) && dsa_is_cpu_port(ds, port))
-			tx_pause = rx_pause = true;
+		/* Force flow control and 2Gbits/sec on BCM5301x and NSP CPU
+		 * ports
+		 */
+		if ((is5301x(dev) || dev->chip_id == BCM58XX_DEVICE_ID) &&
+		    dsa_is_cpu_port(ds, port)) {
+			tx_pause = true;
+			rx_pause = true;
+			speed = 2000;
+		}
 
 		b53_force_port_config(dev, port, speed, duplex,
 				      tx_pause, rx_pause);
-- 
2.53.0



