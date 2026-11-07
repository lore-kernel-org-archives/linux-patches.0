Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063317;
	b=A4AmH87FyDlKJ7QJ3+mEVFoGvsQk6A8EW5/dufz/RytwO7te/giOXGVxUQPbW7iYMDxe
	 eLykSAzjD+C4Mq0Jj8mIM4b3JT5NxlrYXANywKmlpYamsPVXn5V75YDipWVezWGkq33la
	 JJrVTeR6xyCu8BhgPGnKBBMJAwfbwZb5OT608X85EcqUKEq3tlXUjUlpXo26+Yfg3Duq1
	 exkviNOeEF44jpjLTzoM6YEyPOz27W3Yz9baDfWee/LYmf1Gl9BnDU8/4Fa1SvkH8Ej9/
	 aIroEI6SMPFl65IdqaJ4x0lEcFwj5h91nvP0oT/kZSXvY+x1GLz8D6fuOAzXA88SF3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0+81CuiEoFhGRnec2Hj6IXt6HmKFmoTYgAjAtRDAANE=;
	b=ksWvmVUB3v4eeagvFGMAhjOkjRMTHlkzm4ve1NaGYhjc1vuMmVgXzbU1QtishJw0+mb1
	 ges0eQIGowF6dlfdjO5xrn2a4gg53ywNhHde0ZirFMTCppN+4PTCtZ4VsnyWJCLrLhI5E
	 X0OOsK59vo5XdcaFmI6lf3IQI/cnlmHpjjcJmyYKwJuMB4jopGoF55vgZxlNyEOld+tIN
	 hhS47nt+bXx6j2xpbfzxiammDpR7rxkCnjv7ny4h7sqWzDeppUPgirl9YXdi9auC6rsJt
	 hT0j9euQvubM3cVKJa3WE4VdCzcBMWHIYIsngmCcXQGoMhP7/1+761WCLzOEVQ8D+yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJmL5y1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66441606A32C;
	Sat,  7 Nov 2026 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJmL5y1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1425E1F0089F;
	Sat,  7 Nov 2026 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063317;
	bh=0+81CuiEoFhGRnec2Hj6IXt6HmKFmoTYgAjAtRDAANE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJmL5y1nkMiZtiKk9fD1+bK7A3jgIYGhDE6YjMPUbGRnITKkqlY3nuBAcZ/RyMjEb
	 ZXUFOsZvXPr4igU8L10TfzwNf07LJ+hyL9droOU59f7GYEfgDUib6IuuSfNXskdCas
	 mbToWOJVmhaKUF7vlhJOSbh+Wm3ViibOgTbYHkLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 477/869] PCI: Avoid D3 on PLX PEX 8532/8533/8548 downstream ports
Date: Sat,  7 Nov 2026 08:52:39 -0500
Message-ID: <20261107134909.780549753@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 8e923e51892c7da91687dd5b8081ddb1f0fb395a ]

Runtime PM suspends an idle downstream port of a PLX/Broadcom PEX
8532/8533/8548 switch to D3hot, but that takes the whole switch down
with it: any device behind another port of the same switch then
faults with a fatal bus error on its next access, e.g. mptsas probe
on a Sun Ultra 45.

This surfaced on sparc64 once commit a5fb3ff63287 ("PCI: Allow PCI
bridges to go to D3Hot on all non-x86") let bridges enter D3hot. Keep
these downstream ports out of D3 by setting PCI_DEV_FLAGS_NO_D3.

Fixes: a5fb3ff63287 ("PCI: Allow PCI bridges to go to D3Hot on all non-x86")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260927105609.8813-1-kaloz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d29ff1da29b17..812b01d24fc47 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2386,6 +2386,24 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2000, quirk_plx_pci9050);
 DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2600, quirk_plx_pci9050);
 
+/*
+ * An idle downstream port of a PLX/Broadcom PEX 8532/8533/8548 switch
+ * autosuspends into D3hot, and that takes the whole switch down with
+ * it -- any device behind another port of the same switch then sees a
+ * fatal, non-recoverable bus fault on its next access. Keep these
+ * ports out of D3 entirely.
+ */
+static void quirk_plx_pex_no_d3(struct pci_dev *dev)
+{
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) {
+		dev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+		pci_info(dev, "avoiding D3 on this downstream port\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8532, quirk_plx_pex_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8533, quirk_plx_pex_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8548, quirk_plx_pex_no_d3);
+
 static void quirk_netmos(struct pci_dev *dev)
 {
 	unsigned int num_parallel = (dev->subsystem_device & 0xf0) >> 4;
-- 
2.53.0



