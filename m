Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624522;
	b=L1JN6v8IPlCj0QWVr1JKBdpwsH3VferEuS2QdzvhMT819jdwboFhoBogj4TkNoYE6FUL
	 9W1cJ6+W4v9FoVmO02VamUlUkUtvNUYFMFZ5g1M60zsRKCws2kGuoSrcsJmXST1Kfex9K
	 G9cOv2VcgqrNd7SSwRhS16ckEqiGBIb6+aBLa0kP4Wd/fKN24aQsc7wmYAhigUGUvJv87
	 VG5OKh9Ih9RoFMLOARjzYpxVTq+GbCF25YY89LBrLSYQw8QNM7y7MJtUmGRpN+nX7G+OG
	 zOS1AERcr+M+W/3rjPV4rMMEszuEXMZyIQODgCry4MuMrOqmZoC9+Ao81VUnklu5+Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zr7+CcMvGiYftbTPaRJjdt/sTZZOwqFzxUi5KTRQaos=;
	b=Eo8PfXuhAOQwMEaFSH6w8PImTGb3kuV1oH41XjxXqr2XoRlYHlmhXfaBeRsVyS2oNeqL
	 b8pudVKvqhr1l8917uNEkyhIaPjtwYjN+pqaffgJLdx/AQ3QqXqsw2sM8yXky3kmg+vQf
	 fq/o9rcuceduocT1F03Bxwl6s26OJko3g/xnCk8iLvvPd0t1f44AuTEz5UCNiTmBjKueR
	 GH8hnIrxwkai9oh0f25suX/cQIRKP+vl9dgm3q30oCR6Ezn3MoKp0Im9F8kVI8rT1mTHY
	 7Ii76u4QpkBOVHxxObTM8ZLnQ0tVxMSTLSygAJS6KefoqpugKLa/Zv6n++a8ZAbLcTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/ItKG2S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA79606A33F;
	Wed, 25 Nov 2026 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/ItKG2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D10B1F000F2;
	Wed, 25 Nov 2026 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624522;
	bh=zr7+CcMvGiYftbTPaRJjdt/sTZZOwqFzxUi5KTRQaos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/ItKG2SqCg6U275gxNRjzKKnwnVRFl6eWdu5XJQfQa8XtfFlR3L+qp0ThRFFqkY7
	 ByJWYDF35ebVHwc4tIPPJurLDwODO5eJrt2KrOvj6FJyJzM3A0STM4HoGLIeGmbgIS
	 5QJ1s6Hm03PAMX/9uEuyzROjkMrscnHtjjbOYjoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/816] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
Date: Wed, 25 Nov 2026 15:29:26 +0100
Message-ID: <20261125143854.249625035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 1bc00288612c5..0ad48ef3ecfc9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1654,9 +1654,15 @@ static void b53_phylink_mac_link_up(struct phylink_config *config,
 	}
 
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



