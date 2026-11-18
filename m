Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060639;
	b=bYvC2tqgW4VWti2SoOyi8wHgvVPPFXr6fmi8Asybi9O7IoYngQ2hozVpjNBrOpJtFopH
	 1AK8bPNIx2HHEXQIoQ0M7ahSLTnn//4XmIOF5LlY1ccO6PYkIeWEhzvzacq0onlZE5JI4
	 KbyX9FEZvKb8c2L7bDQU7LgNGto/xrGN1AnKwD2IZD/m2CsFIQTn+0amd+YD/VBR/ndki
	 SnaDs3hPSdiDJ/Gm8BC707pvsm6oh1bQLeGi7/Ys8jPNwtPmIu25Dz/x91BVlcY6G+E1/
	 6rGctHNZpwUWfRGrkzSZwRoT61i+BsMW7bMLN7nQtGnkfqI5Sp3eYOQclfBlk3k3urw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xEDjxSQDBGj9PfEz5DgCh7SJXu6SjWIWztqs1nGtuQA=;
	b=gNUl4f7ELvKqxaTLFarOhhqCKat15RJEpWwntPo1iM+IT8wFRCHZdYGlEt+dcP6NBN+Y
	 u+wCgDNGlYZLJNC4e+1x8vcuuwrDi6BamZ/M6Poh2MYhfBN7PSBAXglVE3BNs+Wu7j5hn
	 5f7MSLwa/y11LjjqzdpwBV5JvTXSADtuW7KroTU/Kl1T91/2mcCfuG+j61nadouPenZx7
	 mNi6jp2x1ysH0uWdBEfJ6UQOAdDgZ5+fx9j4ZrVnT+ea4KOxAZ/cW0tKU87Vf2wTE8rik
	 cfI+iE9EW9b5hEVkyHz460DgBOV7nOrL+HaktAKd6B6407EmWscsWRpFvOoP4a1BVUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGCcYVUS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804E606A325;
	Thu, 19 Nov 2026 03:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGCcYVUS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32CF1F000C4;
	Thu, 19 Nov 2026 03:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060639;
	bh=xEDjxSQDBGj9PfEz5DgCh7SJXu6SjWIWztqs1nGtuQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGCcYVUSMGUEhGHo3PaJa0bQ5uUJyCu+kqmU/kzLPGG7+0tMBRJI4oDDjpvYQ9bZX
	 yzoojztMBfnM3vi7XRKzRcseoBBNHsz0TeWcnMN7+L8dwwOjfZCYuyTh8MSRYqFZUW
	 uM0I6sbXRvOTEbzrHGXZssr2cE99HGRrQl35VN2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1270/1848] drm/amd/pm: bound SCLK FCW range entries to the table size
Date: Wed, 18 Nov 2026 15:55:08 +0100
Message-ID: <20261118150012.822487904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0e9d33846114f..fe5764350af2d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -1379,6 +1379,9 @@ int atomctrl_get_smc_sclk_range_table(struct pp_hwmgr *hwmgr, struct pp_atom_ctr
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



