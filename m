Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029584;
	b=LAr7vLzco8tokzdznPWyzX+/M8DAQud6XZgyZhYLVGs3Cmj67iTOO0S37SLuphv7qUtG
	 NCvRUvQXYj06dYYs6UUHlgPsXA3wwCl/ILKnzJdzFszy1GDTdHI/hj0Bk7M0OIeBwW6cT
	 lGPaxGhkgmhf5Pm5tOyILLXpM14ufko7VbFhjTWASLE5+H4Yf9dnI8Tql4yx8bKSMY2DM
	 UtM/x2uqYzQZVac7IGrk7GblkCI72xwqvIKFXhG07E9BVh2mL9qMlqd9yPiIl88R5/16M
	 Ifg3jK6UaDb+UCvSJai+Fn65DhqUMOa7d7wJi7kNXeOQH5omz/EvZ4thlYgbY/TdT1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EsfDsTYGCSbqM0MaSmKb3Y+c55NMrymGdlkPsorJfwE=;
	b=f6lyP0gnlu65OBtA0DO0zkFGxn5ui9KBvASqHeZ0fLJe9nprBva0z55CaSthwf6sZDBv
	 5PoUXCsKKAQhpcoXsTr2y6gMPc35dEbDfhjrFVuVfrucYEGPPkgZ9VUAxLP/jEHir/iQY
	 NnW1xPBM/c47r+qPCiw74kXhMOELqKmnxofbe+PjFcEt/k6RPUAgVLPa4NgZLD2w1xx52
	 4+XlIP7/a/PowsmO2SAoYoWn8vdaCuRHe2mxwDGI1UQzEhrQZF/nvKw9MiXNaba1ntMvb
	 xqCV0iAXijzoz0uJQxh8/KI/gtAMYe7cV+lswAV8RvZVt67bDj8pSFgjuH4QkMYE1SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qvPNu9+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F0606A32C;
	Wed, 18 Nov 2026 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvPNu9+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F99A1F000C4;
	Wed, 18 Nov 2026 19:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029584;
	bh=EsfDsTYGCSbqM0MaSmKb3Y+c55NMrymGdlkPsorJfwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvPNu9+/rxCfFue4DbMta6xhfuGmcOYBCUz2COLydvaAbgPdRN8TEx3FwINTNdS7L
	 y+yxXEqzyw+gitFcEUs0NtvkMeFl0ayTNh/TpJ7vk2WTFC2KEZVasL7exOJTChND2g
	 03uQ0FfnY2kEAm0JpRpTUl76KA2vvD8rbOCLuYLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0402/1756] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118150024.768757358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5c7b043cb1ef4bca9aa2e793dab862c0989d59c3 ]

mesh_path_add() has returned the new (or the already existing) struct
mesh_path, or an ERR_PTR(), since commit ae76eef027f7 ("mac80211: return
new mpath from mesh_path_add()"), but its kernel-doc still says
"Returns: 0 on success". Describe the pointer.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912072840.50710-1-kmehltretter@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0aae70e957c92..9f1b5c6a15840 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -679,7 +679,7 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
  * @dst: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 on success
+ * Returns: the new or the existing path on success, an ERR_PTR() on failure
  *
  * State: the initial state of the new path is set to 0
  */
-- 
2.53.0



