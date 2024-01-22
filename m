Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820764AB0;
	Tue, 23 Jan 2024 01:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975043; cv=none; b=U0NPVTOqecjP5ToAf5xkE6Jb3f7GHMrECdbGiP739sbZYg5+Zyv299twA2mlGQ5gG1jOA5TGrMQDB431t8DcqM9zZQDTfwtcvub84fhRUf2xioxpnxFLtaOAG/HNvhIoV/BMIL+Jm4caxJ1oUHmtiyFqRzztyVmt3AP10gWQI4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975043; c=relaxed/simple;
	bh=xLOrwr0wwJ7+K2bXnvjoRxNTvCF2O/Basxsdn5YuYZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvU6az81YBFh5TX/8NOA3O2wLreWDWidMcSAcOToqmy7L3N8u7WI3BzJl7zrcAbLIOUIe8b5TYphch7NXC53V89tGiKfp0DTidwB0rXuooeFnFlg+lMJ5mErre2C6f8pTCDh1lv0L4JXYDlldwgTgovLdT48Pvw624V+bbYgp8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECe0++FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECe0++FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE2BC433F1;
	Tue, 23 Jan 2024 01:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975043;
	bh=xLOrwr0wwJ7+K2bXnvjoRxNTvCF2O/Basxsdn5YuYZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECe0++FDbf+lBDBWBNy0d/UuAMvLMbYaPYim42TXxvMLgj9GyhxWe79ZYpdbie01J
	 UZmBEaHv64VhHrQehXnk05zyVeVg+bX9ksS+MTUhdy49xh2Dnu8xwlL1+uidAhj9n6
	 1d62caRIfwTmkHEZ95c2hxj/5uont6dnziqz6iBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/583] wifi: cfg80211: correct comment about MLD ID
Date: Mon, 22 Jan 2024 15:54:21 -0800
Message-ID: <20240122235818.430319540@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 2a0698f86d4dfc43cc0c1703efb7ba6b1506a4e2 ]

The comment was referencing the wrong section of the documentation and
was also subtly wrong as it assumed the rules that apply when sending
probe requests directly to a nontransmitted AP. However, in that case
the response comes from the transmitting AP and the AP MLD ID will be
included.

Fixes: 2481b5da9c6b ("wifi: cfg80211: handle BSS data contained in ML probe responses")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240102213313.0917ab4b5d7f.I76aff0e261a5de44ffb467e591a46597a30d7c0a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e4cc6209c7b9..a7d7469b10a4 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2625,8 +2625,11 @@ static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
 	/* MLD capabilities and operations */
 	pos += 2;
 
-	/* Not included when the (nontransmitted) AP is responding itself,
-	 * but defined to zero then (Draft P802.11be_D3.0, 9.4.2.170.2)
+	/*
+	 * The MLD ID of the reporting AP is always zero. It is set if the AP
+	 * is part of an MBSSID set and will be non-zero for ML Elements
+	 * relating to a nontransmitted BSS (matching the Multi-BSSID Index,
+	 * Draft P802.11be_D3.2, 35.3.4.2)
 	 */
 	if (u16_get_bits(control, IEEE80211_MLC_BASIC_PRES_MLD_ID)) {
 		mld_id = *pos;
-- 
2.43.0



