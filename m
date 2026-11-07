Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060706;
	b=iERyZj1DuzYDVfHT/mcpY2Lp9nB5kJnpbhgLYg12RSwGO1DY3WKX1DDL6xUpZLPMTKeG
	 6VFq9h4GU5uW8ofmJEZuUS2qqcgOdfZuUV4TJJLpi1YHMJ37LXK4yV5jiXyhq0gFGim87
	 AHRMECE18W1aIjtXZAlrx2wIEZ2RSfeB14XhTvqwDfjBm0d6q4UBZPwlDHjSQMpHsNBUs
	 ORNkiWzLpSfGzDOu+qkZW6X8ATN7UZuEWrGPwhaYFX9drGF/zIbBkuttXCpV0a7hxSqRg
	 jYq3wXyKLDhxmtfGhKr+Bxi/FwhAZhK0AmjC7UyWoURaMENDxHvUuISr15CUPX2ugIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Te5oS1Vn7DAHLR5rCOLvC9VzFnw443JzIQ0fm5m9i+g=;
	b=iYdcKOCyDNgalaynueKpRtsOWXNX5KYH1TryeIc1dBUbtNjrQSzXKPR4LkO8ahYNI/9D
	 AGWdeGhvzB5FKdt8TVff+4rT9YpJ8sJgBmd/Sw1m7IiWek8toJYZprw9s5koM1hw9uWd7
	 NkbUOuBQUmZs3h/hafG5304JBurCT57K+F+Ycxr5wxrCu1CnOg61vvIbJWR+ttmyi/H7V
	 4dilNLCQuAP6k89e7GHVmMSopWmDpto46nWM2KAAby/A3x/5JtcFYEadKxTJ7psjE3y6Y
	 aVBIvOz8OD63Y1BtVyXAnHpPX8HO8q0VcOgwRj74sgzlgUSSmYmZhhmskul+IOqaLiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMwHLzb3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03FA606A326;
	Sat,  7 Nov 2026 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMwHLzb3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790EC1F0089F;
	Sat,  7 Nov 2026 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060705;
	bh=Te5oS1Vn7DAHLR5rCOLvC9VzFnw443JzIQ0fm5m9i+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMwHLzb3ieoxcGb44y4l1rySjOi8AUiuSvXPxOG/rrF8oxTiN3RABbhCjd0QfQopu
	 ZdjQ3JtBM65hEgnc5eeg8hcpk10nXqsIyDUs+59AzCJWqZEiRSzsWGeCvFh9X7xMYS
	 VDuoUF20fDhPvDvm6tnRpVlw7MIFDMhvl7EEkOFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0134/1536] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Sat,  7 Nov 2026 08:35:50 -0500
Message-ID: <20261107135001.452648410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a51cc8131214870af92abbceab64877b27e690c2 ]

The smart fifo is a feature in the firmware configured by the driver.
The driver keeps a state to remember what was the last configuration
sent to the firmware. Obviously, if the firmware stops, we need to
reconfigure the smart fifo. Since we didn't reset that state upon
firmware stop, we thought the firmware is already properly
configured and we didn't send the smart fifo configuration command
as part of the init sequence.

Reset the smart fifo state in iwl_mvm_stop_device() so that we
will properly send the command during the init that will come
later.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.7d3c5efe2d1a.I16b23c328a677257257f695fa6f439e41fbcd081@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 52fd6b2093c9c..f43b54fe28306 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1585,6 +1585,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.53.0



