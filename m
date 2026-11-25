Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621571;
	b=tTS/0J0akW1tUXO19gpQxk6OfXcu+Sf4HX6IJDGX9OMSkm6Mgt+AHh16JETd0EyAEIBl
	 v1JGxpebJrer0THnWsL4h3Qs7IBusVKwA4LyRCYaoJ3yKgZUaAifhekZQOgPBHhbsptsY
	 mRayS1tbYDEYDL0F4TEd8fKLQNK53Q+OVQ6zUqgcCE5nnCdUjQ7Mg7Bnge6vAQrUkIoVs
	 hSub3+oHYaBVToxym+Q9evyp9CxA6TwV2BpjyNNUIzxxtOzALQL3rk01LItngSiuLvQ+a
	 CYVFbMnPYE4/68troEC4wlisf0hdiqK9ltEqFMtjbGmexumPHRbInG56RwUeZ57Zxeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rwWWml1bhxroLOWVyCpyA+3+QzmGk0XJreoOQARE8kg=;
	b=TSPxzboCIhlaLnjwYHVpQCrupidwere9fheugbg3HT8JkOG7IuPkwcBOV5kCWOMm/Esg
	 ju0B6C4XNoNGGAoQL52IJ7XdYLkZHBnZPlh6HMmQ60SmlgFl7mZLhq4FW1AL+lJavW6w+
	 skpgOXJdzkiFjxuh18GoFQA4G5Z0e7z+aeV3Spw6JcDEpnWXR1AxF9ferz2EOGFb3mcBH
	 uoO9edvG2d6hXkeo93HYt9cwGOdUrBaWLnA/DvYMmhGxpY2LqW2Qk4D9SfwF6wcJjWZ/O
	 Rs179b3DCFeXGIiM8yUzRVyzAF+V2ebi8p3gPiSu9ClIs4Smu/sIhOOFTk33eE5ptZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xR2WiOcu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF71606A31E;
	Wed, 25 Nov 2026 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xR2WiOcu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9E91F000CA;
	Wed, 25 Nov 2026 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621571;
	bh=rwWWml1bhxroLOWVyCpyA+3+QzmGk0XJreoOQARE8kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xR2WiOcumtZC01/J5C7JYqQCPNcwvXOlg/VQ84dT9M9dzg8QAz2ZZy5/kqMQqOzLh
	 lWHzFIIquFiiZQz3FNjfV/i29lYZOh0wzYkiiF0D20Kp3kU3/EOK1y5/3Fyap/ofN7
	 yCJLDZqdY8llRwvR4XwUzIxqDRT16ChLDPeX1Yvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/990] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
Date: Wed, 25 Nov 2026 15:27:16 +0100
Message-ID: <20261125143828.395293397@linuxfoundation.org>
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
index af73a9f70773d..137bc55b86d6b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1702,9 +1702,15 @@ static void b53_phylink_mac_link_up(struct phylink_config *config,
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



