Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619535;
	b=ITEUTOsRLlO45zrUj+62jebhDLcRgRuEuwZnxO0VO/85yClP4tFrCL7o+2/6jVK7WhKT
	 +hRW3Ezr7xh7G8rQt+ILhZ7FBkaMgfDcn0yK/yxDgIWwZDxpTGbQNDn+PH4ORfP4PwTzG
	 4rTs1wcpR/ML46XU3BZu8PGmRbqd54793wg9iQU9egBdgClDmLIqr2wuuAX0JBhtADV/K
	 r1Hi+wwceNv+rWIOCA+S25EjfJXwKoBRJatl/e5mse4zvNiAL4cPa8qBBhupOVohSLBDC
	 PXOlQLhPoOv4AHOMC3ZeghbLOWKkBeoiy5O0Os0dofVLnsYw9O6/p5YdqS6eICEZDwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2GX8AY1oMH1W06XSARSOrHF3ihVHCIfOQj8dncG19g=;
	b=2FLzXa/+dRm+ZPBy2nA0NC4dFa1JinjokN8Do7KiDHXcv3qoDtUF7jMmx/WGsJ0HGZzZ
	 QEw+7w/sknENAUgPq1YuJ3i6TXCo9LlHnamL3JvBihSt2xKtDq/lBi/EJiwJ2+7ufnHDX
	 N/cT/GHuvvfa707TJah3pxrd7BdviatMcwId91cIDceCCmYGbNAAxRgU6NIv5jnvq044k
	 B73ekKCSVbERiSK+Iku5y3HHaoBfA2331n26Bc6cnV0ARdbQ9vupF8fiaIHhXcIo8UUti
	 I4pwV/BHGg3D4/tQ1ZAyxwTlLKBKSwhyc2aZnHXbL3kuPh5PzgcEfNLeMOdg8Dnb3Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtfnJf0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9AD606A31E;
	Wed, 25 Nov 2026 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtfnJf0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1701C1F000C6;
	Wed, 25 Nov 2026 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619535;
	bh=Y2GX8AY1oMH1W06XSARSOrHF3ihVHCIfOQj8dncG19g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtfnJf0dUSHCLgUx0m9Mv4a7gyJGcb8OYWcLTzqaEmsi3LI75/VF63MRVg1GKEezb
	 JoQE2w1N9pWODZVLGhLNUAJUahzB9Ef0qy6TWMstxhH8vxqG8a90aNIwmiSlvEQjnY
	 RZ2b8jy4Nqas1j/NuKwASwe4Z4CkbJqNec0PQV8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.3 0627/1005] net: dsa: microchip: initialize the IRQ access mutex
Date: Wed, 25 Nov 2026 15:32:45 +0100
Message-ID: <20261125143836.434979441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

commit ba1dc196502f3435f4ae53ed6745caacf066f83e upstream.

ksz_switch_register() initializes dev_mutex, regmap_mutex, alu_mutex and
vlan_mutex but not lock_irq, which the IRQ chip takes in its bus lock
callbacks on every mask and unmask of a switch interrupt, and the PTP
code takes the same way. The zeroed mutex happens to work on the
uncontended fast path, but with CONFIG_DEBUG_MUTEXES the first lock,
from the IRQ domain mapping during probe, warns:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:625 at __mutex_lock
  ...
  ksz_irq_domain_map
  irq_domain_associate_locked
  irq_create_mapping_affinity
  ksz_irq_common_setup
  ksz9477_setup
  dsa_register_switch
  ksz_spi_probe

and turns lock debugging off for the rest of the boot.

Initialize it with the other mutexes.

Triggered at every boot of a KSZ9897S over SPI on an i.MX6 SoloX board
with CONFIG_DEBUG_MUTEXES, on v7.4-rc1 and earlier. With this patch the
same board boots with lock debugging enabled and it stays enabled
(debug_locks 1) through two hours of unrelated stress tests.

Fixes: c9cd961c0d43 ("net: dsa: microchip: lan937x: add interrupt support for port phy link")
Cc: stable@vger.kernel.org
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261104-ksz-irq-mutex-init-v1-1-e3bb7d9dbd80@vaisala.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -3928,6 +3928,7 @@ int ksz_switch_register(struct ksz_devic
 	mutex_init(&dev->regmap_mutex);
 	mutex_init(&dev->alu_mutex);
 	mutex_init(&dev->vlan_mutex);
+	mutex_init(&dev->lock_irq);
 
 	ret = ksz_switch_detect(dev);
 	if (ret)


