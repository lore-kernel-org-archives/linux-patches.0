Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016248;
	b=CWrFbOBxzFqqhsso1XoqQ1Nnm2JvpKizMV94zQkjXBSCC8lPvl5J8EMUpBu8TLtCXTRE
	 6LYYgp5BcNCgEEWMDY8nOwkcCDh1+SoqK1dm8A+INnCgRpkcKkiz0pQFrjjioEyB2ANhW
	 D+wA2ruCHHRvenjNntlPVIe+CCvSIfCsl13NEsd1bld5Ict9rh0USsrPtFMjK1EGHZ3Ru
	 EIPUgtE3y4v1ego/q/SvLKN34Z9d2sMNqAQXkVba0GGl8p/N2ZuTcKB92JHOsnpPprEkM
	 QygyJq0ph4XhPnHLf8KDSMAnbxhGY0Bp0XMYgRplxd2EYaqfFOf8Koh1qq2NV8OPPYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y8Qd037PCIq5rGPqJ0pDox4bkDUViu/Z96aMN6ILVXw=;
	b=ROgMJVygsO0gtP8Zd++RRlV2K6+4K9BN0N/jifZwHMfes2vLgvySoP0DfyMFvk5aD9pa
	 XAR6iLHwH6IRnwhs9FPeWK4kz23YnR5VVNn2Z2+8A94hvK57t3TH6XjExcwvnpTIgCm/R
	 D0hoLqXJ8Yt4lvIF8kcUxDfW2ByN1pK0e4fmwe+Pqi4vXKEvcYT7aPiErfadVgIqLtdHo
	 PBBplvb4ADq6yLBvaIRZtGVuGr2HHLhL/m5jnZqX2H/JxTlonOOjIJohrHaWE/D8ZUFDo
	 dKginqPJOKQR8rfHm8b2cxdkO/Y2kLN/d9hIc7FY07Bp4Js9phRXUvE2SLZHYymcLsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="by/M9jM+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B8606A320;
	Wed, 18 Nov 2026 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=by/M9jM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604351F000C5;
	Wed, 18 Nov 2026 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016247;
	bh=Y8Qd037PCIq5rGPqJ0pDox4bkDUViu/Z96aMN6ILVXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=by/M9jM+V6ec/jCVsIpeJjZduU1Lw6Q5MvsRCB0WxZpuoEVQYPpB3TCDmChORKJnN
	 /sJNFXwS9JVlAaQpnbKhNSCeejncD4CoNnsApn0AvtAQpHa1Dbn2gloGSlDJ5JMGJS
	 dB1IY7xLCn/ioBV8n28/t0uhgJRRu6sML4MorlCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0460/2651] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:28:20 +0100
Message-ID: <20261118150304.363469222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 07a21dfa8674a..5a6ed1b6db97e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -679,7 +679,7 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
  * @sdata: local subif
  * @dst: destination address of the path (ETH_ALEN length)
  *
- * Returns: 0 on success
+ * Returns: the new or the existing path on success, an ERR_PTR() on failure
  *
  * State: the initial state of the new path is set to 0
  */
-- 
2.53.0



