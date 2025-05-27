Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFDD280036;
	Tue, 27 May 2025 17:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367012; cv=none; b=t50KjCmVYfGuDUlngtwL9TY3iA7/ORW7e1D8pYmeimbq3QfsmXS4lfEhZA35sOyTtf+i4czvBEi6DY038YQHolWTgnlFZdCm9u7Bxr/llVfHn1Ku+YcEP3eqzjl1s7YP1B5MuO7oDb/HJB8ZsQ7WTK30LH84Q0ql8W616U0ttBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367012; c=relaxed/simple;
	bh=8F2rdVG5KrzV9X2Iw73gDpyWRmNW8HDtxz+UUYraaME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncPLvbhGIVHK6yxuMJu4queRkgC4hPiKiNKq0jgXQh6zE6sSGm3HM8njyrr52FqUI7kzRVWQwIJ24myL+v2/wl3oiBEVurBnZsQxqylTNeL0KTZnvnBZ9Lku+sY/PzD0SO6k7sPsevRM85vE8XEN9UUFbw8BoA/AjSrp1RIvUZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mmYXskM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mmYXskM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7726CC4CEE9;
	Tue, 27 May 2025 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367011;
	bh=8F2rdVG5KrzV9X2Iw73gDpyWRmNW8HDtxz+UUYraaME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mmYXskMHX0VpkRB4PON/5mqCwYcNrXhkyWyazkTTcuEzR5d6T//rKfEJpBKAcqH6
	 GuEp3l4y20RzKWStiz3T/XpfASVeBYOToPmauwiS+xUK3wgf924wDBKVn2Afc3a/ef
	 XUPal/mJi/zR0FmwrA3ckDwUeC2yFDKi07QDa8Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 219/783] wifi: iwlwifi: mark Br device not integrated
Date: Tue, 27 May 2025 18:20:16 +0200
Message-ID: <20250527162522.044511098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5f0ab2f35a43773a0dfe1297129a8dbff906b932 ]

This is a discrete device, don't mark it as integrated.
This also means we cannot set the LTR delay.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.9bb69393fcc9.I197129383e5441c8139cbb0e810ae0b71198a37c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
index ab7c0f8d54f42..d3542af0f625e 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
@@ -148,11 +148,9 @@ const struct iwl_cfg_trans_params iwl_br_trans_cfg = {
 	.mq_rx_supported = true,
 	.rf_id = true,
 	.gen2 = true,
-	.integrated = true,
 	.umac_prph_offset = 0x300000,
 	.xtal_latency = 12000,
 	.low_latency_xtal = true,
-	.ltr_delay = IWL_CFG_TRANS_LTR_DELAY_2500US,
 };
 
 const char iwl_br_name[] = "Intel(R) TBD Br device";
-- 
2.39.5



