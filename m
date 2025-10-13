Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4702F5A37;
	Mon, 13 Oct 2025 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367670; cv=none; b=tUsfbxD3d7DvS8FUxiYmgn8/Bw38SiT2zJ5Tr+yJFdQTmlDv/Qhpbq0O5mppeKHHMJwIjCgNaZAOMzHXYsRBGyokTNHGxiFzrrW9NiOICwNnXYil2i07DBCV9z1pXb/eHrTD2C+0d8Jd9m2fipU9IQ2x0s41dcmbQxGho7aCtac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367670; c=relaxed/simple;
	bh=Fn2dWrSR+WpwQ8lL7XtJCapCss+ym1mFWXIdpOjG/iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukdzC6f4j8Kvz+bm89DG15IcNmwign3X0BWu9d+Cx0VR+TJkMv/+meXME2yneLsSIoB1G9wYo/ThWo+Y9K1vgGuLBXIg1F710W4FbCaKCDW/aovIfEsZ5rFFup5wexZjjuZgEohy2h87tFguJP0IGBQTn0U+V4Gq0HdF6CVNPUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6lww2gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6lww2gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB560C4CEE7;
	Mon, 13 Oct 2025 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367670;
	bh=Fn2dWrSR+WpwQ8lL7XtJCapCss+ym1mFWXIdpOjG/iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6lww2gi4CbVfnAh00cpwFAqdZcmpZ5bvMqQa96PwOB672r+7kBZm8Cd+q7OGM77Y
	 ZD4rI/T1znNmekGPiw+zhk/ZyodI3RNiRRns4VyWGVpAAnkoNdxT3SBx1MJZZROKIP
	 jf4blUh1wqfYg8jPSpdH8Hym8+Gu9d4tYil8H4IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Jeff Chen <jeff.chen_1@nxp.con>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/196] wifi: mwifiex: send world regulatory domain to driver
Date: Mon, 13 Oct 2025 16:44:43 +0200
Message-ID: <20251013144318.644363055@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 69eea0628e670..df6e4a112ec48 100644
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



