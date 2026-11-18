Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043223;
	b=lYhxsKvlb/b4q+2e9+18+icPVt/WyWZmPFUI8ebYaHqDeq+JzVJMZjOkxa4+/7YSpTMk
	 0wD2sWjffr+NN2LQe86t1udue+VCr+ci4b3ZV3Or123n5A934wK5UAMe/yxjEdxwRR65H
	 3muApQlg3AR9ufXyCD2MX46JIvkuPykwKOr/YpVsYMSbw07y7dMZUXqFTV512G36NR1qD
	 ejXciM99geLnSOmxPTouM21v2bhIlz41el5/N926qfjFGW9Cd9qw0mZSJzBgTyXi8yeYM
	 1dg0M58gXjfSDVENlmMPFHX1dPYvx3TQ9e7Sk1ZxjbBkWLtUxnSRKaSs0nIs/D8Jmkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5zIhrJpq6WpWaLvK6sj4amgpeMQsh5nVVKeVIpqd0no=;
	b=E7/wNAIdrLuIR2MVy6sibXEe6sHMcJuuOkV42HEqBvGYe2aOJPJsSryLNymf1/Wl0GqG
	 +ryp1/SuWbrqc3qqcDKN2y6XyRy7x6H0BBLarPiRA797yXboFdCBYI36IcipVL1q3fh+z
	 LC5OZpya2T4DNJquuIbtuvTttmBeXgrIm1ANipVUnl099x8IADCbA1h1s9lvk5ePdVuJJ
	 qNTQVfETLzydrIAn5JTUBmH72Bjn/zqU/6m6YWRE16u8/oKulMUITLrCHdtWuubReeIH9
	 kDPDnZWKixzIkBRUqRWr/riW/xWNOA4Lao8gVAfDG04mgzE/phQZjBLV+o5Iy6G46Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UsGQ3jOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8064606A325;
	Wed, 18 Nov 2026 23:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UsGQ3jOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E11D1F000C4;
	Wed, 18 Nov 2026 23:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043222;
	bh=5zIhrJpq6WpWaLvK6sj4amgpeMQsh5nVVKeVIpqd0no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsGQ3jOd+vLT9Z+XvM+6Vw6g/cP/CpGvD11rtZ/QxM17mGdgYBVyCK1bBj8iGVQgM
	 6d0N7O46hgCbfhnh5sosMSyQcT9d5EZT5yvLT4PK1CvguR+GQbQlA3VjcbCU+6urNO
	 +xziBmPeHSoDeEPXXEBQrwM4c04VwqQcNqY56OUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0133/2857] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Wed, 18 Nov 2026 15:19:27 +0100
Message-ID: <20261118150206.138694271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f2d4c68cf3aa2..1fd4a918bbbc2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -930,11 +930,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
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



