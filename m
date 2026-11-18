Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055130;
	b=4fC+dsLNpNhG2ujSMzdS8oB0L5hX0gK7OHVhVmDGMsngkZ4elfwGGZ8QhC2YbdFA8UvY
	 XNBYOF6NSfR6eb240pmjWWiI1goYYMTDxf2t46D2gDO2AShwBuJIGsGY/bRjg/rCKBDWq
	 T4JpkEYOrIo18kNoGi+ojA/CWCtMR3FwCxp1EAehI2BUqkO3bWW0fTN2/3bbu/4lkCZ47
	 DEDv4UxuIwW+PD9QvbJSf2okW+JK9oytOQVkQaa/TS1vIg6xw2oNDoOKKDGZvEXkmrv3I
	 cWimezGoSbZHUma6oDRcr9HZtxArAKAiyoO8R7A+fzApcwZkAoZwjai1po4Flkr4q5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zp4cRPwaVTODTYHPDr/5WytBJ18UYAjNG9Ww93VlNT4=;
	b=DNCzUwqRtPMTm2KbAwFPSfiF6+VIZjiE0SHjLzOrWAfy4zC5wUIxz88kp/Z8Z+6Lb3D7
	 PNfoHob0XMBETSuSjjd/MiXVfkGFONqMGpxf0XLx6Pzq4Ndpoje4rFQOo/76AugWJ2aTv
	 RoOgbAuBZj9/ggp9OFzytC6bdU4se89Cc9Hvlo3NvWp0toQMp54tBhmcc5Rwcxmhh3Ore
	 vyWJ93Na92YI+9soHOwI/TpEQMP1yhDJTvY3ftOCnSVVzMH1STXfDHpQncpyzVJKt1LRh
	 pjL+qQzYBPjYpC1W6lHdLsDg+fBH6zzr4MI29S7aygGiiKZpbV15ry68NqpWlN3pZjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5sGppBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D23D606A31C;
	Thu, 19 Nov 2026 02:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5sGppBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD021F000C4;
	Thu, 19 Nov 2026 02:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055130;
	bh=zp4cRPwaVTODTYHPDr/5WytBJ18UYAjNG9Ww93VlNT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5sGppBFZw3PJBpQuw7V28kZA/L8TV0g32r8yf2vrWH0O93OYE3xp8TyFQa5RHWP7
	 Shas9ce7d7uDEWhINMwGhDlSoDIyRjqvCsB0UUL2D//JsbbWBAQsvEasWU2PO7pVVu
	 wxzpmgPzizaf0iYh4aDRUvQQtk2uQI/AwPqWY+8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1522/2214] drm/amd/pm: bound SCLK FCW range entries to the table size
Date: Wed, 18 Nov 2026 15:53:18 +0100
Message-ID: <20261118150113.030545324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e981cc3d2f1a5..23a520f402b9d 100644
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



