Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062882;
	b=PVcy8+dYxCMaJlsqq4LRRkoTy/7yDy+6oNORljnU/blT/9XaCfPBVeJ9IvzOyMI97ZGK
	 DXiR7SQS83eaxCcvGu0hAPNWDhDr4+dWRhRMWeq1JhXb76wYAqdaRkbDwP8xyLIcCpq+u
	 X5uUWoO/QxwQvD4ZGkLWweQtdc0UD3ctrflM02lb004WOYWKZf+zMSVKNIqpHDZTLj/En
	 d9IiECSPh9cBxeMe7wklZarSPuEA+m7TsEiFI1U+9rDaF+1CNy6zjHLtyHS4q48eRXx6q
	 ufPS/xjw2qWOpg/Y86UMXR9SJ3oI87yiL1yQvsPZNmdGy2NGE6CvpngiJ8LH8vp3I1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YkkMZlDBj3z0/8VOCr0Ym9HttgKh1a/X4pNaYF1bjnk=;
	b=X3QG/+w0Nrc8mp52FZXotjS/oP4BItYEAlsjyq/cyBskQeVeWO0e8y6k93Sf50OoId4W
	 ADayHtOp2cJSDsRVQU9pzPoSQ8/FtMdlZlAafJ/+szKwTPEqZgow/PLbR/PacnoNOQFgL
	 Rgq14URuVIpJIxxfu7nBEHPknEl1zSzPn6yBEwkFrpccXj9Xy1iFItVG2IMmN5p0T09lI
	 2q1k9HYWIwIG0YrqlCHKmaGRrtxkHz/5bPd9YkDCMGg+m81QaaogIgBKl1lDQ+eM56Mhe
	 xGmz6iilsxuOLRNpdg9VfTifEUGRbDI/8N55XDoyp0Ksfj2vwUJMsIAIH3X5XL0/SbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGE1fsw1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984BE606A326;
	Sat,  7 Nov 2026 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGE1fsw1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B21F0089F;
	Sat,  7 Nov 2026 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062882;
	bh=YkkMZlDBj3z0/8VOCr0Ym9HttgKh1a/X4pNaYF1bjnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGE1fsw1vpDgGS4YUhGOMv6sawOOvTrUqTglGMA6eFsfjF6v0Wj0fJ4ZHOH9HdafV
	 ckHDenuk9tMLd78tsm7YD34d9NlaMewdtBYB2MCgwJ6zH0XApEWRX4X00THgs09J+i
	 UzaEEhvUhXHl39PrIgV2ak+7MqSzo9zj6FNdLreY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wild <andiwild@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/869] PCI: Skip Target Speed quirk on clamped ports with no link
Date: Sat,  7 Nov 2026 08:47:25 -0500
Message-ID: <20261107134857.792694385@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit ff8a969f7dc8e79ea6113abcfa983e070b2b585a ]

Since commit 72780f796468 ("PCI: Always lift 2.5GT/s restriction in PCIe
failed link retraining") the Target Speed quirk lifts a firmware-imposed
2.5GT/s restriction on any downstream port, without checking whether the
link is up.  Where nothing is plugged in, the retraining that follows can
never complete, so each attempt costs PCIE_LINK_RETRAIN_TIMEOUT_MS.  The
quirk makes two of them -- the initial one and the restore on the error
path -- adding a fixed 2 s to every boot.

On an MSI PRO Z690-A WIFI DDR4 (Intel 600 Series PCH) with one empty x1
slot, running v7.2-rc5:

  0.541 pci 0000:00:1c.0: removing 2.5GT/s downstream link speed restriction
  1.541 pci 0000:00:1c.0: retraining failed
  2.541 pci 0000:00:1c.2: [8086:7aba] type 01 class 0x060400

Where the Link Speed has already been clamped at 2.5GT/s and no link has
been established there is nothing worth doing, which is what the kerneldoc
for the quirk already describes: the restriction is to be lifted where
firmware arranged it "and the port reports its link already being up".
Bail out early in that case, before either the ASM2824 workaround or the
removal of the restriction is considered.

Ports whose link is up are unaffected, and so is the ASM2824 workaround,
which is reached with the Target Link Speed not clamped.

With this applied the quirk returns without touching the port: both
messages are gone, enumeration proceeds from 0000:00:1c.0 to 0000:00:1c.2
in 1 ms rather than 2 s, and the systemd "kernel" boot phase goes from
3.011 s to 1.036 s.

Fixes: 72780f796468 ("PCI: Always lift 2.5GT/s restriction in PCIe failed link retraining")
Reported-by: Andreas Wild <andiwild@gmail.com>
Closes: https://lore.kernel.org/lkml/20260801092152.5643-1-andiwild@gmail.com/
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221801
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andreas Wild <andiwild@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Andreas Wild <andiwild@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260801201244.4421-1-andiwild@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e03a3831bcc00..199f2a762b22a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -103,7 +103,11 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
 
 	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &oldlnkctl2);
-	if (!(lnksta & PCI_EXP_LNKSTA_DLLLA) && pcie_lbms_seen(dev, lnksta)) {
+	if (lnksta & PCI_EXP_LNKSTA_DLLLA) {
+		;
+	} else if (PCIE_LNKCTL2_TLS2SPEED(oldlnkctl2) == PCIE_SPEED_2_5GT) {
+		return ret;
+	} else if (pcie_lbms_seen(dev, lnksta)) {
 		pci_info(dev, "broken device, retraining non-functional downstream link at 2.5GT/s\n");
 		ret = pcie_set_target_speed(dev, PCIE_SPEED_2_5GT, false);
 		if (ret)
-- 
2.53.0



