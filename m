Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0623BB38
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2Lu12Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD81AC433C9;
	Wed, 15 Nov 2023 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076181;
	bh=IW7EPkEu2275zpTaqvvs1A7De5cz7MpCs5Xr5Fk26MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2Lu12QfITRj4NL1cr41Y7YLG46hDrIy3LdxMHxsiG6vK4mD/Sp3q7dXcAJ/HwFe7
	 kJepLbI9grkRQFcTL6f4IiolRcvrduhIYVJfIDXpBXYCJp3qxiANqi3elY0s9sW6/V
	 /LBh7i06Iw6T/IBAGn2pJ+51VGPM3d8YjyFlm7tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 127/550] wifi: mac80211: Fix setting vif links
Date: Wed, 15 Nov 2023 14:11:51 -0500
Message-ID: <20231115191609.492767673@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit e7182c4e6bbeafa272612e6c06fa92b42ad107ad ]

When setting the interface links, ignore the change iff both the
valid links and the dormant links did not change. This is needed
to support cases where the valid links didn't change but the dormant
links did.

Fixes: 6d543b34dbcf ("wifi: mac80211: Support disabled links during association")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230928172905.0357b6306587.I7dbfec347949b629fea680d246a650d6207ff217@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 6148208b320e3..16cbaea93fc32 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -195,7 +195,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 
 	memset(to_free, 0, sizeof(links));
 
-	if (old_links == new_links)
+	if (old_links == new_links && dormant_links == sdata->vif.dormant_links)
 		return 0;
 
 	/* if there were no old links, need to clear the pointers to deflink */
-- 
2.42.0



