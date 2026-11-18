Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057358;
	b=XxO+FDxZs/XkJyyEhcKY0PwxwcpgSR3Rk4VPJnOf1nZApZrAxmyuJnlaamvaCTRWk28E
	 tIfNyt3jxXrAduedW+EJO305oIxs3DjQZOz6VKNrYo9ut71O+zrtqF127o1WCrh5+1oxA
	 AjOOzHm7sCl4YKu4ZTWNYC2h5/ANHhoAqPtI/H/d5elZxaD2qDwgcav+KngHnr7+VFaxN
	 Ku+lSkPuQ4vgvJnDC22buA4wrWxdRrNaiYcu6qfATtgVPaYUNkeyfJ3r4xLVnSrTIDDVt
	 LATKjwPvFuLTwy0nGaBMTGxCryMF/5MdT4jXSKlUDrGkw90/YJ7iiSJmOTHNjmY696A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yz18pinGgqhv3rNGZ0hul3KR/DlCXa45ak62PCKou6c=;
	b=QKs3OwF6ImYF82c0XmtJwiMbmeVShE6cv5edcHBi0yuGLLThLY/P4XsZkB/QR15Jp42F
	 8CM4l9DdxgFHJM/JrfkflVjIZ9ENfc4QhymJftXmrb6lWvpDAkUEMopbteLM+ygzGE0hb
	 Tlutianlsxc8gZeFLA20Wq2/aGMJnEP41wYrEOp+yXFzZNoIRo64JvAAPZ+sglSfviHb1
	 7oJreGiKqCzJBXLBxCjEZjl0Xzv9NSuc69i/tqkf5H7rI0rokVGZRWaB1VSdBC5oiXBvZ
	 rXXFm/5AOGLXgQ2CDviyKGdVeHyA7uCwbnrWDJObAUUNfujse/zc25Xanj9MgUQWEaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkOYjNkA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C51660A2616;
	Thu, 19 Nov 2026 03:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkOYjNkA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3041F000C4;
	Thu, 19 Nov 2026 03:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057358;
	bh=Yz18pinGgqhv3rNGZ0hul3KR/DlCXa45ak62PCKou6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkOYjNkA2M57xi5XDjLe4Ko1ujkmZTkP7GM29eozMCjTtcFA4PcM5RRp4W5pi4yk4
	 A0oM+mRla6APYroGXfiZ9CD7Qid4hRpLB7cTiSenfV+svEobLj854WtcmZqt5qBuGc
	 HIPlOjuvEMdqHaTOEfpn/4SLMOqsJx9/jH35BIYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0103/1848] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Wed, 18 Nov 2026 15:35:41 +0100
Message-ID: <20261118145915.364749791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 78ae58ec397a0..936b688430e75 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -942,11 +942,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
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



