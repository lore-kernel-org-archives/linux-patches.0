Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B370F320CB6;
	Fri,  9 Jan 2026 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960813; cv=none; b=oBvqVbWE14CvMBWa3oFmN5/2FWdn3rX0JV+o41KjvhfIDa86rwf5GKw/41XVJTIFmmrZbpS1FrmWU2vIUL/1BIeLlFTg8jYqCTUGxQZv4SklpJj5lPqWH2IZCPtmYBkmnJM2qAyVcBfK19Aysc7fi5ec5lVbUDQzTLQYlfLUpWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960813; c=relaxed/simple;
	bh=U8LLIUzwl1XnwijGxpqpZ05S+00mBXMGo1ZVaTfmS1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoMG+5xXSFFKEl/HyP+QfI3EUrE+kjsPAR1LdLQw0HpDRBgITmJgaI6KAvqIn2YhSIN20KPjIwginU8rW+x8yj2lPbdBcIjgvsKNZNZAGQL/YlA81IS0wFV70yPr0Q+I5CuV3V5Mxcqee/J8DPnGToFuv6Ge0yTsjkkTzVRBglw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAahT+hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAahT+hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4254EC4CEF1;
	Fri,  9 Jan 2026 12:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960813;
	bh=U8LLIUzwl1XnwijGxpqpZ05S+00mBXMGo1ZVaTfmS1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAahT+hS+MxaAfhcmVmN2WuvEhz5A1++aexfenmmtPCzx7MEU8/5/3N3jPXSTL3R6
	 eFd+oCfEMWxvhIKLFlQgwcK9Au/numq6kQU9t377JNBZk8PRFgd9lizDMMBMqD5yCJ
	 XmwA9nIi4j4gnF/4fk9QIn/u+z9oUZIBTrvi05kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 502/737] wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()
Date: Fri,  9 Jan 2026 12:40:41 +0100
Message-ID: <20260109112152.878171109@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5904c869085c..6f116ae5442b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -925,7 +925,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 
 			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
 			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid->datalen;
+			wdev->u.client.ssid_len = ssid_len;
 			break;
 		}
 		rcu_read_unlock();
-- 
2.51.0



