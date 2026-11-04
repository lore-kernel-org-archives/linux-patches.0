Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829558;
	b=UWgVw2vRjunTAyRiZmlimlNxfUcQHAolxiYWDmQ4YoHdvIpOqwPm97sR2ZG4+tR8s9Y/
	 NmtspWD477p/pgYPYzhX/w9hyjTY8sjMS1g9p846tmR1r1id2Rq7TgjuhsbRzWtHLbA5K
	 weLzA3lII7/kxWMbfixQMbubQJVrtahHij1NFdAJbHfh094WhlkQX6KtCDZOqB1saxJGn
	 vXEMER6fAsXe9gMn20OLwCrxzsgPfG1tCBGx8BXguJTefQacZVSNqat37OfQGySksHewu
	 FOjHmTWxSVnQUpPEFvDufM4DeGL63Rse5ckJ/cNlwZy/9m5M0VNYPMG4bhh2OyEs2rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h4NBvM5lQDhto0LkcEySdPZPM15OJvuqWliI1cWH7X8=;
	b=IQ2sDQ5YDlSzqTYh4RsLpFDFX1Hgq4MpwxZSb8ZgHPwhuh7AlbQb2j43gvF8AMuuCwd6
	 i2EYn5CHrvG6MiZSYJGsvBvA60yRY+ezCVG3TmQy/2KUhaNc/T4sP+nup0kHXtq4lLhW5
	 gF2gnKN/KAcGI9KFkWcuwp4cVZzbLIHv5benLg1T+pPyjSVasqm6gu7AVpJ930/LLY87r
	 h3h8NVo0JRQCn1FKJ6mqeLjz73J5iFfyNS24pqg72D/J6EVV7eFjTok3BpJOi8jECkH5r
	 45DSbuQPBxbf8ejxl3EPH5wnET2knUMGlaKsaJl6l6h1aBTBApxKkO/4rimbwRzZMGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XxLQqmy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB46606A846;
	Wed,  4 Nov 2026 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XxLQqmy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6F91F00A17;
	Wed,  4 Nov 2026 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829558;
	bh=h4NBvM5lQDhto0LkcEySdPZPM15OJvuqWliI1cWH7X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxLQqmy7sL2AFYBQ0c8ywoq0vyIJzNIqTZ0KRONp7Ea0NEPVJkLL1lX2Pzc2GNvAc
	 AFCosGsc4enZqU8RXEUWNZ3hKwWioE1k5W6Wx7Pd0KJRiAY8TneIZalgdCoMz/nZ+Y
	 DRLwt3XFTAYDsbdzWk1n0VtLCGYgd2z+GRybmSXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0201/1005] wifi: iwlwifi: mvm: ignore sync frames when sync is disabled
Date: Wed,  4 Nov 2026 15:58:54 -0500
Message-ID: <20261104211049.423762349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a790f60cc4d7dc64a2d7cadb94a3d9f60392bed4 ]

Gate time-sync frame interception on the active flag so frames are not
queued after time-sync teardown.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717172958.ac73ee199a25.Ic1489244f9b02da93060f0a0e5b300a73527f265@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
index 2cfd0fb5e781a..7bdbacb640787 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2022 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __TIME_SYNC_H__
 #define __TIME_SYNC_H__
@@ -19,6 +20,9 @@ int iwl_mvm_time_sync_config(struct iwl_mvm *mvm, const u8 *addr,
 static inline
 bool iwl_mvm_time_sync_frame(struct iwl_mvm *mvm, struct sk_buff *skb, u8 *addr)
 {
+	if (!mvm->time_sync.active)
+		return false;
+
 	if (ether_addr_equal(mvm->time_sync.peer_addr, addr) &&
 	    (ieee80211_is_timing_measurement(skb) || ieee80211_is_ftm(skb))) {
 		skb_queue_tail(&mvm->time_sync.frame_list, skb);
-- 
2.53.0



