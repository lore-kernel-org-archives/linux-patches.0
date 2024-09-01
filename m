Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66E42C1B4;
	Sun,  1 Sep 2024 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207748; cv=none; b=CxqA+fO/GEJfnnEdg+Hj+roKnngcWEq5Uz29MJdgdM/Y1Gyb0L1VY3NiEGakcA87EVO+sUXg+qwEpgHLRu7UqNG6gnhNwwK7Sq6U1ga0sBmHEQcQYcdhufuGgnfMAOS+KbF3gIjBPln7Y0l14YuTjSsiL3535nOg1dLwRUy9QQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207748; c=relaxed/simple;
	bh=FmtlUBC4dMQWRZIc9vsE6EcpaCZx+ocyLAMtw2Ay0bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+4oCCo81XrfLlqVlax+IgCjC0NOUuXoMZuDgafOCL2cOn7zyd2Lmli0yr6Lm2gO6ETqeQtll82MeBz+YnkmBjkbNCnFjpaDWImcijpF6zzSAIOT+T/9tV3cj0WHZDkZDmC8QNqIBDRyj4n5/8OYp8/imJAKgbu0glQNAIUxWJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8eCpCvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8eCpCvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF14C4CEC3;
	Sun,  1 Sep 2024 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207747;
	bh=FmtlUBC4dMQWRZIc9vsE6EcpaCZx+ocyLAMtw2Ay0bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8eCpCvR91EUs1UIKShEXci8T+CzFtN9WOxGCOJF/ofqFb/j8qNQIeIM0IVJoYfyh
	 Iv2cNIKTv2gtj8kNM8dOCZ/fs6vBChq5BZRUMcRzEZw3PsqhZ4uIoJfroU/+DEfBmr
	 Lsl/mL7UNvln/j7aCEaaENo+gOWbUxqmsxgLmCIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 66/98] cxgb4: add forgotten u64 ivlan cast before shift
Date: Sun,  1 Sep 2024 18:16:36 +0200
Message-ID: <20240901160806.187335284@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 80a1e7b83bb1834b5568a3872e64c05795d88f31 upstream.

It is done everywhere in cxgb4 code, e.g. in is_filter_exact_match()
There is no reason it should not be done here

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: stable@vger.kernel.org
Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240819075408.92378-1-kniv@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -940,7 +940,8 @@ static u64 hash_filter_ntuple(struct ch_
 	 * in the Compressed Filter Tuple.
 	 */
 	if (tp->vlan_shift >= 0 && fs->mask.ivlan)
-		ntuple |= (FT_VLAN_VLD_F | fs->val.ivlan) << tp->vlan_shift;
+		ntuple |= (u64)(FT_VLAN_VLD_F |
+				fs->val.ivlan) << tp->vlan_shift;
 
 	if (tp->port_shift >= 0 && fs->mask.iport)
 		ntuple |= (u64)fs->val.iport << tp->port_shift;


