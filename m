Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E452A3BE643;
	Sat, 12 Sep 2026 12:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215805; cv=none; b=FFOO4ULnue8fX+vbxx9J+bxDW0syftKWcWq524z9qq5AKnjGeoHsQxsnjrR9SzJk7YgKb5enGt3+NPQ3aXqVG6t5RlK6PdPnNNsd4roxws4EU8DakETSHMve+MbHrhONYvUDEbNkpuRYuSNPsfhqtlDzZiA6fKUdcUo95R2GqPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215805; c=relaxed/simple;
	bh=VpMVsm8uIVtSMLPjhU9OLye3SSRlnYSd39SSiaCGI6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9QZpu3sMlKo3y89c7EkBO50Ov5uSdcKoQ6npR32NSvt/TfByUROuxYqG9fDXWJlKBT1KQvNN+aZZXmcPXkKQ1IzNom9ReN0sr9HensohQyTe9QBIk79jIpovquAYcMUE0Wj84KhCrBW66Jp7Pjflr6TkcsK2tqiYErdtvGPH1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0hERjDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0hERjDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD8C1F000FF;
	Sat, 12 Sep 2026 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215803;
	bh=NvRXsKkbIPmKXnu01DTdPjHXjrtbcFcRNHqiLcBBSAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0hERjDPbpOXTnTpQAJ5C/gZnmgxduo6U0qy7EeaUqfxzWk86jIuFxLu4RlxcL5N4
	 9cV8poRE77kW8hpw6pu1dJatHwhp/CpJs0PqpA3v7S6hCcxWt0Wav8/t1A8zl/dj0w
	 0BHD7ehFdJ0SqxrXD3P5/6XvMJ7V8MrJykgZE1S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0564/1376] wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
Date: Sat, 12 Sep 2026 08:49:50 +0200
Message-ID: <20260912065620.103619363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit 71e67b4b59337b2f9f4fef976a27de2dad7aabf2 ]

The loop counter 'count' was declared as u8 while num_pc is u32.
If firmware advertises more than 255 PC entries the counter wraps
back to zero and the loop never terminates potentially causing an
infinite loop or reading past the allocated pc_data array.

Change the declaration to u32 to match num_pc.

Fixes: 2b69d242e29b ("wifi: iwlwifi: fw: print PC register value instead of address")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.a61c65f34e87.Ie5f1a7ca43e0cc5a0ddc8305b0448ddffc09cd18@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index 8f107ceec4076..0aa53212a9933 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -488,7 +488,7 @@ static void iwl_fwrt_dump_fseq_regs(struct iwl_fw_runtime *fwrt)
 void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_pc_data *pc_data;
-	u8 count;
+	u32 count;
 
 	if (!test_bit(STATUS_DEVICE_ENABLED, &fwrt->trans->status)) {
 		IWL_ERR(fwrt,
-- 
2.53.0



