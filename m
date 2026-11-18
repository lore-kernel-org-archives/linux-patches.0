Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020358;
	b=my+Y6TNamxZKClOHOCW+ZQKDmaa2WT7tBiuu3ykNfaxghN985ZPtZinECizHqoqYQ43e
	 hI33YYtz9PFZrAB8i8SW26v3qntsrGvzPhfrjcbG2Gb++dKoNFbBzbgu3fpJyM5/I9Jfq
	 aEuS8HShz7TvWqU3JdKQ2aHUhqwZw9Seqzbw3w/bOicQf+XEt1VYkP2RK825h7DLF0u6U
	 xqgG0cDLpxoSCYMOqaXm68GeZ+X95xbX0bWkWB3cCdZlY9I6IL+DROpMQ4f0WjMLkRmve
	 Ih5M9Odqc9m4IXW7SKW0giOR6+nYniiU85LRhCTUhIwoR1VigiviC3IQkj7T4LG7jjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKxcibGqmspHNAYvWP+qwEblsB0IeMRXi94uwj9eqcQ=;
	b=RFCb3sr9Z/jSBcF+OFTbyt/qZE8rnk/yo2PQ7J0HP5de1bY5JA98/l60uWS5/1YRl34h
	 NzRYSDOTD6VTh3Y6WNty7CEzHvFf3wSn52U07LtKXAZ7MNbbgCh1nxUKGoQhaNjdOjHsM
	 ev7hlI/DFJO7Ranl27sSPI7ZYupR+qa4HA3LNQyH2a17dpIywDU5PaPY8KnPCZMp3xGKu
	 TWrzWLMKY2Gdx+7Y+I+3gTFHAls3w85PiLNBVsguAIckB2B/dGhCs3TCEd13N3Ulx0gTj
	 NtMkaqsGnW+EIFRHAbvmPBsyuvcGW+OBom5E4D2bvHhQtOOam+z/yxP7NYGIEhfO34w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4gFy3CR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D63606A325;
	Wed, 18 Nov 2026 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4gFy3CR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0521F000C4;
	Wed, 18 Nov 2026 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020358;
	bh=TKxcibGqmspHNAYvWP+qwEblsB0IeMRXi94uwj9eqcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4gFy3CRD4khQPfemfsBrMIBHB+jnpLi9pjnReVP6lpt3s2lBW80314SzHxNuHJm6
	 9iF2jAOE88GETBzGmjx/PJn9ub9RfzkZTz3ghXOZV6KWWeQxMb1V5MFBX+9k9Q3Tmv
	 hn+X6sb/DgcVIvEgwEn4wMB7zFxu2fhsqPJvq5lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vladimir V. Kondratyev" <vladimirkondratyev2@gmail.com>,
	Sergey Lebedev <lsa.uz@pm.me>,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1882/2651] Bluetooth: btintel_pcie: fix stale cache in set_dxstate fallback check
Date: Wed, 18 Nov 2026 15:52:02 +0100
Message-ID: <20261118150354.677473129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Vladimir V. Kondratyev <vladimirkondratyev2@gmail.com>

[ Upstream commit 12997a385f7140c66f733128b76845fd906c270a ]

btintel_pcie returns -16 (EBUSY) during suspend, causing the entire
suspend operation to abort on Intel Lunar Lake hardware. The system
immediately resumes after every suspend attempt:

  Bluetooth: hci0: Timeout (200 ms) on alive interrupt for D2 entry, retry count 0
  Bluetooth: hci0: Timeout (200 ms) on alive interrupt for D2 entry, retry count 1
  Bluetooth: hci0: Timeout (200 ms) on alive interrupt for D2 entry, retry count 2
  btintel_pcie 0000:00:14.7: PM: pci_pm_suspend(): btintel_pcie_suspend [btintel_pcie] returns -16
  btintel_pcie 0000:00:14.7: PM: dpm_run_callback(): pci_pm_suspend returns -16
  btintel_pcie 0000:00:14.7: PM: failed to suspend async: error -16
  PM: Some devices failed to suspend, or early wake event detected

btintel_pcie_set_dxstate() falls back to checking the controller state via
btintel_pcie_in_d3/d0() when the alive interrupt is missed. However, these
helpers read boot_stage_cache, which is only updated by the interrupt
handler. As such, if the interrupt was missed, the cache is stale and the
fallback check always fails, exhausting all retries and returning -EBUSY,
causing suspend to abort.

The fix involves re-reading the hardware register before the fallback state
check, consistent with btintel_pcie_resume().

Fixes: 88c6216a52ea ("Bluetooth: btintel_pcie: Suspend/Resume: Controller doorbell interrupt handling")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221481
Link: https://lore.kernel.org/linux-bluetooth/20260830151550.44687-1-lsa.uz@pm.me/
Signed-off-by: Vladimir V. Kondratyev <vladimirkondratyev2@gmail.com>
Tested-by: Sergey Lebedev <lsa.uz@pm.me>
Signed-off-by: Sergey Lebedev <lsa.uz@pm.me>
Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 8 +++++---
 drivers/bluetooth/btintel_pcie.h | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 9f1ff12d85a07..a9a2143058e9b 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -3507,10 +3507,12 @@ static int btintel_pcie_set_dxstate(struct btintel_pcie_data *data, u32 dxstate)
 					  BTINTEL_PCIE_CSR_MSIX_HW_INT_CAUSES,
 					  BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0);
 
-		/* A hardware bug may cause the alive interrupt to be missed.
-		 * Check if the controller reached the expected state and retry
-		 * the operation only if it hasn't.
+		/* A hardware bug may cause the alive interrupt to be missed. Refresh
+		 * boot_stage_cache from hardware, since only the interrupt handler
+		 * updates it. Finally retry only if the state check still fails.
 		 */
+		data->boot_stage_cache = btintel_pcie_rd_reg32(data,
+							       BTINTEL_PCIE_CSR_BOOT_STAGE_REG);
 		if (dxstate == BTINTEL_PCIE_STATE_D0) {
 			if (btintel_pcie_in_d0(data))
 				return 0;
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index 5ceb2ba1276fd..443f04dce5a2d 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -51,6 +51,7 @@
 #define BTINTEL_PCIE_CSR_BOOT_STAGE_DEVICE_HALTED	(BIT(14))
 #define BTINTEL_PCIE_CSR_BOOT_STAGE_MAC_ACCESS_ON	(BIT(16))
 #define BTINTEL_PCIE_CSR_BOOT_STAGE_ALIVE		(BIT(23))
+/* Reflects live D-state. Updated by hardware on every D-state transition. */
 #define BTINTEL_PCIE_CSR_BOOT_STAGE_D3_STATE_READY	(BIT(24))
 
 #define BTINTEL_PCIE_CSR_DOORBELL_MBOX_READ_CONFIRM	(BIT(4))
-- 
2.53.0



