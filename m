Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021154;
	b=W9ryi/ifgKpvFe2Jq9lX9khV9c8mhKFNR02z2PObkKm31dcfYhYNUop7U42PmjqHJvSm
	 IGH9nQFVEBX37nGOpf46XYEFVIprejv28xoeMFNz/nAZUsBI1t2ZFcu9wt55stV5ZbQDE
	 xTRC4S6fALINoOgbuKSgwlnBogrr683rn/CUUKCZakzhGAJmwggLdz2mTtp3BmTfSApKt
	 kOJkHWccEWYDVsw74zmzFTiy5q0lSX2b6Mx3SOmlwzfivg3ZbE1Sbc6ZGM6f67lKotB08
	 aEjRkYNRZuUDTo9ZbUD1LHkSW5z8KmL5d0TF0AVIInyj+QugI39tbT1IUETmTgSEWqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/dixpPwj0pipY6FoNtNq/Lawy3q82MVqBpB0NQ7cck=;
	b=2dCRI1e4E2k43CnYSysvvRxUX0tXzkLwqetWTAGCjtyEt5aKUczV1GV/8kl3CCHWLyin
	 qbDa0DPe4cPTKSmRlbiBomJmDEkm5ULHv851NLVXsy+wF6zVilGGwa5jPJXXUKecdgVhR
	 GTeDT3QoFZ6MXpFVDgTu9V1DL7ujHFR83Ic+TEL44Gub7HhREkwkRKsXI3ou/yeEBBzGZ
	 Pb+3l09LA7TQTPgvs2fiNm/DS2VeDIHRn5M8dBerrIxRD8eBwRqpO2Dt2I/YMWrUmWAsk
	 YY9zKRRSaEcHX6FyIq3dyHKPTMMpYOd5D0v4cAh14rBHoi4gp73CrB+b3F5z+pAtUcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lAO6wnU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CFE606A33E;
	Wed, 18 Nov 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAO6wnU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD5C1F000C5;
	Wed, 18 Nov 2026 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021154;
	bh=g/dixpPwj0pipY6FoNtNq/Lawy3q82MVqBpB0NQ7cck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAO6wnU/8Rm7oM6xTo1ybgvJcJuzmTkuJp/Jtay9PTlihsoMCazY2f8NJUuHfZywX
	 5fzXw7cO/KpUvBdq488OI/m0AdIsF22NY6t+dnMwGe75Bw7S+LqzeWndEdXFxUJpp9
	 cFKunwZFumAafvd914rTCj1zVp64kU5T9ccVbKJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2206/2651] ntfs: propagate the map_mft_record() error in ntfs_attrlist_entry_add()
Date: Wed, 18 Nov 2026 15:57:26 +0100
Message-ID: <20261118150405.094280223@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 2db4627c57d608df40647f553a3b5cad1691c1c6 ]

ntfs_attrlist_entry_add() replaces the map_mft_record() error with -EIO,
so an -ENOMEM allocation failure is reported as an I/O error. Both
callers pass the value on to ntfs_attr_add(), which no longer collapses
it since commit 8efe00b098b5 ("ntfs: preserve error code in
ntfs_resident_attr_record_add()").

Return PTR_ERR(ni_mrec) instead. Also fix the debug message.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrlist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/attrlist.c b/fs/ntfs/attrlist.c
index 78e9a1dc79251..3660e7fd24b13 100644
--- a/fs/ntfs/attrlist.c
+++ b/fs/ntfs/attrlist.c
@@ -337,8 +337,8 @@ int ntfs_attrlist_entry_add(struct ntfs_inode *ni, struct attr_record *attr)
 
 	ni_mrec = map_mft_record(ni);
 	if (IS_ERR(ni_mrec)) {
-		ntfs_debug("Invalid arguments.\n");
-		return -EIO;
+		ntfs_debug("Failed to map mft record.\n");
+		return PTR_ERR(ni_mrec);
 	}
 
 	mref = MK_LE_MREF(ni->mft_no, le16_to_cpu(ni_mrec->sequence_number));
-- 
2.53.0



