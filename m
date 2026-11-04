Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829059;
	b=VFT8LunIeHwVS9VGX/vkus/SsmiYMl76FBi0aARUbHSBOCneAUXQGw69IZ+yaWxuF0Ji
	 ir5x0HTIvo1u0FfzJEE/fMnJHPvY06wbHu71t54lc+nBVWB/+a/tDym5Pcr8N9GCGgsM0
	 itjGti62aMpZ2ekvsg4OxkdgDRHCcPPkw0+O6rymxXvb7LdFO1zlvpP4+VddYyOXvELgp
	 Mpqo+SIjgE6gLeznBv4+VwXgHOSGY0ITSLFOW/h52fboy3SnpjN3N3SqxvRMoiExn+40T
	 8IxhFfwBjXdWfhGEwcyCw3vkRLUyF+QMAoe7j0cGDnMOAHbh0RSxt9Z0bhSEVOIvXlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aoHoR356jO1pz4YAOqLsWgvb012HuviprGgUlkLDdvY=;
	b=sH0sPrf6Bq63L6W/wNcbNWiOpC7haLjhvLHefOrkdbfqfEBFFIre4sCZi8CVbdGg0GEm
	 JcVSop2z4R0tWFZGelx7PEi++XSr7JF/dTYapiS0LBmYnj7YcUNoAZ8tmL0PEwxVKrRBI
	 okJU7q9YQyVtrIRMq7OAnlt8mM6OYrLKPHCJr09WAC7RAewINnIBcAhk6I38Tqvm/Pcih
	 cIqN1BAI9TiLlXDMciPtG+wj8u8y5Pedlmi850gaXf318uCKGc3sSXOL+uRWC2PA79rf7
	 +tAOoS3Xrwmjp7x+XfboxMAW4u9RZ0sdRR/0LFwS5qO9V7RDBL0eoSiEDgaXi0d7ifQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pN2Dn0C7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2B760807A8;
	Wed,  4 Nov 2026 21:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pN2Dn0C7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCF51F00A02;
	Wed,  4 Nov 2026 21:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829059;
	bh=aoHoR356jO1pz4YAOqLsWgvb012HuviprGgUlkLDdvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pN2Dn0C7o26NZEoxdK3tB2Dwjhb1cLkRF1nPOtVYfo/PX7Gj0PhHbJgCDpRdICFpG
	 J3EiTKwCe9hT+6vGIrRQ7XgewpawCc3lqYL8YVgummWAoghm1hnyPdjzUM6sIr88p2
	 9w1A+tQXZcAJYzd68PJBUixY+VNLZmr74/RP/uzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 417/547] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Wed,  4 Nov 2026 16:10:01 -0500
Message-ID: <20261104211050.170135503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 5d28b2c920d9d9d3c45b41769342ad785eb372a7 upstream.

The flexfiles layout driver hands out a deviceinfo that names this server
as an NFSv3 DS (flexfilelayout.c hardcodes da->version = 3). With v3
disabled, the client can't talk to the DS: it loops on v3 NULL calls that
the server answers with PROG_MISMATCH, and I/O hangs in D state.

Skip LAYOUT_FLEX_FILES in nfsd4_setup_layout_type() unless v3 is enabled.

Reported-by: Benji Wiebe <itsme@benjiwiebe.com>
Closes: https://lore.kernel.org/linux-nfs/c734eeb8-8486-4491-bb4d-b9656cbaffbe@app.fastmail.com/
Fixes: 9b9960a0ca47 ("nfsd: Add a super simple flex file server")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260904-pnfs-ff-v1-1-5f502cf25401@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4layouts.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -127,10 +127,12 @@ nfsd4_set_deviceid(struct nfsd4_deviceid
 
 void nfsd4_setup_layout_type(struct svc_export *exp)
 {
+	struct nfsd_net *nn = net_generic(exp->cd->net, nfsd_net_id);
 	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
 	expfs_block_layouts_t block_supported = exportfs_layouts_supported(sb);
 
-	if (IS_ENABLED(CONFIG_NFSD_FLEXFILELAYOUT))
+	if (IS_ENABLED(CONFIG_NFSD_FLEXFILELAYOUT) &&
+	    nfsd_vers(nn, 3, NFSD_TEST))
 		exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
 	if (IS_ENABLED(CONFIG_NFSD_BLOCKLAYOUT) &&
 	    (block_supported & EXPFS_BLOCK_IN_BAND_ID))


