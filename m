Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029698;
	b=XUPNJxSke9xZGzTdSHKTCeRw6njdUkHVFMPMXziMlMsS1MqnBj6Fs4xORONZFXE40Xil
	 PDcos5+FHuGCsqapZnIQ8N0DZ+RA2zXgcNzwgZP5+FFr8TG9WmNAF0xvTehkooT1jaEdO
	 UTp2+pv7cg4YqbOmX3y5kR81WAly6B6lTiWHDFGE+G/YzeUv+LF86pRWM8kYsiIGfFM1o
	 aLbc7shF5NnZU7drMvRGGDQdTjLxAiQehYw6dRToPfMvld0rqJGs8A7KtShlcTu+BjHGf
	 +O5/XQRsoOHMG3bf4T7vAq92OJ8qh6yPvEVvgK9ocSBvxmoQKL29oThxpf8KPkSRJUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzjo4wgM8UoqiDZaVVASULe+fmlJDyP3cuoAK61vGcw=;
	b=YBB1Gfk64qMCmZMeBcqP+tl95xwcBTtdLJCxc4++tkIjzPA4Umq+IBdJoPfeozETc4ve
	 42vekFG3QMSMluf96/AVzrdSb46buFagwzpnw2rUpwUuJ9pjibuoysR1LivUgzvYnLeD7
	 LNneXjxKVfQopEwuDJ9Ok8bLgiKtCYXoaD8IdgpijGIzRGHehgcp9yUtqbZ/EKQ79Zvtv
	 yXkBrznPiqLcBBchsqgy6ekvYitCTdptzyZ70kI2Me3RF1Lakf1ZuA8FBqhWiPyIqCh+v
	 +YffRl21xLy0OhQSlHqLqPU1JVqfilK6RxOZZsZA+146LST7SErnEa+yHPc9SSObb9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPGoP+lN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF32D606A31C;
	Wed, 18 Nov 2026 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPGoP+lN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1061E1F000C5;
	Wed, 18 Nov 2026 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029698;
	bh=zzjo4wgM8UoqiDZaVVASULe+fmlJDyP3cuoAK61vGcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPGoP+lNfDzFVfojZuuHPosuzgY+UBQNZ0dbASW3jptNr/+BxMewKGPwzoysOXggw
	 ojtP+h29XrZes5aLKWDnFYNnArVrWD4ANE03B+f6PnjkXlyx96ESOLhz9j/H/g9Bpp
	 wSmmCn0lqeefrtzFavJc2rp0v3kijLMrDhR/CA0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0442/1756] drm/amd/pm: bound SCLK FCW range entries to the table size
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118150026.332129546@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit f35aa5c77f5fca20fc269d6221df19c7b96704a5 ]

atomctrl_get_smc_sclk_range_table() copies ucSclkEntryNum entries from
the VBIOS SMU_Info table into pp_atom_ctrl_sclk_range_table. Both the
source (asSclkFcwRangeEntry[]) and destination (table->entry[]) arrays
are fixed at MAX_SCLK_RANGE (8) entries, but ucSclkEntryNum is an
unchecked u8 read straight from the VBIOS, so it can be up to 255. The
destination is stack-allocated in both callers
(polaris10_get_sclk_range_table(), vegam_get_sclk_range_table()), so a
count above 8 overflows a stack buffer, not just a heap read.

Reject counts above MAX_SCLK_RANGE rather than clamping to it. Only
one version of this VBIOS struct (ATOM_SMU_INFO_V2_1) has ever
existed, so a count above 8 corresponds to no legitimate table format
and means either a corrupted or a tampered VBIOS.

Fixes: a23eefa2f461 ("drm/amd/powerplay: enable dpm for baffin.")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 6a85a3111facf..d992b1aff5c67 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -1453,6 +1453,9 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
 	if (!psmu_info)
 		return -EINVAL;
 
+	if (psmu_info->ucSclkEntryNum > MAX_SCLK_RANGE)
+		return -EINVAL;
+
 	for (i = 0; i < psmu_info->ucSclkEntryNum; i++) {
 		table->entry[i].ucVco_setting = psmu_info->asSclkFcwRangeEntry[i].ucVco_setting;
 		table->entry[i].ucPostdiv = psmu_info->asSclkFcwRangeEntry[i].ucPostdiv;
-- 
2.53.0



