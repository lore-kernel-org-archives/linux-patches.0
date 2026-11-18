Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021141;
	b=H8nOr4Hf0SRbqgzZ+WOGauPiqBb3nL2ODfGTXDwh7ochg7sKOyZECSznU20NpPnih5k0
	 elj+vPmAR8YTEzzTQt71tyLHcby+q3XnOcl7w2fu/p5hD+CBoORzTz1VScmT+PzgZpP68
	 zamWBY7X4ILFs7QL4ajVVQ4Esy0n7oaqzPDnJHiy2aMz/FF9PFkMmUJJLe3imFCRehBAd
	 U0aoI90ZAMpH0S/sXer9L2RAgvQ7sOA3W+Au3IjUt2Gv+/cVpgYxaKMdqVPNgspo4NI5U
	 dc2eNMN6KyB0YE01GvwQ6DSKwarV6YAXT319Odrm8oSu+v+o2YOHRtPv8NvVxkBVymw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yiOFtYjx0VeScdpXik2GKsz/vcv2cGCcOdVGO29S1Ho=;
	b=FDnijMA4eNvckir71936JHTogodzSV9kDai2ZQ/tMr+gkge0nyJDs9AzrNscGeNH6kIO
	 Dp6EGeiobFTCe81aCtoE0KGckQCsXlPCAAB93QtFaegU5lsSH6XG4rtTdjQ2R8UhoA9cB
	 UoXENfml0tbjgAFT/s51Pyl5iRyTvq3fF/elQjKC26CiwD/aIrt8q1xci9+H7we0q5dpj
	 +GdBlHEvWn/T2Ei183GSKInNM3eiDKOwoT4BqaaKXlVihy4i3bxFtYaLsovmF+1mgMTZI
	 MsPhXk/ET1v4jVF86DkkuFh66vSxNNhutKfnauoRvEH6g3wmHCRiagFrvIVhV4bOIUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adxzQPqV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE89606A31C;
	Wed, 18 Nov 2026 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adxzQPqV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFF81F000C4;
	Wed, 18 Nov 2026 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021140;
	bh=yiOFtYjx0VeScdpXik2GKsz/vcv2cGCcOdVGO29S1Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adxzQPqVO9lfmeHA3n2zTnoLTt9H9Tl1Eum3Ipr1+4VHPi6DkCYE97vKf/BOy9ebb
	 A1cDJFsbiAzSu6mxE/unoASm1aHmR0ko4EfVmLPtgEcExWdrWV/IJaBLtLz8GdGh8v
	 XgXjbjYKvw9DrdK7UNGM/FGnpke+KrWqjjAopJfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	=?UTF-8?q?Marek=20Weso=C5=82owski?= <marek@wesolowski.eu.org>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2202/2651] ntfs: require page-aligned full-page attribute writes
Date: Wed, 18 Nov 2026 15:57:22 +0100
Message-ID: <20261118150404.969663378@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 2455958526f9458e2663c079a10e2216131c4438 ]

__ntfs_inode_non_resident_attr_pwrite() treats count == PAGE_SIZE as
proof that the request covers the complete folio. it allocates the folio
without reading it and copies at offset zero. That proof is valid only
when pos is page aligned.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Marek Wesołowski <marek@wesolowski.eu.org>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 213c4a12b33aa..f6bf51c84795f 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3747,7 +3747,7 @@ static s64 __ntfs_inode_non_resident_attr_pwrite(struct inode *vi,
 
 	index = pos >> PAGE_SHIFT;
 	while (count) {
-		if (count == PAGE_SIZE) {
+		if (count == PAGE_SIZE && !offset_in_page(pos)) {
 			folio = __filemap_get_folio(vi->i_mapping, index,
 					FGP_CREAT | FGP_LOCK,
 					mapping_gfp_mask(mapping));
@@ -3769,7 +3769,7 @@ static s64 __ntfs_inode_non_resident_attr_pwrite(struct inode *vi,
 
 		folio_wait_writeback(folio);
 
-		if (count == PAGE_SIZE) {
+		if (count == PAGE_SIZE && !offset_in_page(pos)) {
 			offset = 0;
 			attr_len = count;
 		} else {
-- 
2.53.0



