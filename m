Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033800;
	b=wIa2MLOzQruxwWGgRoi7L+kbnUOpupSuTi6TKQWH6gj8QtDr5phLMqJ5rvDalgWWW4Q0
	 q6iko4QNmALAduMz1yx0tr1poU7suHRnRH0QWVlSxVD97dq2/XbzcXsqe0DdG/FWGpjsL
	 IwjzJXC2GnJ72ydSOgj8cnSmcS1WGXEddKb9gJIqQbQTgy9uqyMRRb8VRy/n+bbaX9/ER
	 M6B94WQyFllU/9a6NeMXWYwiwn/6XEFBXnMVHTmwQTzMr7Umbs1qRAwwrqqunmz9RgbTw
	 UhJ62ZFzMpm7oZquu/P2VuzTxZokzCAmOtJIbdhfgkuaE8AfoZQtzf1DaQTvnJx5a0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZXyVUF/TafaWMCYPbbsjz0H5iKcGWLIcgfx66QUhCwo=;
	b=PH8EMeYCXgRO9xMTxdtrvXaJjGKXUxNOXfzvLevIbsTD0oHfPHCTgMIr1gpVss2qY7Of
	 QIHuLcgISt0ywO3vXRRYX6wKv79qntxjRU5iJ20IRuzbyZlYxWnZ7DF9U2AO2DbDxQVLR
	 ickzHxGYCOJqsOBLQHzqmkvLMeyJ9eEKrOFbrXHe3WdDaauPiVWlJcEc7JQ/5gErck63Q
	 QiUCpXm3m2Jg4VzPkjuZz3oTwsNuwHaTsJfX9W6SlYRdDnqjER+IZty0+GmPM3mZ4mWr6
	 l1eQOm9o2+B+wEMcHWlHG7xkglzU+sdqKNOzyeoTBkTC5ngbiJFOpgw2gvSIx4tvDrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3fzRkzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0651C606A320;
	Wed, 18 Nov 2026 20:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3fzRkzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EE81F000C4;
	Wed, 18 Nov 2026 20:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033799;
	bh=ZXyVUF/TafaWMCYPbbsjz0H5iKcGWLIcgfx66QUhCwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3fzRkzWPQzKIhB8LpjjnLNigfidHJX9Ye/b3KiTxjswEauFf34JfmLsMUarKxEhr
	 NB1T7qfh10iwrtzb3T/VfqipsIMioOgzWFjlo/P461d8mJuiPjroeO1IYGLudpJCfw
	 iLt48ebjJw4ceVcsqRcyjgOk1zEVMWNGKVUbpD4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0143/3318] wifi: iwlwifi: mvm: ignore sync frames when sync is disabled
Date: Wed, 18 Nov 2026 15:12:45 +0100
Message-ID: <20261118150318.761439139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



