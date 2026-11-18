Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059853;
	b=bBLWochPjUd1197iRyE43F+AXJnF4hNDcMnZKpTte2dvFvrqavmkWPUj+HfXbNvnGn1/
	 XpPxk2Y+XQBvgIN+gM5KK8ejEqi8qHobhOmhUpX3rbm65HL4TQZuRDTYzljejbLc9zYjv
	 LTVtYplyy6KSVXq8ilNd2Q5jo+GdlcrWSl8YwEkEg8Qak8qrXkTQ+SysRSZUyJI5euqr9
	 NGhuuHsGtzQCBgXROn3rSIGOwyG1pYqpU61l0eaIqvER0l9+2SGYyZVNCI23J2DmNfITU
	 emTIj8mkFgUXKCkUFyf9/mAw1Hwk/n04x46iBVBDdufRO7y0TEfNIcPPb5p0O7aCKiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FpDVIudZkmiM74dMvGIxiiw6hCOPP0oGUNmMiwHZoP0=;
	b=bX8eP6iUdOcfMyDyDkm6qwyvfvyp6ZNU5qvUg7kxYh7eL9iOqQsWUdu18i8lA4o0Aumr
	 OHbFhQ6k6jcqmv8v26ogK1XFRDpx+i48c3/97jx/PLpIZOBaJGCVWlZ9FD54TjxLDFvMr
	 sXENBGvE7jHSXRstV5zDMR+BriAhXOemWmJmDxBd2MtQuCp5tMCHDpxzsG0o2bVEjAxcj
	 oWMPZYFf/GDW4wXJ3zrygz6JP1s07KT5i+H9fYMZ7a0OIJb3Zw7O2Lxn6ew1zGpiASlQj
	 E+L7bOnLzxmcj4W5ep0fEU9qt7m9savxzSOVwjIwf59r/3gl9E8EG3WDBK6uHwdzK7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eugcriDf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D2C606A325;
	Thu, 19 Nov 2026 03:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eugcriDf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671941F000C4;
	Thu, 19 Nov 2026 03:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059852;
	bh=FpDVIudZkmiM74dMvGIxiiw6hCOPP0oGUNmMiwHZoP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eugcriDfs9VemFahdkrrul4cH8N6Y5ZP7yD+aSHrEEWumc4+Pci8gXu0KSVC04iw7
	 JJwK98UcHLpzpwbd87TefXIWX4w4ZXiS9GZUyL9StBxUlf+7buSH3CuEdDfwj8AxhM
	 sgxIn+VjDeYA+6B7aPWDnWajBfRgFFqDetMpMQ9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0991/1848] ata: libahci: Free the IRQs when activating a multi-IRQ host fails
Date: Wed, 18 Nov 2026 15:50:29 +0100
Message-ID: <20261118145958.367468908@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 34a4a34431ed81d85d14f8fb8035e5a25214ad39 ]

ahci_host_activate_multi_irqs() requests one IRQ per port, but it does
not free them when requesting one of them, or when registering the host,
fails. The IRQs are only freed by the driver core, when it releases the
devres of the device after probe() has returned, while the caller of
ahci_host_activate() releases the resources of the host in its probe()
error path, e.g. ahci_probe() disables the clocks, regulators, resets and
PHYs of the host. An IRQ handler running in that window would access the
MMIO of a host which is no longer clocked.

ahci_host_activate_multi_irqs() did free the IRQs until commit
0a142b26921c ("ahci: cleanup ahci_host_activate_multi_irqs"), which
removed the explicit free because devm makes it unnecessary. That is true
for freeing the IRQs as such, but not for the window described above:
devres is only released after probe() has returned, i.e. after the error
path of the caller has released the resources of the host.

Note that this window cannot be hit with the current users: the only user
of AHCI_HFLAG_MULTI_MSI is the AHCI PCI driver, which does not release
any resource in its probe() error path, and the ports of the host are
still frozen, i.e. their interrupts are masked, when ata_host_register()
fails.

Free the IRQs explicitly again, like ata_host_activate() does, so that
the IRQ handlers cannot run once ahci_host_activate() has failed.

Fixes: 0a142b26921c ("ahci: cleanup ahci_host_activate_multi_irqs")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260915084127.692494-12-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 32ebcfcb7914c..83f82b3ffe7d4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2577,11 +2577,33 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
 				0, pp->irq_desc, host->ports[i]);
 
 		if (rc)
-			return rc;
+			goto free_irqs;
 		ata_port_desc_misc(host->ports[i], irq);
 	}
 
-	return ata_host_register(host, sht);
+	rc = ata_host_register(host, sht);
+	if (rc)
+		goto free_irqs;
+
+	return 0;
+
+free_irqs:
+	/*
+	 * Free the IRQs which have been requested, so that the handlers can no
+	 * longer access the MMIO of the host once we return, e.g. after the
+	 * caller has disabled the clocks of the host.
+	 */
+	while (--i >= 0) {
+		struct ahci_port_priv *pp = host->ports[i]->private_data;
+
+		if (!pp)
+			continue;
+
+		devm_free_irq(host->dev, hpriv->get_irq_vector(host, i),
+			      host->ports[i]);
+	}
+
+	return rc;
 }
 
 /**
-- 
2.53.0



