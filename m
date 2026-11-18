Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018686;
	b=yCpUYSptoL8vxaez2uQ7qzU5jSVml2HRCYvviVu5dhbr54BdL5EQR1oReNgf8n71cjCT
	 UuYZrEKVcNHU9sb3XRBVQu2RFamwBeAHjx34iB8l6fg+imZpw2vPGXOqxCcod/lXKZVNx
	 oaz+tKhQSAbSje9xbIXYTMoOi0/FZnN1YxNEJh28Kqiu6+tDLo2mFH+NyMya8lBBAHsnL
	 tjT26Bzp/9maarCZAWUcH0VT2xv9Bx2CwRx4B+vWMOhOr/Y1VB5pzE7v8kUynf/VD7EFH
	 0rD9V4cpgEASikNEhCJGsofMyWFvNngEWrr0HEm3YeZ1mJQ88J6BE8+NZ+OhtAg3kUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3orL1Yv6F/VTCAHv6mqifhBgsdVxv0Z9H72etPfU2bI=;
	b=dyMY78gFaFQH5h9fp1HvbiZu20TAs4EspWoYykJkc+EsGnYLzJF8A/pTK7d0XNdCcvl/
	 2Gkpiwd+TXpFPd9c/klMvYdFkhchA3BxoVAhJ03nwAaVVHUDIee2FXqUtFJ/D01ARvjM2
	 u+73pqNoXgfNNKexQ/bmDlITiCpOTWJRgapempVp2XxbAxIwB+s4u9BdLZDbHeq2EoObt
	 5egnN9r2D2Rv6O1w1Psqr5J8IrzeVn9y+pexao3+e1g1RAag1H5E7UZFNaMoIP/9Adu+5
	 VhTcSh0Vt4GHsxHowktAxf4n8ON0NlaaMcNMN6kkfsqhTHHiHcP1qMfboHQemQ/ECcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2NGC8bc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547DF606A332;
	Wed, 18 Nov 2026 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2NGC8bc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF84B1F000CB;
	Wed, 18 Nov 2026 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018686;
	bh=3orL1Yv6F/VTCAHv6mqifhBgsdVxv0Z9H72etPfU2bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2NGC8bcVn7FB79uSESXjhRohnzXDD34elsRbW8m28QOEmwyx5oOaklDesFMgnm7W
	 QORFEIQGKiGPobNq/HTQtVX9MhcO2r4muJfE8VFp4gSQIxNbOjyBdgfTJnywC8KIa0
	 /ljFccu05KzOixn79fW5ukR/44ZIodzCbX7mVpkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1328/2651] wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume
Date: Wed, 18 Nov 2026 15:42:48 +0100
Message-ID: <20261118150335.811598430@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit e56c9d429ba004d5416b03091fd7656187cdcaf1 ]

Commit f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware
crash recovery") added an unconditional ath11k_hif_irq_disable()/
ath11k_hif_ce_irq_disable() pair inside
ath11k_core_reconfigure_on_crash(), guarded by "if (!ab->is_reset)", to
stop the DP NAPI from touching rings that have just been torn down. That
fixes AHB device recovery, but breaks PCI device suspend/resume. During
suspend, IRQs are disabled once in ath11k_core_suspend_late(). Then during
resume, ath11k_core_reconfigure_on_crash() sees ab->is_reset clear and
disables them a second time. Those IRQs are enabled only once during
the following reinitialization, leaving the IRQ lines masked. As a result,
HTC control responses never arrive, and resume fails:

  failed to receive control response completion, polling..
  failed to connect to HTT: -110
  failed to reconfigure driver on crash recovery
  failed to resume core: -110

Fix this by disabling the IRQs unconditionally at the top of
ath11k_core_reconfigure_on_crash(), and instead drop the disable
calls from the two places that already disable IRQs before this
function can run: ath11k_core_suspend_late() and ath11k_core_reset().
This keeps a single disable per recovery/suspend cycle regardless of
which path (recovery or suspend) triggers it, so the refcount on
PCI parts stays balanced while AHB parts keep getting the disable
that the original commit needed.

Fixes: f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware crash recovery")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-wireless/a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index d2ed6a0ea7e36..1ad0a47653dec 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1275,9 +1275,6 @@ int ath11k_core_suspend_late(struct ath11k_base *ab)
 	if (ab->actual_pm_policy == ATH11K_PM_WOW)
 		return 0;
 
-	ath11k_hif_irq_disable(ab);
-	ath11k_hif_ce_irq_disable(ab);
-
 	ath11k_hif_power_down(ab, true);
 
 	return 0;
@@ -2333,17 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 	int ret;
 
 	mutex_lock(&ab->core_lock);
+	ath11k_hif_irq_disable(ab);
+	ath11k_hif_ce_irq_disable(ab);
 	ath11k_thermal_unregister(ab);
-
-	/*
-	 * ath11k_core_reset() already disabled the interrupts on the reset
-	 * path; only the firmware crash path reaches here with them live.
-	 */
-	if (!ab->is_reset) {
-		ath11k_hif_irq_disable(ab);
-		ath11k_hif_ce_irq_disable(ab);
-	}
-
 	ath11k_dp_pdev_free(ab);
 	ath11k_cfr_deinit(ab);
 	ath11k_spectral_deinit(ab);
@@ -2605,9 +2594,6 @@ static void ath11k_core_reset(struct work_struct *work)
 	time_left = wait_for_completion_timeout(&ab->recovery_start,
 						ATH11K_RECOVER_START_TIMEOUT_HZ);
 
-	ath11k_hif_irq_disable(ab);
-	ath11k_hif_ce_irq_disable(ab);
-
 	ath11k_hif_power_down(ab, false);
 	ath11k_hif_power_up(ab);
 
-- 
2.53.0



