Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016480;
	b=j5/jfJhkPH0qP0x03/dHNLfzC07RoGj/JXE912LaQ+tlg3Fz9ONdu2XyNTpxSYwHYsdq
	 6F0LfRrm/tMUpn+5gRb2B4XAo9/tXYpym9Nxbf+zsP7VlI7adgQ55hzLtZSyAG2qKFcC0
	 nl7TebptT6uDTSM4nm0j7n/eZR3sSix7yXQSKZZ+ztGs/TYHhBY3KheipD9vxRyPFMORo
	 yyq5XhZuV8c1r6Hae6uss/cRlfzLBLMmLOyZgWdWRgvR7nTOTfFTjEkd02ORYj2fbb43i
	 4W5pnNgk+5LYzPRWc1rZppqxcpKzZQsOY+djQnoDYG2IU631VBbTkkRhz5Md7Nb6WKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2NpFnIkuRYTxdM6h3XoPsGMiq67NHSDFXHWdI7KPhXs=;
	b=bHDEMZ4PDutEc38ZThx7PHV+1ASZxJ85UiXqD2L148OrULagLXQmVqbf4I4+DjHKjAnA
	 3HyQef9GS9224cyyrbaEjE59o4zui+mCYfa2tqJ00GwcRg5uqtgzce0b7vjkaYpAp6T7V
	 ZXC9uGe9jwVJgu06qLNgxC2U3Y1bRSh1N5OMYBBqGMycFTII8IInT+Z2xytTL/6y67fvC
	 lcToKvxraTrdEex87j6Vu4PVSxzZn0qqm3m0v4DBIj+UCmfjT5INwLE11W1pS8ZvVT4A/
	 YDHpcNSyF6v4cbS5qbjb7fJLHkAxmeIlS4sw2zgibCp6xtaeej+WTuv3vdcj7ZhMM/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvcKWrAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653A5606A31C;
	Wed, 18 Nov 2026 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvcKWrAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B371F000C6;
	Wed, 18 Nov 2026 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016480;
	bh=2NpFnIkuRYTxdM6h3XoPsGMiq67NHSDFXHWdI7KPhXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvcKWrAcx72w6vrISbc88sZ3mTcWtxgO56tXUB3dGAab7fDZ2mO8g57k2g4cuUzmO
	 aWRfu1f5YfzCHL3GWzVqkhPQJoK0gseh2wnJRtLEUDrLyo/R49obrlWj7qmC5BM3Oo
	 auL3A47Bww647sjfp/ul+Megstyfo1q0zDPolsSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0543/2651] drm/amd/pm: bound SCLK FCW range entries to the table size
Date: Wed, 18 Nov 2026 15:29:43 +0100
Message-ID: <20261118150307.299361044@linuxfoundation.org>
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
index 4b796d60b03d4..3217ad3c1d17e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -1025,6 +1025,9 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
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



