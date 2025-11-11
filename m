Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E334029E;
	Tue, 11 Nov 2025 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825099; cv=none; b=IKugJ4nheMMmK5JbteNrr11u6ZOyeSSCO1tn+a+iR/kh1MY+FNdueGGPRM5fJ2ZMBUvj+wurO8uK2KtsWDp2dpc/parXGu6wk+r+3qX3XAH7HK5EBdU1Y4dJnjQZ3tXTDS1skyEtpC9AK4iB35mdpmlV0eoTezIFQeermw1mltU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825099; c=relaxed/simple;
	bh=AOhQmwc90N+fi2idvla/llMy8Gk0aNydmyWtjmqaJZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/C5a+iZvfWgyNhuWU4RFSm1UXFqlj0wf1f7VUP7acqXsi17jEaUmsxarHMOv6qKGroE9jjLrbGRjfE5KrExQ+IXgf5IZOnAqOyJMLFXTVOcflo9vTWI8FQGKjtA/SyyhIdGC7AUxQCayiH3rZeIdFV/ZQnzbrGqVHzM5BjZ0DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiFqjzQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiFqjzQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D96C113D0;
	Tue, 11 Nov 2025 01:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825099;
	bh=AOhQmwc90N+fi2idvla/llMy8Gk0aNydmyWtjmqaJZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiFqjzQF638/M2jbZl4GtYCZjN/dVgginpr7WWoNrMmfGUb8f6Bta7mvO3Tk+c/yy
	 NvvbfzvNK6AfyntQEgsDX7dcVgmixrq76WsOnpwh47LhDhEl8GfK9jTlBVt7Ly5JmR
	 CfDgSQdP6DWa6R8htGLCqNQz83Z2c6u2hLRiUADk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijay Satija <vijay.satija@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 658/849] Bluetooth: btintel: Add support for BlazarIW core
Date: Tue, 11 Nov 2025 09:43:48 +0900
Message-ID: <20251111004552.335558863@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 562acaf023f55..c9fb824fb8e1d 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -2088,6 +2088,7 @@ static int btintel_pcie_setup_internal(struct hci_dev *hdev)
 	switch (INTEL_HW_VARIANT(ver_tlv.cnvi_bt)) {
 	case 0x1e:	/* BzrI */
 	case 0x1f:	/* ScP  */
+	case 0x22:	/* BzrIW */
 		/* Display version information of TLV type */
 		btintel_version_info_tlv(hdev, &ver_tlv);
 
-- 
2.51.0



