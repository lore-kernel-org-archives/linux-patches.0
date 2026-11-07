Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063430;
	b=1sVEYY+5g897mcFGnhrfMdWcxWMlz3WBhOOlioi27eCxDz1hobrWxS6ztisJQrBbjhD9
	 fI0nIMU/sWFicOx7OoZWA8DjM5gcIDdvvZKG94t6ylvNf4DXSzl0TYJ+uzQrjINiZHYRr
	 /ysL+46Lau+KWwUMRo6Jrii6qSicTggGhTJPbzptXMUqFTKDcqmuta7OCsc8dtxqRhBX9
	 iM8cRajSeDSiN18/AWR/mMEEyE9QYpvv4Q9PaXny6/l2H8pTFVKKrUGrJR83g6ifemE5n
	 ag2X6TE6bWVfWSxkijr1V1AlyAhHYdjgyPVMORayuElYlj2KPtjnFF/zVMUf43CxY2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ya5QYlL+08nLD0c5LH1Zytio/4YTr2VP6s0h8HXYxsY=;
	b=xpvlULQbzNn2ct4ylIKJ1XRnB6NZTAi1DFUGpcVuuUpg6cJG9bTETPRbfiXIbf8GqtHc
	 yxfndQTteicj7pUiPRSjVR0NpgL1NoGNde2l7IhV2HMMCpufZvh7Cvk4bhlYRLF1YMWHI
	 Pm5NvhSC5WSFZEbqq9k1w29K4aPSnekSJu9thWTbYq72Z++YQbI/3QdyJ6o8LiZ5yyanh
	 zxHepsRa4sYmuTNI6j2nsDey8xjd1hMNNRiwNUxBW+dsGtSsoop9RhVZXr+c7GyDqxq+I
	 3sSofanwbQKvxrk0JKniob2CLNL6+7fATzfB6OxS9Q3ZtRkTwaFnyGTZAFqKPrf6V6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQVra1mR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CD86083627;
	Sat,  7 Nov 2026 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQVra1mR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A261F008A1;
	Sat,  7 Nov 2026 14:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063430;
	bh=Ya5QYlL+08nLD0c5LH1Zytio/4YTr2VP6s0h8HXYxsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQVra1mR46+PgGYFivjeaOd8EYqJwkx61oJDwxxuY7R666NzE1WtOUQYoQ7L6ftTx
	 djitNpcj1JUBK0KmmkdN20WrWmG9MBYl8KYXODfUgitgZUFn2hSpEUURq8kWMcSQur
	 NChI9JRj449fTks6Frg36rZZ1gPLbBcW397wO6CI=
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
Subject: [PATCH 6.18 594/869] PCI/PM: Restore BARs after powering up during enumeration
Date: Sat,  7 Nov 2026 08:54:36 -0500
Message-ID: <20261107134913.239449832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 8cfcd71163031..25720f28518ad 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3242,7 +3242,15 @@ void pci_pm_init(struct pci_dev *dev)
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



