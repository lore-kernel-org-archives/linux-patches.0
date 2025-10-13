Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFCF309F0A;
	Mon, 13 Oct 2025 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367153; cv=none; b=AvBBOFD7IYS8D1ipWkmhIBOjSV2U5HNKne4Y4s87Iq72cqFTKMz0R/kCBGnyPzSPdrpTYkNvGhxdxl0p4Phu+OTVwGI3i5PvBRmZF3uHwvLL3YSgyd1HUahAPJd4sjQkv5wCmHNGJn/6vx9du8dMSaHGOBoU2E8GQ6R5j0VAjk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367153; c=relaxed/simple;
	bh=l5Q1HNxPkcqgZ1lkEGrjSv1asNVw+i33zN9lSSTmQ3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9azy5S6A0cSGEXsn2Pla7nfZDKftdyNazKSK6aay5OwWmBJirIhY/VdNtVIAmvo+EVrv4G7ajarh51CZKJrogizx5AwJzaTs4RpldWXh848/Y19gp9Xe4qV46VZUPVwX7vLOWLoCGswTDVj2JvMie9xCUp0SrBvDYZQ/7Zv5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hey5XJRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hey5XJRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEF8C4CEE7;
	Mon, 13 Oct 2025 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367152;
	bh=l5Q1HNxPkcqgZ1lkEGrjSv1asNVw+i33zN9lSSTmQ3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hey5XJRjj1SyKmXoVywxsY3rCM9dDFAgqSUHBYwII114/z2Y7VexS6Nzb6azqfgq3
	 omgVM8umJfMlSLKfMSIjU/Y0++P5JctubZ6BEsNPKxreUWZ5lMOdxJhsyBANkVt1rP
	 GrJV7TQs6oTjoC63cxhxylKCeZuYMvriWbTRW8Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Jeff Chen <jeff.chen_1@nxp.con>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/196] wifi: mwifiex: send world regulatory domain to driver
Date: Mon, 13 Oct 2025 16:44:43 +0200
Message-ID: <20251013144318.678300558@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Stefan Kerkmann <s.kerkmann@pengutronix.de>

[ Upstream commit 56819d00bc2ebaa6308913c28680da5d896852b8 ]

The world regulatory domain is a restrictive subset of channel
configurations which allows legal operation of the adapter all over the
world. Changing to this domain should not be prevented.

Fixes: dd4a9ac05c8e1 ("mwifiex: send regulatory domain info to firmware only if alpha2 changed") changed
Signed-off-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.con>
Link: https://patch.msgid.link/20250804-fix-mwifiex-regulatory-domain-v1-1-e4715c770c4d@pengutronix.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 5e25060647b2d..3b9b75eb4cdb8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -659,10 +659,9 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 		return;
 	}
 
-	/* Don't send world or same regdom info to firmware */
-	if (strncmp(request->alpha2, "00", 2) &&
-	    strncmp(request->alpha2, adapter->country_code,
-		    sizeof(request->alpha2))) {
+	/* Don't send same regdom info to firmware */
+	if (strncmp(request->alpha2, adapter->country_code,
+		    sizeof(request->alpha2)) != 0) {
 		memcpy(adapter->country_code, request->alpha2,
 		       sizeof(request->alpha2));
 		mwifiex_send_domain_info_cmd_fw(wiphy);
-- 
2.51.0



