Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041272;
	b=ofddTnKml3b50XrsvVh5ZM7DGqB8gYWRbPWJMBfyMIht4pCZMUEqZinUgz1ibVrWBm7j
	 TFE+zdI2nBazzYnZRGwGVmscw3snUSS1WVwUxC/FcK6qY1eshHZKno6mkmI8L6i6KdQ94
	 kEf5ZgrAH7sU2w0dDMLUE2AcVqJJ4BC2ITjyXtXt7aNWjPtkgEt5398wwCrxhzwJxjZCs
	 uQm/+zAeX1x/c7Os15a6Cn1yO9F6v4VaWop3IrQAZWp4Rn4Sqis6k+pIo6zDVqaqiulcT
	 fVKx8UGT5+wGuIJIimW+BMszflIwooTQ6w9H62wOrtXOcHvd128lZM74vofv2hiYKsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pLYLBI//VahNQuCwQVR9uHA1X/jzENqltyiJq0jsrSg=;
	b=1//+fzMYKgRaW68uw2/XOTK/iYw7OuKDhxYDcKVGYC3lZ6ztfmLl9IYTr4jgzSOSaJ8G
	 DTX2xWv/6FsR2gL+VjiiFFvuSbKaoKsbgfoQuPTAaQZbkHxD8MvepPGDBpW4h2rpCHczO
	 rB70ImczknCiFicBZYkURT0Vc9myRAkqnZMYRLKeC64Xm1PsGk27pgcWHIfT96K9J5b05
	 gqXjNFYcGQFYqgoqbsdyKH69YOYOwMT1N7BwJQcJQKXevpWT+uJZvUlsvgycRakFUuAQE
	 CV2kHvdz2fT9yY2DqcUHEcJ6fzcWzxmQaDM/1nzHQDW9xwiZL7GdsmM5bm7yjpUqrpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXJXlVQN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F78606A31C;
	Wed, 18 Nov 2026 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXJXlVQN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08941F000C4;
	Wed, 18 Nov 2026 22:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041272;
	bh=pLYLBI//VahNQuCwQVR9uHA1X/jzENqltyiJq0jsrSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXJXlVQNmX9RG4aUD7q0Qd4wUZv4WF/DzMeIKIpyvrZsixy/aOBbU9R9o71SDn+cE
	 PjHT73ah383eIFjxWforMn2hMOF1PSsvzAb+MCkIzTwa0ceUqvWvlBhM/G2Ba3Utfh
	 QEkgrOsppzAZvGhgRidLLxEowvuYKJSZ33BcdNo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Simon Horman <horms@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2717/3318] wifi: cfg80211: fix header kernel-doc typos
Date: Wed, 18 Nov 2026 15:55:39 +0100
Message-ID: <20261118150442.370643732@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 98e0c7f85773ab161d804103649b33f8a97cf1b3 ]

Correct spelling of several words.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20231001191633.19090-1-rdunlap@infradead.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 298618f28bd3 ("wifi: cfg80211: reg: protect regdb pointer with RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2343f4c0f1d8e..5565465f146f7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2447,7 +2447,7 @@ struct mesh_config {
  * @user_mpm: userspace handles all MPM functions
  * @dtim_period: DTIM period to use
  * @beacon_interval: beacon interval to use
- * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
+ * @mcast_rate: multicast rate for Mesh Node [6Mbps is the default for 802.11a]
  * @basic_rates: basic rates to use when creating the mesh
  * @beacon_rate: bitrate to be used for beacons
  * @userspace_handles_dfs: whether user space controls DFS operation, i.e.
@@ -2720,7 +2720,7 @@ struct cfg80211_bss_select_adjust {
  * @match_sets: sets of parameters to be matched for a scan result
  *	entry to be considered valid and to be passed to the host
  *	(others are filtered out).
- *	If ommited, all results are passed.
+ *	If omitted, all results are passed.
  * @n_match_sets: number of match sets
  * @report_results: indicates that results were reported for this request
  * @wiphy: the wiphy this was for
@@ -2754,7 +2754,7 @@ struct cfg80211_bss_select_adjust {
  *	to the specified band while deciding whether a better BSS is reported
  *	using @relative_rssi. If delta is a negative number, the BSSs that
  *	belong to the specified band will be penalized by delta dB in relative
- *	comparisions.
+ *	comparisons.
  */
 struct cfg80211_sched_scan_request {
 	u64 reqid;
@@ -3596,7 +3596,7 @@ struct cfg80211_update_ft_ies_params {
  * This structure provides information needed to transmit a mgmt frame
  *
  * @chan: channel to use
- * @offchan: indicates wether off channel operation is required
+ * @offchan: indicates whether off channel operation is required
  * @wait: duration for ROC
  * @buf: buffer to transmit
  * @len: buffer length
@@ -3714,7 +3714,7 @@ struct cfg80211_nan_func_filter {
  * @publish_bcast: if true, the solicited publish should be broadcasted
  * @subscribe_active: if true, the subscribe is active
  * @followup_id: the instance ID for follow up
- * @followup_reqid: the requestor instance ID for follow up
+ * @followup_reqid: the requester instance ID for follow up
  * @followup_dest: MAC address of the recipient of the follow up
  * @ttl: time to live counter in DW.
  * @serv_spec_info: Service Specific Info
@@ -6728,7 +6728,7 @@ static inline const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
  * @ies: data consisting of IEs
  * @len: length of data
  *
- * Return: %NULL if the etended element could not be found or if
+ * Return: %NULL if the extended element could not be found or if
  * the element is invalid (claims to be longer than the given
  * data) or if the byte array doesn't match; otherwise return the
  * requested element struct.
@@ -6875,7 +6875,7 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 /**
  * regulatory_set_wiphy_regd - set regdom info for self managed drivers
  * @wiphy: the wireless device we want to process the regulatory domain on
- * @rd: the regulatory domain informatoin to use for this wiphy
+ * @rd: the regulatory domain information to use for this wiphy
  *
  * Set the regulatory domain information for self-managed wiphys, only they
  * may use this function. See %REGULATORY_WIPHY_SELF_MANAGED for more
@@ -6966,7 +6966,7 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
  * Regulatory self-managed driver can use it to proactively
  *
  * @alpha2: the ISO/IEC 3166 alpha2 wmm rule to be queried.
- * @freq: the freqency(in MHz) to be queried.
+ * @freq: the frequency (in MHz) to be queried.
  * @rule: pointer to store the wmm rule from the regulatory db.
  *
  * Self-managed wireless drivers can use this function to  query
@@ -9182,9 +9182,9 @@ bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
 
 /**
  * cfg80211_assoc_comeback - notification of association that was
- * temporarly rejected with a comeback
+ * temporarily rejected with a comeback
  * @netdev: network device
- * @ap_addr: AP (MLD) address that rejected the assocation
+ * @ap_addr: AP (MLD) address that rejected the association
  * @timeout: timeout interval value TUs.
  *
  * this function may sleep. the caller must hold the corresponding wdev's mutex.
-- 
2.53.0



