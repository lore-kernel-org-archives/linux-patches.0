Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037390;
	b=hVn82zlRdfkVbDCdU9UtI2V0jSi1SOLv2DYzTuadX+w/RkCsD+wN8do4GR8JRWmyh+/h
	 iRx1zuSEpu9qO3GPtOzphPlAvlwOxEQ8Q6ynHlF1nCF9dEDCR/ckF2SwKZf2lV7st8pnu
	 8qol6f3ChahVEumzJg7a1yca/gdAmxV4v6dk1FexlsFDSBFoaGmjjPQf7x+2QWvsmMheb
	 DAK/ylcQwspVbmreXOIkS+yoQI5MYJTOs+ME/bpDH95GdVW8EUmDMZUfkyeVhB04bJk5p
	 uM7dRAn/Ie9HXHjAYt5UqMGeMhsdVA2HANGapfRDih+u4r7vKTNeALcbXvc2KXDL9lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUuLl1rR/BUWDDpNveIe1Ftzo76F8PoJUKea1+HOPYA=;
	b=RquRYjEkTKBg3+8d7NFY7ED3YWxw1/0SR4UAaX0SU48qRhJLF2m/G9rbqnjB8YxFZVRB
	 40X4c00BAGpAbRT1ILj3/ole6NHhv5ukI8O543dEtvHrFIwYw+X0728cTpN1hRs75+VVH
	 BmkQJhs7HFzfQm89ad7L5FoxWjvVyv3TgBsqLN3RHzqNBSR9KY7OWepVO0Fv5AYK6SfxE
	 aAmzVy9EF6QjykRUt4DIjgBLL5awm9DYLyqNn8DW1nxM1f5zG6C5VZIkMvDNAHey9zAJi
	 YHKYFMMIhmKnvpVJ8LBzhgaz3mFIFlspDyEuojmVZV4szHQeHrhdvFHJwl0uJwIogJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Typ+OQCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDF4606A32A;
	Wed, 18 Nov 2026 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Typ+OQCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899C91F000C4;
	Wed, 18 Nov 2026 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037390;
	bh=HUuLl1rR/BUWDDpNveIe1Ftzo76F8PoJUKea1+HOPYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Typ+OQCqan5YPE4OyHFkjznu9IMI+a5S4bGUd6Zpl6G5+wPE2aBFYk6UDJkDtP0nI
	 VS6GJtBjNQR9ZiWr5/cO7kpTQ09HUOzM9bedm9F1BEWnahKEmexyuY1rAwJMlw/mIT
	 +uFpxZLHQbDQoh2J2xNWNZoZjXc9stQeBDAF2zVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wild <andiwild@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1334/3318] PCI: Skip Target Speed quirk on clamped ports with no link
Date: Wed, 18 Nov 2026 15:32:36 +0100
Message-ID: <20261118150400.368305781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Andreas: this tree predates pcie_lbms_seen() and pcie_set_target_speed()
  and still tests LBMS and DLLLA in one expression, so the hunk did not
  apply.  Split that test the same way as upstream and compare the
  LNKCTL2 Target Link Speed field against PCI_EXP_LNKCTL2_TLS_2_5GT
  directly, as the existing code further down already does. ]
Signed-off-by: Andreas Wild <andiwild@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6bef92be41f91..57dd40f2e371a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -93,8 +93,12 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
 	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
 	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 	oldlnkctl2 = lnkctl2;
-	if ((lnksta & (PCI_EXP_LNKSTA_LBMS | PCI_EXP_LNKSTA_DLLLA)) ==
-	    PCI_EXP_LNKSTA_LBMS) {
+	if (lnksta & PCI_EXP_LNKSTA_DLLLA) {
+		;
+	} else if ((lnkctl2 & PCI_EXP_LNKCTL2_TLS) ==
+		   PCI_EXP_LNKCTL2_TLS_2_5GT) {
+		return ret;
+	} else if (lnksta & PCI_EXP_LNKSTA_LBMS) {
 		pci_info(dev, "broken device, retraining non-functional downstream link at 2.5GT/s\n");
 
 		lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
-- 
2.53.0



