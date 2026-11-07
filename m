Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064913;
	b=HFdmH2kXL8kTKj3dvsXEzJ235ferc0gxAJwMEog1gn9ruqUzz2K5POEe43YZmzxfupxF
	 h83/6QifX/tOSfcOOMdR+Q2Jt1wDG23pTsucdWcHqMxwth/ocgcM/mydGCNMxrOZgTKUT
	 VzuhrWLnKzbwb+5r5Q+b+HhXTkCxZWNDhUg+NfdDPAJCcXsy9dOzD3atoW80KhwH5NfgM
	 UvJGAIpXvTcz4d9XKZfjjt0aONIdTf8V1sT9Uv1J83d3d6kBqeTK1OCbF2yTqIXCmaV4W
	 e7HRxojxwZt5FM87XOq1gmmp3K4tAGIMwDj7YVr2tCuZLEpLyXRodB3Pl/PYFrP4cRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C57y+wgr5Qh1Tpit4GlQyCKmxGMroKzXYci/0fMrG6s=;
	b=vj5ftdsdiiAeLDsLPVaqeW1xEgoSnqPhxprjovTxar40ffHmoGW78zdK0d7bBf4kQIBF
	 WyrfzfGdQfBsQqvxKeo1WKKZwswSr7HXJwQh+hJ3cDX2AbT/6wESWdXttPf6CzumsrOE3
	 MvELu5YVg+f/8xKpokDSys79zUzOLcnEzjFxFajlp6zkE5luiH3xIYiC8ef9e9Jyqta46
	 4kVMGGJahIKWwcrzlmDDHN9C+JWcz/p3OIaVWqTGqOG4ej5SNqMlCptlJxlGGnZaat7/i
	 UBYzqP/bg9qdSYlvQZnItHulvFeGZc2FCnufScb2vNDs6xlE13DeW7ffNDSgPPc9LNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKlznTjz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EA9606A9EF;
	Sat,  7 Nov 2026 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKlznTjz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CAF1F0089F;
	Sat,  7 Nov 2026 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064913;
	bh=C57y+wgr5Qh1Tpit4GlQyCKmxGMroKzXYci/0fMrG6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKlznTjz/FMWwgHz4ZrUFMsLxXh1OzPaOVeR2oJa/UX0xEAkOFT0Afjseq55KJT9v
	 6lnviL1XMEwZriIxOwQT3VdHaq+RHPCwis2G9xuBPLqcKpr/O7CQD9DFzHvW9Qkek3
	 9zVqfJLv6vJ9m8P7Fse/PWjT8LoYKgn1b8uxkIps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Keng-Yu Lin <keng-yu.lin@hpe.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Desnes Nunes <desnesn@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 7.3 0813/1257] PCI/PM: Restore BARs after powering up during enumeration
Date: Sat,  7 Nov 2026 08:51:49 -0500
Message-ID: <20261107135001.798364762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Keng-Yu Lin <keng-yu.lin@hpe.com>

[ Upstream commit f043083843cac1105206437d8c58e725b6412fad ]

Commit 4d4c10f763d7 ("PCI: Explicitly put devices into D0 when
initializing") added pci_pm_power_up_and_verify_state() to pci_pm_init().
The helper ignores pci_power_up()'s return value indicating that BARs need
restoring. Its resume callers restore saved configuration afterwards;
pci_pm_init() does not.

D3hot-to-D0 may reset a device and lose its BARs (PCI PM 1.2, sec 5.4.1).
After enumeration powers it up, pci_enable_device() reads D0 and skips the
full power-up path. Previously, a device still in D3hot at enable time took
that path, including BAR restoration.

On AMD Venice SP7, two AMD xHCI controllers [1022:17d2] are in runtime
D3hot with No_Soft_Reset clear before kdump. Diagnostic reads on
v7.3-rc6-37 show the following for 0000:01:00.4 in the crash kernel:

                                   PMCSR      BAR0
  before the platform power call   0003       f4100004
  after the platform power call    0003       f4100004
  after native D0 power-up         0000       00000004

The upper BAR DWORD stays zero. pci_power_up() returns 1, but the BAR
address remains zero while dev->resource[0] still contains 0xf4100000.
Without BAR restoration, the crash kernel hangs during boot. The last
console output includes:

  pci 0000:01:00.4: enabling device (0000 -> 0002)

Restoring both controllers' BARs gives matching readbacks and allows kdump
to save a vmcore and reboot. An AMD Turin xHCI [1022:1557] shows the same
BAR loss; restoring its BAR also allows kdump to complete.

Read the initial power state first. Otherwise, pci_power_up() may request a
BAR restore based on a cached PCI_UNKNOWN state, even when the device is
already in D0.

For devices already in D0, only synchronize the platform state so
that ACPI calls such as _REG still run. For other states, use
pci_set_full_power_state() to power up the device and restore BARs
when needed.

Fixes: 4d4c10f763d7 ("PCI: Explicitly put devices into D0 when initializing")
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/CAJZ5v0ie2AvCbdv8-zkpYzHLcTwUPUj+=WWOQjDAPmSepSAQPg@mail.gmail.com/
Signed-off-by: Keng-Yu Lin <keng-yu.lin@hpe.com>
[bhelgaas: shorten comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
Reviewed-by: Desnes Nunes <desnesn@redhat.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015020811.1132314-1-keng-yu.lin@hpe.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 38c7cb8221223..f85256413cf3d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3262,7 +3262,15 @@ void pci_pm_init(struct pci_dev *dev)
 	}
 
 poweron:
-	pci_pm_power_up_and_verify_state(dev);
+	pci_update_current_state(dev, PCI_UNKNOWN);
+	if (dev->current_state == PCI_D0) {
+		/* No need for full power-up, just sync-up platform state */
+		platform_pci_set_power_state(dev, PCI_D0);
+	} else {
+		/* Power up the device and restore BARs if necessary */
+		pci_set_full_power_state(dev, false);
+	}
+	pci_update_current_state(dev, PCI_D0);
 	pm_runtime_forbid(&dev->dev);
 
 	/*
-- 
2.53.0



