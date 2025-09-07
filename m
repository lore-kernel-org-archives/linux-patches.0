Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8721E1DE8AF;
	Sun,  7 Sep 2025 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277236; cv=none; b=rhA1l+cUgl2uoiYF50a4o7jHHr5ufDuukytGUqKCUkMKXZU17+8z2PicwdYkqT5y6s0vdZXnXUvU4OQEJUSyerMPsMtbyjIV3S0Ru3Iwz2xBuG75tJCL/TDCLQxbciHHQI0ZLcKSg9UJut3tlCQf2GjeEPgBU05lpSjSxDNflPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277236; c=relaxed/simple;
	bh=a+orjOynQugwfITG/wVHYDaYQ+Ncix4dngd4c4HMqs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl2j9mAo7atjoPwQgqS5nz+qsNLSFu4/PwVMRQtBKc5q9CPfylZ04lWkvXAt7phWb9FSkoKvITjhkRF8FoWXzNRLcE9fydRietSKcul1lK53EXunMlk7cwG0y5bynbWEzLfSIBWIK8z2ffvxtWQ68pHzL7d9aPdN4mbJR9L2ywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDaArGG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDaArGG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBA4C4CEF0;
	Sun,  7 Sep 2025 20:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277236;
	bh=a+orjOynQugwfITG/wVHYDaYQ+Ncix4dngd4c4HMqs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDaArGG0PHJm7RzV+MjAOeMUNh6d5kvvsnqE6KKL25IJpNj/7hEw6I36ulXGhviiq
	 hdUtANIou7e11yZAKBdInK2X2qFubTaNwxV0sjH798fbuxvG1nfIEjVJHY8mwne+ZX
	 o8yNgITKaXEV+v7cieDrr8Wxg7iU8Qfy0OhBKslU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 126/175] net: dsa: b53/bcm_sf2: implement .support_eee() method
Date: Sun,  7 Sep 2025 21:58:41 +0200
Message-ID: <20250907195617.837336539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit c86692fc2cb77d94dd8c166c2b9017f196d02a84 upstream.

Implement the .support_eee() method to indicate that EEE is not
supported by two switch variants, rather than making these checks in
the .set_mac_eee() and .get_mac_eee() methods.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/E1tL14E-006cZU-Nc@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |   13 +++++++------
 drivers/net/dsa/b53/b53_priv.h   |    1 +
 drivers/net/dsa/bcm_sf2.c        |    1 +
 3 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2388,13 +2388,16 @@ int b53_eee_init(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL(b53_eee_init);
 
-int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_keee *e)
+bool b53_support_eee(struct dsa_switch *ds, int port)
 {
 	struct b53_device *dev = ds->priv;
 
-	if (is5325(dev) || is5365(dev))
-		return -EOPNOTSUPP;
+	return !is5325(dev) && !is5365(dev);
+}
+EXPORT_SYMBOL(b53_support_eee);
 
+int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_keee *e)
+{
 	return 0;
 }
 EXPORT_SYMBOL(b53_get_mac_eee);
@@ -2404,9 +2407,6 @@ int b53_set_mac_eee(struct dsa_switch *d
 	struct b53_device *dev = ds->priv;
 	struct ethtool_keee *p = &dev->ports[port].eee;
 
-	if (is5325(dev) || is5365(dev))
-		return -EOPNOTSUPP;
-
 	p->eee_enabled = e->eee_enabled;
 	b53_eee_enable_set(ds, port, e->eee_enabled);
 
@@ -2463,6 +2463,7 @@ static const struct dsa_switch_ops b53_s
 	.port_setup		= b53_setup_port,
 	.port_enable		= b53_enable_port,
 	.port_disable		= b53_disable_port,
+	.support_eee		= b53_support_eee,
 	.get_mac_eee		= b53_get_mac_eee,
 	.set_mac_eee		= b53_set_mac_eee,
 	.port_bridge_join	= b53_br_join,
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -387,6 +387,7 @@ int b53_enable_port(struct dsa_switch *d
 void b53_disable_port(struct dsa_switch *ds, int port);
 void b53_brcm_hdr_setup(struct dsa_switch *ds, int port);
 int b53_eee_init(struct dsa_switch *ds, int port, struct phy_device *phy);
+bool b53_support_eee(struct dsa_switch *ds, int port);
 int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_keee *e);
 int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_keee *e);
 
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1233,6 +1233,7 @@ static const struct dsa_switch_ops bcm_s
 	.port_setup		= b53_setup_port,
 	.port_enable		= bcm_sf2_port_setup,
 	.port_disable		= bcm_sf2_port_disable,
+	.support_eee		= b53_support_eee,
 	.get_mac_eee		= b53_get_mac_eee,
 	.set_mac_eee		= b53_set_mac_eee,
 	.port_bridge_join	= b53_br_join,


