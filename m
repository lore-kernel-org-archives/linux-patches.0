Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051185;
	b=L9jL2MmLo/dQWPuh/S63r+qMWu9xuGQjrWNrlZy/nN37lOxOinSoT8LDm45kKC/mvykc
	 QpGJBEwGfv4DPO8knaieWS5/ea+y8yOKqoYWlx0GAsc68oa+fH3yJl4w3eAnTpNH72wxs
	 Hca59Og41HNdfowOwNpG1+qqHfIJl98xaGObFvxCYFY5OAWmH+LwRfEWuA5YbD29hWz5V
	 1SxyMHvtjAV4wJOPOm+qUPO5rz0ouUwcmpmGG/kK7CI/W+BBXqZaphCAWAbsFjVdtWiOn
	 Vez4v97hOjXi15bqeJjIrH9N3hhx5MaMUbTSOtdvmk7KShHtQ2f2nOdRbZxj5gnbF8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=npsm3m4FW1hVQ7DC5wrsJ63sChpIpWyk51Anc3Ic0yc=;
	b=me2sSLujsXgQpcHAeUyIxJuDhnTPS930gJNVzHX2fshjRn/IO705FAQgRj6sJUSWOq/6
	 IFmrOoYLO2/2KWpqcxP+r5mnZc6BNFtQp5Ax4d2x1P6p0yqCkV7x0ARgeaAzlmr9WpQqi
	 J8ycmbpxDcekuQjK3NMumhzhHyWvOPoZOBfk0/n6w4tAHFm1Cvh0pd+6kDsq+rOPTGlTl
	 NCQrq8M10FHbNFEC4dSWHyBf/m4+8P88nxJrtFIqy9OsSG+gu7MDvv2a20q7Q69NsQbgV
	 6yo7RJQKJVPShtRHq8Jf5izeVzYeXGOtFXr556jSg7qE7vKmPaIKrNfjHU9/KBm1PlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNNTreoe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAC6606A325;
	Thu, 19 Nov 2026 01:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNNTreoe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA55A1F000C4;
	Thu, 19 Nov 2026 01:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051185;
	bh=npsm3m4FW1hVQ7DC5wrsJ63sChpIpWyk51Anc3Ic0yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNNTreoejYEuvrhgXYvqEb5V6h7MrOvQHfFLE9MxN4tJNbmBq35L802jiwMU+jbvA
	 rFwnrVlx2tRL64c+wfeut9ESVlHU0OYv8+QAfPfcKq1vd41BR1ZRbI8FiDEtRWLwNq
	 izTFEhu1KFVot7dp75rwst6f+Pz3/y2GrYFyaD8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0118/2214] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Wed, 18 Nov 2026 15:29:54 +0100
Message-ID: <20261118150014.734813956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ce927c16a9154..13fa4d64a84d9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -935,11 +935,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
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



