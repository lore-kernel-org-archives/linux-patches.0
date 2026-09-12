Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C16534252D;
	Sat, 12 Sep 2026 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198844; cv=none; b=EJSYrGwxzy7rlGZMSVMxmBmfQiRk0fmza91WiVlZWZNWRxF92RHR02HN6Yaoh2iirbEFRB/XcFVZdjG5Flf83nEGW+JZ2UiYSpzB4shhMIAbFPCYlSpwliN1ZSCKwBUihTzFThDfGx6v35vtCp1j+r61J/Ivt67R2qubY6X+FTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198844; c=relaxed/simple;
	bh=rdZVB4PuHdDvlW0JZ+duekIQdUymZ9aRRnKEawCUefU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfg/AJSNTGt3guAmU6wL6G/1UEOFZLRebSz0MvAHDZt3uhkG5ECcKjkcBz1T09F7ccwcqe9J4vDwagojwSvuNe9b/P+uDPFrKRym+mwaJM6cTpMh3tLIRlPaMHH5pbEBCsfnOw8S64K9q2dcmu7/MSziUVpYtlhQ1TnfLx0B/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGwaN14N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGwaN14N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3911F00893;
	Sat, 12 Sep 2026 07:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198840;
	bh=Cn2YIgZiucym097ZxkOj0dAWtvEcF4yYpKy2UpPpFno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGwaN14NsTsIZrKZhDtvUtpRxyTK8cLfE8dNOC3Tzf9vjUMJbBxlwr5T/ci15Eoss
	 dBUUUJDLqe91A21hUzgJopOnLGrQgMfJbPp0zX/riLUQjbX5SvbH1H42u2q5ovk/ug
	 4JdP7q6T8BMPInB/KJb5uXss/oXHm3/DP4dRV7VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0464/1815] wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
Date: Sat, 12 Sep 2026 08:36:54 +0200
Message-ID: <20260912065659.781239075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c2af66899a780..bbbf3669a555d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -369,7 +369,7 @@ static void iwl_fwrt_dump_fseq_regs(struct iwl_fw_runtime *fwrt)
 void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_pc_data *pc_data;
-	u8 count;
+	u32 count;
 
 	if (!iwl_trans_device_enabled(fwrt->trans)) {
 		IWL_ERR(fwrt,
-- 
2.53.0



