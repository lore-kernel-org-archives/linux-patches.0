Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B8B2C6AF;
	Sun,  1 Sep 2024 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210355; cv=none; b=q6YPcPnZw6c5aLeUOhd1/XkiUYuqeSFydCuKhgjL00jy9h8Ca1uk1moQS0lbC5zzN9/jqKHljnH6zUje+zzM+azesr1GEWnLGkzm505T6DOz1nyldtZPnTFZdantCcV+sRr87rMZ5pvKoxEF+z/Gh9XF+GYiwIYnX7e5yHx7cr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210355; c=relaxed/simple;
	bh=Jf+a7TkU8k6cmf2Zmvmlct+VOpW28MQXEP2aaPllO18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSjNlbaek23UobAzqC8COHWWuSEP5kBGbBkP7TL9Je6TM0eatx4l5bBhHPxP9/iskFs/+proncC79jqqK7EOzlEzoDKus4cEXEbF5zpa8+Si66yStfaXcLQYx5qpZ8cSfrA74b3HJmJP0AwQS7a200owv+FK94GmDQJX5J57vgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbVecV/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbVecV/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A30C4CEC3;
	Sun,  1 Sep 2024 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210355;
	bh=Jf+a7TkU8k6cmf2Zmvmlct+VOpW28MQXEP2aaPllO18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbVecV/uwk5Y5JfBNBmtQq3L962pKX75KRrtBQUaoABUTHeGjMXdZ4RLah79qF+gq
	 5r7HUGQxwsgNTXHCOlZRTj89ROtLbFETXqfip2yLYc7IobaXalsZpopER72PHBHe1S
	 agLszqAKrLoEwamazlh9KOmuGdSLYHdeaew7IVvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 164/215] cxgb4: add forgotten u64 ivlan cast before shift
Date: Sun,  1 Sep 2024 18:17:56 +0200
Message-ID: <20240901160829.558129125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1244,7 +1244,8 @@ static u64 hash_filter_ntuple(struct ch_
 	 * in the Compressed Filter Tuple.
 	 */
 	if (tp->vlan_shift >= 0 && fs->mask.ivlan)
-		ntuple |= (FT_VLAN_VLD_F | fs->val.ivlan) << tp->vlan_shift;
+		ntuple |= (u64)(FT_VLAN_VLD_F |
+				fs->val.ivlan) << tp->vlan_shift;
 
 	if (tp->port_shift >= 0 && fs->mask.iport)
 		ntuple |= (u64)fs->val.iport << tp->port_shift;


