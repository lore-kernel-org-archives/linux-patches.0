Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061948;
	b=U/PDBOHc5pmPm7l2Ztfas7Kp+XMtWgHn1sYpjutaaEH9NgiXcTR4lhHOh8cyuRQlJiwt
	 woD5cDf4MF1/cHz2ZXhub0e65LzAyIsTjLyeiyEXVWOyZqHSyRYJNemiw05kluiaxZL3V
	 +n05THF4UrvQEX1tUMcxjQpZHiT8HBfm+A6KBkgg0lsrVhIxyCOYNJ3ZYcIu5jlvN69Yz
	 k6yudVQajdptHYUabyNzuUETV6U6clgP4439IdoFXo0eXzpkTXOEckcaOK3FP+RP2QHM0
	 dy2jXe3rzdBoQaM9AsDBbMCI7/SLtkzYCg9FMn16QvBR0BBv91lN2NohcoJ9hvqC3qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qBkXV1+BQdi1kpRinGjGKBEWgTZ9exej0sFiAq3Fj/E=;
	b=dhcszdcoonMb37gQ6LdhdmSJHX62+sIWvgcMAOFXSGMb6Q6oGT2hs4Eux5Avs90cM0um
	 8bZ2v+8oY/in6S8MyIAXy4qQuNrWu1curlyswZ3DSK+8ucsM+g+KEYabUvo8Yw6RJEFGH
	 HHSyzdckj+jQguZA7GAIoARtlOBuSisnFDr5wmJ2ksIl4O/rHbMGdMbau0MMySb+dSi7K
	 LEgDfXpabKuzfijA782VhVIijdRDNAXjWktsrbZdDmc6NSzezIgZqtGFvODhVfPubwM9C
	 p3Ixmib+g7uS2DNFFMENtHW+wd+0UMlNS8mRvMQCM3Bz76vWWSaBRgIjAWljuPhgI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUtDTC7K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A98606A320;
	Thu, 19 Nov 2026 04:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUtDTC7K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680271F000C4;
	Thu, 19 Nov 2026 04:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061947;
	bh=qBkXV1+BQdi1kpRinGjGKBEWgTZ9exej0sFiAq3Fj/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUtDTC7KIdbX5xVBpGL/mtczZjISG5ckZSp2+FEy5N8HXUdJ/kIuM78L8N/lOsEWy
	 XsiZsQ8KTcGUtK2BDc9BpOSQYFQrW0YUkKXU0gZMw0L9dhzIAl/Obw6jZokLVPkI8D
	 qBkhLuOJLP2i5PnkGSt/C80Guf3hfHUiBKQJVaWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1684/1848] net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
Date: Wed, 18 Nov 2026 16:02:02 +0100
Message-ID: <20261118150030.263952121@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a18394269fc87276963e8d965c730900178d7e4b ]

It's a frequent pattern to use netdev->stats for the less frequently
accessed counters and per-cpu counters for the frequently accessed
counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
implementation for this use case.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 95a5c641fc7b ("usbnet: fix smp_processor_id() use in preemptible context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d3a2234c736c3..55be695d50532 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4613,6 +4613,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
 void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 			   const struct pcpu_sw_netstats __percpu *netstats);
+void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s);
 
 extern int		netdev_max_backlog;
 extern int		netdev_tstamp_prequeue;
diff --git a/net/core/dev.c b/net/core/dev.c
index 8d286a64d2c8f..835a22a760ca0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10450,6 +10450,21 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 }
 EXPORT_SYMBOL_GPL(dev_fetch_sw_netstats);
 
+/**
+ *	dev_get_tstats64 - ndo_get_stats64 implementation
+ *	@dev: device to get statistics from
+ *	@s: place to store stats
+ *
+ *	Populate @s from dev->stats and dev->tstats. Can be used as
+ *	ndo_get_stats64() callback.
+ */
+void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s)
+{
+	netdev_stats_to_stats64(s, &dev->stats);
+	dev_fetch_sw_netstats(s, dev->tstats);
+}
+EXPORT_SYMBOL_GPL(dev_get_tstats64);
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 {
 	struct netdev_queue *queue = dev_ingress_queue(dev);
-- 
2.53.0



