Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B78A217704;
	Sat, 30 May 2026 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165507; cv=none; b=cOKzFJTud4lbLskkFPmyTa52Rh6eOMbGBRuMzArb85NzWdHgPAeTma+TKS7y6clCZK3t2l2vW1tv5AwpSe8kbgaarevyO9oq8x51tX9O0sxYBmjYZ11S8t3TnJqFVkUfmAlz/e/TaRo15xrmDKJo5MzBHcuZg7nJ8+4M8/P7JY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165507; c=relaxed/simple;
	bh=bR539SMJXneRC6SDNeLdESacRLWITrA+W5zJvMJoKMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kko1mqxShIS20cXrt9fgPACjhOv01vFHSP3oGZp0/AQVeQQkaj/aEYrtVvRTaASElx6AOOCOOV09Uxd+mX7TEEpmAYLLb0S5i23u+oYUBo6krrBrNeWyZweR+bntQtcf0erfBuBWYifuIjFRrSGJk+2i+CpY2StvY62q/lNUURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7H9WS7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7H9WS7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A079E1F00893;
	Sat, 30 May 2026 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165506;
	bh=nwPRPz7HRgFQcMgZqMnCJ9A8ieMLRLMVbgZi586S8Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7H9WS7KtKcv0vOnPc/nsntRblXgWoFBI2y9ubdLRygE/aG61PKnjYoZT3zIXfj54
	 g8VzJp+PGOAWer/gj8SHqHKBoXQMu6kW+I1//n2UK2nOq4DBs1E7UmmAPhKpTu3cRQ
	 MvE4lx2oorTuPny+LZldHbEyPJM/EXJPob23Lw2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guocai He <guocai.he.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/589] Revert "wifi: cfg80211: stop NAN and P2P in cfg80211_leave"
Date: Sat, 30 May 2026 17:59:10 +0200
Message-ID: <20260530160226.416922252@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guocai He <guocai.he.cn@windriver.com>

This reverts commit d91240f24e831d3bd36954599ada6b456fb1bd0a which is commit
e1696c8bd0056bc1a5f7766f58ac333adc203e8a upstream.

The reverted patch introduced a deadlock. The locking situation in mainline is
totally different, so it is incorrect to directly backport the commit from mainline.

Signed-off-by: Guocai He <guocai.he.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 019f9767eda5f..c6c5dd4e35209 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1208,10 +1208,8 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		/* must be handled by mac80211/driver, has no APIs */
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		cfg80211_stop_p2p_device(rdev, wdev);
-		break;
 	case NL80211_IFTYPE_NAN:
-		cfg80211_stop_nan(rdev, wdev);
+		/* cannot happen, has no netdev */
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MONITOR:
-- 
2.53.0



