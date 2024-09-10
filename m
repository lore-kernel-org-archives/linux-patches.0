Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CB5190496;
	Tue, 10 Sep 2024 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963380; cv=none; b=AxUvc66ZpOXJB3BlfTH8YHBcosNQQvRQou5U8/WogLOetx6NeTIhT5NoxEvuazBrwIh2BvnCI/uPrdhQ30l44/3Q5m8BfbZmiIaoDOUKS0hosuu2DLPDnC3Eqh448DiJGYKrMgb+5MDQWSrF6NtHmKdCZMN3kwx1RmJksFU4ObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963380; c=relaxed/simple;
	bh=KyllZ4P6qUSM9MFlr+qyGEl9ITI4Xc6l+9Rvu9arFFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gj1kVQIIklR8dFpjIGjUinmJ/ShA+/gkhAPx1d9davm0vGJkvzO+DU1wXGXVHOCLDlcMSVtP6dux77x9r3XfzX25fz98jGlRlFq2qVuYN00GnxnPNq4UOfl5Bmh/5RrfEOAtklDpQicmIoDH0kPXYIm40Kpi84IBZyl/yWHbpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjfjWoju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjfjWoju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E834C4CEC3;
	Tue, 10 Sep 2024 10:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963380;
	bh=KyllZ4P6qUSM9MFlr+qyGEl9ITI4Xc6l+9Rvu9arFFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjfjWojuZszMkNxmeoaylnZW+Oz7dOdBGvrfCP85bcuvEF0n5pV8lT1XDE9fOSpSm
	 cp8CaA0VVFhlCl+5YS9JbwqvuA5/UFdFGHRMhKNlWQpel6paVU1Qmx8hlsegizVCGH
	 irxPJScY09riqjQ+UaHjnX/oiLm+AYC3RT7pEgE4=
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
Subject: [PATCH 5.15 038/214] wifi: iwlwifi: remove fw_running op
Date: Tue, 10 Sep 2024 11:31:00 +0200
Message-ID: <20240910092600.326587627@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6419fbfec5ac..6da3934b8e9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -252,8 +252,7 @@ static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
 		.data = { NULL, },
 	};
 
-	if (fwrt->ops && fwrt->ops->fw_running &&
-	    !fwrt->ops->fw_running(fwrt->ops_ctx))
+	if (!iwl_trans_fw_running(fwrt->trans))
 		return -EIO;
 
 	if (count < header_size + 1 || count > 1024 * 4)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 35af85a5430b..297ff92de928 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -18,7 +18,6 @@
 struct iwl_fw_runtime_ops {
 	int (*dump_start)(void *ctx);
 	void (*dump_end)(void *ctx);
-	bool (*fw_running)(void *ctx);
 	int (*send_hcmd)(void *ctx, struct iwl_host_cmd *host_cmd);
 	bool (*d3_debug_enable)(void *ctx);
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 01f65c9789e7..0b0022dabc7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -653,11 +653,6 @@ static void iwl_mvm_fwrt_dump_end(void *ctx)
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
@@ -678,7 +673,6 @@ static bool iwl_mvm_d3_debug_enable(void *ctx)
 static const struct iwl_fw_runtime_ops iwl_mvm_fwrt_ops = {
 	.dump_start = iwl_mvm_fwrt_dump_start,
 	.dump_end = iwl_mvm_fwrt_dump_end,
-	.fw_running = iwl_mvm_fwrt_fw_running,
 	.send_hcmd = iwl_mvm_fwrt_send_hcmd,
 	.d3_debug_enable = iwl_mvm_d3_debug_enable,
 };
-- 
2.43.0



