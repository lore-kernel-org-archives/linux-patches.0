Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3252C1EF36E;
	Mon, 13 Oct 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368329; cv=none; b=OR2avgt5peVRxGCeE/xc11Qinj3GcWDDf8CZqwqSFxG5aMruilaii9oP9VRRH2lRzIapWN1TuLEsWtpsFy2Skkg+M8v1Bl+OnQ2L61KcJRff56ro06bD+wcEFFTnTp6wnTctSTMEmz+CDGKJkkWD56JriaSaNwQGlYkDQwPxE0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368329; c=relaxed/simple;
	bh=Tl53nBm+npSWF/yKe/tkfIvjW7MdvFhRZS79rCb2260=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF9AgK4WOMvwKSPcg0X0iqA4oshP4f/8GbF7AdCwDU24MotUVq9H9SOc8MFwYlpP2GWxNzpzHuM/G7/LCsTwCViCAPid2bQyFOYajs2yiL/3LwNpQeRrEEPpo19n5uZwt/neBVa3xof0eSbi5FU8a1TqNLsdqeF2ychg+31giRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eev3VRcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eev3VRcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47FAC4CEE7;
	Mon, 13 Oct 2025 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368329;
	bh=Tl53nBm+npSWF/yKe/tkfIvjW7MdvFhRZS79rCb2260=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eev3VRcdPGeIKRiUXjvRgLJw2zsz8fUJQyAH4yX7ntL0XBFUVJf8tUKEF3RoTVlt9
	 z3AYEDJNlxCK2nG4Za0bDZYiMO1pq+G2wqul8pDKduCzNTRqS0zcSXmc2bIXZZvmhJ
	 tyqDDmyMcz0fww65DI4kzfDT3z4I8dfTH2fA2HI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Jeff Chen <jeff.chen_1@nxp.con>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/262] wifi: mwifiex: send world regulatory domain to driver
Date: Mon, 13 Oct 2025 16:44:25 +0200
Message-ID: <20251013144330.555419202@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 59bea82eab294..8801b93eacd42 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -684,10 +684,9 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
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



