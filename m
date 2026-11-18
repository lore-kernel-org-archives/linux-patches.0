Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048339;
	b=VLe+7B8Pk2WzbWNwanNc8DWQhNxIzFbu2eLWnGaarMvT/zDuRJcMd68DgIMj1e3yEZrl
	 DN8WTUZzzI4epw3JpiArV7AfyyF7F1H/VOzaB8mYVCqV1LxSJ2J3GfbeejcwixNypUXfy
	 gWgDpxUisFmzG0bN7j2ZaeYaNj0z63GraW1MTl0Dk+Osvk3RMG/CorYx9KeTfvTa6K0Cl
	 v1NLDI9sw7o04EcOi9C/UHHOh0U2JKoC1hCnwUQqqaJsCU2hGTnXtdQ9St8UEWB3ovecL
	 W1s66wccRbv/DEbEcbiR26rqC6NRfWSjIplQbYYTCO8eoNSt0PD28ya3tzq4VyzaZng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IOneQDmEIukUZ8XK90txZUenfmSY1GAMblomVUqyQik=;
	b=HZ323MLY1pPbWv+MafcSh7vGG/NFEmJGpSU4cX7dSvU7CINRUOr0IOM+k/dNPb+BRYiK
	 m7uai2JVPuQXwnEPe2arcVkjdzo5I6nWDyvxyAWf6BkRvsHtQKRCRrjdrS/SyOjt+38oq
	 d4uki9p9OZ4MPif1M1sTuOZU+11SgtSQr9pnxmSymjOoOYCEltEJty4PemOK3SXNy3RZo
	 4cqQYhp/RvfuIgidiqqpzKweomBXSMTA07QvFzUvBLcXJiDY6dlkg/iCVI6QY/LnFspdk
	 ihUCjcOWJTpgfqkUHXdjFl6/GfhcU/Hzie8oSeFa7mh4YbJwjpFjroEYnLbanSGtL8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5S3xag7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5BC606A31C;
	Thu, 19 Nov 2026 00:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5S3xag7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08B91F000C4;
	Thu, 19 Nov 2026 00:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048339;
	bh=IOneQDmEIukUZ8XK90txZUenfmSY1GAMblomVUqyQik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5S3xag7R21k1srgESzv+ijHq1cPjCN/IKZvcLlg71uhwEtEWBOE++kdVpMFgP40t
	 9VvTqEHjWgPb4MmgNvF4/FNgYplNaDwtmwp42C26yI5SliM6xWVDb85Ooltl2TNKXa
	 +2lzowpBDfheSxAucmAAA3zJNWMXkDqCjPKfE8AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1960/2857] drm/amd/pm: bound SCLK FCW range entries to the table size
Date: Wed, 18 Nov 2026 15:49:54 +0100
Message-ID: <20261118150311.978364804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



