Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A22554648;
	Tue, 27 Aug 2024 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772735; cv=none; b=GuiU2cFJp3tcPMJHZu2kiv6qgLGytQXLzAlsJ5rxqdAPvl58ajSucs8LUCvbWh74ArIABc29X/O+wf1LyVggEwQZe6rAEuzwVc5+FAQhg3wxbx5MhkqTMnw0XBAozLdUco52deYJjTfa3YghI2e5VfcrQiI/qyb4INxy5zObiEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772735; c=relaxed/simple;
	bh=f372yoSnTnRsbINh56tWoDgxgDyEp/fcfKYYL8ou8MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBuYajN6mjSYmNbIJcObjFpqZyueTHSwWw34HyMdAwnfX5jr2RdPG3KuP8r2PMxOh5TtJTm83KbhkpLfbKtApKOEIrlVA0gKviGE/KDyPjkK38n0MGfxp9pRA+fWiowk+sRcrDxfJoB1CNTfM0geyE/qK0D6Xpm3mhX2ndcdr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzMebNSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzMebNSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B1DC4DDF0;
	Tue, 27 Aug 2024 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772735;
	bh=f372yoSnTnRsbINh56tWoDgxgDyEp/fcfKYYL8ou8MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzMebNSd5egOVkDdMRodiieqVZh9pQa9kUJYcPKOaCEQUANegaZyc2k/akLhZ6XTI
	 GtVSLIP/KzJBp+3Fi1BHkktKqqgIr3zlz72X2AOwbG7epJKCZuzJbyPLGCSc26pxpk
	 OA/IFMbY38oKzrQ6HAJ7MGoLlK+ciTonSEID7IQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 272/321] cxgb4: add forgotten u64 ivlan cast before shift
Date: Tue, 27 Aug 2024 16:39:40 +0200
Message-ID: <20240827143848.604904386@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


