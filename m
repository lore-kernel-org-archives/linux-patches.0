Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C81A072D;
	Tue, 27 Aug 2024 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771610; cv=none; b=VNxUWoKQilpg4br87dAHoBOElK+UGwepraDztzCSOTTOBNB8MOUnMduCaaStGLPMHurni6GYeUvxFy/9/mjuqPif0JE7Zd/7vKy3WdmZ0JXT+CLe92XqFM9dCa0WJebEAh+5u2tJhtKcNWyFAmvnAkhW2kjGXlJU+eSXD3qrAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771610; c=relaxed/simple;
	bh=aH7LIceNVI7ohKujbTXnCkxuq+3NRo5bTuz6/yURVRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGh8Sxgfan2dTqGU/3gchPpaRlykgC1QwqzxEzdHKGYZR0sAQC3aPovQI1MCb421EMcbZpN696HG4ly+XzGoUNRUzJXl8c47/JAx9D61IODafrNWs11LjUJ/al56W2WgyP7cHQpGLazE8bTOoiKwTv4CbJ00xv7BBrGm7/7R/Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkB0vxZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkB0vxZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BBEC6105E;
	Tue, 27 Aug 2024 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771610;
	bh=aH7LIceNVI7ohKujbTXnCkxuq+3NRo5bTuz6/yURVRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkB0vxZtBoFdvn307Cmaby0oBmrGsc62cXy16D4nFV1R2uFkcbcmuZRSZT6yy7iFa
	 7fOxXLud9+6SQ9VgbHb34OyA/XV2ksEs1bUfymqCkFILjNTP8/Jcr1B8IKpEExIdCw
	 3rlcPrkp0JpztMc8m8sLk2EoF9SqdSYPZKwlntmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 241/273] cxgb4: add forgotten u64 ivlan cast before shift
Date: Tue, 27 Aug 2024 16:39:25 +0200
Message-ID: <20240827143842.574580125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


