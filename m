Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029165;
	b=WbfQV1z13lDjaNYw1/kiGiqgcGqeiYyIBXVe0bMkYYaNAjfG49F2Haot7tmM6nIlbIbP
	 9fbNFH0GVfa5n2v/77Fz1xoeHnc+rnV43bsWMV1voQ9FRDR8QN/UUN+jLHioor4ALmoPq
	 wIrqNnI2f/h7yALCcK9GCg7sae9RoHXI0Yzit1A4tYM94/wuqg0QpwW2zoRrVI0Iu5Ob3
	 8b+siuvZYb3hLmqdQdFJeaeFr0AKqy1e0bsXT7SCPvcFpwEv/rWkgqYIolVkeI8rEyNwS
	 ivuyDiEGKUK/Mh5+r/mqBxQ/N9ZtCTkUBJYm3JWeCsvwR9E5U3cVHLi9TqfkgKsObzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dq9wg08+8t5Zc53VkHF1gD0nBTzbAcAToHR727dCQl8=;
	b=i1IhdunJs4yLuNSQAMf4sn9qUEaxxuOPq8DBwZ3mxaP8jrXB8EqIn5E0qgENyDRewRlC
	 2kZL2JKmEnTkdQskfNWdOTmcdxrytvbR43MAWTksabC4kY3V71U9Q1qYFgHfpj2EejA7N
	 RBrJ9omTqPGFWXzeAQryQ/j2xdYAVUuyULempu27c827qxLEnOE158wx99Gt6J0Tldvdz
	 FFhDMFa/aBpvs8+B3cpNfUjPJtXB8woJ56+IOzRU8SOUowx2EwJ4b/htFyffpunz00OeC
	 RKJ5yWwGbuznwIJ223b1vdxVcZzy0qZ9qTJ5oP1kdsrytz+uH23ivMivPoctUbPOybg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcvR8qv8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B6E606A31C;
	Wed, 18 Nov 2026 19:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcvR8qv8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996131F000C4;
	Wed, 18 Nov 2026 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029165;
	bh=dq9wg08+8t5Zc53VkHF1gD0nBTzbAcAToHR727dCQl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcvR8qv8h3yfrKvL2ZOcpvu468KkR955yoeC3iXHnqE31uzJjQe1rxWVRKRXr6M+b
	 78SHjSFWOjryEm/4SqXx+G+7Qlux3iIetfC6hq04BCCTI3X5x6ZXOA7BT1eG4VKRmf
	 A/FM0WSkCvohDYN8Ay/dK/hYr64PXlA6/KLQKGy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0216/1756] wifi: ath11k: disable interrupts during firmware crash recovery
Date: Wed, 18 Nov 2026 15:39:03 +0100
Message-ID: <20261118150016.924885584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c6d17dbbdb376..bdadde90df9d2 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1998,6 +1998,16 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 
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
 	ath11k_spectral_deinit(ab);
 	ath11k_ce_cleanup_pipes(ab);
-- 
2.53.0



