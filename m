Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060578;
	b=l/y/k0mUmvkEzpD0FxDaNM2eDLs+hFbRMq+hWjGCNoMdnWLBXJq78ZTjGlXTnn+i7/5u
	 24LbARy1fvhNEs5iWi+/EIvpdG5j9ci/7FltSBItPywIN83Lwkz4iL/bgjMo/nciNVJJ6
	 5QBkWeWXKQAcWk/Egs6qdeuCgm7LLpEabgID1mJ3o59N7BYSaW+AIVnIGLFa3Q+mFr9Vh
	 HbGvT3rEtpECqgjcrNx0Ip+qMLqLZ4GAodVyIB1tg5ATQF+4lYyU1KcvHqVWyiXqnycYi
	 A9D7dmmthGcIB/sTcspJQp7RNRfJ12AzBgqM96Azscp5oNaxLVCnsKurbn9LWxEWsXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAF0rCGxhR+LTjf/adHe8iFMBzW1kJYBxCa0/wGXAXg=;
	b=2EZLjGgDyY3lJxWwQQ3DOC/jelsjhfyTTrstK3jDaIIToMtfJjhXcpzdhLoLBAp3yVDs
	 3bcAWBmFRqTFnltgaL6mTvzMYMl1oFkBDnVHkLIX4Ky4Mrw9FPF2GZwu3IvU5Lqk9yU8Q
	 cyl+jna6NEGFBtv2iBe8cN+4SxY/RLB1W+9Mo0TrtNhlnHeBODe5A4bZLWFZ/gTul0dGT
	 xVCOHAlPX0iQrBQDoHeOuYXT6CBHpHyb7ZmZTBdHyQkQId5IKZvYrtgpNhGtNNVT54pTw
	 j25TPZqinzA1tGCDewkBmSXc6mupandHQiAjUot5nLxjG5sqXN8h/kT0lraRylcyGpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SGQazm9/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91531606A331;
	Thu, 19 Nov 2026 03:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGQazm9/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE95D1F000C4;
	Thu, 19 Nov 2026 03:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060578;
	bh=iAF0rCGxhR+LTjf/adHe8iFMBzW1kJYBxCa0/wGXAXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGQazm9/hmVfLUEz9RSZ1g8Vp6iKFcwpekvrQkaOa+/l+I1fAPvGrTC/bC4H8+74E
	 zQ+Kn6HGbpcY/JlDD1z41N2DRzGNijzvjV4Dyf4Mch1cC9RMV/CgVvdae7C1RpGOVz
	 DcuQ1sKUMPdkd5SUGTGn2k/n7DauqR2tzK1JSq9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1250/1848] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:54:48 +0100
Message-ID: <20261118150012.120242313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7478ea5786299..578f3fcafea91 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -386,7 +386,7 @@ struct mesh_path *mesh_path_new(struct ieee80211_sub_if_data *sdata,
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



