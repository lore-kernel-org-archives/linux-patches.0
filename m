Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015508;
	b=xy7yP9i04GlZZausne3reSU0q5xN/1pdvC7EVOD4RmIgbV0+ihv4EbAkCF35UR8SDxog
	 3INKKFVVY7smoVNCsfmnleuKcdEFtisUGE7sr+j2HCdg9l6j0tA7mvWqqxKWuV2S1/lU4
	 4CRw00+dHNyTl8SgEEFQhiZEOS3BLkSRwu2v7s2Xhns5oEG3l5aTtIQr7RG+vqolo7tbt
	 3/fR2keYnL2/XivsttoyFX9UZz95fU1qI884MN8fTYG8ouFJkXS0ekOfmOzjPCV3Qys6A
	 hHAgbQf9C8Ci6FwxUMoQlksWDL57F0SydtYIgbLJFRYTHEIt0ztIhwsSnfte08EbmxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RO+7YKCO7y8lqNI33T8KDBwvy/w85avEAmAz2KHch+o=;
	b=kFKY4aLCIcTt6fj+yxhMfoRIslvxRVDwB6p+cUAhf17ytcH6fTBiuJZzBAwy1CHBskNY
	 yLWvV970F/cHlPOfW9MpLxsL4+uq1dmAAP62pYP17i0iHHyz72R/UDjYxY48z4O+mAIO8
	 rQ6P2h7Tu5Ww2yodv8D4X9o0N63MgcWbyggeifFC2Y6WmhHcUeTc7uji6/2Iae5Y5EE90
	 1rafu8zX1osA+h/WSV7KZeZynlgDXgG2THsVn24Lit0c65nBw0sMPvCI+ZS6RFANBzO06
	 nCDMi2UlBO8d6ZdaD0VpCQq2dUVR+aX3GTV7tdlRMq/GBb0o7KYMuqHMx/AUpB54nnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbXF9A9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30D6606A320;
	Wed, 18 Nov 2026 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbXF9A9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0761F000C5;
	Wed, 18 Nov 2026 15:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015507;
	bh=RO+7YKCO7y8lqNI33T8KDBwvy/w85avEAmAz2KHch+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbXF9A9UjWJuv9Wucniih4qcE/AGbUBlVhGynFnx3GwXoSJfuofLyDsFKJ9qvW3Dw
	 s4LiaLOV7CXJ5NiDHGNW5i4p5/zRyDlr1tlB4UjRvQ28UGGxnDcgsVM7XTDDrLbw2j
	 Hljwa2noBpNa7/nx6zXnpiqUenh13GI0Z5QIS56c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0197/2651] wifi: ath11k: disable interrupts during firmware crash recovery
Date: Wed, 18 Nov 2026 15:23:57 +0100
Message-ID: <20261118150254.950251358@linuxfoundation.org>
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

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit f7a74e131d3f0de04335dbe278bfb82bdafcdb3e ]

On IPQ8074 a firmware assert reboots the SoC:

  Unable to handle kernel read from unreadable memory at virtual address 0
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
  Call trace:
   ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
   ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
   ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
   ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
   __napi_poll+0x38/0x188
   net_rx_action+0x120/0x2c0

ath11k_core_reconfigure_on_crash() tears the data path down with
ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
which memsets the ring list. The DP NAPI is still running while that
happens, so it services a ring whose address pointer has just been
cleared.

That function used to disable the interrupts first, until
commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
moved the disable into ath11k_core_reset(). reset_work is only queued
from mhi.c and from the debugfs hw-restart handler, so AHB parts never
run it on a real firmware crash. Their recovery goes QMI server exit ->
restart_work -> ath11k_core_reconfigure_on_crash() ->
ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
anywhere along it.

Disable them again on the crash path. The reset path has already done
so by the time it gets here, hence the ab->is_reset check.

This is also why the debugfs hw-restart trigger never showed the
problem: it goes through ath11k_core_reset(), the one path that still
had the disable.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1

Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260726221908.104873-3-julius@bairaktaris.de
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 8039124e78327..d2ed6a0ea7e36 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2334,6 +2334,16 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 
 	mutex_lock(&ab->core_lock);
 	ath11k_thermal_unregister(ab);
+
+	/*
+	 * ath11k_core_reset() already disabled the interrupts on the reset
+	 * path; only the firmware crash path reaches here with them live.
+	 */
+	if (!ab->is_reset) {
+		ath11k_hif_irq_disable(ab);
+		ath11k_hif_ce_irq_disable(ab);
+	}
+
 	ath11k_dp_pdev_free(ab);
 	ath11k_cfr_deinit(ab);
 	ath11k_spectral_deinit(ab);
-- 
2.53.0



