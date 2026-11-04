Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831175;
	b=Wg5fm/DatVoR3cS4GrPelIMTh1nQJKz0i3Jg6AEzFY6U88ugb0TqMzP3fvM2pvV2ZeLP
	 GPhlG7CdSCC3Cy+cA0/JmBuqImvRs8DH2y05ZyPPhIg97Uwb7Y/UArJDSGKINLgL+tZS2
	 ytl+zpw8kT476zc6RdUx5qx33e3WYvJsikqsVlg1f0q/FLHvAKxBMrIqVs1X5PY6R2XoA
	 N2WPoEFiFJ7dRviHwZoOXBr90woJvWHrM899DO3655XC28v7i7cKpn5iDRDY3xWDhyh/A
	 hPEdLMpgcs8rZZX0ko/IbeqwTUXsoS89j6125VDmam5qQSrcAZHmT7J18e6LgKLdRKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gS0MkRSwBey/q0EeZJSyWrZvlcD0nMoR26olm7lSlrQ=;
	b=CBVujh086ntgo8Pc+WC3GwtYs3xWmdozDh5VwjIaMXj4SFTsttmLis9OeRoau1AfIdJU
	 vuUGuqZHGQ+8xdMQq/4iL34dJADpM0OrxYGvAMO+sRGf+jCIVZfZOxH+6yyUGuNmzODEt
	 op8gk8asYiPKmfkgGEu3NXIHnp2vKs4SHtzJPlWEJUUchHSntCFuEl/5H8MO5xgLR3Vwo
	 YqgCAG8/zz3ptFuXqIkpSD07feo4/lig+dBFqooBD80ORfVpjA9rVVh+kmtPIMZYKB4ZF
	 h3RHOZjH7RMUbFI8YB3WyJBJExb3wh4u9caYn5volIwi3j4SJD7iJ4uMIlmy1+yz29Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAuTQfVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5989606A33C;
	Wed,  4 Nov 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAuTQfVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D9B1F000C1;
	Wed,  4 Nov 2026 22:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831174;
	bh=gS0MkRSwBey/q0EeZJSyWrZvlcD0nMoR26olm7lSlrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAuTQfVt4Z1FU2UkKGHgIydnF/1HFAfrh2xLnQJXhy8yTlG3GFCjaEFKmlosXAnVy
	 SboKAhQtnAmr10IfU3OGcTqaFeYkQfVEwzImctwYp8iFYAs9r8deMyw4gisC9IGjTq
	 6T7v5BthsSF5ufg5fW72g8r9WIUKNxzcQGkrLuCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0542/1005] irqchip/gic-v5: Fix standalone IRSes OF probe
Date: Wed,  4 Nov 2026 16:04:35 -0500
Message-ID: <20261104211059.073549711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 64212d63193cfd81849f5948365c7b0ecd011745 ]

An IRS is architecturally allowed to be standalone, namely, with no
direct CPUs connections. Make sure such configuration is allowed on
OF firmware by skipping "cpus" and "arm,iaffids" IRS node properties
parsing if they are not present so that the IRS configuration can
complete successfully.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Link: https://patch.msgid.link/20261015-gicv5-irs-no-cpus-v1-2-d4b337b7f000@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index cf951d4071cbb..554106a22d1a2 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -604,6 +604,10 @@ static int __init gicv5_irs_of_init_affinity(struct device_node *node,
 	u16 iaffid_mask = GENMASK(iaffid_bits - 1, 0);
 	int ret, i, ncpus, niaffids;
 
+	/* An IRS is architecturally allowed to have no cpus associated with it */
+	if (!of_property_present(node, "cpus") && !of_property_present(node, "arm,iaffids"))
+		return 0;
+
 	ncpus = of_count_phandle_with_args(node, "cpus", NULL);
 	if (ncpus < 0)
 		return -EINVAL;
-- 
2.53.0



