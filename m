Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064026;
	b=t5VktGmNl0/U7R7QVGdaDZz0tSs8OKQb4aoQuAYr/vULritaRM5wx8zGfZhlYMZkjH9l
	 kh+DbWJgwqDShxnfvlrG7Dk4Zvs6GUEWcDybp12D8+baEt+USsPUV7QHq6yLx8vCa64r0
	 f4C6gqgHfbzknETPSEzYLiTu4Ov+Wa199Kokh7ETYb6jBDJyMiGLlrAF7N+vClQtDTjq7
	 58ProeljjQad4q/XHjOdY5C4XTGpjobzgPzrSmP6/vIk4C2a/LH0wKQHUSglJsuNTGFg6
	 B6fsukPhhV/aTn0HBozFlB7L8e7v9LpNdHtFptqIp0YvTukpoNW0lZ8Yk8+ionjwMxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MsVdXHrIbj3/zT6Q6VG89op67RNl7lVd+avnCHCy4Ao=;
	b=t8xsUdTT5tWMZLxYfylLc74pm/hiqYAMAyyN26mndath8OgUsdv3VT4WfTL4llTSoeep
	 tWVnz0hOXNtCyfzsLTYH61q2ktUlV1cKswbiidojpEtpM/BE5eoINaYO49X8xVKJ/xmV1
	 5qsNXAbhUzjwMAjLn4ayWbCKAwoZyfHa8O6gLf22bbkqhiwkUDnqzmgzDkDhhxWj42Biv
	 SAOpX8GoK5NX+3uX3BLiNbrRRntcA6h4dMq8Nl0jSCDcYohQ4SPaSe1CHRPwt/Wza1FSO
	 s/PBNvuipg0J/+AZZW8eLbcM/8Vi6+6FQ3APsE3CfAN/OrU0EoxmD6Jo/NNUj0PjgDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8cbWT6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D6760A3827;
	Sat,  7 Nov 2026 15:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8cbWT6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E0B1F008A2;
	Sat,  7 Nov 2026 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064024;
	bh=MsVdXHrIbj3/zT6Q6VG89op67RNl7lVd+avnCHCy4Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8cbWT6Zd4R4Jsjv+7bQys+kW6JC8a+fbF1AlWAIfTsVelNJTKXLwpIBVJtmwERuW
	 4HJ3bi6twzNHeRLDK6QdHwwrWi7j6a16mw6gk6iEpI2nO+8wbWflk0T1nw0UgLlX/j
	 bfxdw/m9PlGWw4xmPjfYGdvnzdEbkChqsFsA8rio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wild <andiwild@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0200/1257] PCI: Skip Target Speed quirk on clamped ports with no link
Date: Sat,  7 Nov 2026 08:41:36 -0500
Message-ID: <20261107134945.083899453@linuxfoundation.org>
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
index 1aa87a3ef9ede..866493aceef0c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -108,7 +108,11 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
 
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



