Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2521335BCD;
	Fri,  9 Jan 2026 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962595; cv=none; b=HRyM2QiTXExRrsaYb1T2Eo0btENFFAfOdKYR/2TVoivXtW5uA81ppB9LJNnhOxqMrgJ1X+GMxnG3hjwmhbU5ERnJFBEg2DAY1xqLpNH3CXORoI9cUtKUvyaBHnBcLaivdmN9UDsavUBbWWhO1Uc5vZfrea/xiCDHGW8+g+C6i3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962595; c=relaxed/simple;
	bh=S5x2OWkZCYITmK50IL7q+OGF/CCIBUYBqxnCTbHnqyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3UD8RZ6sjB9SKZ4LC70oqb/XUYpQaasreHgo+Uto3dAOU9rNQEw0c4iKDc93OPtqJMwMABCMyW02XNo2wCl7PdsiJ0dpRNaPDV0H/4TjS9KgdSkk+Qk972MCqn4rJvs8Moql5XrXh2p2xBjrQPjwnsP8mhT49OYRnrjvWV5LRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpXdryf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpXdryf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FDBC4CEF1;
	Fri,  9 Jan 2026 12:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962594;
	bh=S5x2OWkZCYITmK50IL7q+OGF/CCIBUYBqxnCTbHnqyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpXdryf+R0GqqOOw9ILoRCXiO7RwxI1hHs5BOP6ig6dRZuvdFNhTEPcH3M3iy0U98
	 I52Q+cUUrcuQsR7XUbgGbcYX1TplCrwtH2+GnNE3H/UBhLYQ4FFKNoFthSmOGsAsPa
	 Y/8xDPCnZplvf4NrJrDqBnjbDA4G7Vz/Dk8w+WMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 388/634] wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()
Date: Fri,  9 Jan 2026 12:41:06 +0100
Message-ID: <20260109112132.131922992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2b77b9551d1184cb5af8271ff350e6e2c1b3db0d ]

The QGenie AI code review tool says we should store the capped length to
wdev->u.client.ssid_len.  The AI is correct.

Fixes: 62b635dcd69c ("wifi: cfg80211: sme: cap SSID length in __cfg80211_connect_result()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aTAbp5RleyH_lnZE@stanley.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ed16e852133e..26106802b17b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -896,7 +896,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 
 			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
 			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid->datalen;
+			wdev->u.client.ssid_len = ssid_len;
 			break;
 		}
 		rcu_read_unlock();
-- 
2.51.0



