Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831582;
	b=Zmiy+6BXgCIObTHXAynLi4NeY72LLtGML+l1sZQ4b+UYwBR10rQTV2YGlassYPCcecFo
	 vT1Sczjtzc9RIQ1JjaG5DImn/Rt79JoznHkv8skK4ABwXEevlayKlPzlXrpM5AJWg+aJi
	 0KkTxT8Hp7Xrpaqu/Xgxv77rbZv/5ypW3ds5PUPTWI9IjRCaTDTqg70a4xeDaE3mcMD98
	 EORrPvMS9RCdwEimLV/hA4hD2L9HoJzhSHOeppynOT4ExLfcGyrXv21+JkBeYieK8dusO
	 RNqF1m40y6lGxFTnKeGPVe+k1IWgibt5qaGVtZ5SUV/2xnSvMBUvOMSFB7Bvciuim3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HAZ/qUb4D89JtZD0b1rLexMPJRXfDtPDiuOjZDMuj2U=;
	b=sf0UN+EBmN9xCpgml9733AnawUT8SurlmIMrNtXaNZGtWCaPhzAU/8cWVqm0exxF7AVk
	 d3iHmoY/xjVmr2KXok9PnHzJi1T2r5qQ5eJ9tO+tcASGKt0VwJcXw5HCufbd19+a3IYGg
	 bubvwfH6Cy9YueLuMOcFFm62IGP1E8F7ajn8DWbTDjE6+oWTEff3W8B7rbZRwphkzM+no
	 Xp8ELK2NKC16byBzcr0mpx3BWCRyMpMHNKIA0QpPRl3AY677HmOpe1tV2t/G1LEogeR/w
	 Z13amq+j6PDaTbSnKc+d9kGT/PxVDpAs0i5SVL6rkgX/eoL0bQx5A+SKU/mHqAAE6aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yr2+T74P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544F5606A844;
	Wed,  4 Nov 2026 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yr2+T74P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F871F00919;
	Wed,  4 Nov 2026 22:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831582;
	bh=HAZ/qUb4D89JtZD0b1rLexMPJRXfDtPDiuOjZDMuj2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr2+T74P1iQESNwo/CelCN11+tl8rLF8eonyG1sAxtXrzrpjIoIUhSNqmhcvxStx6
	 K1q/ZsVw47V5rk0D8t2Nm5iSeeigNfaN1cWA/UmOwY6jaWe+VlPJdXsQ97ln5kGQ0q
	 wSsvt3+qR0un/XwAQP1qHNcBA/lCDTbKGnFl4YG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0789/1005] xfs: zero out di_metatype when removing the metadir file iflag
Date: Wed,  4 Nov 2026 16:08:42 -0500
Message-ID: <20261104211105.442437506@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit f5b4d8c8ce16675f77c25a4ff06caaa9a2739f31 upstream.

LOLLM pointed out that we should zero di_metatype (fka di_onlink) when
we're clearing the METADIR inode flag because the file is no longer a
metadata file.

Cc: stable@vger.kernel.org # v6.13
Fixes: 7297fd0bebbd70 ("xfs: enforce metadata inode flag")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -579,8 +579,10 @@ xrep_dinode_flags(
 
 		fa = xfs_dinode_verify_metadir(sc->mp, dip, mode, flags,
 				flags2);
-		if (fa)
+		if (fa) {
 			flags2 &= ~XFS_DIFLAG2_METADATA;
+			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
+		}
 	}
 
 	dip->di_flags = cpu_to_be16(flags);


