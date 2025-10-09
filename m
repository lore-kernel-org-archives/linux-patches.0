Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3D122157F;
	Thu,  9 Oct 2025 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025475; cv=none; b=CWaoyBYJNKbsVMQrOdYZ8e+Kzc7YhcIFEJYPiUoKpKveRj1uTS+HT0rtKD2tIsYBRY4PXOINuUmcGSQ+nlztWKW1TONaxtMayJjP6ie4ijdEG78OWFh+mk4nw6S9sxaPozoqpd930MZnuvFocJ1/G6jBNo8Cg5oR07n26dReweM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025475; c=relaxed/simple;
	bh=GnBLVdctQ6Mn4VK9shgxomf1x++ifJGHmduqS2Rf2hU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ktMxjI/8m5if0ABQ15zLgWNKNqL7JwWgg6wJTx9zvEVP5/mcxCvFP6NcDp+sRN098jDSA2TB7kAik1914/dUqKhCaFdcdJpPmibraTRsK4o3RsOnJMshNVZ6z97o0g1Xpq0WRr/LE3/EfsnUuKmlwFBdlWFZsZcC+TnuX2iW0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qOi23cCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qOi23cCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935A1C4CEE7;
	Thu,  9 Oct 2025 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025474;
	bh=GnBLVdctQ6Mn4VK9shgxomf1x++ifJGHmduqS2Rf2hU=;
	h=From:To:Cc:Subject:Date:From;
	b=qOi23cCqSHHdWp6vevmDBup6sFX++OPm/db+vofRtiGSLrKNGyM/nC7/dRKPGMzvf
	 q+8/qyVxvLY2W2ySQn7xgGcsZI+9wpnu+5lH+jDQYh+uH/VeULEcbI7zOmPSJ1V9FG
	 g8j5ONhSV4ZxpGY99V8yEauFHC0VjDN7xiVoaTFp8w3XPM78LjTpehHuOZk6Rh152z
	 u68hoi+eYOppLPMhFVaP17nPO2Aw6BoOT9CZPaUus1Xx8KXBoFe3FrrhqWqlQhMeoT
	 qV6Na32gJ7uUglmRSO15aQiSTJM36xLqaHyqdIpZeQ8if0nfoQ2KVJjtH75ImiZNu+
	 s5adgOdUkYKdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rong Zhang <i@rong.moe>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	clemens@ladisch.de,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] hwmon: (k10temp) Add device ID for Strix Halo
Date: Thu,  9 Oct 2025 11:54:27 -0400
Message-ID: <20251009155752.773732-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rong Zhang <i@rong.moe>

[ Upstream commit e5d1e313d7b6272d6dfda983906d99f97ad9062b ]

The device ID of Strix Halo Data Fabric Function 3 has been in the tree
since commit 0e640f0a47d8 ("x86/amd_nb: Add new PCI IDs for AMD family
0x1a"), but is somehow missing from k10temp_id_table.

Add it so that it works out of the box.

Tested on Beelink GTR9 Pro Mini PC.

Signed-off-by: Rong Zhang <i@rong.moe>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250823180443.85512-1-i@rong.moe
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the added ID lets the existing k10temp driver bind to Strix Halo’s
DF3 device so users get temperature readings on that platform.

- `drivers/hwmon/k10temp.c:560` gains
  `PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3`, fixing the current omission that
  prevents the module from attaching to Strix Halo’s Data Fabric
  function 3 and leaves its sensors unavailable.
- The constant already exists in released kernels
  (`include/linux/pci_ids.h:587`) and is used by the AMD northbridge
  driver (`arch/x86/kernel/amd_nb.c:98`), so the new table entry simply
  connects existing infrastructure; no functional code paths change.
- Scope is minimal (one ID entry, no new logic), making regression risk
  negligible; the patch has been verified on shipping hardware (Beelink
  GTR9 Pro).
- For stable backports, this applies cleanly to branches ≥ v6.10 where
  the PCI ID is defined; older long-term trees would first need commit
  0e640f0a47d8 (or an equivalent definition).

Natural next step: backport to the relevant stable lines that already
carry the Strix Halo PCI ID definition (6.10.y, upcoming 6.11.y, etc.).

 drivers/hwmon/k10temp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 2f90a2e9ad496..b98d5ec72c4ff 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -565,6 +565,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
-- 
2.51.0

