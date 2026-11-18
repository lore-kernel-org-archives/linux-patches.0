Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059494;
	b=RXqsX/5wqqcVb7q9agQ8Ncu3PJFYbp6gTfyHBRf5aDhZuKlLv15lBVmfVQGfRAEfJUkk
	 OwEn04wQKJSyU4s/Uf8Pu5zytCj9sOKONjX0cYkm0rX4H5g/4qEHtCepud3yz6Uwwetsr
	 kl3XGGUlOIiWwE7lNBQSOSb+m4D08L9huDUsujg3HdBEpnhyRAhIxETTGerjmnOd3f0sL
	 y3x7H0vGZQV6aw3+LmGypqf63+yBokeiJZw5xqwf9T0FN12mwofxMk2nPd64So25I+tdI
	 O7wobiIV8RFMnlBaW0I4l9zUwJ6cPmZcc+zgefaXckT6TDbcI2BHKp1VHVpoh58z4eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ihx5rCXmYqWpA6cICRBuSlKiGgnwI+VOWtbEgkD09Kw=;
	b=wkFGjMw+AChdGua7w7IGD+rdGNtO1kGzgpkmXS8dga1pncLck/RfICzZBfHetEK1mCbk
	 PdktYYEyAidPBsMdQ3pfEZ0LluL8n0qrCdtLBj+MIGQJKcUZQC/m7gCzpXabUW18KIEgE
	 tg7ohiM4beJuGCpt+DR+yd+q233M4nenSBWOc78zCowBaCQdzbLSc9gpiHyY85oLrqxNk
	 XL4ssZiQWB2MwAqX8YEu+ENuqiKCVmlmoGmF+ilx5qvmUp5sk0en5oSfzXPsFJUtmX0/c
	 sKYy/MSWZWc7o27CjdEo4YOyy460p/PqTozM8WBdye8ULnQ2rcvbsd93GPSAsQtyX4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVqQiPtL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0BD606A325;
	Thu, 19 Nov 2026 03:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVqQiPtL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF91F000C4;
	Thu, 19 Nov 2026 03:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059494;
	bh=Ihx5rCXmYqWpA6cICRBuSlKiGgnwI+VOWtbEgkD09Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVqQiPtLy8DS7CqrYFS7QO5vshz73hS2Sull32kGBljkaLnpPB4Ir3sL9PzXs390Y
	 Dse2me27HnXU5qrfdodDPgU5pzwG1saVeJ1qUsulAHTo7T1CiFB3pvFNEXosU5KkSl
	 Ec2RFVqSSPAiDwUkVp0MTVmafpP2cqquC/TRkveE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fab Stz <fabstz-it@yahoo.fr>,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0862/1848] drm/nouveau/pci: use config-space MSI rearm on MCP79/MCP7A (NVAC)
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118145952.583145432@linuxfoundation.org>
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

From: Marek Czernohous <marek@czernohous.de>

commit 354d47fb3f35461b7f942831c1b2a7105e92b57f upstream.

NVAC (MCP79/MCP7A) uses g94_pci_func, whose .msi_rearm is
nv40_pci_msi_rearm(): a re-arm write through the MMIO mirror of PCI
config space.  On this IGP that path is unreliable; when a re-arm is
missed the interrupt line stays dead, command submission times out and
the GPU appears hung until reboot.  On an Apple Mac mini (early 2009,
MCP79, boot0 0x0ac080b1) this showed as sporadic fifo timeouts and GPU
hangs under load unless MSI was disabled via config=NvMSI=0.

Give NVAC its own pci func that re-arms through real PCI config space
(nv46_pci_msi_rearm) instead.  This follows existing precedent: nv46.c
documents the MMIO-mirror re-arm as broken on several related parts,
and commit 5112abc6a433 ("drm/nouveau/pci/g92: Fix rearm") fixed g92
the same way while moving the remaining chipsets, NVAC included, into
the newly added shared g94 table, where NVAC stayed on the MMIO path.
This change completes that fix for NVAC.  The sibling IGP NVAA
(MCP77/MCP78) has MSI disabled entirely as "reported broken" in
nvkm_pci_new_(); NVAC works correctly once the re-arm goes through
config space, so disabling MSI is not necessary.

Only NVAC is switched: that is the hardware this has been validated
on.  The other users of g94_pci_func (G94/G96/G98/GT2xx and the
MCP77/MCP89 IGPs) keep their current behavior; MCP77 and MCP89
plausibly want the same treatment but were not tested.

Tested on the Mac mini as a daily driver for two months with MSI
enabled and zero fifo timeouts.  Independently confirmed stable on an
iMac9,1 (MCP79) running 6.12.90 with the v1 form of this change (the
same one-line functional switch, applied to that kernel's g94
implementation).

Fixes: 5112abc6a433 ("drm/nouveau/pci/g92: Fix rearm")
Cc: <stable@vger.kernel.org> # v6.16+
Tested-by: Fab Stz <fabstz-it@yahoo.fr>
Assisted-by: Claude:claude-opus-4-7
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/178688574401.522643.12812428444459119913@gmail.com
[ Backport note: linux-5.10.y predates commit 2f89bb3264af
  ("drm/nouveau/pci: add PRI address of config space mirror to
  nvkm_pci_func"), so struct nvkm_pci_func has no .cfg member here.
  mcp79_pci_func uses the nv40 .rd32/.wr08/.wr32 accessors instead,
  exactly as g94_pci_func does in this tree, and still differs from
  g94_pci_func only in .msi_rearm.  This tree also still uses the
  older (device, index) subdev constructor form, so mcp79_pci_new(),
  its declaration and the nvac_chipset entry follow g94_pci_new()
  there. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/include/nvkm/subdev/pci.h |  1 +
 .../gpu/drm/nouveau/nvkm/engine/device/base.c |  2 +-
 .../gpu/drm/nouveau/nvkm/subdev/pci/Kbuild    |  1 +
 .../gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c   | 35 +++++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h
index 4803a4fad4a27..d1e080b6ac7fc 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h
@@ -46,6 +46,7 @@ int nv4c_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
 int g84_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
 int g92_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
 int g94_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
+int mcp79_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
 int gf100_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
 int gf106_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
 int gk104_pci_new(struct nvkm_device *, int, struct nvkm_pci **);
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 7851bec5f0e5f..a8f325bae1f30 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -1286,7 +1286,7 @@ nvac_chipset = {
 	.mc = g98_mc_new,
 	.mmu = mcp77_mmu_new,
 	.mxm = nv50_mxm_new,
-	.pci = g94_pci_new,
+	.pci = mcp79_pci_new,
 	.therm = g84_therm_new,
 	.timer = nv41_timer_new,
 	.volt = nv40_volt_new,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild b/drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild
index 174bdf9952715..c5911d7d08ea1 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild
@@ -9,6 +9,7 @@ nvkm-y += nvkm/subdev/pci/nv4c.o
 nvkm-y += nvkm/subdev/pci/g84.o
 nvkm-y += nvkm/subdev/pci/g92.o
 nvkm-y += nvkm/subdev/pci/g94.o
+nvkm-y += nvkm/subdev/pci/mcp79.o
 nvkm-y += nvkm/subdev/pci/gf100.o
 nvkm-y += nvkm/subdev/pci/gf106.o
 nvkm-y += nvkm/subdev/pci/gk104.o
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c
new file mode 100644
index 0000000000000..5c831bcaa3385
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright 2026 Marek Czernohous
+ *
+ * MCP79/MCP7A (NVAC): like g94, but MSI re-arm goes through real PCI
+ * config space.  The MMIO-mirror re-arm is unreliable on this IGP and a
+ * missed re-arm kills the interrupt line (see the nv46 comment; g92
+ * already re-arms through config space for the same reason).
+ */
+#include "priv.h"
+
+static const struct nvkm_pci_func
+mcp79_pci_func = {
+	.init = g84_pci_init,
+	.rd32 = nv40_pci_rd32,
+	.wr08 = nv40_pci_wr08,
+	.wr32 = nv40_pci_wr32,
+	.msi_rearm = nv46_pci_msi_rearm,
+
+	.pcie.init = g84_pcie_init,
+	.pcie.set_link = g84_pcie_set_link,
+
+	.pcie.max_speed = g84_pcie_max_speed,
+	.pcie.cur_speed = g84_pcie_cur_speed,
+
+	.pcie.set_version = g84_pcie_set_version,
+	.pcie.version = g84_pcie_version,
+	.pcie.version_supported = g92_pcie_version_supported,
+};
+
+int
+mcp79_pci_new(struct nvkm_device *device, int index, struct nvkm_pci **ppci)
+{
+	return nvkm_pci_new_(&mcp79_pci_func, device, index, ppci);
+}
-- 
2.53.0



