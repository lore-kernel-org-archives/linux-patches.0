Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D64135C1AE;
	Tue,  6 Jan 2026 17:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721590; cv=none; b=ZgmS3p+wbVqRMkqaB7zl1fqWXUQar9S4MGF9Z+JjB/GIaZFmcQOJMPo6xAlOBs1TSH6k8KWngaby41bv4SH/zR2FJbCSuvBUGWrICGSpeJdrMF1KWO6L8CkvYQ4NNviAZsrrUsJAdlajdqloQu5URXKENefXObycpqaAXpWGCMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721590; c=relaxed/simple;
	bh=J0bVmtJHd4wCItknnjkMYv6Ir2v3P1UIXZSWR5+pnsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+A14b6geqbhAR4N7rzbobFynz7L1lvpX30GubUsCYZrSr0trsWwojomzrMbeAXEY6JnBZPTjjW8sZXZitlaz8nDkLYFX6pkrTt1JU8hIlTMI5CxpjMTMmNkoLQq8Q+L3PCurOFmg6TbkYHQfTOP712uaql4+nZfoV0y5Nscbh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfWpT85X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfWpT85X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B2DC116C6;
	Tue,  6 Jan 2026 17:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721590;
	bh=J0bVmtJHd4wCItknnjkMYv6Ir2v3P1UIXZSWR5+pnsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfWpT85XDGKY286baDaPKCqTbvubK6eIm6AZupy8EEiKrp1/FXti7ivLBstTLxLOQ
	 iI9SXV/O/ni7qJfJvgihOCtfzXrnLkzfUQKCy6JxsEjTVQtLgC5cnWF5/y108JGZNc
	 UwGwaxgYsy9CghLoPxJv0KeNx+Ki3bsmpbJlIs/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/312] wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()
Date: Tue,  6 Jan 2026 18:01:28 +0100
Message-ID: <20260106170548.369678556@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
index 3a028ff287fb..4e629ca305bc 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -910,7 +910,7 @@ void __cfg80211_connect_result(struct net_device *dev,
 
 			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
 			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid->datalen;
+			wdev->u.client.ssid_len = ssid_len;
 			break;
 		}
 		rcu_read_unlock();
-- 
2.51.0



