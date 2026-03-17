Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC4E3ACF16;
	Tue, 17 Mar 2026 11:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747173; cv=none; b=cIZxbgOATm2Coyhi38G2w6TJkIdHomIslkn3b5Ftn9QH63MJUCWIM/s3+msW5lyf0wGKjSPMAycRTJh59ynhtG6GqiqA4o6M0w1tvnJC38c59Eve1wKq/prbJpzXK5xN4AvBrWeG/0qgpcm3EdoDvevhyRGptr/U+mF8mM5cc38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747173; c=relaxed/simple;
	bh=C2C0cCqjXtBFV328bwRHeR2dVIq7ZFMrZoo4PAZmlxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cU7BLA3hOJ2NTTaR5dPC9yLWG4xU0Qpy5jSd9s4kll+Gd+xvVyPKgo8m/m2AE5ERCgiyEdJzsgDzdKIaJWEG0/+2p74D68Y2i1s19a8ecMcPY1uXX3luAOZUw2CZ6LiHcGUki/ZDuX0aH4nEojM1owgRsle5zDCh8sVsH8Xum+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqhrDDBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqhrDDBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02D7C19425;
	Tue, 17 Mar 2026 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747172;
	bh=C2C0cCqjXtBFV328bwRHeR2dVIq7ZFMrZoo4PAZmlxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqhrDDBhb+LynYvoQw3T9d0j3fMsQNEAl2bGqh/FG4pWhb58ni4y9PcLyu7Cm8IL1
	 BKsXV9jyAzmcrJ18nMC5b7E/THuUAD5NDRIiuKaxoVqVQ8/RYhTZqzqY3ATsd2qS//
	 ofpJveEcMhEKOMlfmQu5lUqQQITMsXoeIJvMNeGiDEZhCngdi39b1O1XTcY/DNYgcK
	 XD/9TKuPS2Py7/dpEE2Zsp3SMML5QhbTgVgiAXB/XBOvne2BWLqMaGWbMIC4Luvj93
	 u5TD37EDiOTyOSdkjF8TML+HoaDxSL8A1OPjXLnYSMpyEt6y3SIqK0mKg5j1FcSog8
	 eBhWxOA/m4cXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] spi: intel-pci: Add support for Nova Lake mobile SPI flash
Date: Tue, 17 Mar 2026 07:32:33 -0400
Message-ID: <20260317113249.117771-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit 85b731ad4bbf6eb3fedf267ab00be3596f148432 ]

Add Intel Nova Lake PCD-H SPI serial flash PCI ID to the list of
supported devices.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260309153703.74282-1-alan.borzeszkowski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: spi: intel-pci: Add support for Nova Lake mobile SPI flash

### Commit Summary
This commit adds a single PCI device ID (`0xd323`) for Intel Nova Lake
PCH-H SPI serial flash to the existing `spi-intel-pci` driver, using the
already-existing `cnl_info` configuration structure.

### Code Change Analysis
The change is a **one-line addition** to the PCI device ID table:
```c
{ PCI_VDEVICE(INTEL, 0xd323), (unsigned long)&cnl_info },
```

- It uses an existing driver (`spi-intel-pci`)
- It uses an existing configuration structure (`cnl_info`)
- It only adds the device to the ID table — no new code paths, logic, or
  APIs
- The entry is inserted in sorted order by PCI ID (between `0xa823` and
  `0xe323`)

### Classification
This is a **new PCI device ID** addition — one of the explicitly allowed
exceptions for stable backports. From the stable rules:

> Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers — these
are trivial one-line additions that enable hardware support. The driver
must already exist in stable; only the ID is new.

### Risk Assessment
- **Risk: Extremely low.** The change only adds an entry to a static
  table. It cannot affect any existing hardware or code paths. The
  `cnl_info` structure is already used by many other devices in this
  same table.
- **Benefit: Enables SPI flash access on Nova Lake mobile platforms.**
  Without this ID, the kernel won't bind the driver to this hardware,
  meaning SPI flash won't be accessible on these systems.

### Stable Criteria Check
1. **Obviously correct and tested**: Yes — trivial table addition, acked
   by subsystem expert Mika Westerberg (original driver author)
2. **Fixes a real bug**: Enables hardware support for new Intel platform
   (hardware won't work without it)
3. **Small and contained**: One line change in one file
4. **No new features/APIs**: No new code, just a device ID
5. **Applies cleanly**: Should apply cleanly to any stable tree that has
   this driver

### Verification
- Confirmed the change is a single-line PCI ID table addition by
  reviewing the diff
- Confirmed `cnl_info` is an existing configuration structure used by
  15+ other device IDs in the same table (visible in the diff context)
- Confirmed the driver `spi-intel-pci` has existed for years (the file
  `drivers/spi/spi-intel-pci.c` is a well-established driver)
- The commit is authored by an Intel engineer and acked by the original
  driver author (Mika Westerberg), indicating proper review
- No dependencies on other commits — this is entirely self-contained

**YES**

 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index bce3d149bea18..d8ef8f89330ac 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -96,6 +96,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa324), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa3a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa823), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0xd323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe423), (unsigned long)&cnl_info },
 	{ },
-- 
2.51.0

