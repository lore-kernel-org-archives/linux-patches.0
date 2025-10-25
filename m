Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2674730CD8F;
	Sat, 25 Oct 2025 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409145; cv=none; b=q8T6ABDXI+jnmOHjqiNEim5hSHU/e3k+dI13rQOYZg8/0B4yV0RCxUiftjP7C/4yGwpqmeVmvzOw8N6ygSw+v2MMRZoM+gkhzflFfN3pvi/6a1ZbTGjJSZY241xaDSNzCvRu+X/9BnfnT1EIu5eGhb7SqFkmrxEpqeWpyATDx4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409145; c=relaxed/simple;
	bh=Z04x+cVUsZbf7V30Zmdq+MQzTJKo7XzvMh7nhLk3OYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IE2vcXcOJQCHvSDBoNPLAymfIS9MOcOXHZNkg8GhyhsTv5/5Bv9NZsVUxK9f1xfTV3S/K6/MbHtfoavdsgrfK/l9NExKxtBGASMnG4bUwpOgAm/0QbqWSx1EbNPNnBHv0yhz7I85QnkBmCoatIKYj7AADmbypaOe2pJqFssQxiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy+rGiUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy+rGiUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE63C4CEFB;
	Sat, 25 Oct 2025 16:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409145;
	bh=Z04x+cVUsZbf7V30Zmdq+MQzTJKo7XzvMh7nhLk3OYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cy+rGiUiguvvCtrdPu7qodJZyO6Q+96I/gjpCVlNWNWQiWtaP18x+eyA+z+Tv1Vb4
	 NlYNrFzTVc7NlrBdpPKp2nmfGZak99Lj17HtjRU/zT8HSi1BGh9C6xqZF9VwQGUhhX
	 Qo9oUgPAtbtnLhW1p5ArF4bZaYi/LxQb8E8kH2xa9yZ4MKrgGghg5nuaQik7MSx2rN
	 Ve8HoMWEq4ETR2dsKo1vo+T/mtUMV5CcGtJUdWlE98uAnCmniLt8hz0GkGp6uVeDDP
	 MU1QgJ0Vh2okk9valvhKPxe4yE12F0xF9sr07mHTCjQXgbX/2G+5Hm8XUWrJGq2w81
	 goLRKA6x4e6gA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	mani@kernel.org,
	quic_vpernami@quicinc.com,
	krishna.chundru@oss.qualcomm.com,
	johan+linaro@kernel.org,
	dnlplm@gmail.com,
	alexandre.f.demers@gmail.com,
	tglx@linutronix.de,
	quic_skananth@quicinc.com
Subject: [PATCH AUTOSEL 6.17] bus: mhi: host: pci_generic: Add support for all Foxconn T99W696 SKU variants
Date: Sat, 25 Oct 2025 11:57:26 -0400
Message-ID: <20251025160905.3857885-215-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 376358bb9770e5313d22d8784511497096cdb75f ]

Since there are too many variants available for Foxconn T99W696 modem, and
they all share the same configuration, use PCI_ANY_ID as the subsystem
device ID to match each possible SKUs and support all of them.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
[mani: reworded subject/description and dropped the fixes tag]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20250819020013.122162-1-slark_xiao@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The PCI ID table in `drivers/bus/mhi/host/pci_generic.c`
  broadens Foxconn T99W696 matching by replacing several hardcoded
  subsystem device IDs with a single entry that uses `PCI_ANY_ID` for
  the subsystem device:
  - New entry: `drivers/bus/mhi/host/pci_generic.c:929`
    - `{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308,
      PCI_VENDOR_ID_FOXCONN, PCI_ANY_ID), .driver_data =
      (kernel_ulong_t) &mhi_foxconn_t99w696_info },`
  - This consolidates prior SKU-specific entries (e.g., `0xe142`,
    `0xe143`, `0xe144`, `0xe145`, `0xe146`) into one match-all line for
    the same device family. The result is that all Foxconn T99W696
    variants with QCOM vendor `0x0308` and subsystem vendor `FOXCONN`
    will match the correct device data.

- Why this matters for users: All those SKUs use the same MHI
  configuration data, `mhi_foxconn_t99w696_info`:
  - `drivers/bus/mhi/host/pci_generic.c:655` defines
    `mhi_foxconn_t99w696_info` which points to
    `modem_foxconn_sdx61_config` and includes the expected channels
    (including NMEA) and event config appropriate for these modems.
  - Without the change, unlisted T99W696 SKUs can fall back to the
    generic SDX65 entry directly below
    (`drivers/bus/mhi/host/pci_generic.c:931`), mapping to
    `mhi_qcom_sdx65_info` (`drivers/bus/mhi/host/pci_generic.c:403`),
    which may not expose the Foxconn-specific channel layout (e.g.,
    NMEA), leading to reduced functionality or improper operation.

- Scope and risk:
  - Small and contained: It only adjusts one entry in the ID table; no
    logic, APIs, or structures change. The probe path remains identical;
    `mhi_pci_probe()` consumes `id->driver_data` to select the
    controller config (`drivers/bus/mhi/host/pci_generic.c:1298`), and
    `mhi_pci_driver.id_table` uses this table
    (`drivers/bus/mhi/host/pci_generic.c:1700`).
  - Constrained matching: The broadened match still requires
    `(vendor=QCOM, device=0x0308, subsystem_vendor=FOXCONN)`. It does
    not affect other vendors or non-Foxconn subsystems. It simply
    captures additional T99W696 SKUs that share the same configuration.
  - Ordering is correct: The Foxconn-specific match precedes the generic
    `PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308)` entry
    (`drivers/bus/mhi/host/pci_generic.c:931`), ensuring Foxconn SKUs
    bind to the correct `mhi_foxconn_t99w696_info` rather than the
    generic SDX65 config.
  - Regression risk is minimal: This is a classic ID-table-only
    enablement that widens support for hardware already handled by the
    driver with identical configuration; it neither introduces new
    features nor changes driver behavior for existing matched devices.

- Stable criteria assessment:
  - Fixes a user-visible issue: Ensures more T99W696 SKUs bind to the
    correct configuration instead of a generic one.
  - Minimal and localized: One table entry; no architectural or
    behavioral changes beyond matching.
  - No side effects beyond fixing the match coverage for a confined
    subsystem (MHI PCI host).
  - While there is no explicit “Cc: stable@” tag, this kind of ID-table
    expansion to enable existing hardware is standard and low-risk for
    stable backports.

Conclusion: This is a low-risk, ID-only match fix that improves hardware
support for users with additional Foxconn T99W696 SKUs. It should be
backported.

 drivers/bus/mhi/host/pci_generic.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 4edb5bb476baf..4564e2528775e 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -917,20 +917,8 @@ static const struct pci_device_id mhi_pci_id_table[] = {
 	/* Telit FE990A */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2015),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fe990a_info },
-	/* Foxconn T99W696.01, Lenovo Generic SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe142),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.02, Lenovo X1 Carbon SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe143),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.03, Lenovo X1 2in1 SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe144),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.04, Lenovo PRC SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe145),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.00, Foxconn SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe146),
+	/* Foxconn T99W696, all variants */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, PCI_ANY_ID),
 		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx65_info },
-- 
2.51.0

