Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C01301701;
	Sat, 25 Oct 2025 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408967; cv=none; b=jqiw7GZTlFVWbbclbEXTetMgkslANdEDzU3OACzwiSmkjjwxyCuhoKKd6ZopfU2pnm17fTyvBQkskpgibw82j3/x/V7DSK6hkRDjdnn9bu7jAsY4jNSOyzfy0ZEuYElrJgO8MtihAycftd4+6sOkQ8hCr6lZDgcf+Jfw3Hp9JcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408967; c=relaxed/simple;
	bh=QwO0iTE43pGFIY/hJQqlLOWK3XWSU6LqZkqpYUjdzOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oyPtJMNeCSUyMJl7CSnOeuaQFbq+A/2Upcbak5LWg4AyK/C03jc3azkjIXVrWhuEYXF2vKo3u1S2rXDHZOJhVhH5feSCDSZS0e2zSZYvJFHYgZp5ti0SyAkZeJ5q6IsSouEIYs5lT1vDxmzO+p2M8loEI2w7MgFBpxFV/Slks0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pD+rQOS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pD+rQOS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32865C4CEFB;
	Sat, 25 Oct 2025 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408966;
	bh=QwO0iTE43pGFIY/hJQqlLOWK3XWSU6LqZkqpYUjdzOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD+rQOS98ZIH6hyWS5FfnxwFB+lCHluS7lRzqKCsYr/e13EH1XgI5rlLImwCvn7uN
	 UdLm8/YXx3c9GoF5Wxl73+GwKON0ZqPIw67XR46iGWr5Eojyf+Sm69NGVztFT5joLi
	 o/KfyyzUt35SsRcZYCT/Y85QKIGi+RY22NUY+udXtwO0JRgLCfCHzXAWuAYU8dfXnE
	 cm53nO/h+hWXZDBNEaD5i88N2re8mgtsutMYUe4iBF6M9mkMCkExH6Wu2rYK+vEQ+m
	 9vYk+Owxf0czMEK3VomEPhWFlL2R8cuQgo8PACGbwjcYbVqZWQ+1rcoAy1uR6wRSkd
	 y36vqvJqQeB3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] Bluetooth: btintel_pcie: Define hdev->wakeup() callback
Date: Sat, 25 Oct 2025 11:56:27 -0400
Message-ID: <20251025160905.3857885-156-sashal@kernel.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit 3e94262921990e2884ff7a49064c12fb6d3a0733 ]

Implement hdev->wakeup() callback to support Wake On BT feature.

Test steps:
1. echo enabled > /sys/bus/pci/devices/0000:00:14.7/power/wakeup
2. connect bluetooth hid device
3. put the system to suspend - rtcwake -m mem -s 300
4. press any key on hid to wake up the system

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `drivers/bluetooth/btintel_pcie.c:2350` introduces
  `btintel_pcie_wakeup()`, which just calls
  `device_may_wakeup(&data->pdev->dev)`; this mirrors the existing
  pattern in other Bluetooth transports (for example
  `drivers/bluetooth/btusb.c:3758`) and safely queries whether userspace
  enabled PCIe wakeups for the device that is already stored at
  `drivers/bluetooth/btintel_pcie.c:2411`.
- Hooking that helper via `hdev->wakeup = btintel_pcie_wakeup;` at
  `drivers/bluetooth/btintel_pcie.c:2382` lets the HCI core mark the
  controller as remote‑wakeup capable (`net/bluetooth/hci_core.c:2661`)
  and, during system suspend, actually run the wake-capable
  configuration instead of bailing out early
  (`net/bluetooth/hci_sync.c:6214`). Without this patch, the Intel PCIe
  controller never programs accept lists/event masks for wake-on-
  Bluetooth even when `/sys/bus/pci/.../power/wakeup` is set to
  `enabled`, so Bluetooth HID devices cannot wake the machine—an obvious
  user-visible regression for WoBT capable hardware.
- The change is self-contained: it neither alters suspend/resume
  sequencing nor touches shared subsystems beyond wiring the standard
  callback, and it relies only on long-standing primitives
  (`device_may_wakeup`, `hci_get_drvdata`) already present in stable
  releases beginning with v6.10 where `btintel_pcie` first appeared.
- Because it fixes a real functionality gap with minimal, well-
  understood code and matches existing drivers’ behaviour, the risk of
  regression is low while the benefit (restoring Wake-on-BT support) is
  high, making this patch a strong candidate for stable backporting.

 drivers/bluetooth/btintel_pcie.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 58cff211ec2c1..a91e768c0c4c0 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -2341,6 +2341,13 @@ static void btintel_pcie_hw_error(struct hci_dev *hdev, u8 code)
 	btintel_pcie_reset(hdev);
 }
 
+static bool btintel_pcie_wakeup(struct hci_dev *hdev)
+{
+	struct btintel_pcie_data *data = hci_get_drvdata(hdev);
+
+	return device_may_wakeup(&data->pdev->dev);
+}
+
 static int btintel_pcie_setup_hdev(struct btintel_pcie_data *data)
 {
 	int err;
@@ -2366,6 +2373,7 @@ static int btintel_pcie_setup_hdev(struct btintel_pcie_data *data)
 	hdev->set_diag = btintel_set_diag;
 	hdev->set_bdaddr = btintel_set_bdaddr;
 	hdev->reset = btintel_pcie_reset;
+	hdev->wakeup = btintel_pcie_wakeup;
 
 	err = hci_register_dev(hdev);
 	if (err < 0) {
-- 
2.51.0

