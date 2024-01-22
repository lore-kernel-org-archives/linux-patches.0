Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287E5154C05;
	Tue, 23 Jan 2024 00:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969414; cv=none; b=ggeDNeDkhfiM14aMn7xlcRP1Tn5zONH1LtDfL2beF/sjLhmoOFGLycvbkBGipPhTPHp+HFb3PTspsyNqg5VMgKgfsVXQjprBcZZIEEb4aerYj6yVdeBbrAlvQZwV434Iln+63qIy3ls8Fpl2heBJxOF3sBL15xdK/BzMM6uXZRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969414; c=relaxed/simple;
	bh=8rBkDwlF9e2qgUwDgZ7T0758NS4JF/xfyirT5SD37gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0c5QRYaR7UPzoV/QIkikHqTGnqHAmxOT/8JLhOxd8sm7EswvWTFdLA/F5QtiqXK7RamKJpfFsdi7hSpFv14VsDW7ZY1KAmWjSxkJGGKAFzZM6CqOEWMaMQ8fA+NaYimvcygDhIXgpy+gRVY4KOHqwN23481ZTWWS/I7TMA1dlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3lKO4X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3lKO4X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B074C43390;
	Tue, 23 Jan 2024 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969413;
	bh=8rBkDwlF9e2qgUwDgZ7T0758NS4JF/xfyirT5SD37gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3lKO4X9h45ixadWwaWcuMWLmJ41n1LMlFxYzA8jJXmOY+Ew4vSVthgkMVSH15SfC
	 w8CYHZs23N+od1wUWncH2xDsoqGVHhhju6JkcxuTX85YfXdN5LGpJtJaB4zYdg+Xtr
	 bV3lLt+YrvAU3w/0RFkyDfj47ML7qS4qGpki28co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 229/641] wifi: cfg80211: correct comment about MLD ID
Date: Mon, 22 Jan 2024 15:52:13 -0800
Message-ID: <20240122235825.099157078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9e5ccffd6868..8cd3eef76f2b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2647,8 +2647,11 @@ static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
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



