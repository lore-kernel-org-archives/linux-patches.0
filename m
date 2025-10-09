Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12B62FC880;
	Thu,  9 Oct 2025 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025671; cv=none; b=Exov2X6IMC9zitGCoJSvh2l1/u29nQIQtlGPjDeKUj6jkaE6SeXKrTzjvHBE8wBPoe61a4NbzXkS8d8qwJl54hhOIyVJwe5OaGM9T36nKUmeDbsYOal4SbZpoCBC5p2fbwrcW8h5aNXpjZf4/UHFJ7eOevt+5yOMC0L0xqnBJw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025671; c=relaxed/simple;
	bh=JmNmYM0sle+eRlh6oYsgYdwed+dwDlN+QOKLYbR0ZY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzP3VFSFuCi+W6lfosePBzL0/vtKqizo4Pjxj/JiY/ebI/duFiT7X0Ee71lcVxYM6FUpiY0EzCuOETLHnAo3ptVC06RIDpNM05/Bdhh69HvbBwASy0tu0QcEFXbYMZZNp2o88ymYnoip8nxPs8Wa6THPVUf/FZvlPg3qCqzg/r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvOD74FC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvOD74FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6F5C4CEE7;
	Thu,  9 Oct 2025 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025670;
	bh=JmNmYM0sle+eRlh6oYsgYdwed+dwDlN+QOKLYbR0ZY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvOD74FC4nF/PmmApTLnL7115dpv2lEvD0IwYyGlzEH/YR19sSWfDDVsvgYTWZcwq
	 2dWqyppkYDgZOVsXrysH21b71arMixIMECcoaXqusLVvSZcifHTFzbvEsGiKgpjzgR
	 Rt0XLga5vI7kWaUE+K9hO4uMNJF8EbLlGAuz4H5Bd1HxkZ/eqqlviGmgNBtsIqlUme
	 FCodlTy6Atg8pWBUN2xESBH9cOZVZijNNTBvq4VOgAD5aqwZg+E2EeGk1qvwlTJU6b
	 6mxvqToJ29ajQZaJ/wpG0H3VQ53YRAcdqBOUMCM4ccp039HzC22JzVcx2SXZmX+7X+
	 rFzwiqWjrik9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Avadhut Naik <avadhut.naik@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	clemens@ladisch.de,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] hwmon: (k10temp) Add thermal support for AMD Family 1Ah-based models
Date: Thu,  9 Oct 2025 11:56:11 -0400
Message-ID: <20251009155752.773732-105-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
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

From: Avadhut Naik <avadhut.naik@amd.com>

[ Upstream commit f116af2eb51ed9df24911537fda32a033f1c58da ]

Add thermal info support for newer AMD Family 1Ah-based models.

Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Link: https://lore.kernel.org/r/20250729001644.257645-1-avadhut.naik@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Adds missing device IDs for AMD Family 1Ah model 50h/90h locally in
  `drivers/hwmon/k10temp.c:86` so the stable tree doesn’t need header
  updates, keeping the change self‑contained and under the “just add a
  device ID” rule.
- Extends `k10temp_id_table` to match those IDs
  (`drivers/hwmon/k10temp.c:563` and `drivers/hwmon/k10temp.c:565`),
  letting the existing probe path bind on the new desktop parts; without
  it, users on those CPUs lose all `k10temp` temperature readouts.
- The runtime logic for Family 1Ah CPUs was already upstreamed earlier
  (see the 2023 support commit still present in this tree at
  `drivers/hwmon/k10temp.c:482`), so the new entries simply reuse a
  proven Zen5/1Ah code path with no behavioral changes for older
  systems.
- No collateral effects: no register programming changes, no new flows,
  and the driver keeps using the same SMN readouts, so regression risk
  is negligible while hardware coverage noticeably improves.

 drivers/hwmon/k10temp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index babf2413d666f..2f90a2e9ad496 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -84,6 +84,13 @@ static DEFINE_MUTEX(nb_smu_ind_mutex);
  */
 #define AMD_I3255_STR				"3255"
 
+/*
+ * PCI Device IDs for AMD's Family 1Ah-based SOCs.
+ * Defining locally as IDs are not shared.
+ */
+#define PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3	0x12cb
+#define PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3	0x127b
+
 struct k10temp_data {
 	struct pci_dev *pdev;
 	void (*read_htcreg)(struct pci_dev *pdev, u32 *regval);
@@ -556,7 +563,9 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
 };
-- 
2.51.0

