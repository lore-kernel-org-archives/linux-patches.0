Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216782;
	b=seWHvedCwGqXPiTTxlvfcjRPyCP5bHMeQtsc27FOnKndx2Twa07VWdaASf5FF2cwtSPA
	 trf7BMpNkrSFRII7WYCebz4IzjRYSQAUwukyrLwTM7ZMpNJ/p0W3Mtj67Gu2acl5WxltB
	 c3/9wdChW/5H5acgzJ/hAYgB7DuXVENi0ZuUugKOOatdr1tFv0gDPWRJYactPMmRaJ+kR
	 5DsAGV9+MgJX1LNa/EUHbjhGia4xRb+/Q/avOyhyiLFnKOKepN0vCfa4t102jefUtXf6K
	 SW1Y4a1da54cKwUhTi9Ubbijt1E7TZTvRLvHpiysODjWnKRAkSjo05zqIHNYNsOZNSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zrriqi/HPUnkh3uXu5MdvejhUTJAA65t11Vq1+nY4xA=;
	b=MH1xObfFPNWJrPLk9hlKmPt7dkX2vuKD+rfpCFGVtG734U2sQgN+KsOJQeodS7MkvhTA
	 yNC5qgdSUFmNhGq4khfDcwlv7S+yNlKKN28mFiVEsoJMsGVsbYiW4Iry7n83pwXp7A1QQ
	 01KRTOQyosIghYxq3ToLrUe+hGSnC8cDGRkQYurX6ptepa5dogeJoihH+LC4nCKPYY91r
	 wpq0HEnxgbXROGNB2PT3T1Dk3KH6uJZLDjXx/BtNsT/CnIi5ZJ8oegx2NhYBmDrg2B2xS
	 I8auX/aY0meT2xHbWaxJ8Zz21f/XKvP+iJoqO/JRrzNInSWtSncJpqfH4UIf/RMkhNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kktJKeb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98276606A31A;
	Wed, 28 Oct 2026 19:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kktJKeb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6B91F01825;
	Wed, 28 Oct 2026 19:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216782;
	bh=zrriqi/HPUnkh3uXu5MdvejhUTJAA65t11Vq1+nY4xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kktJKeb6dn6WWVr+jzhaX4NK+cc6qm0awm74QbIvFLD1Dpj0RioCTMPhQnQtZEhPe
	 JUBXUsuoR47FHQG6Qtc6E5BMN0LgSLSAfzhBNW/gczm3+wk1b08c8sYkBoMPrYONGA
	 ZMDkoOOeRiBnOiYepCj1E/5/Q/kD3ROrRyeaebUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1676/1887] driver core: Avoid warning when removing a device while its supplier is unbinding
Date: Wed, 28 Oct 2026 18:02:52 +0100
Message-ID: <20261028170537.597750530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 36d74f17e03f7e60e1b08fbe16cfad6e69cc3aa9 ]

During driver removal, the following warning can appear:
   WARNING: CPU: 1 PID: 139 at drivers/base/core.c:1497 __device_links_no_driver+0xcc/0xfc
   ...
   Call trace:
     __device_links_no_driver+0xcc/0xfc (P)
     device_links_driver_cleanup+0xa8/0xf0
     device_release_driver_internal+0x208/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     driver_detach+0xa0/0x12c
     bus_remove_driver+0x6c/0xbc
     driver_unregister+0x30/0x60
     pci_unregister_driver+0x20/0x9c
     lan966x_pci_driver_exit+0x18/0xa90 [lan966x_pci]

This warning is triggered when a consumer is removed because the links
status of its supplier is not DL_DEV_DRIVER_BOUND and the link flag
DL_FLAG_SYNC_STATE_ONLY is not set.

The topology in terms of consumers/suppliers used was the following
(consumer ---> supplier):

      i2c -----------> OIC ----> PCI device
       |                ^
       |                |
       +---> pinctrl ---+

When the PCI device is removed, the OIC (interrupt controller) has to be
removed. In order to remove the OIC, pinctrl and i2c need to be removed
and to remove pinctrl, i2c need to be removed. The removal order is:
  1) i2c
  2) pinctrl
  3) OIC
  4) PCI device

In details, the removal sequence is the following (with 0000:01:00.0 the
PCI device):
  driver_detach: call device_release_driver_internal(0000:01:00.0)...
    device_links_busy(0000:01:00.0):
      links->status = DL_DEV_UNBINDING
    device_links_unbind_consumers(0000:01:00.0):
      0000:01:00.0--oic link->status = DL_STATE_SUPPLIER_UNBIND
      call device_release_driver_internal(oic)...
        device_links_busy(oic):
          links->status = DL_DEV_UNBINDING
        device_links_unbind_consumers(oic):
          oic--pinctrl link->status = DL_STATE_SUPPLIER_UNBIND
          call device_release_driver_internal(pinctrl)...
            device_links_busy(pinctrl):
              links->status = DL_DEV_UNBINDING
            device_links_unbind_consumers(pinctrl):
              pinctrl--i2c link->status = DL_STATE_SUPPLIER_UNBIND
              call device_release_driver_internal(i2c)...
                device_links_busy(i2c): links->status = DL_DEV_UNBINDING
                __device_links_no_driver(i2c)...
                  pinctrl--i2c link->status is DL_STATE_SUPPLIER_UNBIND
                  oic--i2c link->status is DL_STATE_ACTIVE
                  oic--i2c link->supplier->links.status is DL_DEV_UNBINDING

The warning is triggered by the i2c removal because the OIC (supplier)
links status is not DL_DEV_DRIVER_BOUND. Its links status is indeed set
to DL_DEV_UNBINDING.

It is perfectly legit to have the links status set to DL_DEV_UNBINDING
in that case. Indeed we had started to unbind the OIC which triggered
the consumer unbinding and didn't finish yet when the i2c is unbound.

Avoid the warning when the supplier links status is set to
DL_DEV_UNBINDING and thus support this removal sequence without any
warnings.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Link: https://patch.msgid.link/20260511155755.34428-4-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6427d8e43347b..e39910e68d82d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1501,7 +1501,8 @@ static void __device_links_no_driver(struct device *dev)
 		if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 		} else {
-			WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
+			WARN_ON(link->supplier->links.status != DL_DEV_UNBINDING &&
+				!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
 			WRITE_ONCE(link->status, DL_STATE_DORMANT);
 		}
 	}
-- 
2.53.0



