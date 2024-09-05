Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E023A1990BB;
	Thu,  5 Sep 2024 09:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529709; cv=none; b=rz4SE7iPvzTrsFWcukYBLC0qddYUR2mK4qaJJtDmyghf9fFgj99zLiQkCksNCKDkfcqkdO9w7qqlMnzpYy3VqstC+Ynj7O2ZK+e1Qf08cmiKrC4P6Wo31u5+1P34QEeRpx+5OZq9vTcJhqcHJ2Bc+pK34+jbvw7LGBfvYNgTcaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529709; c=relaxed/simple;
	bh=TLe+JWk71o+OXpHFxeLEj+nrhqU2hpbT/wIdkzMr3J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaK3awAJLmYj6jAsMj+fVeq1h9Y3SvCvMjpmtfZYccVY294qxMi/vVOFoLottq/xs24rGp63tOHW+xCvPxFgPBrwwjxSEBBpcxlf5bkv5H3uO/tKcbMt+9fLeFxi+fD8KeOCmOKb160jUp5ot5y2GEVXXuDI2tRj3FSk8s4YOIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeGK4HA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeGK4HA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA1EC4CEC3;
	Thu,  5 Sep 2024 09:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529708;
	bh=TLe+JWk71o+OXpHFxeLEj+nrhqU2hpbT/wIdkzMr3J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeGK4HA9Ud9rbvgGzSxtIXjKN2oonxk3pY9Jd7NdfHCajUDUrrq00KBRebZDEC/Fs
	 j9BX1bzUG8KL82EJJVNpybqhDft1sHkxN3w10NNjqW4FJAjbmBU1HpSkFdIR+qiWcX
	 XXpEXt8OKzm7vkE8/rwvLLkrGHaYAesB0kWXNRrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar S Matityahu <shahar.s.matityahu@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 118/184] wifi: iwlwifi: remove fw_running op
Date: Thu,  5 Sep 2024 11:40:31 +0200
Message-ID: <20240905093736.837608396@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit 37733bffda3285d18bd1d72c14b3a1cf39c56a5e ]

fw_running assumes that memory can be retrieved only after alive.
This assumption is no longer true as we support dump before alive.
To avoid invalid access to the NIC, check that STATUS_DEVICE_ENABLED
bit in trans status is set before dumping instead of the prior check.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.ca07138cedeb.I090e31d3eaeb4ba19f5f84aba997ccd36927e9ac@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 6 ------
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 751a125a1566..893b21fcaf87 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -230,8 +230,7 @@ static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
 		.data = { NULL, },
 	};
 
-	if (fwrt->ops && fwrt->ops->fw_running &&
-	    !fwrt->ops->fw_running(fwrt->ops_ctx))
+	if (!iwl_trans_fw_running(fwrt->trans))
 		return -EIO;
 
 	if (count < header_size + 1 || count > 1024 * 4)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 9122f9a1260a..d201440066ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -19,7 +19,6 @@
 struct iwl_fw_runtime_ops {
 	void (*dump_start)(void *ctx);
 	void (*dump_end)(void *ctx);
-	bool (*fw_running)(void *ctx);
 	int (*send_hcmd)(void *ctx, struct iwl_host_cmd *host_cmd);
 	bool (*d3_debug_enable)(void *ctx);
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 1380ae5155f3..498afbe4ee6b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -770,11 +770,6 @@ static void iwl_mvm_fwrt_dump_end(void *ctx)
 	mutex_unlock(&mvm->mutex);
 }
 
-static bool iwl_mvm_fwrt_fw_running(void *ctx)
-{
-	return iwl_mvm_firmware_running(ctx);
-}
-
 static int iwl_mvm_fwrt_send_hcmd(void *ctx, struct iwl_host_cmd *host_cmd)
 {
 	struct iwl_mvm *mvm = (struct iwl_mvm *)ctx;
@@ -795,7 +790,6 @@ static bool iwl_mvm_d3_debug_enable(void *ctx)
 static const struct iwl_fw_runtime_ops iwl_mvm_fwrt_ops = {
 	.dump_start = iwl_mvm_fwrt_dump_start,
 	.dump_end = iwl_mvm_fwrt_dump_end,
-	.fw_running = iwl_mvm_fwrt_fw_running,
 	.send_hcmd = iwl_mvm_fwrt_send_hcmd,
 	.d3_debug_enable = iwl_mvm_d3_debug_enable,
 };
-- 
2.43.0



