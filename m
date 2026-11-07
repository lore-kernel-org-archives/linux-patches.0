Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061996;
	b=yXTQK/PI5YUepsvE+FqNtrUxzLy2FugeDxHFYCf8wmj2D+BncKRoV6Pkwh3AULjWUcud
	 fYx6/NYfzy7Rj5qsb6KOh6R3b8mSsQwX4nRaV5pnLY9Ph4WK90cZuHVlRXlEgv4VN/fbz
	 t7qVk6tPEgZPzy9/mrj8Rf9w1adG1Ente8v34bHlS7Hg2xJXDv6djmmRqzF2yaoyQpA/B
	 iD1cMI/ECMJ7z1oDE1mraehmHwvZKgMfxXwohXh3ItWnhlS0DNFeIBpGuB7cQNKO/Z0ba
	 6srL/Bsm/5YI/15QANAWtv7pkeyA2QyvCT09x2LWqvxjExVW2VDOT12qWpsR8Ug3agg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ZIhDbNyvEY8PmaQFrLODUvpMksTFcRvzFDUf/K7uy0=;
	b=HfAV09kb2X3DflItlxRPi1oR7Ll6T9x/jv8WOTndhn+dax+2WM+Ft5aneMeDRWvBLviL
	 lGXqcvAH8lM4gzDsCeLpaiX27lHt5vz0TYyEJtMpEoEUuDVVIQ81ASXbs+YWN5JsnBJA/
	 M+r5RMyhhnmhKo5umioaRmQa6d3qvMeJkTYkkr+S7qVVTlTIVkZlzxHwqaY5T9FvfHGNt
	 EW81WWahmfKHj4pnPs3vwJTjjh8kxOynzn4j/9vTjRBDo4MgccVSWvUNwYdpRconV8P+2
	 DVpiNVAbStwC4oR5iwUr2nfbIRfr9EUQTJMmiuZN3kYdfl+rSxdYgMGmVq4WmSSW6Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6ihZOX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C82A606A32E;
	Sat,  7 Nov 2026 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6ihZOX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1D71F0089F;
	Sat,  7 Nov 2026 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061996;
	bh=6ZIhDbNyvEY8PmaQFrLODUvpMksTFcRvzFDUf/K7uy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6ihZOX6LeAwT6f//t3+jdkk9V/Vl3y9K+RhSLhFfXcLxcUulM6XUPH0FmNncsUhc
	 gCQ/UHeVH/YR497mzeVxZcAZfmpeGQDk/Xv2jvRvGCo4yM3mIlszu1ZrQiGq69CnsR
	 q934Gm7X0w9yA9pw1GFd6XQSjmsZJMWon42MqrDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0986/1536] ata: libahci: Free the IRQs when activating a multi-IRQ host fails
Date: Sat,  7 Nov 2026 08:50:02 -0500
Message-ID: <20261107135025.350408201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0a8a48384f17f..3084127abd90d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2739,11 +2739,33 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
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



