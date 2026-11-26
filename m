Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704321;
	b=HIFmVOhhufwNU3Dlv/WnxrLpMg24I5tU9tCDoq+5qLEfHKfT8eM7z0XszNqR/YllXRmn
	 uBPFAacK9lBrNhKvOUnXqlEnfzehYRknKsgy2MBDknJivMNhAgBkoI4HATCj9IER8r7ZY
	 i4eoelmAJITiUooldC8Vz0NopBD7nICXc8wfqwmboY5y+vSWgR3XoGQJ4UxXWHUgvXlo4
	 q+yT0FeKRPv54sIIA8ugs6s8GhYVuJuiYQxcg7SnU6maI9D+8ljMwEImkvvQQVZoB4y0/
	 oz9I/llPk2SnsIs9UaYYQgjMKntKETgpGnJ6/luKMmezemJoM8RYyHUBzNan6jrWcUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FPjVlN6Jv5xzEMnRdcgEqcQf6rE+Za74jJIw3outRw=;
	b=c0DvEOQmlLcfKFwVWRV/stIGMLaAHvQ18LptToy7ha7/2sugipFYxg/thEsZoNudM5+R
	 YY6JT5e3UsiBCjQsBbxROHswbGfHFx5mZX1dI6cOkQlrEHJxk3ODWfqTQSMN7NMfm5qzv
	 L8xrwH4F5OTuwLLo4veYtCEIKSRIDau7Dg+qLGI/HtOJW5iDltFdysFyVHN8q28ZnLg5A
	 XXjC/tM7db5awyyQCivjdKwqJXvjmIPn+q46xlXvaUScMG3YzWvrwA5dbpmzcUPDZ2rta
	 Kh5HXhqJg5P8bg7vBI2cIFeqW7xtZz/Ary6rMgU5THXTUAn1oGnHma0nvjBURWHWpSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtjlM5ac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0688606A32E;
	Thu, 26 Nov 2026 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtjlM5ac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A691F000C6;
	Thu, 26 Nov 2026 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704321;
	bh=7FPjVlN6Jv5xzEMnRdcgEqcQf6rE+Za74jJIw3outRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtjlM5acs0dMikjrZA6mUuFPDlfTjNQvApnkUUCHBWX8no1ZyDQ6sljfyQyBDXPWi
	 T3+khiyaEDgDsA0EO+YUda5OSh5RMoahdVD6CTxfc45eXQgaq53QnREYfBTc2Qw8qq
	 QJULkPzNWwvZff8Ku/FnZpyzY2xm8qFlJ31jV2HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/265] net: dsa: b53: Force flow control for BCM5301X CPU port(s)
Date: Thu, 26 Nov 2026 15:36:52 +0100
Message-ID: <20261126143610.764015894@linuxfoundation.org>
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

[ Upstream commit 93a2579ed08c76835514d2a7f6e5bf3a9bc377ef ]

Just like what b53_adjust_link() does, force flow control for the
BCM5301X CPU port(s) by forcing rx_pause and tx_pause in
b53_phylink_mac_link_up(). Preparatory step for getting rid of
b53_adjust_link().

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20240423183339.1368511-5-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 41af38324341 ("net: dsa: b53: restore the NSP IMP port 2 Gbps mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e975c1f627afd..bd0b3dbb4df4a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1474,6 +1474,10 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		return;
 
 	if (mode == MLO_AN_FIXED) {
+		/* Force flow control on BCM5301x's CPU port */
+		if (is5301x(dev) && dsa_is_cpu_port(ds, port))
+			tx_pause = rx_pause = true;
+
 		b53_force_port_config(dev, port, speed, duplex,
 				      tx_pause, rx_pause);
 		b53_force_link(dev, port, true);
-- 
2.53.0



