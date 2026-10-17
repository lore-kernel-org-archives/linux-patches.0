Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6538654F;
	Sat, 17 Oct 2026 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253867; cv=none; b=PxOH5rzizQgcsFRJc5LrsagEYvomt6qnwmqmznO2HY4MzVIQeVVX3WWRJKrm1/td4+ShNcU5nZw/KBq4Li3RyOLDDyGx5R24nJZdAs34uTespZ1bqO2ccGihnUlqJ7+iFVwIvZzwbLBzkHYbstIhosC55aNKFpgG6cbvU9ux53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253867; c=relaxed/simple;
	bh=mzzwwgIegW6NkNtM+/OEot/tdXOlNzRh9kxXY6uLr+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFCcdoE+p2b2D5TpbQSoKqhKGiandqDqdyuxus/2mjsP+4k6/hzOqtXc+ve39W827/9+0+KYJ+fJs8P8lh+b9BjWtbe+UBvJrkpiuVsjbTqQufO5jsA6eZhUWJldIlzemxHuB+FVVlXOcmq/sONgcqeTKOO/nukn4H/L6LbaNTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfLKd/nA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfLKd/nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483CF1F000C5;
	Sat, 17 Oct 2026 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253866;
	bh=v5evMiye35Kd+7uuvG3XOaPDrMj53x4l8uVqBB5mpKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfLKd/nA5bp0ZwWYUSTX6S0BVFtLZp46osByJWiIQFa5wvTWQ/NlQ+wC2Odo1udSr
	 yxoIrP5R2eRxnGTqBNX+En1Gaqdd6yyETuY8kRT2y/HgwXJzTz86t9th+u7MXNP1mk
	 +T8QvO61b83FVy7zH4tp8aCZo5IytWsN+HMsDQ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/869] wifi: iwlwifi: mvm: dont send a 6E related command when not supported
Date: Sat, 17 Oct 2026 17:51:41 +0200
Message-ID: <20261017160043.726961893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 323156c3541e23da7e582008a7ac30cd51b60acd ]

MCC_ALLOWED_AP_TYPE_CMD is related to 6E support. Do not send it if the
device doesn't support 6E.
Apparently, the firmware is mistakenly advertising support for this
command even on AX201 which does not support 6E and then the firmware
crashes.

Fixes: 0d2fc8821a7d ("wifi: iwlwifi: nvm: parse the VLP/AFC bit from regulatory")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220804
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260324113316.e171f0163f2a.I0c444d1f82d1773054e7ffc391ad49697d58f44e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4bad012472e1e..968cb35d6408c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -490,7 +490,8 @@ static void iwl_mvm_uats_init(struct iwl_mvm *mvm)
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
 
-	if (mvm->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
+	if (mvm->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210 ||
+	    !mvm->trans->cfg->uhb_supported) {
 		IWL_DEBUG_RADIO(mvm, "UATS feature is not supported\n");
 		return;
 	}
-- 
2.53.0



