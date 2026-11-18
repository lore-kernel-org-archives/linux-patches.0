Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055079;
	b=S4ti6fvX9qPNZhjTqwAaA1e349QbVphPfpM0Din7kkHNpWEjzqXWeV/tY1UiBgJ4YP2A
	 PqXpCl0mX5ZjcftqMkPc0H5jy+vUWf/DoNQeRbdIzDZHAXGWZk1Oc9GLX4rrCIGNEbY1T
	 xBRPcvNI3vu1ZMH2wfIZRkni2xsSUKUTv1d7Lw7aMrNiV/67PryWfErAICmWeFoCdZmJR
	 sKGhDln8mXRtFDxWqsEOWlg+7M/pVe75eKelJ9fDnftXPus2FJwyZsPfX6bAruQ2H/UJm
	 HfYUEFKX1N/SxPWk3ty2CpsznjZ0MeQtpU/I2zQ8eDFFs1hGQEGdR8EL/CHKbHS5tqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tyzCq0xGpkr/s6rmaK9tWtDtxIgGMn6Y1bBZuG59o8s=;
	b=bBZslh+J8xDz6ETcpWoDgjxWqvPO9KmHCrPbrTm7PYn2SW0mBNOJPOOjv19rQQ0BEuF7
	 Y7bxucGxN7h6bmlxXopZitCg96MvL1D1jcHClqScBsJeA0b24oxydY6AJ2mWcGp2aknz/
	 o6Pc4fK3r6MS7I5sjNcSNTynjp8wMhE9nlHLdQC+fK1om1rG+AKlywAG2m44C3KPrHJ4q
	 uTP3KQJc+qsiyN1dRebPAOrwZ36n02GlacCWi4SNFHR2i/PALovx4dzGscupa1gsq7xfz
	 o0J9lZyKcgMxxhKYgTE8caqNXmYzDln5uwJFkL3FY20cxda0ofgm9EBQSkSW3PvcbTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrLvgZwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C0606A32A;
	Thu, 19 Nov 2026 02:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrLvgZwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45B61F000C4;
	Thu, 19 Nov 2026 02:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055079;
	bh=tyzCq0xGpkr/s6rmaK9tWtDtxIgGMn6Y1bBZuG59o8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrLvgZwE1sneyAc93ujXLa89fC0/ty+VruWPrzBFJ8BR9uWmjVIgpUuiF2Mie9bju
	 9BsczeJ8emBXI6baVw/BnkD3FoqPLP/4UwgM7fh1etM9qfnP/iBCxUBBznUpiYpDAU
	 ABVTZTp7bWMC/f5n/HDVJFYEri8Uq2617P1dztKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1501/2214] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150111.801541089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2970f33f96c5..0a4641f06bb1f 100644
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



