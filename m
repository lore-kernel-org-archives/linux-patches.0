Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30541304BC9;
	Sat, 25 Oct 2025 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409722; cv=none; b=NfYlIZMwkZ5kRQNWLQm0zyYb77VqksRzfkl4hT30s475F390il6KMulFpcl/CwSME9UJKnQNuMHn0Gl1hLewYzOFgsfKr1VpdLejFmuJuGIDQiCLc9HUtCgzBwKbtXK+IIzXrvFPqkMHpoCzTj7BbOt5Ei+a3FDp6qFd8E2DkAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409722; c=relaxed/simple;
	bh=OC9x/f+GJHiDHxyUMWzjCdyqcedfmS8OR43ptFEhYWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmYRPxUJk4kalPAB0h6dSs/DZJ7UsUHgGSbpSOf6euWtxDWr/nrMH3GEMe2tSE3gZg2D912hvFh5rdxgKu7BGeGpPF4YLxi5BmeqcnUjH8sUvr5nLMwjgIt/ZuZDPsNk5kMsyFuRtNoh5/g/7X+Fp6Fs8AnaJIxuld7mrpJA+XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwyVD8hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwyVD8hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11967C4CEF5;
	Sat, 25 Oct 2025 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409722;
	bh=OC9x/f+GJHiDHxyUMWzjCdyqcedfmS8OR43ptFEhYWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwyVD8hrzEXpogZutwwY2almcLBujpsQWQ9o/dIanQyb1JlSdjSlTKObVe2+A7jwK
	 aaPSERNUlvKLaux3I0DGPa603uRiSS/V8g8UQMATV3j+vUL5ERuoxeCBpE08Z1vMfY
	 Bnmga2k2IdrFhx/zuD4egPTAXKI5tBym5MO2TqXnEdi6x8mgpqTVXz3QSMfv0BHKYW
	 adL6Noeuy324w9nNGF1eEPWrwXV7y8x/FZE9QkRL6XxQANhjcZ+iVQztvBRmfnQm2X
	 +pQ8CrycZCuqlq7ia1XPHBht/ptMfvvVLszU6N7np+nKR7XNnFj96+nLPSikN0hRJj
	 OjjjZLpVvTrOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kiran K <kiran.k@intel.com>,
	Vijay Satija <vijay.satija@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] Bluetooth: btintel: Add support for BlazarIW core
Date: Sat, 25 Oct 2025 12:01:07 -0400
Message-ID: <20251025160905.3857885-436-sashal@kernel.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 926e8bfaaa11471b3df25befc284da62b11a1e92 ]

Add support for the BlazarIW Bluetooth core used in the Wildcat Lake
platform.

HCI traces:
< HCI Command: Intel Read Version (0x3f|0x0005) plen 1
    Requested Type:
      All Supported Types(0xff)
> HCI Event: Command Complete (0x0e) plen 122
  Intel Read Version (0x3f|0x0005) ncmd 1
    Status: Success (0x00)
    .....
    CNVi BT(18): 0x00223700 - BlazarIW(0x22)
    .....
    .....

Signed-off-by: Vijay Satija <vijay.satija@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES — supporting BlazarIW is a straightforward extension of the existing
TLV-capable Intel path and prevents a hard failure on shipping hardware.

- `drivers/bluetooth/btintel.c:487` adds variant `0x22` to the allow-
  list; without it the setup path aborts with `-EINVAL`, so Wildcat Lake
  systems can’t bring up Bluetooth. The variant follows the exact
  handling already used for 0x1d/0x1e/0x1f, so no new behavior is
  introduced.
- `drivers/bluetooth/btintel.c:3257` ensures the new variant reuses the
  standard Microsoft vendor extension opcode assignment alongside the
  other TLV devices, keeping feature parity.
- `drivers/bluetooth/btintel.c:3598` includes 0x22 in the TLV bootloader
  setup branch, reusing the proven quirk, DSM reset, and devcoredump
  logic the other Blazar-class parts rely on; there are no extra code
  paths or architectural changes.
- `drivers/bluetooth/btintel_pcie.c:2095` mirrors the same allow-list
  update for the PCIe transport so host setups don’t bail out earlier in
  bring-up.

The change is limited to switch tables, carries no behavioral risk for
older hardware, and resolves a clear user-visible regression (device
unusable). Given the minimal scope and the importance of enabling
supported hardware, this is a good fit for stable backporting.

 drivers/bluetooth/btintel.c      | 3 +++
 drivers/bluetooth/btintel_pcie.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index be69d21c9aa74..9d29ab811f802 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -484,6 +484,7 @@ int btintel_version_info_tlv(struct hci_dev *hdev,
 	case 0x1d:	/* BlazarU (BzrU) */
 	case 0x1e:	/* BlazarI (Bzr) */
 	case 0x1f:      /* Scorpious Peak */
+	case 0x22:	/* BlazarIW (BzrIW) */
 		break;
 	default:
 		bt_dev_err(hdev, "Unsupported Intel hardware variant (0x%x)",
@@ -3253,6 +3254,7 @@ void btintel_set_msft_opcode(struct hci_dev *hdev, u8 hw_variant)
 	case 0x1d:
 	case 0x1e:
 	case 0x1f:
+	case 0x22:
 		hci_set_msft_opcode(hdev, 0xFC1E);
 		break;
 	default:
@@ -3593,6 +3595,7 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	case 0x1d:
 	case 0x1e:
 	case 0x1f:
+	case 0x22:
 		/* Display version information of TLV type */
 		btintel_version_info_tlv(hdev, &ver_tlv);
 
diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 585de143ab255..58cff211ec2c1 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -2087,6 +2087,7 @@ static int btintel_pcie_setup_internal(struct hci_dev *hdev)
 	switch (INTEL_HW_VARIANT(ver_tlv.cnvi_bt)) {
 	case 0x1e:	/* BzrI */
 	case 0x1f:	/* ScP  */
+	case 0x22:	/* BzrIW */
 		/* Display version information of TLV type */
 		btintel_version_info_tlv(hdev, &ver_tlv);
 
-- 
2.51.0

