Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26927E7CF;
	Tue, 27 May 2025 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364851; cv=none; b=ufsliOP66TSIZ95lPc3GrMMIo1FB1Eq3s1NQGCJ9El8voRkbWAWzzQ8rKz681hXw05Yz7t5s3+fEj/lxpqiQCrUDZ/+QIUnYjiIq220Rr+MocEuAGymLmJVL5h3CBFTwz6SvvYdUEQAXdyo8WqYzaWfg/c7/xBxyB59FNknjyP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364851; c=relaxed/simple;
	bh=jN592LgemYMHzZgO2XgOWkDsrYSLs7NESJMqHvQLy7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruMJBkxG5aFYc71550g/Cn6uERJ/GHl3epHLkSbIVDtdNXqrxxTJvFukp8hv+6Mjlk43bgWBUZcwqunkdP4smZoMLLK9WrVQCz7XyJNkj7/kySSE7vVK5Y0TWhF4ggXlqFstMoOlIXXm1U9EMiFHPqaAqnwjcRqD451F9lgyjNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpBm9/mF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpBm9/mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BF6C4CEE9;
	Tue, 27 May 2025 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364851;
	bh=jN592LgemYMHzZgO2XgOWkDsrYSLs7NESJMqHvQLy7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpBm9/mFaV9hGuwYxLrI3RgfWKZ7kuu1uUESfZdV4lkAbOHVVDqTABuhnFn8KMUVU
	 aHzB9XQu6XMMVd236seQz+xJjWPc8NDMzFf0E2/gOKUtzCl1DPMjSn5oMwaaV2C855
	 NEghPVm+FE9EvcxXphBqbjBE8sbTPAdrIjA6Srxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/626] wifi: iwlwifi: mark Br device not integrated
Date: Tue, 27 May 2025 18:21:20 +0200
Message-ID: <20250527162452.610517181@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



