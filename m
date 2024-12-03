Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B50153800;
	Tue,  3 Dec 2024 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241074; cv=none; b=RqFFVY3o7MpGP9naMzjBxpq83QIVNcfqmk0yBTNQNSTFL0GW+a/P/sItAm5KB+IL12OS/53JqpjYIRGT8Ts+j7mLNxeEPw8aJJYydQAeN437TYe8pA75V/KpNZ6h/LD/uEtP4ZHXX5c3FoTDG9s1p/3xX5JxOnZhkqx68Fqv6bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241074; c=relaxed/simple;
	bh=qHg71MVtoRM8C4sb2eGlt4iUniFP9Z3PG5KuDofF1QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCCiTRxz83BT6qGaXH2ovGc19nWTEQvB/wDH7gqvuwvAIbOoJI1gey8JxXElf/AXhknWPfykw57rtkiw2DO2qV1Ak1JFXwPPkAojHCabPz1bV2cZ59G37cR989maZRH3oQgjEQrW1a897RkBSJOBrfrz1HgO6ftZTROcE0w0avA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tK9LhAwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tK9LhAwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235A0C4CECF;
	Tue,  3 Dec 2024 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241074;
	bh=qHg71MVtoRM8C4sb2eGlt4iUniFP9Z3PG5KuDofF1QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tK9LhAwm3S/NSdXBdPQOc+xwXndxCR5Zdxiq2CnLTMuLUnni7E/cX2heXmMs251xn
	 L3RSuvUuesoIq5Se914kWSJWkfF5OtQq2L5JxBBF99h5ACZ3U+txEqW+IRWnnYT1BS
	 O3OTWOub7BGyn3Zbl+ViXIGS0JtIj+NVm/Hqqm7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/826] wifi: iwlwifi: allow fast resume on ax200
Date: Tue,  3 Dec 2024 15:40:45 +0100
Message-ID: <20241203144756.166767714@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit e53ebc72054efca12e0329d69342e3daf7250a5a ]

This feature can be used on ax200 as well. It'll avoid to restart the
firmware upon suspend / resume flow. Doing so also avoids releasing and
re-allocating all the device related memory which makes the memory's
subsystem task easier.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241028135215.514efe0ce4c7.I60061277526302a75cadbba10452e94c54763f13@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d1a54ec21b8e ("wifi: iwlwifi: mvm: tell iwlmei when we finished suspending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 80b9a115245fe..eee7a385d9467 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1377,7 +1377,7 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm, bool suspend)
 		iwl_mvm_rm_aux_sta(mvm);
 
 	if (suspend &&
-	    mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+	    mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_22000)
 		iwl_mvm_fast_suspend(mvm);
 	else
 		iwl_mvm_stop_device(mvm);
-- 
2.43.0



