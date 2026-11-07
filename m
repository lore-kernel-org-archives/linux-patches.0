Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060764;
	b=34fkCSSEPMTcrilXIHaK6Ji3aRoh/Qk+4+tiPx9JnqJMVg8gPMT06t9e0YwLv2iYK6PP
	 ryeRCLiU1EuJpJvtV8HLodl9aLiZQfOBcEzPM7Z1SP/4r4Yb8KCbQA3FCPYHCthAoCd7z
	 GgFdXbdf/86jNz+fYkyqEhwysCX87/g+3vJfjifub5JtoEe+OY2LB3/OLIkJxuHXj+9Wy
	 wfsBsrw6qPBc7C8DJxtDh/Xci0/F2ku7Nvu6H/NsvRjyDs5TPfCgjhdueXfEfdbvtAmb2
	 cqfVIGyzoU98xT8f9/f8rnNXbO87OlW8pLMPxEYklb6OMc/8HzJkyl/fOkxzbUj66pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wya1U/p1UXzS4wDdjOyJIuSjysjvj/OYBxN6gbo4iZw=;
	b=oF/XF1onxWg0AAukrbmg3pZvSXaeU6aI7rIjwISJ0nXrVXMOKN0Mu0OOMfXPn0x19g/P
	 M5xeflnVQZGwc6fIqI05ySGqdvVqgorArugfyZfWhP5oJ3jGpLRbktt8yThAzVEV89nGF
	 v9O4aimclqxuC3LRACEzr/QXNYm/tUfywTCOl98yCOdJTkzX3LJjHutXqpyIDAG4moZeK
	 z93jINeN/jRxCWXyjxrtl65TpTiKagHUb80EX6Alw37Nde+zUKb10LP1PKfhDrMNf7l9X
	 lB9KNsWlohfZdWfW2v+gGRh2a1rc6BGeGbjx/RJB+Q0L0EvaJQPPseSgJ0JglcDqHbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7CYdTJT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0462606A326;
	Sat,  7 Nov 2026 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7CYdTJT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6681F0089F;
	Sat,  7 Nov 2026 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060763;
	bh=Wya1U/p1UXzS4wDdjOyJIuSjysjvj/OYBxN6gbo4iZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7CYdTJTX1HDOvYKS4yeLtt9Fc9VAkqlV5RKXpAYUwYv6sTMi57dRTv3XGjHiSMUu
	 4p0s6ZXk0ngXDyCz0frJ8XLGNDLrT1UofBMPzIzV+jP7ymUtwmJzTiZ5VG6TlP+7RG
	 MPzKut6owsnQGHUtTW+xR4mXHg77poSIMVyOMFao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0176/1536] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Sat,  7 Nov 2026 08:36:32 -0500
Message-ID: <20261107135002.601676432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ce22d4e98efaa..9df43cd76979e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -917,11 +917,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
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



