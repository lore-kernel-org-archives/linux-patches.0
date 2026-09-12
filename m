Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D880246BCD;
	Sat, 12 Sep 2026 10:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207690; cv=none; b=XiY2gE4P13oVeOHq+7CaBekiPeFCG94qj4/ykN8UHNlXg4CPceygZHgOX77MWk2sahINK9pQe6HyRhrQr1phd8Bkgfs+vY/pVDIoMZSN8Xx0BoRuL0EKj+Y61l4eiGCsMD/iVGD04EVQFBIP8Qk77EAD4wXeoqE3q/k+P4fVTSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207690; c=relaxed/simple;
	bh=LS/s7h07H1bLO8dojY+SanYtYxBA1q9DJA7VpfG9T+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dglfxMY7VuuCsINKbNcCOeZcEbCnKIfq6TsD6GCoyI/Ek28BiNS5UpKNxY1X6VpcIFaZKsIhRnohcCHR9l2evSmvHDxxtM9xu5Ipb+DA36gw5chfRcE9LbNBlEOJZXmhrGXNir/nCAUkYsG6NyjwL3pbB47b/sFt0e5yOjm59HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VCDdTF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VCDdTF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26E11F000FF;
	Sat, 12 Sep 2026 10:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207689;
	bh=d0F31UxfSlIXrjqxfJMLYniqZLyTFAiMSKjvQ81zfUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VCDdTF6KAQEv0BaSHvw4CXhAleveYxiBD8bxilMMPccRsI8KYq3eW9VK9IypEzwl
	 S9OIFxL/lfBDdbic/NY5c38c5TgKS+cmkk8XVbpsiOdlw2nFtkRtU9X5L+SJ18S3xX
	 iQrGhD5RAtxqDi0s+AxGz9YjRq5+sJrcUCkOx4OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0421/1518] wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
Date: Sat, 12 Sep 2026 08:43:10 +0200
Message-ID: <20260912065632.975799418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ddd714cff2f4d..87acbb482435a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -436,7 +436,7 @@ static void iwl_fwrt_dump_fseq_regs(struct iwl_fw_runtime *fwrt)
 void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_pc_data *pc_data;
-	u8 count;
+	u32 count;
 
 	if (!iwl_trans_device_enabled(fwrt->trans)) {
 		IWL_ERR(fwrt,
-- 
2.53.0



