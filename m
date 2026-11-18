Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039759;
	b=alcridfLJzGREfLQY4Dogvn8yNWKXuAaqwBPDiAYFXk5r9bf4PvaYq+oRNNbjiN/p/B4
	 b76ycjpUDiT8SkZ+4cc6nhQ78SmYFjYKiEFwLqa5mhY06LMEHkOIGdcFqVgA9XzrjZVkE
	 r6k242P99eCIDV3lGTN940tzN65+tVTetOjr34t7eW+NLJsEe/aMjhIkxtD0X5+vW2zw7
	 Z7GpWjd0MNjZ8MLF+5cL4R3rYsxCXU417nCerIlymBGEehdrjt6zPF8t1ccSy/dsXh26c
	 19gVrvgf+hp0esblUGObxgGwVdfTEBskJZg0E9Z5y/CextaYL3KGjhw3TZ+YQy4Rc7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CPbtFw1ffFUpaCBR3QQUAE1z7ko3ShNNzCJsXyLbeK4=;
	b=Tbe56x1H1MeZpoNOPa/HY07h+QS9dVWWQoJ+fvMmq2oR0GeAkk2v+/NAoFZ7ies887En
	 46hnmKNbchFStPrT5gvAxJyXbiE0/7pVgDN+6Nau1T8STuELziL0FFjUPVwteffSbpb8v
	 9LiV4yo/nYMotVzQ74GGSxvauLBEwiGKM2csgV0xxnFM6u8A4BJC3C4Dvkxt2PbiMPnKR
	 bkHcSm+vxAeGsjODy/m83gNHkh+fpcEjkRsBefa/JGLXYMXH+DvIhpJMx8sb3c88opEwD
	 QxhbQgbwiTMrjKJ2Aq7Duu2VPyF2zkdWawLz6vlQGpwUE2CC/SCfsXn45ZE58N8KUKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPKlJq66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BC8606A31C;
	Wed, 18 Nov 2026 22:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPKlJq66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998731F000C4;
	Wed, 18 Nov 2026 22:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039759;
	bh=CPbtFw1ffFUpaCBR3QQUAE1z7ko3ShNNzCJsXyLbeK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPKlJq66rHRla1bbbvBgktojeD3iBqulk45ILcEkGyeu0nrpEPTo6e+EFFITxEslF
	 I2QlTZjK5kjJm+kUwwZ+iXAhp8djiFYoYosb39kLf8dR45xmvdpuZLD50Of1/z3b0w
	 H+jcVx685ur+P5rE53bJvjS3HRA+IhqBTI6NLcOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2214/3318] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:47:16 +0100
Message-ID: <20261118150428.324128320@linuxfoundation.org>
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
index 7cbc54b418287..bd91e9de2f4d7 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -674,7 +674,7 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
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



