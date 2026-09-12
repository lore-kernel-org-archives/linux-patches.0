Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5839426D03;
	Sat, 12 Sep 2026 10:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209425; cv=none; b=ZRbYYrKbHGImE587b0TM9bYf5WQ8wTRtaMM/XGmF0pigoqWu6e6IpYivX1dQkHzkT3x7y53ed5280x54AIkwv9TBNYe0RIeLYeou9p18yJOd518nbYwZNMAHLAv8HVbsgbTNawxveG5c5Im3qUZL0QTl5gwq87rNl0+p2I0jZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209425; c=relaxed/simple;
	bh=P/c4uUOonpUw/AKpFqIQ6im/ax/7X5PffGkWLWCsEeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJShuhFL93LgI9jz8OOR858leZEE6Y3GH3+t5DFmaznwBbnm47QhCxHddvfveEjfLotw+z3UTbXVbIUUBAion996C/VnjEkBCJcxJ6L+wYWc5VGXWSvIyGuATrxgO+TDnanDa3OKo9/cMInhqrEOqzJvu9Oi+Yw/ZXGvX/xS1p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0kX65iJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0kX65iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B40C1F000FF;
	Sat, 12 Sep 2026 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209423;
	bh=drhR1O611Z4tCBmXg/4fa6ZxA5daVZEW+dVxdS4xXNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0kX65iJWkmY1lVx/i8IrupNIDVx3qgKjh91I5EtqOEGkcK0+zTFKm0xjv6bsxEnY
	 5K/bWL/aSYav/v/zV5VYPwz17OJuveSwbBgOXjMKTlfOa+oQh+TlOOja959HGuH978
	 Rj6j2Lwhex8Xprg/E6mXKjQaXbTusxpt1pXsE3r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0817/1518] wifi: cfg80211: include S1G_NO_PRIMARY flag when sending channel
Date: Sat, 12 Sep 2026 08:49:46 +0200
Message-ID: <20260912065641.918221514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit e1cbdf78f60c35a1a320ca401852fd6a73624a4a ]

When sending a channel ensure we include the IEEE80211_CHAN_S1G_NO_PRIMARY
flag.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260109081439.3168-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 6c5fc504d0d6 ("wifi: cfg80211: stop PMSR before P2P and NAN teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8134f10e4e6c0..964e1c779cdd3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4444,6 +4444,9 @@ enum nl80211_wmm_rule {
  *	channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_NO_16MHZ: 16 MHz operation is not allowed on this
  *	channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_S1G_NO_PRIMARY: Channel is not permitted for use
+ *	as a primary channel. Does not prevent the channel from existing
+ *	as a non-primary subchannel. Only applicable to S1G channels.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -4492,6 +4495,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_4MHZ,
 	NL80211_FREQUENCY_ATTR_NO_8MHZ,
 	NL80211_FREQUENCY_ATTR_NO_16MHZ,
+	NL80211_FREQUENCY_ATTR_S1G_NO_PRIMARY,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 776dcf8835d71..541d86cc6018a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1316,6 +1316,9 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
 		if ((chan->flags & IEEE80211_CHAN_NO_16MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_16MHZ))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_S1G_NO_PRIMARY) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_S1G_NO_PRIMARY))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-- 
2.53.0



