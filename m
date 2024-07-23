Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EA81586F5;
	Tue, 23 Jul 2024 18:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759847; cv=none; b=P6ky9qPgAwcg82Bs6nJYZXVp/29y+wwBe/WgDWPSCOyNK2b710g8brAVVP1Febg136ozZg8BMDFcZiqxy+cN2Fyu0JROJ7agdZAB/MpQqn85w9l/6HkTYp+5Pz5p4Shmzxbb2I8qxRJ61tKxjK7MO8Im7UzvonbOWDoWwXRJm10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759847; c=relaxed/simple;
	bh=ahB+xeVfP+RURfagj7g4zEg1XIshfC6MkbzIPWYZQTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1VZD+wABdRxCXIozdlN+1JfexJx9qPKuEv3HGSGT1kYBLKOjLpgoCVLgW9aZoTFQKUE+UwIgaHyWIiDu4BnTDveOrG6gUwNZdq3npNsQkFsLisG+3Qz9LK7gNS+trF/iEwU+jKL8/jRSUU8xdtpNB0M3Azoh6dIySrVk/shPzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8/QP3u4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8/QP3u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ADDC4AF0B;
	Tue, 23 Jul 2024 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759846;
	bh=ahB+xeVfP+RURfagj7g4zEg1XIshfC6MkbzIPWYZQTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8/QP3u40QSuEi9EuBd/0/93mZhsSPwQsxV4+Ecw+Q2MHNYGqIVc6O9uwHahp5Oqs
	 8sykwMkDSDFid07NV+pEqfimvvxWgdMBhV27/LFoGf3F6Z4G6RyA0LAcbrbhq2tpm5
	 EyGVHGATAMwkr64y7KSB86WVOmrDmC5bv8QW/mCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 018/163] wifi: iwlwifi: mvm: d3: fix WoWLAN command version lookup
Date: Tue, 23 Jul 2024 20:22:27 +0200
Message-ID: <20240723180144.174477673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yedidya Benshimol <yedidya.ben.shimol@intel.com>

[ Upstream commit b7ffca99313d856f7d1cc89038d9061b128e8e97 ]

After moving from commands to notificaitons in the d3 resume flow,
removing the WOWLAN_GET_STATUSES and REPLY_OFFLOADS_QUERY_CMD causes
the return of the default value when looking up their version.
Returning zero here results in the driver sending the not supported
NON_QOS_TX_COUNTER_CMD.

Signed-off-by: Yedidya Benshimol <yedidya.ben.shimol@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.8cabfd580614.If3a0db9851f56041f8f5360959354abd5379224a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 52518a47554e7..74743c3ceeefb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2182,7 +2182,8 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 
 out:
 	if (iwl_fw_lookup_notif_ver(mvm->fw, LONG_GROUP,
-				    WOWLAN_GET_STATUSES, 0) < 10) {
+				    WOWLAN_GET_STATUSES,
+				    IWL_FW_CMD_VER_UNKNOWN) < 10) {
 		mvmvif->seqno_valid = true;
 		/* +0x10 because the set API expects next-to-use, not last-used */
 		mvmvif->seqno = status->non_qos_seq_ctr + 0x10;
-- 
2.43.0



