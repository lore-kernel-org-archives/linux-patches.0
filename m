Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705147;
	b=yOaToG1GYdxWGah2+Qk8AqmKrzxtG82tx1WlLamcs0T+Cb0AUCAl5i4WOcoyT5pNb4qu
	 W63ksdSaQ0oY0n6sxTXxk357j04ph6Oac8BUUrGhbbvG4hdbrYkjLXqS0cdDiX1lXhLKc
	 vYDc+eaB/Toog/drIiGXi5NhvGwXmpoLi1SOvZqK4hxcZEswm7AbJfPMd+/MlRO52vx83
	 /ixwqWMAtuAkfttMLHMU/8rx144GfC4F/dgsNYLLIaE0zaEFWo+kDB/fUyHeMFwQXSA2m
	 QvBP2PH5mDOeztrEnah31D49tYqtgTOJhhmjYDhscrigbw/NlBKSj9hY1ckMj5TMWwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLpC3U5H+Hc65qI8HmQbWTqrgh+mH96bhTwJckt1KjA=;
	b=W70UTArkbFzL9DhGg0tvlWkIUrk7A4NTy2PlhKDE9ayso7Xbv0PeIctHeXLNOBJcXEJu
	 9asabCcL2yHLKIW6Yk/jKPH0LyAzPJbe3bXneTXhJ0Uhifrk/3Oq20PJ0BEYtg0FJ+ZLL
	 dyHEndIUrz+a/EVWYt1kN+Oe0ObVpcXa2i+GGcf+Aoffag0BHOC55+3knKVdjAjRBQXeD
	 1DyoLKUdyqrg2o/q7Cd/B9c6HPetTd7nUfm8SQfec2a1bjLfnixAExpmwnNCPa19gnQ2z
	 jXWXf47Y/eWvY09ix1PzF2uOY+uEZ2eYNCSTVjfXbwmoR+m+34nlcnF6GhhhC4LrFRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jIOsO1CI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E2606A31C;
	Thu, 26 Nov 2026 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jIOsO1CI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512331F000C4;
	Thu, 26 Nov 2026 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705146;
	bh=eLpC3U5H+Hc65qI8HmQbWTqrgh+mH96bhTwJckt1KjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIOsO1CIUfTQ1Od1TmQE6roz8PqZtTUUnABK3jh9B94gI7LWXZa+q34v2WcW9x0CS
	 h+2kP4DT6a1yg9Wi4eVDz1qJerbs+Gf3CSiwdz8R6WwPzelJ+4EBDs48e3hWrF1VYa
	 td8DQvUOyvWujSz9LCCqhFd4u3MFu8PHJIj1pnrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/319] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
Date: Thu, 26 Nov 2026 15:37:47 +0100
Message-ID: <20261126144008.979366300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 84b71af29c5c9..cc6810ae58f2c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1538,9 +1538,15 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
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



