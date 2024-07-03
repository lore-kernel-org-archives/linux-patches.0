Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8E11993A5;
	Wed,  3 Jul 2024 10:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003792; cv=none; b=DxnCJSU0257GWV4Sz+1hCjiUbM4YVIsB57LdYjz4ncO34PeQLTDQtlVmrhdwDzl+4ohmrBzocgL5AkWTo1uJddH2t9o5SBphUz+GF/Mq6tN3nTxlbiSgt5sxXBivseWdaBDp29rFp5n7F3/WmGufl9FixsHm4oVPfXqiG47q1jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003792; c=relaxed/simple;
	bh=f1zN087hzp5qzVVBITQmjuOaL/ZGytVMP3IfpQMV/6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rm/UiZghYIdxRRUCoo9iv9z0HyTnO8ktVxZbhVF5pnBSXFyw8zG3kfK+0NFNBVAo7dWHpSDjsAtSNAVwtzWCf1Dm0az0nfZV/sSz/2tBOX5L4ckYMY/Y2T+zTbp/vECn7pUnsR7m3btFBIasb746GBEb696/EAH1kemhUSvDzjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdmqMOs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdmqMOs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DFDC2BD10;
	Wed,  3 Jul 2024 10:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003792;
	bh=f1zN087hzp5qzVVBITQmjuOaL/ZGytVMP3IfpQMV/6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdmqMOs5QKPwGhKN7l4BPtg2VSpT7oDlEN32CkmwFRFAxfbSOnD1N0VtaRWxF/QEo
	 2/tYFBpr+jIPFKp9JtkHgOm7sVi1w/iVVTq1BtUNpd/k7dqVsrm9eLcwnNN6XlFMJR
	 OLoHMcK4iH0z53L++C+0FPryflYsG+bhAOqZ3o6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar S Matityahu <shahar.s.matityahu@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/189] wifi: iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef
Date: Wed,  3 Jul 2024 12:37:46 +0200
Message-ID: <20240703102841.703698477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit 87821b67dea87addbc4ab093ba752753b002176a ]

The driver should call iwl_dbg_tlv_free even if debugfs is not defined
since ini mode does not depend on debugfs ifdef.

Fixes: 68f6f492c4fa ("iwlwifi: trans: support loading ini TLVs from external file")
Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.c8e3723f55b0.I5e805732b0be31ee6b83c642ec652a34e974ff10@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 1848b957dc5cd..9e63230da1ec0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1669,8 +1669,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	debugfs_remove_recursive(drv->dbgfs_drv);
-	iwl_dbg_tlv_free(drv->trans);
 #endif
+	iwl_dbg_tlv_free(drv->trans);
 	kfree(drv);
 err:
 	return ERR_PTR(ret);
-- 
2.43.0



