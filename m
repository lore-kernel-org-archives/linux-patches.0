Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FF91D6AA;
	Tue,  6 Jan 2026 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720633; cv=none; b=Cx5edMvFOvPPWy11NsE5x28jhgPM8dmSE7fwwjBrMxx4MmjB7MhvLTJjRDk/RWk0Zk7GqnFecV/0C67AybSWoSUqkJpsYuZ+uD++fY4UVEAzmMWcLdC+kl75uADa+hZo54UvEz/h8YWt9Dd9Z3L6hRUAAgEII+YJKXB44yA8nts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720633; c=relaxed/simple;
	bh=LcSHIZOF7VZvmFmX+fGP7SrAoOGavpp6x3onBiPNHU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6dq87xwZHW0a1HiPndfps2YCHLNjHWS01/YtOQmtesmywR7n7skepbaXR/7nboXH2FSDag6i+q2+ypguGuS37jC9EX01Fg1QNIfM3UJHrabW8AxF4UWG98B+A0CBH/CaFo7kr2/Y96A+d/jtTYo3dvIaB63Wu9YxVmzd5BtIoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zu6Wrpmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zu6Wrpmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62171C116C6;
	Tue,  6 Jan 2026 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720632;
	bh=LcSHIZOF7VZvmFmX+fGP7SrAoOGavpp6x3onBiPNHU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zu6WrpmvBRiKC3ZjKtCbz4BfJ0deBJYrVo3SMn1oHuSxfApgdy7SDmlCEWHAN3Tbl
	 liyp2whPB6kRqNH6CHS5vICJYQaMYTmK+0E6m6FKZgPDNAnbg2CBncd7+2x7asFInJ
	 GAkjZYXT0ZxUXRlw8si74ViR4XsJ1ucWEjGgEIUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/567] wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()
Date: Tue,  6 Jan 2026 18:01:18 +0100
Message-ID: <20260106170502.281876461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e0d3c713538b..d8250ae17d94 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -913,7 +913,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 
 			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
 			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid->datalen;
+			wdev->u.client.ssid_len = ssid_len;
 			break;
 		}
 		rcu_read_unlock();
-- 
2.51.0



