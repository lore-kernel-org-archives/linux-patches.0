Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620075;
	b=Ap/Etj0/jL54X1wVR+eE1ZAbwT9b4EmVmZLJ/5O7aIQ1T/FtRAYtRvnGJWYYHchl3IeG
	 5F1nzerQp7T7phWPzNhxRtV3ybUcMj5y2FjBGF2sJcuWbMUXGEsJdivsTy5Vo0UgCDl39
	 oaVBLcVjgAhUFMvcWgHT8uH+ZiZeYpH9SWYC87ejhdfqf7Cro2Hty0QZXsFYNWMkYpzBe
	 LfSaD5BdIMeqTLDZ7ninKB92Qbr5cQcVJDAlj/NqvGMnTYE+Le4DSutVgC+jXhx4VWcSl
	 cTAdiv4Nn6WzTzAv+fvR7f/VzwH0H/x0sD5wcaelV6/IqYUnYHB2WZ7PVm7pwOfJRug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RPu9n3eF+ZegXdM9ue8AS0t5z0kzguNrpmI9DaW64HQ=;
	b=Ugj/w+xq3hKgRpL4YP6AV/CNUIOATpXGDf5tDRaI+QMCJj1HEABqkHWjkFujBN4Wozdg
	 IkvlBjZRhZYUq8rSh7SnxSAdlys+s+61+TkBtoh2o8GLrcBsMdUTk6purXUQLiquc/b4X
	 IYkU2JNqIrjYpJVsLHxcc4+X14uR+lSq2CnrfPU7HJAkcjEjdXzp0EnbHMRqqbPe7RxJL
	 Q3JH1mgMvzBfHecYR4v5CBQ3qcx3vmYEk26TcRV3QrUR5uTAXlraYOcD2U12GBYz9tXpy
	 lVXK1h43ljVRzmJpJ+CyQ6jjjH4eQfyzxVYuJGTJIOJT2stkA9voEXZBh630B5pj10A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttCYavru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E360606A31E;
	Wed, 25 Nov 2026 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttCYavru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7AD1F000CF;
	Wed, 25 Nov 2026 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620074;
	bh=RPu9n3eF+ZegXdM9ue8AS0t5z0kzguNrpmI9DaW64HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttCYavruQEuFzifvTR+DL2wXFh16Zctppqqb31yWgzQFYTCvVbBly+eyFQ2GiGtlT
	 UWh3hz2iSJW5ruL7d36q+Ae5b09eO+psG2k3ZPBTBSx0tFP28jMIhFJzuA5fjTsHG4
	 xTdh/oChFRqkKEAng/jb6fuxUpDj14hPnAOTT0fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0801/1005] wifi: mac80211: recheck the IBSS station limit before insertion
Date: Wed, 25 Nov 2026 15:35:39 +0100
Message-ID: <20261125143840.497881400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit f7670bcdf650b37551a9c5d084521f877d939f11 upstream.

Frames from successive unknown IBSS peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142235.15428-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1630,8 +1630,12 @@ void ieee80211_ibss_work(struct ieee8021
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ibss_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);


