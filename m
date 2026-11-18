Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023788;
	b=r/5bTV4d+aWkv+qZwwn3c3LK5tq50gxNzd+oWAdYeBzf7tiDj9sObbFYJGp4WaN95l2i
	 PSWdZt4Z9RAxe6mDKqKqa9W8NwK0fuDf31Gx9TKzADthslpTwrzUy49W6JaThUrTWxqsP
	 PaRj+1cEMUw9lrxxYbjGiU7lg7f9eG3XMu9ZoeiWVlin6OfjB647s6amihPG1tjE6iN8X
	 PMs1oBtSyYI6iqrPci6WngPc3dNXjJQF9D2aJavuxer/nv3LrpXGE5qotr4PgrWwU1Mbn
	 W8QDDQKECLVL0cJwQxcnn6zDMPu/q/V9yxGMTwJCoTLDgiAjU5aHY8by0NznSEZeJmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xgpslsJGhgurSEMFvAH6XrOeGH8NWOutmvupDHORlAM=;
	b=Tbb3Y1oW2CHYGA2qVnPknrJ6EBNYPM13N8hXNGPJkhURD2SnOI61e0QHclkAPE9I6MPQ
	 /sztcfFh9fR2SUCHUasMzX1k98497NY3U+mhHQxEBdeXr1bAHXSISNbNRrtLZRJr8tPgC
	 C3JxMHMdyA4d9a3tKViff2o46dX6mYBKLa+kA08IyXhStw0LUoIbYXLpSVelwkSPkDoEu
	 MCSIHaLxMDuWycSK0Pa32YIxVVzuefTiIzwV4j4dMRkmHeV7ZSetPTDpB2pMBx+NdagWQ
	 Q5yjf63xjAe66OlNewvtXw3Rb7a9vNTUvboWOeYo7/azBDm5WIQ6UC4wVNGFkHHSVAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rueQMaPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A78606A320;
	Wed, 18 Nov 2026 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rueQMaPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F51F000C5;
	Wed, 18 Nov 2026 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023787;
	bh=xgpslsJGhgurSEMFvAH6XrOeGH8NWOutmvupDHORlAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rueQMaPoP+arz7qvXr6QeqlaT10d3BnfNLsiUfMpTjK/trudGK5O5EWtzP/PR+NQ/
	 1l06tM5fbRN+71APxbuQjaNRipgb7pUmTy1vjjW3/8J30tEHf7uxEmgSDqAzunbGM/
	 xskzZd/6PZ1b2ZMaJDB/9QRuYEUU5XorjhDigYqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0494/2151] drm/amd/pm: bound SCLK FCW range entries to the table size
Date: Wed, 18 Nov 2026 15:37:09 +0100
Message-ID: <20261118150140.050511005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



