Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275A93491C9;
	Sat, 12 Sep 2026 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223377; cv=none; b=qvU0Xt8W8V9nPppSk16SSD2vCk8xWgp9+k1rOUUDXoeis6moAcg9ei0utmxt/F+TJ7UlTG6BbcoaNmYf9oU5bo64+bAoBPiyGsbK//E6bJuL0NH44W2LnRe33AFICfeWc2R/TanGIClzioNvk+CrpS4PHCK4PlDklM3TsPXLYN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223377; c=relaxed/simple;
	bh=aWIa5+Fsk2YYXV3igrbsKWiMgF/i+6z3ew20/amQt6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wh9NYw6YxDBfRdKBFg6lNq3p9lmOIMbFWyqIpT0p1gEXdXtbgxL1/T1jQWS6ArJjngmLUkdV4R0cC8ZufEHIlOTjzj/C7B8eMVgkmJo79Lnqpn/7+pwqkfS7UdqO1sqAqTzRYBa902twmyCmHcEsZr1HBbXo2zc1FQ1t0AvoVAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5tVY3DY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5tVY3DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F011F000FF;
	Sat, 12 Sep 2026 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223375;
	bh=HBcKbWulYQYUaVJNmKTov8KE/AKnMaWF6dXALDk4Jgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5tVY3DYKPOUiPC4WrKAHfOr0FEyNnRchjgR9Qs4CSMSI3kHH2sFfEoL9tBCr/+t3
	 fybUc64xbv+ts3+/x69KBtEp50PotMZho7aXnxne2UEFSoCeX6NbWeBk3BvfgkKpzD
	 j7B7vFm8mHTP9ekBo/j8NxNAa832ogTCBse7kWZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0778/1424] wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
Date: Sat, 12 Sep 2026 08:53:30 +0200
Message-ID: <20260912065624.721842394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



