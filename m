Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033829;
	b=4H878fXtWwDhBt9weHb4qnOrcSBadtNkPggZ/oeBmimjplC8Y37oJ52Cex+7VOebFm6M
	 zLJUJmWYQFPGA3wJpAbBZWgYJN8aT6y3VzGYmv/WOdDeqwl05gJSeZLBuelIjaOSYovRS
	 U/siap6v6D51GW+8f3nBx5BhZPqTmgHUbO7kBHxsMcDYTWHy7uvADuEzUBRQ9uiHcVM9S
	 P0QkYXXMonhf4zI1TufT6zSgI+/qhM70rO3BoF8/OXXAS0YDewb5IkaMkVet6fkG255iv
	 erxbC5iyzH9u3sxh9+MnZ7dC0Fy2JGhzsBS136oLAC0b0cuNb3mWFY7MjPDpPeDP8bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Q5yhRuewQIYid/dUrBDnBlXnWe2ek6N/DAiOq78SBg=;
	b=TM5VNVc4XMhf5ra05GIm2KiymWSkYaIrbD8afb1784RyZ1QyLSk/hZj0reUFc9ztDO9M
	 C8miDdBtpL20FW3axiScc6EgpwhMYjLIXOfbY02qtZEGxU8l2BRg/avPzC1eBlzcBUIEn
	 ym4amT27bjPey09W5NUZwSXt1pc50vKzhN59b4fRtfhenjw0AbJYO/2RLFReOaIgfMbON
	 KtsKZIF2yHyA1geuy+nwTFyniznl19wggIyQgIUZ+lgg2MdcUSQ1Guj4ihouVvTMJCZMt
	 QYMs3vqKu3PQjdBSsgNVcihihjMcieC2+sr62WAtcB8tysN44gm7GrX4uey5UG6DLIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxEDqLgr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FFF606A32A;
	Wed, 18 Nov 2026 20:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxEDqLgr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CD61F000C4;
	Wed, 18 Nov 2026 20:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033828;
	bh=6Q5yhRuewQIYid/dUrBDnBlXnWe2ek6N/DAiOq78SBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxEDqLgr81IwRChmj9GONKaRqNjmGYRRYVBZ/J/qBUyNhEm00ar3Tvw3wyDHxc2Tc
	 KErhwDZWlHu3F+EgcSSE4tdxb01MEy+/zFWAMWQDqQ3Bznj48WCie3dr6boJ6dxmBT
	 /nWwRHBmkHrqLAxb98DImxxH7tTh6XZX9NgwxMEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0152/3318] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Wed, 18 Nov 2026 15:12:54 +0100
Message-ID: <20261118150319.083276400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

[ Upstream commit aa4c0a649903567762edf2bbc7fff608953b3ca4 ]

The function was reading reason_code from the frame before validating
that the frame is at least IEEE80211_DEAUTH_FRAME_LEN bytes long.

Move the reason_code read to after the length check so the field is
guaranteed to be present before it is accessed.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715212706.db26604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2474feb149b3a..a0f6ce86afe17 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -934,11 +934,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
 {
-	u16 reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason;
 
 	if (len < IEEE80211_DEAUTH_FRAME_LEN)
 		return;
 
+	reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	ibss_dbg(sdata, "RX DeAuth SA=%pM DA=%pM\n", mgmt->sa, mgmt->da);
 	ibss_dbg(sdata, "\tBSSID=%pM (reason: %d)\n", mgmt->bssid, reason);
 	sta_info_destroy_addr(sdata, mgmt->sa);
-- 
2.53.0



