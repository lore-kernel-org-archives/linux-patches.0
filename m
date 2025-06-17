Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0B52ECE9B;
	Tue, 17 Jun 2025 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175150; cv=none; b=fxWpwAg2HPFJix7J/D+cO9xFaz0t2veR7TtiSCEK5G3fcnOV0BObVwqE2KJj1FB2/zAA/BWOLYSPvVkLEgPyfdK7VwK9Rwuj1T16UU0Bm83cS3qYZ5wKF3Feg0ydRMKKHsalnZaVvRyU+kjtuhV7vRom8eoDKDGCRbp4/WTElAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175150; c=relaxed/simple;
	bh=e68KYG0+V+1se5p02veN5NVKWn8heqddHi5+4mupPiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYbsoEgqsAOD62JJThGhBiYrX0evaLpfqASch4Ub/3MiHxc+tjwGaO+zDHTl3azgA9iyab/IFu2rdzhPsZ1TnBchWE19JCH+YZot51ie7R/xZQgEjQ4lZpLsVAEB7fEFPz+HvkOHH4NcF+G7vbP8shPIrUUnDNbAoWzjp4ZVjXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6Vbg2wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6Vbg2wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94258C4CEE3;
	Tue, 17 Jun 2025 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175149;
	bh=e68KYG0+V+1se5p02veN5NVKWn8heqddHi5+4mupPiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6Vbg2woLlG75tGv58f8kIyhI+JFw7xo4Fy+cTP7n9AE5rmR57QrwAPWQB3HsX5AT
	 ToT/NwufGT+ghQElhDuwQnJT0teUWI6jetxnOzD1UqMMHg2mdtyOznf0Mi84znQ6eO
	 yQ5qCqQ+54obJ/ECaYKBOMulvyC7EEKJs0NcMj18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Massot <julien.massot@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 057/780] ASoC: mediatek: mt8195: Set ETDM1/2 IN/OUT to COMP_DUMMY()
Date: Tue, 17 Jun 2025 17:16:05 +0200
Message-ID: <20250617152453.825091097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Massot <julien.massot@collabora.com>

[ Upstream commit 7af317f7faaab09d5a78f24605057d11f5955115 ]

ETDM2_IN_BE and ETDM1_OUT_BE are defined as COMP_EMPTY(),
in the case the codec dai_name will be null.

Avoid a crash if the device tree is not assigning a codec
to these links.

[    1.179936] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[    1.181065] Mem abort info:
[    1.181420]   ESR = 0x0000000096000004
[    1.181892]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.182576]   SET = 0, FnV = 0
[    1.182964]   EA = 0, S1PTW = 0
[    1.183367]   FSC = 0x04: level 0 translation fault
[    1.183983] Data abort info:
[    1.184406]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    1.185097]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    1.185766]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    1.186439] [0000000000000000] user address but active_mm is swapper
[    1.187239] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    1.188029] Modules linked in:
[    1.188420] CPU: 7 UID: 0 PID: 70 Comm: kworker/u32:1 Not tainted 6.14.0-rc4-next-20250226+ #85
[    1.189515] Hardware name: Radxa NIO 12L (DT)
[    1.190065] Workqueue: events_unbound deferred_probe_work_func
[    1.190808] pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    1.191683] pc : __pi_strcmp+0x24/0x140
[    1.192170] lr : mt8195_mt6359_soc_card_probe+0x224/0x7b0
[    1.192854] sp : ffff800083473970
[    1.193271] x29: ffff800083473a10 x28: 0000000000001008 x27: 0000000000000002
[    1.194168] x26: ffff800082408960 x25: ffff800082417db0 x24: ffff800082417d88
[    1.195065] x23: 000000000000001e x22: ffff800082dbf480 x21: ffff800082dc07b8
[    1.195961] x20: 0000000000000000 x19: 0000000000000013 x18: 00000000ffffffff
[    1.196858] x17: 000000040044ffff x16: 005000f2b5503510 x15: 0000000000000006
[    1.197755] x14: ffff800082407af0 x13: 6e6f69737265766e x12: 692d6b636f6c6374
[    1.198651] x11: 0000000000000002 x10: ffff80008240b920 x9 : 0000000000000018
[    1.199547] x8 : 0101010101010101 x7 : 0000000000000000 x6 : 0000000000000000
[    1.200443] x5 : 0000000000000000 x4 : 8080808080000000 x3 : 303933383978616d
[    1.201339] x2 : 0000000000000000 x1 : ffff80008240b920 x0 : 0000000000000000
[    1.202236] Call trace:
[    1.202545]  __pi_strcmp+0x24/0x140 (P)
[    1.203029]  mtk_soundcard_common_probe+0x3bc/0x5b8
[    1.203644]  platform_probe+0x70/0xe8
[    1.204106]  really_probe+0xc8/0x3a0
[    1.204556]  __driver_probe_device+0x84/0x160
[    1.205104]  driver_probe_device+0x44/0x130
[    1.205630]  __device_attach_driver+0xc4/0x170
[    1.206189]  bus_for_each_drv+0x8c/0xf8
[    1.206672]  __device_attach+0xa8/0x1c8
[    1.207155]  device_initial_probe+0x1c/0x30
[    1.207681]  bus_probe_device+0xb0/0xc0
[    1.208165]  deferred_probe_work_func+0xa4/0x100
[    1.208747]  process_one_work+0x158/0x3e0
[    1.209254]  worker_thread+0x2c4/0x3e8
[    1.209727]  kthread+0x134/0x1f0
[    1.210136]  ret_from_fork+0x10/0x20
[    1.210589] Code: 54000401 b50002c6 d503201f f86a6803 (f8408402)
[    1.211355] ---[ end trace 0000000000000000 ]---

Signed-off-by: Julien Massot <julien.massot@collabora.com>
Fixes: e70b8dd26711 ("ASoC: mediatek: mt8195: Remove afe-dai component and rework codec link")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20250417-mt8395-audio-sof-v1-2-30587426e5dd@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-mt6359.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359.c b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
index df29a9fa5aee5..1fa664b56f30f 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -822,12 +822,12 @@ SND_SOC_DAILINK_DEFS(ETDM1_IN_BE,
 
 SND_SOC_DAILINK_DEFS(ETDM2_IN_BE,
 		     DAILINK_COMP_ARRAY(COMP_CPU("ETDM2_IN")),
-		     DAILINK_COMP_ARRAY(COMP_EMPTY()),
+		     DAILINK_COMP_ARRAY(COMP_DUMMY()),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(ETDM1_OUT_BE,
 		     DAILINK_COMP_ARRAY(COMP_CPU("ETDM1_OUT")),
-		     DAILINK_COMP_ARRAY(COMP_EMPTY()),
+		     DAILINK_COMP_ARRAY(COMP_DUMMY()),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(ETDM2_OUT_BE,
-- 
2.39.5



