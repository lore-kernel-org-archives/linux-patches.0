Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215373;
	b=jc/C+/amVd32YjUIVD11cXOptbiOfbjeKnZR1vGWziyq5k8xkEagxCL+Vhn7SsXlckz6
	 mldmIV5Gl4ILmWfWNDwUEsp1mZBi8CAJkRReWDdPq+27JG2UpcD6cf5FgECNYAYSCPAh6
	 9WixJjXDLGRaSQPehO7BCkdIZWJiwGox0rJxJuFamoi1fvIT8loXBTMGy96g1wbUsHYrY
	 X2LYBjqCAZcRJArzTXHZaS1e7b+L0+3K/6/RGTYDDTvjno5fq03yRTRrbY6Lo6KPNe49Q
	 q3XR/CwZSzuOEY9g7l/AlQYnF9i4kRJ15NowZ0cngqn6H5q1CraR7ToUsnX20yXfm6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQADxRhPoEKrIz6XrBuQJ9C/kTmLEtzqqvakSqChlFI=;
	b=IcdtQbo4lcTmtfDQ/0aIrwhgUR6lFUEhqqTAo4GnMchLC5mYgMgThocq9D5GIS9FLBS6
	 fdoHtpB3MMITnbjLKRfpvXOwGubHQAZKalRYufM4aE9ZRdBl56JHGScT1LTEwAq19klsM
	 WoFqNT8K6d/ypADI4YTT+HRN/dgZ0EeOs0VXLiNEQVcTqBGe3zTzMCJeQfp8WYXjUZZNG
	 PD42lD+sEb8Emx9AbV9fVye1BRqlwof5yJaTDkuke+A/1GdR/GtyprJ3EAMZns4381nUo
	 GEDlqx/V5Ms74U1oCZyHqWMthf7rFMAGVuFsJn6syI1IFWlzMx5Q8Jf7jMg5eh8z+4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqKT0h0y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC41E606A31A;
	Wed, 28 Oct 2026 19:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqKT0h0y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C41F01825;
	Wed, 28 Oct 2026 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215372;
	bh=FQADxRhPoEKrIz6XrBuQJ9C/kTmLEtzqqvakSqChlFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqKT0h0y/u7Ybz1k5cT5aX/f4CWcdCUIGczXfO5JSTRvfkzJo/gmYj1/+JstpOYBd
	 /bMTi0SKi0z8QdW7GXYSIx+Lbp3nxVoeJd+hbhd2NWmOzF2klkOEuYHFI1bZViCT/G
	 Ahohme+2yTF0YltceK3Uy0KXDCJ1VrXDmyLlds0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1189/1887] wifi: cfg80211: add link_station_info structure to support MLO statistics
Date: Wed, 28 Oct 2026 17:54:45 +0100
Message-ID: <20261028170526.461909158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit d2329fff7e527e8b350086be2e7cbf0d190177a3 ]

Current implementation of NL80211_GET_STATION does not work for
multi-link operation(MLO) since in case of MLO only deflink (or one
of the links) is considered and not all links.

Therefore to support for MLO, add link_station_info structure
to account link level statistics for station.

Additionally, add valid_links in station_info structure to indicate
bitmap of valid links for MLO. This will be helpful to check the link
related statistics during MLO.

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Link: https://patch.msgid.link/20250528054420.3050133-3-quic_sarishar@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: aa2eb6252518 ("wifi: mac80211: defer link RX stats percpu free to RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 101 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b04d249550fe4..691d328e0507f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1858,6 +1858,99 @@ struct cfg80211_tid_stats {
 
 #define IEEE80211_MAX_CHAINS	4
 
+/**
+ * struct link_station_info - link station information
+ *
+ * Link station information filled by driver for get_station() and
+ *	dump_station().
+ * @filled: bit flag of flags using the bits of &enum nl80211_sta_info to
+ *	indicate the relevant values in this struct for them
+ * @connected_time: time(in secs) since a link of station is last connected
+ * @inactive_time: time since last activity for link station(tx/rx)
+ *	in milliseconds
+ * @assoc_at: bootime (ns) of the last association of link of station
+ * @rx_bytes: bytes (size of MPDUs) received from this link of station
+ * @tx_bytes: bytes (size of MPDUs) transmitted to this link of station
+ * @signal: The signal strength, type depends on the wiphy's signal_type.
+ *	For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_.
+ * @signal_avg: Average signal strength, type depends on the wiphy's
+ *	signal_type. For CFG80211_SIGNAL_TYPE_MBM, value is expressed in _dBm_
+ * @chains: bitmask for filled values in @chain_signal, @chain_signal_avg
+ * @chain_signal: per-chain signal strength of last received packet in dBm
+ * @chain_signal_avg: per-chain signal strength average in dBm
+ * @txrate: current unicast bitrate from this link of station
+ * @rxrate: current unicast bitrate to this link of station
+ * @rx_packets: packets (MSDUs & MMPDUs) received from this link of station
+ * @tx_packets: packets (MSDUs & MMPDUs) transmitted to this link of station
+ * @tx_retries: cumulative retry counts (MPDUs) for this link of station
+ * @tx_failed: number of failed transmissions (MPDUs) (retries exceeded, no ACK)
+ * @rx_dropped_misc:  Dropped for un-specified reason.
+ * @bss_param: current BSS parameters
+ * @beacon_loss_count: Number of times beacon loss event has triggered.
+ * @expected_throughput: expected throughput in kbps (including 802.11 headers)
+ *	towards this station.
+ * @rx_beacon: number of beacons received from this peer
+ * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
+ *	from this peer
+ * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
+ * @tx_duration: aggregate PPDU duration(usecs) for all the frames to a peer
+ * @airtime_weight: current airtime scheduling weight
+ * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
+ *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
+ *	Note that this doesn't use the @filled bit, but is used if non-NULL.
+ * @ack_signal: signal strength (in dBm) of the last ACK frame.
+ * @avg_ack_signal: average rssi value of ack packet for the no of msdu's has
+ *	been sent.
+ * @rx_mpdu_count: number of MPDUs received from this station
+ * @fcs_err_count: number of packets (MPDUs) received from this station with
+ *	an FCS error. This counter should be incremented only when TA of the
+ *	received packet with an FCS error matches the peer MAC address.
+ * @addr: For MLO STA connection, filled with address of the link of station.
+ */
+struct link_station_info {
+	u64 filled;
+	u32 connected_time;
+	u32 inactive_time;
+	u64 assoc_at;
+	u64 rx_bytes;
+	u64 tx_bytes;
+	s8 signal;
+	s8 signal_avg;
+
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
+	s8 chain_signal_avg[IEEE80211_MAX_CHAINS];
+
+	struct rate_info txrate;
+	struct rate_info rxrate;
+	u32 rx_packets;
+	u32 tx_packets;
+	u32 tx_retries;
+	u32 tx_failed;
+	u32 rx_dropped_misc;
+	struct sta_bss_parameters bss_param;
+
+	u32 beacon_loss_count;
+
+	u32 expected_throughput;
+
+	u64 tx_duration;
+	u64 rx_duration;
+	u64 rx_beacon;
+	u8 rx_beacon_signal_avg;
+
+	u16 airtime_weight;
+
+	s8 ack_signal;
+	s8 avg_ack_signal;
+	struct cfg80211_tid_stats *pertid;
+
+	u32 rx_mpdu_count;
+	u32 fcs_err_count;
+
+	u8 addr[ETH_ALEN] __aligned(2);
+};
+
 /**
  * struct station_info - station information
  *
@@ -1924,6 +2017,11 @@ struct cfg80211_tid_stats {
  *	received packet with an FCS error matches the peer MAC address.
  * @airtime_link_metric: mesh airtime link metric.
  * @connected_to_as: true if mesh STA has a path to authentication server
+ * @valid_links: bitmap of valid links, or 0 for non-MLO. Drivers fill this
+ *	information in cfg80211_new_sta(), cfg80211_del_sta_sinfo(),
+ *	get_station() and dump_station() callbacks.
+ * @links: reference to Link sta entries for MLO STA, all link specific
+ *	information is accessed through links[link_id].
  */
 struct station_info {
 	u64 filled;
@@ -1983,6 +2081,9 @@ struct station_info {
 	u32 airtime_link_metric;
 
 	u8 connected_to_as;
+
+	u16 valid_links;
+	struct link_station_info *links[IEEE80211_MLD_MAX_NUM_LINKS];
 };
 
 /**
-- 
2.53.0



