Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060789;
	b=TI4ukjeJesLmN956aU9jnoQCuBR3VFwo6enAAoCZxUf+0IlGr5p5CCRpjuPEH1J/Ll/h
	 2gqV91+Odz1cGKmgSzKpn88hGfVwGnfYZXsOfdWpBV+xbdDPk13P5Kpk0NS8eK6wlOsjI
	 JHmfb4yOdNxtts7T3up3DXN5Gw1aIVKVdaOUp5Js/O/R6sfUnRawkHwNbN6ZkfeG+AUPk
	 qxGvF2B0/0wdb68lw/X2UXOMpxsdg4mS9dy0t8YY7i3YWrlE/jY4PeaNo1oAkiXMuniE0
	 eNZ+lE1/16L6IP116hJ725VBgPSTN+rIR2DIUUphSdvgM+uD66VSiBzhxcO04+mV4XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7e08uW0nvbYI6Kj7mOHaORrSRs9MMmmI2X5kmNS6c/4=;
	b=ACfWvKzJpJyU470+CbIud8q/1fjsiR0Il5KBxPuksg5zqGYNJRAuIsaPtZuuHTjLptZ/
	 zAWtXQpnejusEAL8OHvDFmhQ0uU6PNbSkOW3qhgLMdnHYcQ0ddNAr5Zn1laTFGT2PgFuC
	 vwGmavYmHEoOC6qZYSMRNR4UPX63s5oaI+qqnHGrSFOPBaOFj8wSikao5JkRD918KTSyD
	 kY0XvcSM5ezaDPEs6fme2Tq2ocwhmMRg8rxNnjIgQ8e4smRQQGpZ9TsyYtAGqJlkliU2f
	 9aWuqzDfAKjuQQR+aSILWUam9Bu4N46hmrwQd+WuS2ORe/aj4xA5ROYvciuRHTuDx5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIyq94Eq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB55A606A326;
	Sat,  7 Nov 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIyq94Eq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945C81F0089F;
	Sat,  7 Nov 2026 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060788;
	bh=7e08uW0nvbYI6Kj7mOHaORrSRs9MMmmI2X5kmNS6c/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIyq94EqKJgTYX90E/hTr+c4Rw4RdlEfXKoFukbpAL5pzTL4L64vwNsOGjliczx6h
	 NhF98f1kvXnGirFEjEgisQEceDScwsEavI4543sSJbGCYZKwJQ1TUoC2deyHIZnzUy
	 HyiJr6/P2LAnoMOBKbPW/zN69EhFo9Jbf2yoM2ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0166/1536] wifi: iwlwifi: mvm: ignore sync frames when sync is disabled
Date: Sat,  7 Nov 2026 08:36:22 -0500
Message-ID: <20261107135002.330613248@linuxfoundation.org>
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



